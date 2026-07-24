# `gt` calculator - a calculator built with local LLMs

> Published at 2026-05-31T14:24:10+03:00

I created a calculator. Not because the world needed another one, but because I wanted to test something: How well do local LLMs hold up as pair programmers on a real project? I want to be independent of the big LLM providers like Anthropic, OpenAI, and company for this `gt`-project.

The answer is: well enough for small projects like this.

`gt` is a command-line calculator written in Go that does RPN (Reverse Polish Notation), percentage calculations, unit conversion, and a fair bit more. The name stands for "greater than" — `gt` is a comparison operator the calculator supports. Plus it was free in my shell (`gt` command wasn't used yet by another tool) and I liked the short name.

If you want the full feature guide, the README links to a detailed doc for every feature covered here and more:

[gt on Codeberg](https://github.com/snonux/gt)  
[![gt logo](./gt-calculator/logo.svg "gt logo")](./gt-calculator/logo.svg)  

The whole thing — code, tests, documentation, even the logo — was built using only LLMs that can run locally on reasonable hardware: Qwen, Gemma, Nemotron, GPT-OSS. To be honest, I didn't run them locally either — I rented Hyperstack VMs with NVidia GPU just to get a feel for the quality before investing in hardware. The point was to test models that don't require a cloud API and could realistically run on your own box.

[https://www.hyperstack.cloud/](https://www.hyperstack.cloud/)  

This post is about the calculator and what it does. My experience running those LLMs as pair programmers will be a separate post later.

And no, this wasn't vibe-coded. I used a specific technique and a set of AI skills to drive the LLMs. The codebase came out well-structured and maintainable — not the "prompt it and pray" mess. 

## Table of Contents

* [⇢ `gt` calculator - a calculator built with local LLMs](#gt-calculator---a-calculator-built-with-local-llms)
* [⇢ ⇢ The motivation](#the-motivation)
* [⇢ ⇢ What it does](#what-it-does)
* [⇢ ⇢ Percentage calculations](#percentage-calculations)
* [⇢ ⇢ RPN arithmetic](#rpn-arithmetic)
* [⇢ ⇢ ⇢ Modulo](#modulo)
* [⇢ ⇢ ⇢ Logarithms](#logarithms)
* [⇢ ⇢ ⇢ Hyper operators (n-ary)](#hyper-operators-n-ary)
* [⇢ ⇢ ⇢ Comparisons and booleans](#comparisons-and-booleans)
* [⇢ ⇢ Variables and symbols](#variables-and-symbols)
* [⇢ ⇢ Built-in constants](#built-in-constants)
* [⇢ ⇢ The metrics system](#the-metrics-system)
* [⇢ ⇢ ⇢ Suffix notation](#suffix-notation)
* [⇢ ⇢ ⇢ Unit conversion](#unit-conversion)
* [⇢ ⇢ ⇢ Metric-aware arithmetic](#metric-aware-arithmetic)
* [⇢ ⇢ ⇢ Custom metrics](#custom-metrics)
* [⇢ ⇢ ⇢ SI vs IEC modes](#si-vs-iec-modes)
* [⇢ ⇢ ⇢ Discovering metrics](#discovering-metrics)
* [⇢ ⇢ Stack manipulation](#stack-manipulation)
* [⇢ ⇢ Rational number mode](#rational-number-mode)
* [⇢ ⇢ The REPL](#the-repl)
* [⇢ ⇢ Some more usage examples](#some-more-usage-examples)
* [⇢ ⇢ Fish shell completions](#fish-shell-completions)
* [⇢ ⇢ Installation](#installation)
* [⇢ ⇢ Wrapping up](#wrapping-up)

## The motivation

Four things drove this.

First, I wanted to test local LLMs as coding partners. Not the cloud-hosted ones with infinite context and billions of parameters — the ones you can actually run yourself. I figured a calculator project is big enough to be interesting but small enough to finish.

Second, cloud independence is a thing I care about. I build tools that don't need a network connection to function. Writing software that talks to OpenAI or Anthropic APIs doesn't count as "running locally." Everything here runs offline.

Third, I wanted to learn more about how these models actually work in practice. Not benchmarks or leaderboard scores — the day-to-day experience. How do you operate them? How do you structure prompts? When do they produce clean code versus garbage? Where do they struggle?

Finally, the tool needed to be genuinely useful. A toy that calculates `2 + 2` isn't worth the disk space. I aimed for a calculator I'd actually reach for.

## What it does

At its core, `gt` is a stack-based RPN calculator with percentage support and a full metrics system. It runs as a single binary, has no dependencies, and works three ways:

```sh
gt '3 4 +'                     # one-liner: RPN
gt '20% of 150'                # one-liner: percentage
gt                             # interactive REPL
```

You can also pipe into it: `echo '1000Mbps @Gbps convert' | gt` → `1`.

## Percentage calculations

This is the simplest entry point. Three forms, all case-insensitive, all with step-by-step output:

```sh
gt '20% of 150'                # → 30.00
gt '30 is what % of 150'       # → 20.00%
gt '30 is 20% of what'         # → 150.00
```

Every percentage result shows the formula and intermediate values, so you can verify the math. Useful for tips, discounts, tax, and any "what's the actual number?" moment.

## RPN arithmetic

The main engine uses Reverse Polish Notation. No parentheses needed — the order of tokens determines the order of operations.

```sh
gt '3 4 +'                     # 7
gt '2 10 ^'                    # 1024
gt '100 10 / 5 +'              # 15
gt '3 4 + 5 6 + *'             # (3+4) × (5+6) = 77
```

Six basic operators: `+`, `-`, `*`, `/`, `^`, `%`. All work on the stack, popping operands and pushing the result.

The fast integer power operator `**` uses binary exponentiation (O(log n) instead of O(n)). So `2 100 **` does about 7 multiplications instead of 99. It only accepts integer exponents — use `^` for fractional powers.

### Modulo

`%` gives the remainder after division:

```sh
gt '17 5 %'                    # → 2
gt '100 7 %'                   # → 2
```

### Logarithms

Three unary operators for when you need them:

- `lg` — base 2 (information theory, algorithm complexity)
- `log` — base 10 (decibels, pH, order of magnitude)
- `ln` — natural log (continuous growth, statistics)

```sh
gt '1024 lg'                   # → 10
gt '1000 log'                  # → 3
gt 'e ln'                      # → 1.0000000000
```

### Hyper operators (n-ary)

Want to add everything on the stack at once? Square-bracket operators pop the entire stack and reduce left-associatively:

```sh
gt '1 2 3 4 5 [+]'            # → 15 (sum of all)
gt '100 10 20 30 5 [-]'       # → 35 (100-10-20-30-5)
gt '2 5 10 [*]'               # → 100 (product)
gt '1000 2 2 2 2 [/]'         # → 62.5
```

Full set: `[+]`, `[-]`, `[*]`, `[/]`, `[^]`, `[%]` for arithmetic, plus `[lg]`, `[log]`, `[ln]` for logarithms. The log hyper operators work differently from the arithmetic ones — they compute the sum of the log function applied to each value, not a left-associative reduction. A quick entropy calculation:

```sh
gt '0.25 0.5 0.25 [lg]'      # → -5  (information theory entropy bits)
```

The square-bracket syntax is inspired by Raku's hyper operators.

[https://raku.org](https://raku.org)  

### Comparisons and booleans

Six comparison operators, each with a symbolic alias:

```sh
gt '5 3 gt'                    # → true
gt '3 5 <'                     # → true
gt '5 5 =='                    # → true
```

Results are `true` or `false`, which coerce into arithmetic (true = 1, false = 0). That means you can do inline conditionals:

```sh
gt '85 80 gt 10 *'             # → 10 (85 > 80, so 1 × 10)
gt '50 80 gt 10 *'             # → 0  (50 < 80, so 0 × 10)
```

Range validation works by summing boolean results:

```sh
gt '72 68 gte 100 lte +'       # → 2 (both checks pass, temp is in range)
gt '105 68 gte 100 lte +'      # → 1 (out of range)
```

Booleans also do plain arithmetic, which is occasionally useful:

```sh
gt 'true true +'               # → 2 (1 + 1)
gt 'false 5 +'                 # → 5 (0 + 5)
```

## Variables and symbols

Store values with three assignment styles:

```sh
gt 'x 10 :='                   # right assignment
gt '20 y =:'                   # left assignment
gt 'rate 100Mbps ='            # standard (or rate = 100Mbps)
```

`vars` lists them, `clear` wipes all variables and constants, `:name d` deletes one. In REPL mode, variables persist to disk between sessions.

Symbols (the `:x` syntax) are named placeholders on the stack. The `:` prefix makes intent explicit: `:x` always pushes the symbol `x`, even if a variable named `x` already exists. This is how you delete a variable without ambiguity, and how you push a name onto the stack without resolving it.

```sh
> x 10 :=                     # define x
> x                           # pushes 10 (variable resolved)
> :x                          # pushes :x (the symbol itself)
> :x d                        # deletes the variable x
```

Bare identifiers that don't match any variable or constant also push as symbols.

## Built-in constants

Thirty-six of them. Use them directly as tokens:

```sh
gt 'pi 2 *'                    # → 6.283185307
gt 'euler'                     # → 2.718281828
gt 'phi 10 *'                  # → 16.18 (golden rectangle)
gt 'sqrt2 sqrt3 *'             # → 2.449 (√6)
```

Greek letter aliases work too: `π`, `τ`, `φ`, `√2`, `√3`, `√5`.

There's also a `constants` command that lists all 36 in one shot. Edge cases are covered too — `inf`, `-inf`, and `nan` exist as constants if you ever need them.

## The metrics system

This is where `gt` earns its swiss army knife title. Every number carries a unit of measurement, and arithmetic understands those units.

Six built-in categories, plus `Cool` — the default unitless metric for plain numbers. The name comes from Raku's `Cool` role, which represents things that are "cool enough" to do basic operations (strings, numbers, etc.). In `gt`, Cool values absorb into any metric category during arithmetic, so `5 100Mbps +` treats the `5` as `5Mbps`.

- *DataRate*: bps, Kbps, Mbps, Gbps, Tbps
- *DataSize*: bits, bytes, KB/MB/GB/TB/PB (SI), KiB/MiB/GiB/TiB/PiB (IEC)
- *Time*: ms, s, min, hr, day
- *Weight*: mg, g, kg, lb, oz, ton
- *Speed*: mps, kmh, mph, knots
- *Distance*: m, km, mi, ft, in, nm (nautical miles)

### Suffix notation

Attach units directly to numbers:

```sh
gt '100Mbps'                   # 100 megabits per second
gt '5GB'                       # 5 gigabytes
gt '1hr'                       # 1 hour
gt '70kg'                      # 70 kilograms
```

### Unit conversion

Use `@<target> convert`:

```sh
gt '1000Mbps @Gbps convert'    # → 1
gt '1km @mi convert'           # → 0.6213711922
gt '60mph @kmh convert'        # → 96.56
gt '3day @s convert'           # → 259200
```

### Metric-aware arithmetic

Addition and subtraction auto-convert within categories:

```sh
gt '1km 500m +'                # → 1.5 (converted to km)
gt '1Gbps 500Mbps -'           # → 500 (in Mbps)
```

Multiplication and division do cross-category inference:

```sh
gt '100Mbps 1hr *'             # rate × time = data transferred
gt '10GB 2hr /'                # data / time = rate
gt '100kmh 1hr * @mi convert'  # → 62.14 miles traveled
```

Comparison operators are metric-aware too:

```sh
gt '1km 1000m eq'              # → true
gt '1GB 1024MB eq'             # → false (SI: 1GB = 1000MB)
```

### Custom metrics

Define your own units:

```sh
custom define reel 304.8 Distance      # surveyor's reel
custom define fortnight 1209600 Time   # 14 days
custom define cup 240 Weight           # cooking measure
```

Then use them like built-ins:

```sh
> 5reel @m convert
1524
> 2fortnight @day convert
28
> 3cup @g convert
720
```

### SI vs IEC modes

Data size units have two modes. SI (default) uses powers of 1000. IEC uses powers of 1024. Switch with `metric decimal set` / `metric binary set`. The dedicated IEC units (KiB, MiB, GiB) are always unambiguous.

### Discovering metrics

You can explore what's available without leaving the REPL:

```sh
> metric list
DataRate, DataSize, Distance, Speed, Time, Universal, Weight
> metric DataRate
Gbps, Kbps, Mbps, Tbps, bps
```

`metric compatible` checks whether two values can be combined before you try:

```sh
> 1km 5mi metric compatible
km (Distance) and mi (Distance): true
> 100Mbps 2hr metric compatible
Mbps (DataRate) and hr (Time): false
```

## Stack manipulation

Five operators for managing the RPN stack:

- `dup` — duplicate the top value
- `swap` — swap top two values
- `pop` — discard the top value
- `show` / `showstack` / `print` — display the stack without modifying it
- `clear` — clear all variables and constants

`dup` and `swap` come up a lot. Square a number: `7 dup *` → 49. Reverse operand order: `2 10 swap /` → 5 (instead of 0.2). `pop` discards the top value if you pushed something by accident: `5 6 pop` → 5.

## Rational number mode

"Rational" refers to rational numbers — numbers that can be expressed as an exact fraction of two integers (numerator/denominator). The name "rat" is just the shorthand command.

In the default float64 mode, numbers are stored as binary floating-point approximations. `0.1` cannot be represented exactly in binary, so it becomes something like `0.1000000000000000055511151231257827...`. This causes the classic problem:

```sh
> rat off
Rational mode disabled (using float64)
> 0.3 0.1 - 0.2 -
-2.775557562e-17
```

The result should be `0`, but floating-point rounding errors accumulated. Silent wrong answer.

Rational mode stores numbers as exact fractions using Go's `math/big.Rat`. `0.1` is stored as `1/10`, `0.2` as `2/10` (simplified to `1/5`), and all arithmetic operates on those exact values. No binary approximation, no silent drift.

```sh
> rat on
Rational mode enabled
> 0.1 0.2 +
0.3000000000
```

Internally, `1/3` stays as the exact fraction `1/3`, and `1/3 * 3` computes to exactly `3/3 = 1`. No binary conversion, no rounding.

REPL-only. Has a known limitation with non-dyadic decimals and metric operations — the docs explain the why.

## The REPL

Run `gt` with no arguments when attached to a terminal and you get the interactive session. Command history (1000 entries, persisted to `~/.gt_history`), tab completion, Emacs-style line editing, Ctrl+R reverse search.

Variables save to disk between sessions. Session state lives in `~/.local/state/gt/vars`. For auditing or note-taking, session logging works like this:

```sh
$ gt --log calc-session.log
> 1Gbps 1hr *
> @GB convert
> quit
```

Built-in REPL commands: `help`, `clear`, `quit`/`exit`, `rpn`/`calc`, `rat`, `stack`. `stack` is a shorthand hint for viewing the RPN stack. Tab-completes.

Here's what a session looks like:

```sh
$ gt
> rate 100Mbps =
rate = 100
> time 2hr =
time = 2
> rate time *
200 Mbps
> metric show
Mbps, DataRate, base: bps, factor: 1e+06
> download 50GB =
download = 50
> speed 100Mbps =
speed = 100
> download speed / @min convert
83.33333333
> custom define reel 304.8 Distance
defined custom metric "reel" (factor: 304.8, category: Distance)
> 5reel @m convert
1524
> 100Mbps 50Mbps swap -
50 Mbps
> show
50 Mbps
> 20% of 150
20.00% of 150.00 = 30.00
  Steps: (20.00 / 100) * 150.00 = 0.20 * 150.00 = 30.00
> rat on
Rational mode enabled
> 1 3 / 3 *
1.0000000000
> vars
rate = 100
time = 2
download = 50
speed = 100
```

Inline help is built in. Bare `help` lists all commands, and `help <command>` drills into one topic:

```sh
> help rat
rat on/off/toggle - Switch between float64 and rational number modes
  rat on       Enable rational mode (exact fractions)
  rat off      Disable rational mode (use float64)
  rat toggle   Toggle current mode
> help clear
clear - Clear the screen
Usage: clear
```

No need to leave the REPL or dig through docs when you forget a subcommand.

## Some more usage examples

Here are some more `gt` usage examples:

```sh
# Download volume at 1 Gbps for an hour
gt '1Gbps 1hr * @GB convert'        # → 450

# Internet speed threshold in scripts
MIN_SPEED=$(gt '1Gbps @Mbps convert')  # → 1000

# Travel planning
gt '500mi @km convert'              # → 804.67
gt '65mph @kmh convert'             # → 104.86

# Tips, discounts, whatever
gt '18% of 63.40'
gt '15% of 89.99'

# File sizes in MiB instead of bytes
find . -exec wc -c {} + | awk '{print $1}' | xargs -I{} gt '{} @MiB convert'

# Quick math
gt 'pi 5 5 * *'                     # circle area, r=5 → 78.54
gt '1000 lg'                        # → 10 (bits needed)
```

## Fish shell completions

`gt` ships with a fish completion script that covers everything: operators, constants, metric units, stack commands, the `metric` and `custom` subcommand trees, and boolean literals. It's context-aware — it won't suggest `metric` subcommands in the middle of an RPN expression, and it suppresses fish's default file completions so you only see calculator tokens.

Install it:

```sh
cp completions/gt.fish ~/.config/fish/completions/
```

Or system-wide:

```sh
sudo cp completions/gt.fish /usr/local/share/fish/vendor_completions.d/
```

In practice this means tab-completion for all 36 constants, every metric unit (bps through Tbps, KB through PiB, kmh, mph, knots, etc.), all arithmetic and hyper operators, and the `metric show` / `metric list` / `custom define` subcommand chains. The `custom define` subcommand even completes the valid category names so you don't have to memorize them.

## Installation

```sh
go install github.com/snonux/gt/cmd/gt@latest
```

Or from the source directory: `mage install`.

One quirk: there are no `-h` or `--help` flags. `gt version` gives you the version, and bare `gt` with no TTY prints usage. If you pass `-h`, `gt` tries to evaluate it as RPN and errors. It's intentional and keeps the surface area small.

## Wrapping up

The local LLM experiment worked. The code is clean enough, the tests pass, the docs are thorough, and I use the tool. The logo was generated by a local model too.

For the complete and always-up-to-date feature guide, detailed docs for every feature, and the source code, head to the repo.

[gt on Codeberg](https://github.com/snonux/gt)  

But will I now invest a couple of thousand dollars in hardware to run Qwen 3 Coder Next, Qwen 3.6 35B or 27B? (I used the dense 27B model most of the time to build `gt`). Unfortunately, no. I don't think it's worth the cost yet, as cloud models are still cheaper and more convenient and the frontier ones also much more "intelligent".

However, I will keep an eye on how the technology develops and continue experimenting with rented Hyperstack VMs for now; I will also default more often to smaller LLMs that could potentially run on home hardware. Ollama Cloud subscription or an OpenRouter API key are also good options alongside Claude and OpenAI Codex.

I will write another blog post at some point about my setup and what I learned from self-hosting models on Hyperstack.

Other related posts:

[2026-06-01 `gt` calculator - a calculator built with local LLMs (You are currently reading this)](./2026-06-01-gt-calculator.md)  
[2025-08-05 Local LLM for Coding with Ollama on macOS](./2025-08-05-local-coding-llm-with-ollama.md)  

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
