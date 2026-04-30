# Unveiling I/O Riot NG

> Draft — not in the gemfeed yet. Promote with the usual rename + index dance.

I rewrote I/O Riot. The old one was C + Systemtap and dates from 2017. The new one — call it ior — is Go + C + BPF via libbpfgo, runs on Linux, and is mostly a TUI dashboard rather than a record/replay box. Since pictures are worth more than yet another README table of key bindings, I built a demo.

=> ./unveiling-ior-ng/00-hero-flamegraph.png ior's live flamegraph: every running process, by file path, by syscall — width = event volume

=> https://codeberg.org/snonux/ior I/O Riot NG on Codeberg
=> ./2018-06-01-realistic-load-testing-with-ioriot-for-linux.gmi the original I/O Riot post (2018)

<< template::inline::toc

## What it does

ior attaches BPF tracepoints to a chunk of the synchronous-I/O syscall surface — open, read, write, stat, mmap, sync, link, fcntl, dup, the obvious ones. Each enter/exit pair becomes an event with a duration plus an inter-syscall gap, and the events feed a Bubble Tea dashboard with seven tabs: a live flamegraph, an overview, sortable per-syscall / per-file / per-process tables, latency histograms, and a live event stream with a stackable filter UI on top.

Same shape as the old I/O Riot in spirit: capture what the system is actually doing, not synthetic load. Different shape in execution: no replay engine, no separate record file unless you ask for one, no kernel-debug-info dance.

=> ./unveiling-ior-ng/00-logo.png I/O Riot NG logo

## A short detour: eBPF and libbpfgo

If you haven't touched eBPF before: it's a small in-kernel bytecode VM. You compile a tiny C program, the kernel verifies it can't crash or loop forever, and then it runs every time some hook fires — a syscall enter/exit, a kprobe, a tracepoint, a network packet. The program writes events into a ring buffer that userspace mmaps and drains. No kernel module, no patched kernel, no debug symbols required.

ior plugs into the syscall tracepoints — `sys_enter_openat`, `sys_exit_read`, etc. — and the BPF side does the bare minimum: timestamp the event, copy a few fields, push to a perf ring buffer. All the heavy lifting (string interning, latency math, aggregation, the dashboard) is in Go on the userspace side.

The kernel ships a C library called libbpf that handles loading the program, attaching it to hooks, managing maps, and reading the ring buffer. There are two well-known ways to drive that from Go:

* libbpfgo (Aqua Security): a thin cgo wrapper around libbpf. You ship libbpf along with your binary and call into the same C API that `bpftool` and `perf` use.
* cilium/ebpf: a from-scratch pure-Go reimplementation of everything libbpf does — ELF parser, BTF resolver, syscall layer, the lot.

I went with libbpfgo specifically because it's a wrapper, not a reimplementation. Whatever lands in libbpf upstream — new map types, new attach kinds, CO-RE fixes — I get for free the next kernel cycle. The pure-Go variant has to chase libbpf's feature set in parallel, and any divergence is on me to debug. For a tracer that's mostly value-add on the userspace side, "be a thin client of the kernel's own library" wins.

### CO-RE — the part that makes ior actually portable

The old I/O Riot was Systemtap. Systemtap programs are translated into a kernel module against the running kernel's exact headers, and that module then has to be loaded with `insmod`. That meant: the user has to install a kernel-debuginfo package matching their running kernel, and a fresh build per host (or per kernel update). On the BSD-style "you only run what you compiled here" laptop crowd that was tolerable; on a fleet of distros + kernel versions it was a recurring tax. Half of the original I/O Riot's README was about kernel-debuginfo dance steps.

CO-RE — Compile Once, Run Everywhere — is the eBPF feature that throws all of that out. The idea, in one paragraph: when you write a BPF program that reads `task->mm->start_stack`, you don't bake the offsets of those fields into the compiled program. Instead, the compiler emits relocation records ("at this instruction, fetch the offset of `mm` inside `task_struct`"). At load time, libbpf looks up the actual offsets in the target kernel's BTF (BPF Type Format — a description of every kernel struct, embedded in `/sys/kernel/btf/vmlinux` on any modern kernel) and patches the program in place. The same `.bpf.o` that ran on a 5.10 Debian kernel runs on a 6.8 Fedora kernel without recompilation.

Pictorially, the contrast looks like this:

```
Old I/O Riot (Systemtap)                 New ior (libbpf + CO-RE)
─────────────────────────                ────────────────────────────
  .stp source                              .bpf.c source
       │                                        │
       │ needs THIS kernel's headers            │ build ONCE against vmlinux.h
       │ + debuginfo package installed          │ (generated from any kernel BTF)
       ▼                                        ▼
  per-host translate + compile              one portable .bpf.o
       │                                        │
       ▼                                        ▼
  per-host kernel module                    same binary on every host
       │                                        │
  insmod / modprobe                         libbpf loader:
       │                                        │  • read /sys/kernel/btf/vmlinux
       ▼                                        │  • patch field offsets
  attached, this kernel only                 │  • verify + load
                                              ▼
                                          attached, runs anywhere
```

What that buys ior in practice: I ship a single `ior` binary. On any Linux ≥4.18-ish with BTF available (which is almost all of them now — Debian, Ubuntu, Fedora, Arch, RHEL all ship `CONFIG_DEBUG_INFO_BTF=y` by default), it just works. No kernel-debuginfo dependency, no per-kernel build matrix, no DKMS hooks. The first time I tried `scp ior fedora-box:` and it ran without complaint after a 6-month gap I had to double-check it wasn't silently doing nothing.

The runtime shape of a trace pipeline lines up with that:

```
 kernel side                                userspace (this binary)
 ───────────                                ───────────────────────
                                            ┌──────────────────────┐
   tracepoint:                              │  Go process          │
   sys_enter_openat                         │  ┌────────────────┐  │
        │                                   │  │  aggregator    │  │
        ▼                                   │  │  (latency,     │  │
   ┌─────────┐                              │  │   stacks,      │  │
   │ BPF prog│ ─── perf ring buf ──────────>│──│   filters)     │  │
   │ (verified                              │  └─────┬──────────┘  │
   │  bytecode)                             │        │             │
   └─────────┘                              │        ▼             │
                                            │  Bubble Tea TUI /    │
                                            │  parquet writer /    │
                                            │  CSV stdout          │
                                            └──────────────────────┘
```

The cost is cgo. Every call from Go into libbpf crosses the cgo boundary, which historically meant tens to ~hundred-ish nanoseconds of overhead per call — register save/restore, a stack switch onto g0, goroutine state bookkeeping. Cheap in absolute terms, but it adds up if you call into C inside a tight loop. ior keeps the actual hot path on the kernel side and only crosses into Go once per drained batch of events from the ring buffer, so the per-call cost is amortized over thousands of events. In practice it doesn't show up in profiles.

Go 1.26, the current release at the time of writing (late April 2026), is the one that finally took a serious bite out of cgo's per-call cost — the runtime can elide a chunk of the bookkeeping for calls that don't need it. Real-world wins depend heavily on the workload, but the rough direction is that cgo now feels closer to "an unusually expensive function call" than to "a context switch", which is the right mental model for almost everyone touching a C library from Go. The shorter version: cgo overhead used to be a real footgun for ports that called into C in the inner loop. With Go 1.26 it's a footnote unless you're doing many millions of small calls per second, in which case batching across the boundary still fixes it.

### If you want to go deeper

If any of this sounds interesting and you want to learn how to write your own BPF programs, two books are the standard recommendations and both well worth the time:

* "Learning eBPF" by Liz Rice (O'Reilly, 2023) is the friendlier on-ramp. It walks through writing your first programs end-to-end, covers CO-RE and BTF in plain English, and is the book I'd hand to someone who has never touched the kernel side before. Liz also gave the canonical "what is eBPF" conference talk floating around YouTube, which makes a good 40-minute companion.
* "BPF Performance Tools: Linux System and Application Observability" by Brendan Gregg (Addison-Wesley, 2019) is the encyclopedia. It's where you go after you've understood the basics and now want a complete reference for tracing every subsystem in the kernel — file systems, networking, scheduler, languages, applications — with worked tools for each. The flame-graph-driven analysis style throughout is also exactly how ior's own flamegraph tab thinks about a workload.

Between the two, Rice teaches you the moving parts and Gregg teaches you what to do with them.

## The whole thing as a tape pipeline

The demo isn't a screencast I sat through. It's 14 VHS tapes that drive the TUI deterministically, with a background workload generator producing real syscall traffic for the trace to chew on. One `mage demo` and every GIF below regenerates from scratch. The boring part of "make a demo" — having to re-record everything when the UI shifts — goes away.

## First launch

```sh
sudo ./ior
```

You land on the PID picker. The default selection is "All PIDs", so Enter just dumps you straight at the dashboard.

=> ./unveiling-ior-ng/01-launch.gif Cold start: PID picker, then the dashboard

The dashboard opens on the live flamegraph. Bars grow as new events arrive. Before walking through the keys, a paragraph on what you're looking at — flamegraphs are easier to read than they are to describe.

A flamegraph is a histogram of stacks. Each horizontal bar is one entry in a stack; every bar directly above it is a child of that entry, and the stack you read top-to-bottom is the same shape as a call chain. In ior, "stack" doesn't mean function-call stack (we don't have userspace symbols). It means a tuple of dimensions of the trace: by default `comm/path/tracepoint`, so the bottom row is per-process names, the middle row is per-file paths, and the top row is the syscall (`enter_read`, `enter_openat`, etc.). A wide bar means lots of events landed in that bucket, a narrow bar means few. There is no time axis — left-to-right is just sort order, not chronology. The whole chart is one "where is the I/O coming from?" picture.

One thing worth flagging because it's the unusual bit: this flamegraph is live. Most of the flamegraph tooling out there — Brendan Gregg's `flamegraph.pl`, all the `perf script | stackcollapse-* | flamegraph.pl` pipelines, every `pprof -web` invocation — produces a static SVG: capture a profile for N seconds, render once, browse the result. ior's tab is not that. Bars grow, shrink, appear, and disappear in real time as events stream in from the kernel — at full screen-refresh rate while the workload runs, with no pause. You can sit on this tab while you change something on the system (start a build, cycle a service, run a query) and watch the I/O shape mutate underneath you. That's a different mental model from the static "I have a profile, let me look at it" workflow most people are used to, and it's what makes the tab actually useful as an at-a-glance diagnostic surface rather than a post-mortem artifact.

Because it's live, there's also a way to throw away the accumulated history and start the rolling count from "now": `r` resets the baseline. Everything the flamegraph has been counting since launch (or since the last reset) is dropped, and from that moment the chart reflects only events that arrived after the reset. Useful for the "compare before vs after" workflow — change one thing on the box, hit `r` immediately, and the next thirty seconds of accumulation is a fresh picture of the new state.

That visualisation buys you two things you can't easily get from a tabular view. First, hierarchy: it's immediately obvious whether one process is responsible for ten thousand reads on a single file, or ten thousand reads spread across a hundred files — the first looks like one tall pillar, the second looks like a wide ridge. Second, scale: bar width is proportional to the metric (count or bytes), so a process that did 95% of the work towers over the others. The eye picks that up instantly; the same fact in a sorted table requires reading numbers and doing the ratio mentally.

Useful workflows you can do entirely from this tab:

* "What's pounding the disk?" — leave it on default order (`comm/path/tracepoint`) and watch which `comm` widens. Press `b` once to switch the metric to bytes if you care about throughput, not call count.
* "Why is this one process slow?" — `l` (or `→`) until the cursor is on that process, then `enter` to zoom. The whole chart re-roots there and you see only that process's paths and syscalls.
* "What's in /var/lib/X?" — press `o` once to flip ordering to `path/tracepoint/comm`, navigate to the path, zoom. Now the children show which syscalls hit it and which processes did them.
* "Did the new deploy change the I/O shape?" — press `r` to reset the baseline, wait a bit, and the chart starts fresh with only events from the reset point onward. Pair the same syscall surface "before" vs "after" and the difference jumps out by shape.

Now the keys. Movement uses vi-style `h`/`j`/`k`/`l` everywhere in ior — and the cursor keys work too if you'd rather. `h`/`l` (or `←`/`→`) walk siblings at the current depth, `j`/`k` (or `↓`/`↑`) step shallower or deeper. `enter` zooms into the selected subtree (the rest of the chart greys out and the selection becomes the new root). `u` or `Esc` undoes the zoom. `b` toggles the metric driving bar width between event count and total bytes. `/` opens regex search; matching frames stay coloured while everything else greys out, so you can use it as a filter as well as a finder. And `o` cycles between five different stack-ordering modes, each with its own lens on the data.

The five orderings ship as built-in presets. The leftmost dimension is the bottom row of the chart (the root); the rightmost is the top row (the leaf). Pressing `o` rotates through them in this order:

* `comm/tracepoint/path` — the default. Root rows are processes (by command name); each process's bar splits into the syscalls it issued, and each syscall splits further by file path. Best general-purpose view: "which programs are doing the I/O, and what kind?"
* `path/tracepoint/comm` — root by file path. Use this when you suspect a particular file or directory is the bottleneck — pick the path, see which syscalls hit it, and which processes did those syscalls. Pairs naturally with directory grouping in the Files tab.
* `tracepoint/comm/path` — root by syscall. When you already know "this is an `openat` problem" or "we're write-bound", this view collects all the openat (or write) traffic at the bottom and lets you drill into who's doing it and to which paths.
* `pid/tracepoint/path` — root by PID, not comm. Same shape as the default but each individual process gets its own bar instead of being lumped in with siblings sharing a comm. Useful when you have many bash or python instances and need to tell them apart.
* `comm/path/tracepoint` — root by process, then by file (skipping the syscall layer at the top). Best when you care about "what files does this program touch?" more than "what syscalls does it issue?" — the file column gets a full row of vertical real estate instead of being split per-syscall.

In all five orderings, bar widths still mean the same thing — proportion of the active metric (events or bytes, toggled with `b`). The toolbar at the top of the chart always shows the current ordering as `o:order(<dim1>/<dim2>/<dim3>)`, so you never lose track of which lens you're looking through.

=> ./unveiling-ior-ng/13-tui-flamegraph.gif Live in-TUI flamegraph: navigate, zoom, undo, cycle order + metric

## The seven tabs, in 30 seconds each

The number keys jump between tabs. `tab` and `shift+tab` step.

### `2` Overview

A sparkline plus the top syscalls and top paths — the at-a-glance view, useful as a "what's happening right now?" landing tab when you don't yet know what you're looking for.

=> ./unveiling-ior-ng/02-overview-tab.gif Overview tab

### `3` Syscalls

A sortable table of every syscall ior knows about, with rate, average latency, p95/p99, total bytes, and error count. `s` sorts by the selected column, `S` reverses. The most useful column when something's wrong is usually p99 — it's where you see the long-tail outlier syscall types.

=> ./unveiling-ior-ng/03-syscalls-tab.gif Syscalls table with sort + reverse-sort

### `4` Files

Same shape as Syscalls but rows are file paths. The interesting key here is `d`: it rolls per-file rows up into their parent directory. Essential when you've got a process touching ten thousand files in `/usr/share/` — without it the table is unreadable noise.

=> ./unveiling-ior-ng/04-files-tab.gif Directory grouping toggle

### `5` Processes

Same shape again, but rows are processes / comms. Best paired with the Stream tab — once you spot a culprit comm here, push it to the global filter with `Enter` and the rest of the dashboard is scoped to that process.

=> ./unveiling-ior-ng/05-processes-tab.gif Processes tab

### `6` Latency + Gaps

Two histograms side by side: how long each syscall took (latency), and the wall-clock interval between syscalls on the same thread (gap). Latency tells you "is the kernel slow"; gap tells you "what is the program doing between two kernel calls".

A subtle but important point about that gap: ior measures it from the exit of one syscall to the entry of the next on the same TID, but it does not know what the thread was doing in the meantime. A long gap doesn't mean the thread was idle — it might have been pinned on a CPU running pure userspace code (number-crunching, JSON parsing, GC, a busy loop). All "gap" tells you for sure is "this thread didn't call into the kernel for X microseconds." Whether that's because it was sleeping, blocked on a condition variable, computing, or scheduled out is something only the gap value alone cannot answer — pair it with `top`/`perf top` if you need to disambiguate. In practice this is still extremely useful: a syscall-driven workload with surprisingly long gaps is a strong hint that you're CPU-bound somewhere outside the kernel, and that's a different optimisation conversation than slow I/O.

The dd loop in the demo workload spreads the latency distribution out so you can actually see the shape.

=> ./unveiling-ior-ng/06-latency-gaps-tab.gif Latency + gap histograms

### `7` Stream

The live tail — every event as it happens, in a row-per-event ring buffer. This is where you spend most of your time when something's actually broken. The whole next section is about it.

=> ./unveiling-ior-ng/07-stream-live.gif Stream tab live-tailing

## The Stream tab is the good one

`space` pauses. In pause mode, the same vi-style `h`/`j`/`k`/`l` (or arrow keys) move the row/column cursor across the table. Hitting `Enter` on a cell pushes a new filter onto a stack, narrowing what you see. Pile them up — comm, then syscall, then file — and `Esc` pops them off LIFO when you want to back out.

=> ./unveiling-ior-ng/08-stream-pause-filter.gif Pause, push two filters, undo with Esc

`/` and `?` are regex search forward/backward. `n` and `N` walk matches. The search runs against every column in the ring buffer and wraps at the end. Search and filtering are different beasts: search highlights and jumps, filtering hides everything that doesn't match.

=> ./unveiling-ior-ng/09-stream-regex-search.gif Regex search

`e` exports the current filtered snapshot to a CSV in the working directory. `x` does the same for the paused stream view specifically (preserving your filter stack), `X` prompts for a filename, `E` opens the most recent export in `$EDITOR`.

=> ./unveiling-ior-ng/10-stream-csv-export.gif CSV export

## Filtering, more thoroughly

The Enter-to-push trick isn't unique to Stream. It works the same on Files, Syscalls, and Processes: highlight a row, hit Enter, and the cell value becomes a filter against the entire dashboard. Three tabs of "I see one weird path / comm / syscall, drill in" with one keystroke.

The filter status line gives you a one-glance summary of every active frame, written like:

* `comm~bash` — substring match on a string column. This is what Enter-on-a-cell produces for `comm`, `syscall`, and `file`.
* `pid=1234` — exact equality. Used for `pid`, `tid`, `fd`, `ret`, `bytes`.
* `latency>=5ms` / `gap>=10us` — numeric comparison with a duration suffix. The full operator set is `>`, `<`, `=`, `>=`, `<=`, `!=`.

Stack frames AND together, so pushing `comm~bash` and then `syscall~openat` shows you bash's openat calls, not bash OR openat.

Undoing is symmetric to pushing: `Esc` pops the most recent frame off the stack — one keystroke per layer, LIFO. Press it once to drop the `syscall~openat` filter and you're back to bash-only; press it again and the `comm~bash` filter goes too, leaving the unfiltered firehose. To clear the whole stack at once, just hold `Esc` until the status line reads `filter: all`. The `F` key is a synonym for `Esc` here and works from any tab — handy from Files/Syscalls/Processes where `Esc` might otherwise close a modal first.

Two other knobs do related work:

* `p`, `t`, `o` open the PID, TID, and probe-toggle dialogs. These are global filters: they reconfigure the BPF side, so kernel-level events for excluded PIDs/probes never even reach userspace. Cheaper than filtering a firehose, but it also means the filter applies to recordings (the parquet file only contains rows the kernel let through).
* The CLI mirrors of those dialogs let you bake the same scoping into a one-shot run: `-pid`, `-tid`, `-comm`, `-path`, plus `-tps <regex>` / `-tpsExclude <regex>` for picking which tracepoints to attach in the first place.

=> ./unveiling-ior-ng/11-pid-tid-probe.gif PID, TID, and probe pickers

## Recording

Three persistence flows, each for a different job:

* `R` from the dashboard starts streaming Parquet — every event row that survives your current TUI filter goes to disk continuously. `R` again stops. Footer shows the active file or the last error.

=> ./unveiling-ior-ng/12-parquet-recording.gif Parquet recording from the TUI

* `sudo ./ior -flamegraph -name <n>` writes one aggregated `.ior.zst` artifact at shutdown. Aggregated counters, not per-event rows. Cheaper to write, ideal for ior's native flamegraph workflow and integration tests.

* `sudo ./ior -parquet trace.parquet` is the headless firehose — every row, no TUI, no filtering. `sudo ./ior -plain` is even lighter: CSV to stdout, pipe it into anything.

=> ./unveiling-ior-ng/14-headless-modes.gif All three headless flows in one tape

## Querying a parquet trace with ClickHouse

The schema is flat and stable: `seq, time_ns, gap_ns, latency_ns, comm, pid, tid, syscall, fd, ret, bytes, file, is_error, filter_epoch`. ClickHouse Local reads parquet directly without a server, which makes it a perfect post-mortem tool — point it at the file and run SQL:

```sh
clickhouse local --query "
  SELECT comm, syscall, count() AS n,
         formatReadableSize(sum(bytes)) AS total
  FROM file('trace.parquet', Parquet)
  GROUP BY comm, syscall
  ORDER BY n DESC
  LIMIT 10
" --format PrettyCompactNoEscapes
```

```
    ┌─comm────────────┬─syscall─┬─────n─┬─total──────┐
 1. │ notify-rs inoti │ read    │ 42005 │ 732.31 KiB │
 2. │ cosmic-term     │ statx   │ 10898 │ 0.00 B     │
 3. │ cosmic-term     │ read    │ 10103 │ 4.02 MiB   │
 4. │ surface-eDP-1   │ ioctl   │  8452 │ 0.00 B     │
 5. │ cosmic-term     │ close   │  4918 │ 0.00 B     │
 6. │ cosmic-term     │ openat  │  4537 │ 0.00 B     │
 7. │ cosmic-term     │ ioctl   │  3556 │ 0.00 B     │
 8. │ tokio-runtime-w │ read    │  1976 │ 4.04 MiB   │
 9. │ cosmic-comp     │ read    │  1118 │ 6.63 KiB   │
10. │ systemd-oomd    │ read    │  1085 │ 111.97 KiB │
    └─────────────────┴─────────┴───────┴────────────┘
```

The fields you actually want for performance work are `latency_ns` and `gap_ns`. P99 by syscall, only the ones that landed in error:

```sh
clickhouse local --query "
  SELECT syscall, count() AS n,
         round(quantile(0.5)(latency_ns)/1000,  1) AS p50_us,
         round(quantile(0.99)(latency_ns)/1000, 1) AS p99_us
  FROM file('trace.parquet', Parquet)
  WHERE is_error = 1
  GROUP BY syscall
  ORDER BY p99_us DESC
" --format PrettyCompactNoEscapes
```

```
    ┌─syscall────┬─────n─┬─p50_us─┬─p99_us─┐
 1. │ statx      │  1216 │    2.2 │   16.4 │
 2. │ newfstatat │    69 │    1.7 │   16.4 │
 3. │ open       │     1 │   16.1 │   16.1 │
 4. │ mkdir      │   306 │    3.9 │   11.7 │
 5. │ readlink   │    11 │    1.5 │   10.4 │
 6. │ newstat    │    44 │    2.5 │    8.4 │
 7. │ unlinkat   │   347 │      1 │    6.2 │
 8. │ openat     │   380 │    2.1 │    5.8 │
 9. │ access     │     2 │      5 │    5.5 │
10. │ read       │ 23597 │    0.5 │    5.4 │
11. │ ioctl      │   901 │      1 │    5.3 │
12. │ writev     │     1 │    0.7 │    0.7 │
    └────────────┴───────┴────────┴────────┘
```

Real output, by the way — those rows are from a 30-second `ior -parquet trace.parquet` capture on the laptop I'm typing this on. `notify-rs inoti…` is the inotify thread of some Rust app I had open; `cosmic-term` is the COSMIC desktop's terminal emulator. The slowest p99 errors are the directory-walking syscalls (statx, newfstatat, mkdir) at ~16 µs — bog standard.

Same trick works in DuckDB (`duckdb -c "SELECT ... FROM 'trace.parquet'"`), pandas, polars, anything that reads Parquet. The point of streaming Parquet rather than ior's native `.ior.zst` format is exactly this: once it's on disk, you're in the standard data-tools ecosystem.

## Reproducing the whole demo

```sh
mage installDemoTools     # one-time: VHS via go install + ttyd from dnf
sudo -v                   # warm the sudo timestamp once
mage demo                 # ~10 minutes, fully headless, safe to background
```

To rebuild a single GIF after editing its tape: `TAPE=07-stream-live mage demoOne`.

## What's still missing

ior is pre-alpha and basically a personal tool. The headline gaps:

* No record/replay — that was the whole point of the original I/O Riot. The new one is a tracer, not a workload simulator. I keep going back and forth on whether to put replay back in.
* No userspace symbol resolution. Stacks are at the syscall surface, not "which line of which library called read".
* No remote / cluster mode. Single host, one trace at a time.

But the live flamegraph, the stackable stream filters, and the cheap parquet capture together cover the cases I actually hit week to week. The demo above is the easiest way to get a feel for whether it's the kind of tool you want.

=> https://codeberg.org/snonux/ior Source on Codeberg
=> https://codeberg.org/snonux/ior/src/branch/main/demo/TUTORIAL.md The full in-repo tutorial
