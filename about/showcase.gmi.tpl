# Project Showcase

Generated on: 2026-07-24

=> showcase-rank-history.svg Interactive Project Rank History Graph (SVG)

This page showcases my side projects, providing an overview of what each project does, its technical implementation, and key metrics. Each project summary includes information about the programming languages used, development activity, releases, and licensing. The projects are ranked by score, which combines recent activity, project size, tag history, and whether the project has shipped a release.

<< template::inline::toc

## Overall Statistics

* 📦 Total Projects: 77
* 📊 Total Commits: 13,876
* 📈 Total Lines of Code: 680,434
* 📄 Total Lines of Documentation: 299,648
* 💻 Languages: Go (50.2%), Java (8.8%), Shell (7.2%), C (5.3%), Dart (4.7%), XML (3.3%), C++ (3.1%), YAML (2.8%), Perl (2.6%), C/C++ (2.2%), JavaScript (1.9%), JSON (1.7%), TypeScript (1.1%), Ruby (1.0%), CSS (1.0%), HTML (1.0%), Config (0.6%), HCL (0.4%), Python (0.4%), Make (0.3%), TOML (0.1%)
* 📚 Documentation: Text (74.8%), Markdown (24.0%), LaTeX (1.1%)
* 🚀 Release Status: 43 released, 34 experimental (55.8% with releases, 44.2% experimental)

## Projects

### 1. dtail 1↖13↖14↙13↙12↙11↙9←9←9↙6↙4↙2↙1←1↖10↙8↙6←6↙2↖21↙20

* 💻 Languages: Go (95.2%), Shell (2.3%), JSON (1.0%), C (0.7%), Make (0.5%), C/C++ (0.1%)
* 📚 Documentation: Text (97.9%), Markdown (2.1%)
* 📊 Commits: 784
* 📈 Lines of Code: 56634
* 📄 Lines of Documentation: 220971
* 🏷️ Tags: 27
* 📅 Development Period: 2020-01-09 to 2026-07-18
* 🏆 Score: 57.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Apache-2.0
* 🏷️ Latest Release: v4.3.3 (2024-08-23)


=> showcase/dtail/image-1.png dtail screenshot

DTail (a distributed tail program) is a DevOps tool for engineers programmed in Google Go for following (tailing), catting and grepping (including gzip and zstd decompression support) log files on many machines concurrently. An advanced feature of DTail is to execute distributed MapReduce aggregations across many devices.

=> https://github.com/snonux/dtail View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash dtail

---

### 2. ggaze 2↙1

* 💻 Languages: C (91.4%), C/C++ (6.5%), XML (1.3%), Python (0.8%)
* 📚 Documentation: Markdown (98.4%), Text (1.6%)
* 📊 Commits: 35
* 📈 Lines of Code: 11922
* 📄 Lines of Documentation: 2430
* 🏷️ Tags: 0
* 📅 Development Period: 2026-07-12 to 2026-07-22
* 🏆 Score: 46.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: GPL-3.0
* 🧪 Status: Experimental (no releases yet)


**ggaze (GNOME Gaze)** is a small, fast, native GTK4 image viewer written in C for Fedora Linux, designed to quickly preview a folder of camera downloads, cull rejects, and move on — think `feh`/`nsxiv`/`qiv` but GNOME-native and KISS (no library, database, or sidecars). Its workflow pairs a gthumb-style thumbnail grid with a full-window large view, plus rich keyboard-driven actions: navigation, zoom/pan, EXIF info overlay, mark/select, trash (with undo) or permanent delete, configurable move destinations, external program launchers, shell-script runners, optional GEGL quick-enhance and crop/straighten/rotate, clipboard copy, fullscreen, and slideshow.

**Architecture:** A meson/ninja C project built on GTK4 + libadwaita + GLib, with a strict main-thread-touches-GTK / decode-in-`GTask`-threads split and a "one active load per window, last-write-wins" invariant backed by a bounded `GdkTexture` LRU. Plain-C modules (navigator, loader, detect, thumbnail, trash, mover, opener, runner, enhancer, info, texturecache, clipboard) are display-free and unit-tested standalone; GTK widgets live in `app`, `window`, `viewer`, `gridview`, and `shortcuts`. Decode backends are pluggable behind `GGAZE_HAVE_*` guards (pixbuf default; optional `gegl`, `jxl`, `avif`, `heif` as meson `feature`s), so a minimal GdkPixbuf-only build stays valid and fast. Testing is two mandatory tracks (unit ≥80% coverage via gcov for plain-C modules; integration suites for cross-module flows with offscreen GTK and real temp dirs), plus an ASan/UBSan leak-check pass after every milestone.

=> https://github.com/snonux/ggaze View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash ggaze

---

### 3. dotfiles 3↖6←6↙4↙3↙2↖3←3↖8↙7←7←7↖9←9↙8↙6↙4←4↙3↖4↙3

* 💻 Languages: Shell (74.5%), Config (7.0%), TOML (6.2%), CSS (6.0%), Python (3.3%), JSON (2.2%), Ruby (0.6%), INI (0.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 1148
* 📈 Lines of Code: 5403
* 📄 Lines of Documentation: 18312
* 🏷️ Tags: 0
* 📅 Development Period: 2023-07-30 to 2026-07-22
* 🏆 Score: 31.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


These are all my dotfiles. I can install them locally on my laptop and/or workstation as well as remotely on any server.

=> https://codeberg.org/snonux/dotfiles View on Codeberg
=> https://github.com/snonux/dotfiles View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash dotfiles

---

### 4. ychat 4↖76↙68←68←68↙67↙66←66↖67←67←67↙65↙64←64↙63←63←63↖66↙63↙62↙43

* 💻 Languages: C++ (50.0%), Shell (21.4%), C/C++ (19.7%), Perl (2.7%), Config (2.1%), HTML (2.0%), Make (1.0%), CSS (0.6%), Docker (0.4%)
* 📚 Documentation: Markdown (95.1%), Text (4.9%)
* 📊 Commits: 57
* 📈 Lines of Code: 42334
* 📄 Lines of Documentation: 549
* 🏷️ Tags: 7
* 📅 Development Period: 2008-05-15 to 2026-07-08
* 🏆 Score: 27.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.9.0 (2026-07-07)


ychat: source code repository.

=> https://codeberg.org/snonux/ychat View on Codeberg
=> https://github.com/snonux/ychat View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash ychat

---

### 5. shuriken.sh 5↙3↙2↙1←1←1

* 💻 Languages: Shell (99.5%), Config (0.4%), Docker (0.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 348
* 📈 Lines of Code: 24240
* 📄 Lines of Documentation: 952
* 🏷️ Tags: 32
* 📅 Development Period: 2011-11-19 to 2026-07-18
* 🏆 Score: 24.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.13.0 (2026-07-18)


=> showcase/shuriken.sh/image-1.svg shuriken.sh screenshot

shuriken is a Bash script for Unix like operating systems (such as Linux) to generate static web photo albums.
The resulting static photo album is pure HTML+CSS (without any JavaScript!).

=> https://github.com/snonux/shuriken.sh View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash shuriken.sh

---

### 6. tasksamurai 6↙5↙4↙2↖15↙14↙13←13↖14↙11↙9←9↙7←7↙5↖23↙22←22↙18↙17↙16

* 💻 Languages: Go (99.9%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 343
* 📈 Lines of Code: 15859
* 📄 Lines of Documentation: 265
* 🏷️ Tags: 25
* 📅 Development Period: 2025-06-19 to 2026-07-19
* 🏆 Score: 22.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: BSD-2-Clause
* 🏷️ Latest Release: v0.18.3 (2026-07-19)


=> showcase/tasksamurai/image-1.png tasksamurai screenshot

Task Samurai invokes the `task` command to read and modify tasks. The tasks are displayed in a Bubble Tea table where each row represents a task. Hotkeys trigger Taskwarrior commands such as starting, completing or annotating tasks. The UI refreshes automatically after each action so the table is always up to date.

=> https://github.com/snonux/tasksamurai View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash tasksamurai

---

### 7. conf 7↙4↙3←3↖7←7↙6←6↙4↖5↖14↙12↙10←10↙7↖9↙7←7↖9↙8↙5

* 💻 Languages: YAML (75.2%), Shell (11.0%), Perl (7.9%), Python (2.8%), Make (1.3%), JSON (0.5%), Docker (0.5%), TOML (0.3%), Config (0.3%), Ruby (0.2%), HTML (0.1%)
* 📚 Documentation: Markdown (97.5%), Text (2.5%)
* 📊 Commits: 1015
* 📈 Lines of Code: 24071
* 📄 Lines of Documentation: 7537
* 🏷️ Tags: 0
* 📅 Development Period: 2021-12-28 to 2026-07-20
* 🏆 Score: 22.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


This is my personal config repository. Including...

=> https://codeberg.org/snonux/conf View on Codeberg
=> https://github.com/snonux/conf View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash conf

---

### 8. gonf 8↙2↙1

* 💻 Languages: Go (100.0%)
* 📚 Documentation: Markdown (99.3%), Text (0.7%)
* 📊 Commits: 28
* 📈 Lines of Code: 3373
* 📄 Lines of Documentation: 136
* 🏷️ Tags: 0
* 📅 Development Period: 2026-07-04 to 2026-07-09
* 🏆 Score: 17.6 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


=> showcase/gonf/image-1.svg gonf screenshot

**gonf** is a pure-Go, KISS-style configuration-management tool in the spirit of Puppet/Chef but written entirely in Go with no external DSL or runtime. You declare desired system state directly in Go using a small, declarative API — `File`, `Dir`, `Link`, `Package` (and their `No*`/`IsAbsent` counterparts) — passing functional options like `WithContent`, `WithMode`, `WithSource`, `WithPrune`, `IsLatest`, etc. A single `api.Apply()` then reconciles every declared resource against the actual filesystem/package state.

Architecturally it's a clean three-layer design: a public `api` package exposes the resource constructors and `Apply` entry point; an `internal/resource` package provides a thread-safe **repository** that registers resources by unique ID and topologically sorts them (with circular-dependency detection) before invoking each resource's `Applier`; and per-type packages (`file`, `dir`, `link`, `pkg`) implement the concrete reconciliation logic. Options are decoupled from resources via small capability interfaces (`Moded`, `Sourced`, `Contented`, `Prunable`, `Latestable`, `Linkable`, …), so new resource types or options can be added without touching existing code. A `cmd/gonf` binary wires it together and currently runs an `examples` configuration as a demonstration.

=> https://codeberg.org/snonux/gonf View on Codeberg
=> https://github.com/snonux/gonf View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash gonf

---

### 9. hexai 9↙7↙5←5↙2↖5↖7←7↙6↙4↖5↙3↖8←8↙6↙4↙1←1←1↖3↙2

* 💻 Languages: Go (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 558
* 📈 Lines of Code: 47443
* 📄 Lines of Documentation: 3894
* 🏷️ Tags: 106
* 📅 Development Period: 2025-08-01 to 2026-07-15
* 🏆 Score: 17.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.42.0 (2026-07-02)


=> showcase/hexai/image-1.png hexai screenshot

Hexai, the AI addition for your Helix Editor (https://helix-editor.com) .. Other editors should work but weren't tested.

=> https://github.com/snonux/hexai View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash hexai

---

### 10. gitsyncer 10↙8↙7↙6↙5↙3↖10←10←10↖20←20↙19↙18←18←18↙16↙14←14↙11↙10↖15

* 💻 Languages: Go (95.3%), Shell (4.4%), JSON (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 203
* 📈 Lines of Code: 16777
* 📄 Lines of Documentation: 2501
* 🏷️ Tags: 43
* 📅 Development Period: 2025-06-23 to 2026-07-22
* 🏆 Score: 12.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: BSD-2-Clause
* 🏷️ Latest Release: v0.18.5 (2026-06-17)


GitSyncer is a tool for synchronizing git repositories between multiple organizations (e.g., GitHub and Codeberg). It automatically keeps all branches in sync across different git hosting platforms.

=> https://github.com/snonux/gitsyncer View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash gitsyncer

---

### 11. gt 11↙9↙8←8↙6↙4↙1←1↖28↙26←26↙25↙24←24←24↙22↙21←21↙17↙16↙13

* 💻 Languages: Go (97.7%), Shell (2.0%), YAML (0.3%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 413
* 📈 Lines of Code: 19759
* 📄 Lines of Documentation: 4351
* 🏷️ Tags: 7
* 📅 Development Period: 2025-11-25 to 2026-05-25
* 🏆 Score: 9.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.5.1 (2026-05-25)


=> showcase/gt/image-1.svg gt screenshot

A simple AI-engineered command-line percentage calculator written in Go. No frontier AI models from Claude, OpenAI, Google, ec, were used for this project. The ones used were:

=> https://github.com/snonux/gt View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash gt

---

### 12. foo.zone 12↖25↙24↙23←23↙22↙21←21←21↙18←18↙17↙16←16↙13↙10↙8↖68↙64←64↙6

* 💻 Languages: XML (98.4%), Shell (1.3%), Go (0.3%)
* 📚 Documentation: Text (86.4%), Markdown (13.6%)
* 📊 Commits: 1845
* 📈 Lines of Code: 21604
* 📄 Lines of Documentation: 176
* 🏷️ Tags: 0
* 📅 Development Period: 2021-04-29 to 2026-07-24
* 🏆 Score: 9.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


Each format is in it's own branch in this repository. E.g.:

=> https://codeberg.org/snonux/foo.zone View on Codeberg
=> https://github.com/snonux/foo.zone View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash foo.zone

---

### 13. snonux 13↙10←10←10↖11↙10↙8←8↙7↙3↙2↖4↙3←3←3↙2↖5←5

* 💻 Languages: JSON (36.9%), JavaScript (26.9%), Go (23.7%), CSS (12.6%)
* 📚 Documentation: Text (79.8%), Markdown (20.2%)
* 📊 Commits: 119
* 📈 Lines of Code: 23342
* 📄 Lines of Documentation: 1139
* 🏷️ Tags: 29
* 📅 Development Period: 2026-04-06 to 2026-07-08
* 🏆 Score: 8.6 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.18.0 (2026-07-06)


**WIP** - A microblog generator project

=> https://github.com/snonux/snonux View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash snonux

---

### 14. ior 14↙11←11↙9↙8←8↙5←5←5↙1↖12↖14↙13←13↖14↙12↙9↙8↙4↙1←1

* 💻 Languages: Go (90.2%), C (8.9%), Shell (0.4%), JSON (0.2%), C/C++ (0.2%), Docker (0.1%)
* 📚 Documentation: Markdown (83.9%), Text (16.1%)
* 📊 Commits: 848
* 📈 Lines of Code: 66290
* 📄 Lines of Documentation: 3008
* 🏷️ Tags: 3
* 📅 Development Period: 2024-01-18 to 2026-05-14
* 🏆 Score: 8.3 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v1.1.0 (2026-05-14)


=> showcase/ior/image-1.png ior screenshot

> **🚧 PRE-ALPHA SOFTWARE:** This project is in a pre-alpha state and is intended for my own personal use only. Use at your own risk.

=> https://github.com/snonux/ior View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash ior

---

### 15. irregular.ninja 15↙12↙9↙7↙4

* 💻 Languages: Config (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 21
* 📈 Lines of Code: 112
* 📄 Lines of Documentation: 48
* 🏷️ Tags: 0
* 📅 Development Period: 2026-06-15 to 2026-07-18
* 🏆 Score: 7.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


The architecture is straightforward: source photos live outside the repo (referenced via symlinks), and `just` recipes invoke `shuriken.sh` to transform them into static albums. This keeps the repo lean while making builds reproducible and easy to automate—just run `just all` to regenerate both sites, or target a single album individually.

=> https://github.com/snonux/irregular.ninja View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash irregular.ninja

---

### 16. goprecords 16←16↙15↙14←14↙12↙11←11←11↙9↙6←6↙4←4↙2↖29↙28←28↙24←24←24

* 💻 Languages: Go (97.5%), Shell (2.2%), Docker (0.3%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 170
* 📈 Lines of Code: 7359
* 📄 Lines of Documentation: 1008
* 🏷️ Tags: 17
* 📅 Development Period: 2013-03-22 to 2026-07-20
* 🏆 Score: 6.6 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.5.2 (2026-06-07)


`goprecords` is a Go command-line program that generates uptime reports for hosts based on the input record files from `uptimed`. It supports importing records into SQLite and querying for reports, or reporting directly from a stats directory.

=> https://github.com/snonux/goprecords View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash goprecords

---

### 17. hypr 17↙14↙12↙11↙9↙6↙2←2←2↖17↙16↙15↙14←14↙11↙7↙3←3

* 💻 Languages: TypeScript (51.7%), Ruby (33.0%), JSON (7.8%), Shell (4.1%), TOML (3.4%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 143
* 📈 Lines of Code: 10829
* 📄 Lines of Documentation: 2948
* 🏷️ Tags: 0
* 📅 Development Period: 2026-03-21 to 2026-06-17
* 🏆 Score: 6.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


=> showcase/hypr/image-1.svg hypr screenshot

Automates Hyperstack GPU VM lifecycle: create, bootstrap, WireGuard tunnel, and vLLM inference.
Runs two A100 VMs concurrently — each serving a different model — with [Pi](https://pi.dev) coding agents connected to each.

=> https://github.com/snonux/hypr View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash hypr

---

### 18. totalrecall 18↙17↙16↙15↙13←13↙12←12←12↙10↙8←8↙6←6↙4↙1↖18←18↙15←15↙14

* 💻 Languages: Go (98.8%), HTML (0.4%), CSS (0.3%), Shell (0.3%), YAML (0.2%)
* 📚 Documentation: Markdown (96.0%), Text (4.0%)
* 📊 Commits: 268
* 📈 Lines of Code: 22960
* 📄 Lines of Documentation: 400
* 🏷️ Tags: 43
* 📅 Development Period: 2025-07-14 to 2026-06-18
* 🏆 Score: 6.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.29.3 (2026-06-18)


=> showcase/totalrecall/image-1.png totalrecall screenshot

`totalrecall` is a versatile tool for generating Anki flashcard materials from Bulgarian words. It offers both a command-line interface (CLI) and a graphical user interface (GUI) for creating audio pronunciation files and AI-generated images.

=> https://github.com/snonux/totalrecall View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash totalrecall

---

### 19. player 19↙15↙13↙12↙10↙9↙4←4↙3↙2↙1←1

* 💻 Languages: Go (44.9%), Dart (41.0%), JavaScript (7.7%), TypeScript (2.4%), CSS (2.1%), HTML (0.7%), JSON (0.3%), YAML (0.3%), Shell (0.2%), XML (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 319
* 📈 Lines of Code: 74887
* 📄 Lines of Documentation: 6954
* 🏷️ Tags: 0
* 📅 Development Period: 2026-04-28 to 2026-05-23
* 🏆 Score: 6.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


Player is an opinionated KISS web media player. It is designed to be simple, lightweight, and easy to use and designed keyboard-first.

=> https://github.com/snonux/player View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash player

---

### 20. fastforge 20↙18↙17↙16←16↙15←15←15←15↙12↙11↙10↙5←5↙1↖3

* 💻 Languages: C (92.4%), C/C++ (4.1%), JavaScript (2.6%), Make (0.8%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 85
* 📈 Lines of Code: 3786
* 📄 Lines of Documentation: 232
* 🏷️ Tags: 1
* 📅 Development Period: 2026-04-06 to 2026-04-15
* 🏆 Score: 4.9 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v1.0.0 (2026-04-15)


=> showcase/fastforge/image-1.png fastforge screenshot

FastForge is a Pebble watchapp for intermittent fasting tracking, built with the Rebble SDK.

=> https://github.com/snonux/fastforge View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash fastforge

---

### 21. foostore 21↙19↙18↙17←17←17←17←17←17↙15←15↙13↙12←12↖16↙14↙11←11↙7↙6↖7

* 💻 Languages: Go (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 130
* 📈 Lines of Code: 10592
* 📄 Lines of Documentation: 162
* 🏷️ Tags: 12
* 📅 Development Period: 2018-05-26 to 2026-04-29
* 🏆 Score: 4.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.8.1 (2026-04-29)


> **🚧 PRE-ALPHA SOFTWARE:** This project is in active early development, unstable, and intended for personal use. Expect bugs, breaking changes, missing safeguards, and possible data loss. Backward compatibility and upgrade paths are not guaranteed. Use at your own risk.

=> https://github.com/snonux/foostore View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash foostore

---

### 22. timesamurai 22↙21←21↙20←20↙19↙18←18←18↙16↖17↙16↙15←15↙12↙11↙10↙9↙5↙2

* 💻 Languages: Go (99.3%), Shell (0.6%), YAML (0.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 96
* 📈 Lines of Code: 10363
* 📄 Lines of Documentation: 112
* 🏷️ Tags: 5
* 📅 Development Period: 2025-06-25 to 2026-03-26
* 🏆 Score: 4.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.8.0 (2026-03-26)


> **🚧 PRE-ALPHA SOFTWARE:** This project is in a pre-alpha state and is intended for my own personal use only. Use at your own risk.

=> https://github.com/snonux/timesamurai View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash timesamurai

---

### 23. comicforge 23↙20←20↙19←19↙18↙16←16←16↙13↙10↙5↙2←2

* 💻 Languages: Go (100.0%)
* 📚 Documentation: Markdown (95.9%), Text (4.1%)
* 📊 Commits: 49
* 📈 Lines of Code: 11223
* 📄 Lines of Documentation: 998
* 🏷️ Tags: 0
* 📅 Development Period: 2026-04-19 to 2026-04-23
* 🏆 Score: 4.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


=> showcase/comicforge/image-1.png comicforge screenshot

ComicForge turns a vocabulary file into a generated comic package. It uses Gemini-backed providers to write a story, draw comic pages, and optionally produce narration. The CLI writes comic assets into `./comics/assets/<slug>/`, gallery copies into `./comics/gallery/`, and final PDFs into `./comics/PDF/`.

=> https://github.com/snonux/comicforge View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash comicforge

---

### 24. rampage 24↙22↙19↙18←18↙16↙14←14↙13↙8↙3

* 💻 Languages: Go (100.0%)
* 📊 Commits: 2
* 📈 Lines of Code: 736
* 🏷️ Tags: 0
* 📅 Development Period: 2026-05-03 to 2026-05-04
* 🏆 Score: 3.9 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


rampage: source code repository.

=> https://github.com/snonux/rampage View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash rampage

---

### 25. ds-sim 25↙24↙23↙22←22↙21↙20←20←20↙19←19↙18↙17←17↙15↙13↙12←12↖25←25↙21

* 💻 Languages: Java (98.6%), Shell (0.9%), CSS (0.4%)
* 📚 Documentation: Markdown (98.7%), Text (1.3%)
* 📊 Commits: 474
* 📈 Lines of Code: 28576
* 📄 Lines of Documentation: 3103
* 🏷️ Tags: 2
* 📅 Development Period: 2008-05-15 to 2026-03-30
* 🏆 Score: 3.6 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: 1.1.0 (2026-03-27)


=> showcase/ds-sim/image-1.png ds-sim screenshot

DS-Sim is a open-source simulator for distributed systems, written in Java. It provides a powerful environment for simulating and learning about distributed systems concepts.

=> https://github.com/snonux/ds-sim View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash ds-sim

---

### 26. gogios 26↖27↙26↙25↖26↙25↙24←24←24↙22←22↙21←21←21↙20↙18↖19←19↙16↙14↙11

* 💻 Languages: Go (98.9%), JSON (0.6%), YAML (0.5%)
* 📚 Documentation: Markdown (94.9%), Text (5.1%)
* 📊 Commits: 114
* 📈 Lines of Code: 3864
* 📄 Lines of Documentation: 394
* 🏷️ Tags: 11
* 📅 Development Period: 2023-04-17 to 2026-07-18
* 🏆 Score: 2.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.4.2 (2026-07-18)


=> showcase/gogios/image-1.png gogios screenshot

Gogios is a lightweight and minimalistic monitoring tool not designed for large-scale monitoring. It is ideal for monitoring self-hosted servers on a tiny scale, such as only a handful of servers or virtual machines (e.g. my personal infrastructure). If you have limited resources to monitor and require a simple yet effective solution, Gogios is an excellent choice. However, for larger environments with more complex monitoring requirements, it might be necessary to consider other monitoring solutions better suited for managing and scaling with increased monitoring demands.

=> https://codeberg.org/snonux/gogios View on Codeberg
=> https://github.com/snonux/gogios View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash gogios

---

### 27. yoga 27↖29↙28↙27←27↙26↙25←25←25↙24←24↙23↙22←22↙21↙19↙17←17↙13←13↙12

* 💻 Languages: Go (69.1%), HTML (30.9%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 17
* 📈 Lines of Code: 6498
* 📄 Lines of Documentation: 196
* 🏷️ Tags: 9
* 📅 Development Period: 2025-10-01 to 2026-03-07
* 🏆 Score: 2.3 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.4.0 (2026-01-28)


=> showcase/yoga/image-1.png yoga screenshot

> **⚠️ DEPRECATED:** This project is no longer maintained. No further updates, bug fixes, or feature additions will be made. Use at your own risk.

=> https://github.com/snonux/yoga View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash yoga

---

### 28. epimetheus 28←28↙27↙26↙25↙24↙23←23←23↙21←21↙20↙19←19↙17↙15↙13←13↙8↙7↙4

* 💻 Languages: Go (85.2%), Shell (14.8%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 4
* 📈 Lines of Code: 5199
* 📄 Lines of Documentation: 1736
* 🏷️ Tags: 0
* 📅 Development Period: 2026-02-07 to 2026-03-07
* 🏆 Score: 2.3 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


=> showcase/epimetheus/image-1.png epimetheus screenshot

> **🚧 PRE-ALPHA SOFTWARE:** This project is in a pre-alpha state and is intended for my own personal use only. Use at your own risk.

=> https://github.com/snonux/epimetheus View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash epimetheus

---

### 29. rcm 29↙26↙25↙24←24↙23↙22←22←22↖25←25↙24↙23←23↙22↙20↙15↖16↙12←12↙10

* 💻 Languages: Ruby (99.6%), TOML (0.4%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 109
* 📈 Lines of Code: 1719
* 📄 Lines of Documentation: 778
* 🏷️ Tags: 3
* 📅 Development Period: 2024-12-05 to 2026-03-02
* 🏆 Score: 2.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v0.1.1 (2026-03-01)


=> showcase/rcm/image-1.png rcm screenshot

A KISS (Keep It Simple, Stupid) configuration management system written in Ruby, designed for personal use.

=> https://codeberg.org/snonux/rcm View on Codeberg
=> https://github.com/snonux/rcm View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash rcm

---

### 30. gemtexter 30←30↙29↙28←28←28↙27←27←27←27↖28↙27←27←27↖28↙27↙26←26↙22↖23↙22

* 💻 Languages: Shell (55.9%), CSS (31.0%), HTML (11.2%), Config (1.8%)
* 📚 Documentation: Text (75.1%), Markdown (24.9%)
* 📊 Commits: 488
* 📈 Lines of Code: 3194
* 📄 Lines of Documentation: 1195
* 🏷️ Tags: 6
* 📅 Development Period: 2021-05-21 to 2026-06-03
* 🏆 Score: 2.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: GPL-3.0
* 🏷️ Latest Release: 3.0.0 (2024-10-01)


This is the source code of my personal internet site and blog engine. All content is written in Gemini Gemtext format, but the script `gemtexter` generates multiple other static output formats (with zero JavaScript) from it. You can reach the site(s)...

=> https://codeberg.org/snonux/gemtexter View on Codeberg
=> https://github.com/snonux/gemtexter View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash gemtexter

---

### 31. scifi 31←31↙30↙29←29↙27↙26←26←26↙23←23↙22↙20←20↙19↙17↙16↙15↙10↙9↙8

* 💻 Languages: JSON (36.6%), JavaScript (30.2%), CSS (29.6%), HTML (3.7%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 27
* 📈 Lines of Code: 1724
* 📄 Lines of Documentation: 874
* 🏷️ Tags: 0
* 📅 Development Period: 2026-01-25 to 2026-03-13
* 🏆 Score: 1.9 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


A static HTML page showcasing a science fiction book collection. Works fully offline with all assets stored locally.

=> https://github.com/snonux/scifi View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash scifi

---

### 32. gos 32←32↙31↙30←30↙29↙28←28↖30↙29←29↙28↙26←26↙25↙24↙23←23↙19↙18←18

* 💻 Languages: Go (99.6%), Shell (0.2%), JSON (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 408
* 📈 Lines of Code: 4534
* 📄 Lines of Documentation: 477
* 🏷️ Tags: 17
* 📅 Development Period: 2024-05-04 to 2026-07-05
* 🏆 Score: 1.9 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.3.1 (2026-07-05)


=> showcase/gos/image-1.png gos screenshot

Gos is a Go-based replacement for Buffer.com, providing the ability to schedule and manage social media posts from the command line. It can be run, for example, every time you open a new shell or only once every N hours when you open a new shell.

=> https://codeberg.org/snonux/gos View on Codeberg
=> https://github.com/snonux/gos View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash gos

---

### 33. log4jbench 33←33↙32↙31←31↙30↙29←29←29↙28↙27↙26↙25←25↙23↙21↙20←20↙14↙11↙9

* 💻 Languages: Java (78.9%), XML (21.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 4
* 📈 Lines of Code: 774
* 📄 Lines of Documentation: 119
* 🏷️ Tags: 0
* 📅 Development Period: 2026-01-09 to 2026-01-09
* 🏆 Score: 1.6 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🧪 Status: Experimental (no releases yet)


A minimal Java tool to benchmark Log4j2 logging throughput with configurable concurrent threads and various logging configurations.

=> https://github.com/snonux/log4jbench View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash log4jbench

---

### 34. timr 34←34↙33←33←33↙32↙31←31↖32↙31←31↙30↙29←29↙27↙26↙25←25↙21↙20↙19

* 💻 Languages: Go (96.0%), Shell (4.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 32
* 📈 Lines of Code: 1538
* 📄 Lines of Documentation: 99
* 🏷️ Tags: 5
* 📅 Development Period: 2025-06-25 to 2026-01-02
* 🏆 Score: 1.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.3.0 (2026-01-02)


A simple command-line tool to track time spent on tasks. It has been primarily coded using Google Gemini CLI and Claude Code CLI.

=> https://github.com/snonux/timr View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash timr

---

### 35. foostats 35←35↙34↙32←32↙31↙30←30↖31↙30←30↙29↙28←28↙26↙25↙24←24↙20↙19↙17

* 💻 Languages: Perl (100.0%)
* 📚 Documentation: Markdown (54.6%), Text (45.4%)
* 📊 Commits: 98
* 📈 Lines of Code: 1902
* 📄 Lines of Documentation: 423
* 🏷️ Tags: 2
* 📅 Development Period: 2023-01-02 to 2025-11-01
* 🏆 Score: 1.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v0.2.0 (2025-10-21)


A privacy-respecting web analytics tool for OpenBSD that processes HTTP/HTTPS and Gemini protocol logs to generate anonymous site statistics. Designed for the foo.zone ecosystem and similar sites, it provides comprehensive traffic analysis while preserving visitor privacy through SHA3-512 IP hashing.

=> https://codeberg.org/snonux/foostats View on Codeberg
=> https://github.com/snonux/foostats View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash foostats

---

### 36. wireguardmeshgenerator 36←36↙35↙34←34↙33↙32←32↖33↙32←32↙31↙30←30↙29↙28↙27←27↙23↙22↖23

* 💻 Languages: Ruby (64.8%), YAML (35.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 42
* 📈 Lines of Code: 922
* 📄 Lines of Documentation: 24
* 🏷️ Tags: 1
* 📅 Development Period: 2025-04-18 to 2026-07-03
* 🏆 Score: 1.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.0.0 (2025-05-11)


Have a look at the `wireguardmeshgenerator.yaml`

=> https://codeberg.org/snonux/wireguardmeshgenerator View on Codeberg
=> https://github.com/snonux/wireguardmeshgenerator View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash wireguardmeshgenerator

---

### 37. ioriot 37←37↙36↙35←35↙34↙33←33↖34↙33←33↙32↙31←31↙30←30↙29←29↖34↖35←35

* 💻 Languages: C (58.7%), C/C++ (22.5%), Config (17.9%), Make (1.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 80
* 📈 Lines of Code: 13609
* 📄 Lines of Documentation: 899
* 🏷️ Tags: 7
* 📅 Development Period: 2018-03-01 to 2026-03-19
* 🏆 Score: 1.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Apache-2.0
* 🏷️ Latest Release: 0.5.1 (2019-01-04)


=> showcase/ioriot/image-1.png ioriot screenshot

...is an I/O benchmarking tool for Linux based operating systems which captures I/O operations on a (possibly production) server in order to replay the exact same I/O operations on a load test machine.

=> https://codeberg.org/snonux/ioriot View on Codeberg
=> https://github.com/snonux/ioriot View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash ioriot

---

### 38. quicklogger 38←38↙37↙36←36↙35↙34←34↖35↙34←34↙33↙32←32↙31←31↙30←30↙26←26↙25

* 💻 Languages: Go (96.3%), XML (2.3%), Shell (0.9%), TOML (0.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 43
* 📈 Lines of Code: 1556
* 📄 Lines of Documentation: 84
* 🏷️ Tags: 6
* 📅 Development Period: 2024-01-20 to 2026-04-09
* 🏆 Score: 0.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.1.1 (2026-04-09)


=> showcase/quicklogger/image-1.png quicklogger screenshot

This is a tiny GUI app written in Go using the Fyne framework to quickly log a message to a file. Read on my blog more about this: https://foo.zone/gemfeed/2024-03-03-a-fine-fyne-android-app-for-quickly-logging-ideas-programmed-in-golang.html

=> https://github.com/snonux/quicklogger View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash quicklogger

---

### 39. quicklog 39←39↙38↙37←37↙36↙35←35↖36↙35←35

* 💻 Languages: Dart (53.9%), CMake (13.5%), Kotlin (9.9%), C++ (9.2%), XML (8.0%), YAML (3.5%), C/C++ (2.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 44
* 📈 Lines of Code: 1794
* 📄 Lines of Documentation: 97
* 🏷️ Tags: 0
* 📅 Development Period: 2024-01-20 to 2026-05-08
* 🏆 Score: 0.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🧪 Status: Experimental (no releases yet)


=> showcase/quicklog/image-1.png quicklog screenshot

Tiny GUI app to quickly jot a thought into a timestamped Markdown file.
Originally a Go/Fyne app called *Quicklogger* — this is the Flutter rewrite,
renamed to **Quicklog**, targeting Android (primary) and Linux desktop
(development).

=> https://github.com/snonux/quicklog View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash quicklog

---

### 40. sillybench 40←40↙39↙38←38↙37↙36←36↖37↙36←36↙34↙33←33↙32←32↙31←31↙27←27←27

* 💻 Languages: Go (90.9%), Shell (9.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 5
* 📈 Lines of Code: 33
* 📄 Lines of Documentation: 3
* 🏷️ Tags: 0
* 📅 Development Period: 2025-04-03 to 2025-04-03
* 🏆 Score: 0.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


To compare how fast this runs on FreeBSD vs a Linux Bhyve VM

=> https://github.com/snonux/sillybench View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash sillybench

---

### 41. terraform 41←41↙40↙39←39↙38↙37←37↖38↙37←37↙35↙34←34↙33←33↙32←32↙28←28↙26

* 💻 Languages: HCL (96.6%), Make (1.9%), YAML (1.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 126
* 📈 Lines of Code: 2852
* 📄 Lines of Documentation: 52
* 🏷️ Tags: 0
* 📅 Development Period: 2023-08-27 to 2026-07-23
* 🏆 Score: 0.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

Go to AWS Secrets manager manually and create it!

=> https://codeberg.org/snonux/terraform View on Codeberg
=> https://github.com/snonux/terraform View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash terraform

---

### 42. guprecords 42←42↙41↙40←40↙39↙38←38↖39↙38←38↙36↙35←35↙34←34↙33↖42↙39↙29←29

* 💻 Languages: Raku (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 97
* 📈 Lines of Code: 383
* 📄 Lines of Documentation: 425
* 🏷️ Tags: 1
* 📅 Development Period: 2013-03-22 to 2026-03-07
* 🏆 Score: 0.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v1.0.0 (2023-04-29)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

guprecords: source code repository.

=> https://codeberg.org/snonux/guprecords View on Codeberg
=> https://github.com/snonux/guprecords View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash guprecords

---

### 43. photoalbum 43←43↙42↙41←41↙40←40←40↖42↙41←41↙40↙39←39↙38←38↙37↙36↙32↖33↖34

* 💻 Languages: Shell (92.5%), Make (4.6%), Config (2.9%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 159
* 📈 Lines of Code: 908
* 📄 Lines of Documentation: 42
* 🏷️ Tags: 18
* 📅 Development Period: 2011-11-19 to 2026-06-09
* 🏆 Score: 0.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.8.1 (2026-06-09)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

photoalbum is a minimal Bash script for Unix like operating systems (such as Linux) to generate static web photo albums.
The resulting static photo album is pure HTML+CSS (without any JavaScript!).

=> https://codeberg.org/snonux/photoalbum View on Codeberg
=> https://github.com/snonux/photoalbum View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash photoalbum

---

### 44. geheim 44←44↙43↙42←42↙41↙39←39↖40↙39←39↙37↙36←36↙35←35↙34↙33↙29↖30←30

* 💻 Languages: Ruby (86.7%), Shell (13.3%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 75
* 📈 Lines of Code: 822
* 📄 Lines of Documentation: 108
* 🏷️ Tags: 4
* 📅 Development Period: 2018-05-26 to 2026-03-07
* 🏆 Score: 0.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.3.1 (2025-11-01)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

> **⚠️ DEPRECATED:** This project is no longer maintained. I have switched to another solution and will not be doing any further work on this project.

=> https://codeberg.org/snonux/geheim View on Codeberg
=> https://github.com/snonux/geheim View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash geheim

---

### 45. gorum 45←45↙44↙43←43↙42↙41←41←41↙40←40↙38↙37←37↙36←36↙35↙34↙30↖31↙28

* 💻 Languages: Go (91.3%), JSON (6.4%), YAML (2.3%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 83
* 📈 Lines of Code: 1525
* 📄 Lines of Documentation: 17
* 🏷️ Tags: 0
* 📅 Development Period: 2023-04-17 to 2026-03-07
* 🏆 Score: 0.3 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

Gogios is a minimalistic quorum manager.

=> https://codeberg.org/snonux/gorum View on Codeberg
=> https://github.com/snonux/gorum View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash gorum

---

### 46. docker-radicale-server 46←46↙45↙44←44↙43↙42←42↖43↙42←42↙39↙38←38↙37←37↙36↙35↙31↖32↙31

* 💻 Languages: Make (57.5%), Docker (42.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 5
* 📈 Lines of Code: 40
* 📄 Lines of Documentation: 3
* 🏷️ Tags: 0
* 📅 Development Period: 2023-12-31 to 2025-08-11
* 🏆 Score: 0.3 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

For the Radicale server https://radicale.org

=> https://codeberg.org/snonux/docker-radicale-server View on Codeberg
=> https://github.com/snonux/docker-radicale-server View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash docker-radicale-server

---

### 47. randomjournalpage 47←47↙46↙45←45↙44↙43←43↖44↙43←43↙41↙40←40↙39←39↙38↙37↙33↖34↙33

* 💻 Languages: Shell (94.1%), Make (5.9%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 8
* 📈 Lines of Code: 51
* 📄 Lines of Documentation: 26
* 🏷️ Tags: 0
* 📅 Development Period: 2022-06-02 to 2024-04-20
* 🏆 Score: 0.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

This is a quick and dirty script which I use personally to grab a random PDF file (a scanned version of one of my bullet journals) and to extract a random set of pages from it in order to reflect/read what was happening in the past. This also includes various notes of books I have read and random ideas I wrote down and my want to reconsider.

=> https://codeberg.org/snonux/randomjournalpage View on Codeberg
=> https://github.com/snonux/randomjournalpage View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash randomjournalpage

---

### 48. failunderd 48

* 💻 Languages: Perl (89.7%), Config (5.0%), Make (3.1%), Shell (2.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 151
* 📈 Lines of Code: 614
* 📄 Lines of Documentation: 32
* 🏷️ Tags: 0
* 📅 Development Period: 2011-02-05 to 2022-05-13
* 🏆 Score: 0.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

Let me examine the project's source code to provide an accurate summary.
FailunderD is a zero-dependency failover automation daemon written in Perl for OpenBSD hosts on Hetzner Cloud, leveraging Hetzner's floating IPs to provide high availability across a small fleet of nodes. It runs as a system daemon (managed via `rcctl`) that periodically polls each configured participant's HTTP and Gemini endpoints, exchanges status JSON with partner nodes over a TCP socket, and computes a health "score" per peer. Stale or failing peers lose points, enabling the daemon to determine which node should hold the floating IP. Despite its name advertising "zero-dependency," the code relies only on Perl core modules (HTTP::Tiny, IO::Socket::INET, JSON::PP, Sys::Syslog) plus sendmail for email notifications.

Architecturally, it follows a small plugin-module pattern: `bin/failunderd` handles daemonization, PID management, signal handling, config parsing, and a timing-accurate main loop; `FailunderD::RunModules` dynamically discovers and instantiates modules from a configured directory and schedules their execution with sub-interval carry-over to avoid drift; `FailunderD::Logger` is a syslog/STDOUT singleton that also dispatches mail notifications via sendmail. The only shipped module, `FailunderD::Modules::Handler`, performs the actual health checks, status-file writes (atomic via tmp+rename), remote status fetches, score aggregation, and daily email reports — making the failover logic itself pluggable without touching the daemon core.

=> https://codeberg.org/snonux/failunderd View on Codeberg
=> https://github.com/snonux/failunderd View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash failunderd

---

### 49. algorithms 49↙48↖49↙46←46↙45↙44←44↖45↙44←44↙42↙41←41↙40←40↙39↙38↙35↖36↙32

* 💻 Languages: Go (96.5%), Make (2.0%), Config (1.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 84
* 📈 Lines of Code: 2107
* 📄 Lines of Documentation: 821
* 🏷️ Tags: 0
* 📅 Development Period: 2020-07-12 to 2026-07-06
* 🏆 Score: 0.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

This includes exercises from the Algorithms lecture. Well, this is just a refresher exercise.

=> https://github.com/snonux/algorithms View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash algorithms

---

### 50. staticfarm-apache-handlers 50↙49↙47←47←47↙46↙45←45↖46↙45←45↙43↙42←42↙41↖42↙41↙40↙37↖38↖40

* 💻 Languages: Perl (96.4%), Make (3.6%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 4
* 📈 Lines of Code: 919
* 📄 Lines of Documentation: 16
* 🏷️ Tags: 1
* 📅 Development Period: 2015-01-02 to 2026-03-07
* 🏆 Score: 0.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.1.3 (2015-01-02)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

DEPRECATED
    This project is no longer maintained. No further updates, bug fixes, or
    feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/staticfarm-apache-handlers View on Codeberg
=> https://github.com/snonux/staticfarm-apache-handlers View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash staticfarm-apache-handlers

---

### 51. ipv6test 51↙50↙48←48←48↙47↙46←46↖47↙46←46↙44↙43←43↙42↙41↙40↙39↙36↖37↙36

* 💻 Languages: Perl (65.8%), Docker (34.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 22
* 📈 Lines of Code: 149
* 📄 Lines of Documentation: 21
* 🏷️ Tags: 0
* 📅 Development Period: 2011-07-09 to 2026-02-17
* 🏆 Score: 0.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

This is a quick and dirty Perl-based IPv6 test website.

=> https://codeberg.org/snonux/ipv6test View on Codeberg
=> https://github.com/snonux/ipv6test View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash ipv6test

---

### 52. sway-autorotate 52↙51↙50↙49←49↙48↙47←47↖48↙47←47↙45↙44←44↙43←43↙42↙41↙38↖39↙38

* 💻 Languages: Shell (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 8
* 📈 Lines of Code: 41
* 📄 Lines of Documentation: 17
* 🏷️ Tags: 0
* 📅 Development Period: 2020-01-30 to 2025-04-30
* 🏆 Score: 0.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: GPL-3.0
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

This is a fork of https://github.com/tedk0n/autorotate_sway_script

=> https://codeberg.org/snonux/sway-autorotate View on Codeberg
=> https://github.com/snonux/sway-autorotate View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash sway-autorotate

---

### 53. mon 53↙52↙51↙50←50↙49↙48←48↖49↙48←48↙46↙45←45↙44←44↙43←43↙40←40↙39

* 💻 Languages: Perl (96.5%), Shell (1.8%), Make (1.2%), Config (0.4%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 8
* 📈 Lines of Code: 5360
* 📄 Lines of Documentation: 793
* 🏷️ Tags: 2
* 📅 Development Period: 2015-01-02 to 2026-03-07
* 🏆 Score: 0.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.0.1 (2015-01-02)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

DEPRECATED
    This project is no longer maintained. No further updates, bug fixes, or
    feature additions will be made. Use at your own risk.

=> https://github.com/snonux/mon View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash mon

---

### 54. fapi 54↙53↙52↙51←51↙50↙49←49↖50↙49←49↙47↙46←46↙45↖46↙44←44↙41←41↖44

* 💻 Languages: Python (96.6%), Make (3.1%), Config (0.3%)
* 📚 Documentation: Text (98.3%), Markdown (1.7%)
* 📊 Commits: 222
* 📈 Lines of Code: 1681
* 📄 Lines of Documentation: 543
* 🏷️ Tags: 32
* 📅 Development Period: 2014-03-10 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.0.2 (2014-11-17)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

DEPRECATED
    This project is no longer maintained. No further updates, bug fixes, or
    feature additions will be made. Use at your own risk.

=> https://github.com/snonux/fapi View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash fapi

---

### 55. pingdomfetch 55↙54↙53↙52←52↙51←51←51↖52↙51←51↙49↙48←48↙47←47↙45←45↙42←42↙41

* 💻 Languages: Perl (97.3%), Make (2.7%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 10
* 📈 Lines of Code: 1839
* 📄 Lines of Documentation: 416
* 🏷️ Tags: 3
* 📅 Development Period: 2015-01-02 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.0.2 (2015-01-02)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

DEPRECATED
    This project is no longer maintained. No further updates, bug fixes, or
    feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/pingdomfetch View on Codeberg
=> https://github.com/snonux/pingdomfetch View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash pingdomfetch

---

### 56. playground 56↙55↙54←54←54↙53←53←53

* 💻 Languages: Ruby (100.0%)
* 📊 Commits: 5
* 📈 Lines of Code: 15
* 🏷️ Tags: 0
* 📅 Development Period: 2021-01-02 to 2025-06-09
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

playground: source code repository.

=> https://codeberg.org/snonux/playground View on Codeberg
=> https://github.com/snonux/playground View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash playground

---

### 57. loadbars 57↙23↙22↙21←21↙20↙19←19←19↖53←53↙51↙50←50↙49←49↙46↙10↙6↙5↖47

* 💻 Languages: Perl (97.4%), Make (2.6%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 501
* 📈 Lines of Code: 1828
* 📄 Lines of Documentation: 100
* 🏷️ Tags: 24
* 📅 Development Period: 2010-11-05 to 2015-05-23
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.7.5 (2014-06-22)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

Loadbars is a real-time server load monitoring tool that visualizes CPU, memory, network, load average, and disk I/O statistics for multiple remote Linux servers simultaneously in an SDL2 window. It connects to hosts via SSH (using key-based auth) and runs an embedded Bash script that reads from `/proc`, parsing metrics like per-core CPU usage, RAM/swap, network throughput, and disk I/O — then renders them as vertical colored bars side by side. Unlike graphing tools that require data collection over time, Loadbars shows only the current state (like `top` or `vmstat`), making it useful for quick, at-a-glance monitoring of cluster health across many machines.

Architecturally, the Go binary embeds the remote monitoring script at build time and runs it locally or over SSH via `bash -s`, so remote hosts need only bash and `/proc` (no Go installation required). The codebase is organized into `internal/` packages: `collector` handles script execution and metric parsing, `display` manages the SDL2 rendering loop and hotkey-driven toggles (per-core vs. aggregate views, extended peak lines, memory/network/load/disk bars), `config` manages CLI flags and `~/.loadbarsrc` persistence, and `stats` defines the shared data structures. macOS is supported as a client for monitoring remote Linux hosts, though local monitoring requires Linux.

=> https://codeberg.org/snonux/loadbars View on Codeberg
=> https://github.com/snonux/loadbars View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash loadbars

---

### 58. pwgrep 58↙56↙55←55←55↙54←54←54←54←54←54↙52↙51←51↙50←50↙47←47↙44←44↖50

* 💻 Languages: Shell (85.0%), Make (15.0%)
* 📚 Documentation: Text (75.0%), Markdown (25.0%)
* 📊 Commits: 115
* 📈 Lines of Code: 493
* 📄 Lines of Documentation: 28
* 🏷️ Tags: 22
* 📅 Development Period: 2009-09-27 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.9.3 (2014-06-14)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

> **⚠️ DEPRECATED:** This project is no longer maintained. No further updates, bug fixes, or feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/pwgrep View on Codeberg
=> https://github.com/snonux/pwgrep View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash pwgrep

---

### 59. xerl 59↙57↙56←56←56↙55↙50←50↖51↙50←50↙48↙47←47↙46↙45↖48←48↙45←45↙42

* 💻 Languages: Perl (98.3%), Config (1.2%), Make (0.5%)
* 📊 Commits: 143
* 📈 Lines of Code: 1675
* 🏷️ Tags: 1
* 📅 Development Period: 2011-03-06 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.0.0 (2018-12-22)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

Those are the host templates to be used with Xerl itself.

=> https://codeberg.org/snonux/xerl View on Codeberg
=> https://github.com/snonux/xerl View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash xerl

---

### 60. awksite 60↙58↙57←57←57↙56↙55←55←55←55←55↙53↙52←52↙51←51↙49←49↙46←46↖61

* 💻 Languages: AWK (72.1%), HTML (16.4%), Config (11.5%)
* 📚 Documentation: Markdown (50.0%), Text (50.0%)
* 📊 Commits: 3
* 📈 Lines of Code: 122
* 📄 Lines of Documentation: 12
* 🏷️ Tags: 1
* 📅 Development Period: 2011-01-27 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.2 (2011-01-27)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

Awksite is a minimal CGI application written entirely in GNU AWK that generates dynamic HTML pages using a simple template engine. It reads key-value pairs from a configuration file (`awksite.conf`), where values can be static strings or shell commands (prefixed with `!`), then substitutes `%%key%%` placeholders in an HTML template file with the corresponding values. It also supports a `!sort` directive to insert sorted file contents. The entire runtime is a single 88-line AWK script, making it incredibly lightweight and portable across any Unix system with GNU AWK.

It's useful for quickly standing up simple dynamic websites—like server status pages—without needing a full programming language runtime or web framework. The architecture is straightforward: `index.cgi` reads the config, emits an HTTP header, and iterates over the template line by line, recursively resolving any `%%placeholder%%` tags by looking up values (or executing shell commands) from the config.

=> https://codeberg.org/snonux/awksite View on Codeberg
=> https://github.com/snonux/awksite View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash awksite

---

### 61. gotop 61↙59↙58←58←58↙57↙56←56←56←56←56↙54↙53←53↙52←52↙50←50↙47←47↖48

* 💻 Languages: Go (98.0%), Make (2.0%)
* 📚 Documentation: Markdown (60.0%), Text (40.0%)
* 📊 Commits: 58
* 📈 Lines of Code: 499
* 📄 Lines of Documentation: 10
* 🏷️ Tags: 1
* 📅 Development Period: 2015-05-24 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.1 (2015-06-01)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

> **⚠️ DEPRECATED:** This project is no longer maintained. No further updates, bug fixes, or feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/gotop View on Codeberg
=> https://github.com/snonux/gotop View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash gotop

---

### 62. japi 62↙60↙59←59←59↙58↙57←57←57←57←57↙55↙54←54↙53←53↙51←51↙48←48↖53

* 💻 Languages: Perl (78.3%), Make (21.7%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 42
* 📈 Lines of Code: 286
* 📄 Lines of Documentation: 148
* 🏷️ Tags: 12
* 📅 Development Period: 2013-03-22 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.4.3 (2014-06-16)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

DEPRECATED
    This project is no longer maintained. No further updates, bug fixes, or
    feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/japi View on Codeberg
=> https://github.com/snonux/japi View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash japi

---

### 63. perldaemon 63↙61↙60←60←60↙59↙58←58←58←58←58↙56↙55←55↙54←54↙52↖55↙52↙49↖51

* 💻 Languages: Perl (72.7%), Shell (23.9%), Config (3.4%)
* 📊 Commits: 111
* 📈 Lines of Code: 611
* 🏷️ Tags: 6
* 📅 Development Period: 2011-02-05 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.4 (2022-04-29)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

PerlDaemon is a minimal daemon for Linux and other UNIX a like operating system
programmed in Perl.  It can be extended to fit any task...

=> https://codeberg.org/snonux/perldaemon View on Codeberg
=> https://github.com/snonux/perldaemon View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash perldaemon

---

### 64. rubyfy 64↙62↙61←61←61↙60↙59←59←59←59←59↙57↙56←56↙55←55↙53↙52↙49↖50↙49

* 💻 Languages: Ruby (98.5%), JSON (1.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 35
* 📈 Lines of Code: 273
* 📄 Lines of Documentation: 34
* 🏷️ Tags: 1
* 📅 Development Period: 2015-09-29 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Apache-2.0
* 🏷️ Latest Release: 0 (2015-10-26)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

> **⚠️ DEPRECATED:** This project is no longer maintained. No further updates, bug fixes, or feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/rubyfy View on Codeberg
=> https://github.com/snonux/rubyfy View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash rubyfy

---

### 65. netdiff 65↙63↙62↖63←63↙62↙61←61←61←61←61↙59↙58←58↙57←57↙55↙54↙51↖52↖56

* 💻 Languages: Shell (52.2%), Make (46.3%), Config (1.5%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 43
* 📈 Lines of Code: 134
* 📄 Lines of Documentation: 110
* 🏷️ Tags: 10
* 📅 Development Period: 2013-03-22 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.1.5 (2014-06-22)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

DEPRECATED
    This project is no longer maintained. No further updates, bug fixes, or
    feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/netdiff View on Codeberg
=> https://github.com/snonux/netdiff View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash netdiff

---

### 66. perl-c-fibonacci 66↙64↙63↙62←62↙61↙60←60←60←60←60↙58↙57←57↙56←56↙54↙53↙50↖51↙45

* 💻 Languages: C (80.4%), Make (19.6%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 4
* 📈 Lines of Code: 51
* 📄 Lines of Documentation: 69
* 🏷️ Tags: 0
* 📅 Development Period: 2014-03-24 to 2022-04-23
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

perl-c-fibonacci: source code repository.

=> https://codeberg.org/snonux/perl-c-fibonacci View on Codeberg
=> https://github.com/snonux/perl-c-fibonacci View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash perl-c-fibonacci

---

### 67. muttdelay 67↙65↙64←64←64↙63↙62←62←62←62←62↙60↙59←59↙58←58↙56↖57↙54←54↖55

* 💻 Languages: Make (47.1%), Shell (46.3%), Vim Script (5.9%), Config (0.7%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 42
* 📈 Lines of Code: 136
* 📄 Lines of Documentation: 100
* 🏷️ Tags: 4
* 📅 Development Period: 2013-03-22 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.2.0 (2014-07-05)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

DEPRECATED
    This project is no longer maintained. No further updates, bug fixes, or
    feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/muttdelay View on Codeberg
=> https://github.com/snonux/muttdelay View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash muttdelay

---

### 68. cpuinfo 68↙66↙65←65←65↙64↙63←63←63←63←63↙61↙60←60↙59←59↙57↖60↙57↙56↖59

* 💻 Languages: Shell (53.2%), Make (46.8%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 26
* 📈 Lines of Code: 124
* 📄 Lines of Documentation: 75
* 🏷️ Tags: 3
* 📅 Development Period: 2010-11-05 to 2021-11-05
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.0.2 (2014-06-22)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

cpuinfo - A small and humble tool to print out CPU data

=> https://codeberg.org/snonux/cpuinfo View on Codeberg
=> https://github.com/snonux/cpuinfo View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash cpuinfo

---

### 69. dyndns 69↙67↙66←66←66↙65↙64←64↖65←65←65↙63↙62←62↙61←61↙59↖62↙59↙58↖62

* 💻 Languages: Shell (100.0%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 4
* 📈 Lines of Code: 18
* 📄 Lines of Documentation: 53
* 🏷️ Tags: 0
* 📅 Development Period: 2014-03-24 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

DEPRECATED
    This project is no longer maintained. No further updates, bug fixes, or
    feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/dyndns View on Codeberg
=> https://github.com/snonux/dyndns View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash dyndns

---

### 70. debroid 70↙68↙67←67←67↙66↙65←65↖66←66←66↙64↙63←63↙62←62↙60↖63↙60↙59↙57

* 💻 Languages: Shell (92.0%), Make (8.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 17
* 📈 Lines of Code: 88
* 📄 Lines of Documentation: 150
* 🏷️ Tags: 1
* 📅 Development Period: 2015-06-18 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

=> showcase/debroid/image-1.png debroid screenshot

> **⚠️ DEPRECATED:** This project is no longer maintained. No further updates, bug fixes, or feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/debroid View on Codeberg
=> https://github.com/snonux/debroid View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash debroid

---

### 71. netcalendar 71↙69←69←69←69↙68↙67←67↖68←68←68↙66↙65←65↙64←64↙61↙58↙55←55↙46

* 💻 Languages: Java (83.0%), HTML (12.9%), XML (3.0%), CSS (0.8%), Make (0.2%)
* 📚 Documentation: Text (89.5%), Markdown (10.5%)
* 📊 Commits: 50
* 📈 Lines of Code: 17380
* 📄 Lines of Documentation: 949
* 🏷️ Tags: 0
* 📅 Development Period: 2009-02-07 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: GPL-2.0
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

=> showcase/netcalendar/image-1.png netcalendar screenshot

> **⚠️ DEPRECATED:** This project is no longer maintained. No further updates, bug fixes, or feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/netcalendar View on Codeberg
=> https://github.com/snonux/netcalendar View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash netcalendar

---

### 72. jsmstrade 72↙70←70←70←70↙69↙68←68↖69←69←69↙67↙66←66↙65←65↙62↙56↙53←53↙52

* 💻 Languages: Java (76.0%), Shell (15.4%), XML (8.6%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 14
* 📈 Lines of Code: 720
* 📄 Lines of Documentation: 8
* 🏷️ Tags: 0
* 📅 Development Period: 2008-06-21 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

=> showcase/jsmstrade/image-1.png jsmstrade screenshot

> **⚠️ DEPRECATED:** This project is no longer maintained. No further updates, bug fixes, or feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/jsmstrade View on Codeberg
=> https://github.com/snonux/jsmstrade View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash jsmstrade

---

### 73. template 73↙71←71←71←71↙70←70←70↙64←64←64↙62↙61←61↙60←60↙58↖61↙58↙57↖60

* 💻 Languages: Make (89.2%), Shell (10.8%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 23
* 📈 Lines of Code: 65
* 📄 Lines of Documentation: 232
* 🏷️ Tags: 1
* 📅 Development Period: 2013-03-22 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

DEPRECATED
    This project is no longer maintained. No further updates, bug fixes, or
    feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/template View on Codeberg
=> https://github.com/snonux/template View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash template

---

### 74. vs-sim 74↙72←72←72←72↙71↙69←69↖70←70←70↙68↙67←67↙66←66↙64↙59↙56↖63←63

* 💻 Languages: Java (98.8%), Shell (0.7%), XML (0.4%)
* 📚 Documentation: LaTeX (98.3%), Text (1.4%), Markdown (0.3%)
* 📊 Commits: 396
* 📈 Lines of Code: 16303
* 📄 Lines of Documentation: 2905
* 🏷️ Tags: 0
* 📅 Development Period: 2008-05-15 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

=> showcase/vs-sim/image-1.jpg vs-sim screenshot

VS-Sim is an open source simulator programmed in Java for distributed systems. VS-Sim stands for "Verteilte Systeme Simulator" which is the german translation for "Distributed Sytstems Simulator".

=> https://codeberg.org/snonux/vs-sim View on Codeberg
=> https://github.com/snonux/vs-sim View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash vs-sim

---

### 75. perl-poetry 75↙73←73←73←73↙72↙71←71←71←71←71↙69↙68←68↙67←67↙65↙64↙61↙60↙54

* 💻 Languages: Perl (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 2
* 📈 Lines of Code: 191
* 📄 Lines of Documentation: 8
* 🏷️ Tags: 0
* 📅 Development Period: 2014-03-24 to 2014-03-24
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

Here you find some Poetry written in Perl.

=> https://codeberg.org/snonux/perl-poetry View on Codeberg
=> https://github.com/snonux/perl-poetry View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash perl-poetry

---

### 76. fype 76↙74←74↙53←53↙52←52←52↖53↙52←52↙50↙49←49↙48←48↖66↙46↙43←43↙37

* 💻 Languages: C (72.1%), C/C++ (20.7%), HTML (5.7%), Make (1.5%)
* 📚 Documentation: Text (71.3%), LaTeX (28.7%)
* 📊 Commits: 83
* 📈 Lines of Code: 10196
* 📄 Lines of Documentation: 1741
* 🏷️ Tags: 0
* 📅 Development Period: 2008-05-15 to 2021-11-03
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

**F**or **Y**our **P**rogram **E**xecution — a lightweight scripting language.

=> https://codeberg.org/snonux/fype View on Codeberg
=> https://github.com/snonux/fype View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash fype

---

### 77. hsbot 77↙75←75↙74←74↙73↙72←72←72←72←72↙70↙69←69↙68←68↙67↙65↙62↙61↙58

* 💻 Languages: Haskell (98.5%), Make (1.5%)
* 📊 Commits: 81
* 📈 Lines of Code: 601
* 🏷️ Tags: 0
* 📅 Development Period: 2009-11-22 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

This project is no longer maintained. No further updates, bug fixes, or
feature additions will be made. Use at your own risk.

=> https://codeberg.org/snonux/hsbot View on Codeberg
=> https://github.com/snonux/hsbot View on GitHub
For cgit access go to c-git dot f3s dot buetow dot org slash hsbot
