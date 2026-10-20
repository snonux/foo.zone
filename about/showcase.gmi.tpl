# Project Showcase

Generated on: 2026-10-19

=> showcase-rank-history.svg Interactive Project Rank History Graph (SVG)

This page showcases my side projects, providing an overview of what each project does, its technical implementation, and key metrics. Each project summary includes information about the programming languages used, development activity, releases, and licensing. The projects are ranked by score, which combines recent activity, project size, tag history, and whether the project has shipped a release.

<< template::inline::toc

## Overall Statistics

* 📦 Total Projects: 88
* 📊 Total Commits: 18,564
* 📈 Total Lines of Code: 1,821,333
* 📄 Total Lines of Documentation: 154,567
* 💻 Languages: Go (43.9%), C++ (15.8%), Dart (11.4%), C (6.9%), Shell (4.6%), Java (3.3%), JavaScript (3.0%), YAML (1.6%), Python (1.5%), XML (1.3%), JSON (1.3%), C/C++ (1.2%), Perl (0.9%), TypeScript (0.8%), CSS (0.5%), HTML (0.5%), Kotlin (0.4%), Ruby (0.4%), Config (0.3%), TOML (0.2%), HCL (0.2%), Make (0.1%)
* 📚 Documentation: Markdown (82.1%), Text (15.7%), LaTeX (2.2%)
* 🚀 Release Status: 57 released, 31 experimental (64.8% with releases, 35.2% experimental)

## Projects

### 1. gunrunners

* 💻 Languages: C++ (92.3%), Python (4.3%), C (1.9%), Shell (0.4%), HTML (0.3%), CMake (0.2%), CSS (0.2%), JavaScript (0.2%)
* 📚 Documentation: Text (85.2%), Markdown (14.8%)
* 📊 Commits: 329
* 📈 Lines of Code: 286751
* 📄 Lines of Documentation: 13722
* 🏷️ Tags: 18
* 📅 Development Period: 2026-10-08 to 2026-10-17
* 🏆 Score: 179.9 (combines recent activity, code size, tags, and release status)
* ⚖️ License: GPL-2.0
* 🏷️ Latest Release: v0.10.3 (2026-10-17)


=> showcase/gunrunners/image-1.gif gunrunners screenshot

Gunrunners is a free, open-source (GPLv2+) jump-and-shoot platformer that plays like Duke Nukem II, offering a 49-level campaign across six episodes plus a standalone seventh episode ("Deep Space"). Every level has its own gameplay twist (rhythm-synced neon platforms, rising sludge tides, gravity flips, a fight along a moving train), its own prototype weapon, its own soundtrack, and a hidden bonus level behind a patch of TV static. Players choose from six built-in runners or create their own in a full runner editor, and can swap runners mid-level, carry up to three guns, and pilot six vehicles from tank to mech. The game works both as a complete modern title and as a faithful tribute: movement is a frame-accurate port of Duke Nukem II's physics (via RigelEngine), expanded with modern features like double jumps, an auto-drawing exploration map, a cheat menu, and accessibility options such as a guide arrow, adjustable game speed, and fully rebindable controls.

=> showcase/gunrunners/image-2.jpg gunrunners screenshot

The game is implemented in C++ and built with CMake, with smooth HD vector graphics rendered via Cairo, and all sound effects and music synthesized in real time by the game itself—no audio samples at all. SDL2 handles windowing and input (including keyboard, gamepad, and touch), and libcurl supports optional S3-compatible cloud saves. A single codebase targets three platforms: native Linux, Android (distributed via F-Droid, with intelligent thumb-zone touch controls that yield to connected gamepads), and the browser through an Emscripten build (~20 MB). The project also includes five save slots plus quick save/load, per-runner voices, a comprehensive test suite, and gameplay recording.

=> https://github.com/snonux/gunrunners View on GitHub

---

### 2. player

* 💻 Languages: Dart (44.1%), Go (39.7%), JavaScript (7.2%), TypeScript (5.5%), CSS (1.3%), Python (0.6%), HTML (0.5%), Kotlin (0.4%), YAML (0.2%), Shell (0.2%), JSON (0.2%)
* 📚 Documentation: Markdown (99.9%), Text (0.1%)
* 📊 Commits: 497
* 📈 Lines of Code: 148408
* 📄 Lines of Documentation: 9415
* 🏷️ Tags: 21
* 📅 Development Period: 2026-04-28 to 2026-10-19
* 🏆 Score: 155.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.8.2 (2026-10-19)


=> showcase/player/image-1.png player screenshot

**Player** is a self-hosted media player built as a monorepo containing a Go server (`player-server`) and a Flutter Android client (`player-android`). The server is the core of the system: it hosts the web UI for browsing a media library, serves playback APIs, and manages user accounts and media storage. It supports multiple content types—including images (with a mini viewer) and audio playback such as audiobooks, with chapter navigation. The Android client is a lightweight Flutter app that acts as a mobile front end, talking to the server through the same documented REST API, allowing users to access their library on the go.

=> showcase/player/image-2.png player screenshot

Architecturally, the repo is organized into two self-contained component directories, each with its own README, build process (Mage for the server, standard Flutter tooling for Android), and documentation. The server is a single binary with an embedded web UI, relies on ffmpeg/ffprobe for media processing, and ships deployment files for Docker and Kubernetes. Releases are tightly coordinated: a single shared version and tag covers both components, and a GitHub Actions workflow validates version parity, publishes signed Android APKs (also distributed via F-Droid), and produces a Linux server bundle containing the binary and web assets. This shared release process, along with API documentation that both clients must stay aligned with, keeps the server and mobile client in sync as a unified product.

=> https://github.com/snonux/player View on GitHub

---

### 3. conf

* 💻 Languages: YAML (57.8%), Shell (17.1%), Go (16.5%), Perl (4.1%), Python (2.1%), Make (0.8%), Config (0.7%), JSON (0.6%), Docker (0.2%)
* 📚 Documentation: Markdown (97.7%), Text (2.3%)
* 📊 Commits: 1519
* 📈 Lines of Code: 46671
* 📄 Lines of Documentation: 9920
* 🏷️ Tags: 2
* 📅 Development Period: 2021-12-28 to 2026-10-17
* 🏆 Score: 110.9 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


This repository (`conf`) is configuration-as-code for a personal homelab spanning a heterogeneous fleet: OpenBSD frontends (blowfish, fishfinger), NetBSD and Rocky Linux Raspberry Pis, Rocky Linux k3s nodes (r0–r2), and FreeBSD storage hosts (f0–f3), organized into named clusters. Its value is reproducible, idempotent management of the whole environment from one checkout — unattended upgrades and vulnerability audits on every OS, OpenBSD web/mail/DNS services (httpd, NSD, OpenSMTPD, relayd, PF, WireGuard), monitoring (Gogios, DTail, Foostats), certificate handling, and a full GitOps-driven k3s platform ("f3s") with ArgoCD apps, Helm charts, cert-manager, Prometheus/Loki/Tempo, Pi-hole, a private registry, media workloads (Immich, Navidrome), and Garage object storage.

Architecturally it has two halves. The first is **gonf recipes** — Go code against the external `snonux/gonf` library (pinned at v0.25.0), run via `./gonf.sh`, with 61 tasks grouped per host cluster. Tasks declare dependencies (`Needs`), aggregate via prefix-matching, bind to clusters (`OnCluster`), and consume typed per-host inventory data; a plan mode records `plan.jsonl` for dry-run previews, and secrets resolve through logical paths mapped to a KeePass/foostore vault (failing hard, never falling back). The second is the **f3s directory** of k3s manifests, Helm charts, and ArgoCD applications, each app exposing a uniform `Justfile` (`status`, `logs`, `port-forward`, `sync`, `restart`). Supporting pieces include a `packages/` build system publishing custom RPM/pkg packages to a private repo, OpenBSD frontend assets, and archived operational docs.

=> https://github.com/snonux/conf View on GitHub

---

### 4. comicredr

* 💻 Languages: Dart (74.8%), Shell (13.8%), Python (5.0%), TOML (2.5%), JSON (1.7%), YAML (0.6%), C++ (0.4%), Make (0.4%), Kotlin (0.3%), CMake (0.3%), XML (0.2%), C (0.1%)
* 📚 Documentation: Markdown (97.2%), Text (2.8%)
* 📊 Commits: 540
* 📈 Lines of Code: 90730
* 📄 Lines of Documentation: 7371
* 🏷️ Tags: 22
* 📅 Development Period: 2026-09-24 to 2026-10-19
* 🏆 Score: 92.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Apache-2.0
* 🏷️ Latest Release: v0.9.3 (2026-10-19)


=> showcase/comicredr/image-1.gif comicredr screenshot

**ComicRedr** is a free, open-source comic reader for Linux laptops and Android phones/tablets that recreates the Comixology-style "guided view" reading experience: pages can be stepped through panel by panel, and even speech balloon by speech balloon, with an animation gliding between each. It's designed around local ownership of your data — it reads comics you already have (CBZ, CBT, comic EPUB, PDF, and image folders/files), runs entirely on your own machine with no account or cloud service, and only offers optional cross-device sync through an S3 bucket you control (such as a self-hosted Garage instance). Privacy and offline usability are central to the design.

=> showcase/comicredr/image-2.svg comicredr screenshot

Implementation-wise, panel and balloon detection is handled by a small model built into the app that runs locally on CPU. Alternatively, users can have a coding agent (Claude Code or Codex) pre-draw panel boundaries next to their comics. Beyond guided viewing, the app includes a full library manager (covers, series, search, collections, bookmarks with notes, reading history), resumes exactly where you left off — down to the page, panel, and zoom level — and syncs that position across devices. Reading tools include two-page spreads, zoom, a night filter, margin trimming, and clean-up for yellowed scans. The interface is keyboard-first with an optional vi layer, fully configurable keybindings and tap zones, and complete touch support, with Linux installations built from source and Android available via a custom F-Droid repository.

=> https://github.com/snonux/comicredr View on GitHub

---

### 5. snonux.foo

* 💻 Languages: JavaScript (65.9%), JSON (16.4%), Go (11.5%), CSS (6.2%)
* 📚 Documentation: Text (53.3%), Markdown (46.7%)
* 📊 Commits: 288
* 📈 Lines of Code: 53019
* 📄 Lines of Documentation: 1803
* 🏷️ Tags: 41
* 📅 Development Period: 2026-04-06 to 2026-10-13
* 🏆 Score: 77.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.20.4 (2026-10-13)


**snonux** is a Go-based static site generator purpose-built for microblogging, powering [snonux.foo](https://snonux.foo). Its publishing workflow is file-drop simple: you place source files into an input directory (`./inbox` by default) — plain text, Markdown (GFM with raw HTML pass-through and automatic embedding of locally referenced images), standalone images (auto-downscaled past 1024px and re-encoded as JPEG), or MP3 audio (rendered with an HTML5 player) — and each becomes a post rendered into a self-contained static site with paginated HTML pages, an Atom feed (last 42 entries), and a favicon. Because output is entirely static and fonts are bundled rather than fetched from CDNs, it needs no database, no runtime web service, and makes no external requests — making it useful for low-maintenance, privacy-respecting personal publishing, especially paired with its `--sync` flag that rsyncs output to remote hosts over LAN with WireGuard fallback.

Architecturally, it's a single Go binary (`cmd/snonux`) whose generator lives in `internal/generator/templates`. Each post becomes a `posts/<timestamp>/` directory containing a `post.json` (metadata plus rendered HTML) and its assets, and source files are consumed from the inbox once processed. The theme system is the standout feature: roughly twenty visual themes (e.g., dos, matrix, synthwave, noir, tropicale), each with its own stylesheet, distinct bundled web fonts, and a themed WebGL background. An embed pipeline (`embed.go`) automatically discovers `*.woff`/`*.woff2` font files and license files within any theme directory and copies them to the distribution folder, so adding fonts or themes requires no Go code changes. Every theme also ships its own arcade game — ten levels, sound, cookie-saved progress, and mobile-friendly fullscreen touch controls — built on a shared JavaScript engine (`shared/games.js`) with per-theme game logic in separate `game.js` files, tested via headless-Chrome e2e suites and benchmarked for frame rate and CPU cost.

=> https://github.com/snonux/snonux.foo View on GitHub

---

### 6. turbolaunch

* 💻 Languages: Dart (73.9%), Shell (12.9%), Kotlin (9.8%), YAML (1.8%), XML (1.6%)
* 📚 Documentation: Markdown (93.4%), Text (6.6%)
* 📊 Commits: 122
* 📈 Lines of Code: 11962
* 📄 Lines of Documentation: 971
* 🏷️ Tags: 13
* 📅 Development Period: 2026-10-08 to 2026-10-16
* 🏆 Score: 76.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.3.10 (2026-10-16)


=> showcase/turbolaunch/image-1.png turbolaunch screenshot

TurboLaunch is a minimalist, search-first home screen replacement for Android, built specifically for GrapheneOS and privacy-conscious users. Its core interaction model is simple: press Home, type two or three letters, and hit Enter to launch an app. The search uses fzf-style fuzzy matching—letters in order with gaps allowed (e.g., "orgm" finds Organic Maps), with matched letters highlighted and the top match launched on Enter. Beyond search, it offers an always-visible search box, a quick launch bar for rarely-used-but-frequently-wanted apps like the camera, app shortcuts as search results, searchable split-screen app pairs, customizable gestures and swipes (including flashlight and quick settings), work profile support with badges, and a stats screen showing launch counts.

=> showcase/turbolaunch/image-2.png turbolaunch screenshot

The key architectural idea is a usage-aware, optionally synced home grid: apps are arranged by launch frequency over a configurable window (default: last 30 days), placing the most-used apps nearest the thumb, with an option to keep icons static instead. Launch counts aggregate across devices by syncing through the user's own S3-compatible bucket (Garage, MinIO, AWS), where apps missing on a given phone keep their grid cell as a faded ghost. The app contains no tracking and no Google Play Services—optional S3 sync is its only network use—and everything can be exported and imported as a single JSON file for migrating phones. It's MIT-licensed and distributed via a F-Droid repository or direct APK downloads.

=> https://github.com/snonux/turbolaunch View on GitHub

---

### 7. turbomon

* 💻 Languages: Dart (82.8%), Kotlin (13.1%), XML (2.9%), YAML (0.7%), Python (0.4%), JavaScript (0.1%)
* 📚 Documentation: Markdown (87.6%), Text (12.4%)
* 📊 Commits: 26
* 📈 Lines of Code: 13184
* 📄 Lines of Documentation: 1376
* 🏷️ Tags: 3
* 📅 Development Period: 2026-10-10 to 2026-10-15
* 🏆 Score: 70.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.2.1 (2026-10-15)


=> showcase/turbomon/image-1.png turbomon screenshot

TurboMon is a comprehensive system monitor for Android that provides a `top`-style view of CPU, RAM, and GPU usage, along with live graphs that change colour to reflect load levels. Beyond core metrics, it covers battery status, temperatures, storage, disk I/O, network speed, plus a Wi-Fi channel analyser and Bluetooth scanner in dedicated tabs. Its standout feature is the **snapshot**: a one-tap Markdown report capturing the device's current state, designed to be handed directly to an LLM so it can diagnose what's draining the phone and suggest a fix—bridging the gap between raw telemetry and actionable answers.

=> showcase/turbomon/image-2.png turbomon screenshot

The project is built with a strong privacy-first architecture: TurboMon has **no internet permission at all**, so every reading stays on the device. It runs with standard Android permissions out of the box, but optionally integrates with Shizuku or root to unlock deeper data—true CPU percentages, the process list, and every thermal sensor. The UI is organized into focused tabs (System, Power, I/O, etc.), with background scanning for continuous monitoring and both a home-screen widget and a floating overlay for at-a-glance stats. Distributed via F-Droid under the MIT license, it's aimed at users who want deep visibility into their phone without giving up data privacy.

=> https://github.com/snonux/turbomon View on GitHub

---

### 8. dotfiles

* 💻 Languages: Shell (79.8%), Python (7.0%), Go (6.0%), Config (2.0%), TOML (1.6%), CSS (1.4%), Ruby (0.8%), JSON (0.7%), YAML (0.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 1514
* 📈 Lines of Code: 22711
* 📄 Lines of Documentation: 23154
* 🏷️ Tags: 2
* 📅 Development Period: 2023-07-30 to 2026-10-18
* 🏆 Score: 57.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


This repository is a collection of personal dotfiles and system configuration for a small fleet of machines (Fedora, Rocky Linux, FreeBSD, and macOS hosts), managing everything from shell configs (bash, fish, zsh), editors (helix), terminal multiplexer (tmux), and the sway/waybar desktop environment, to systemd user services, privileged system state (WireGuard, `/etc/hosts`, uptimed, login shells), and a set of utility scripts in `~/scripts` (backups, media encoding, AI editor prompts, Immich sync, etc.). Its usefulness lies in making the whole environment reproducible: a single tool declaratively installs both user-level configs and Fedora packages, handles host-specific overrides (e.g., the high-res PipeWire setup or Proton Bridge tunnel only on "earth"), and even links agent workflows from `prompts/` into a dozen AI coding tools.

Implementation-wise, everything is deployed via [gonf](https://github.com/snonux/gonf), a task-based deployment tool invoked through `./gonf.sh`. Tasks are modular (one per app or concern), written as gonf recipes under `gonf/`, and guarded by conditions evaluated on the destination machine — so the same command works locally or via `gonf.sh push user@host <task>`, which streams a plan over SSH after installing gonf there. Guards are serializable and profile-aware (detected from `/etc/os-release`, overridable), tasks declare whether they need sudo, and the tool supports dry-runs (`-n`), task listing with guard status, and Git worktree awareness. Deployment uses a mix of symlinks (configs that stay live against the checkout) and synced copies (scripts, systemd units), with per-host tmux theming handled by a single shared config using conditional `%if` blocks.

=> https://github.com/snonux/dotfiles View on GitHub

---

### 9. turbonotes

* 💻 Languages: Dart (85.1%), Kotlin (9.1%), XML (1.9%), CMake (1.4%), C++ (1.3%), Python (0.5%), YAML (0.4%), C/C++ (0.3%)
* 📚 Documentation: Markdown (95.8%), Text (4.2%)
* 📊 Commits: 20
* 📈 Lines of Code: 17376
* 📄 Lines of Documentation: 991
* 🏷️ Tags: 7
* 📅 Development Period: 2026-10-07 to 2026-10-16
* 🏆 Score: 53.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.3.1 (2026-10-16)


=> showcase/turbonotes/image-1.png turbonotes screenshot

TurboNotes is a free, open-source Android app (with a Linux desktop build) for browsing and editing a folder of plain Markdown notes. You point it at any directory—say, one that Syncthing keeps in sync with your laptop—and every `.md` file becomes one tap away. It complements its sibling app Quicklog, which jots down new notes while TurboNotes handles browsing and editing the ones you already have. Because notes are just plain files in a standard format rather than entries in a proprietary database, the app stays flexible and interoperable with whatever other tools you use, and distribution is handled through its own F-Droid repository.

=> showcase/turbonotes/image-2.png turbonotes screenshot

The feature set centers on navigating, editing, and protecting your notes: a file tree with pinned and recent notes and a tag-based filter, fuzzy finding plus typo-tolerant full-text search, and two editing modes over the same Markdown text—a raw editor and a WYSIWYG view that never rewrites the underlying file and renders images inline (from camera, gallery, or clipboard). Notes can be shared out as text, PDF, or image, edited in place from other apps such as a File Browser server (with saves routed back to the source), and captured quickly via a home-screen widget or the Android share sheet. Robustness and privacy are priorities throughout: autosave never silently overwrites changes made on disk elsewhere, and the optional S3 sync (off by default, no telemetry) merges independent edits while preserving conflict copies.

=> https://github.com/snonux/turbonotes View on GitHub

---

### 10. quicklog

* 💻 Languages: Dart (89.7%), Kotlin (7.3%), CMake (0.9%), YAML (0.8%), C++ (0.6%), XML (0.6%), C/C++ (0.1%)
* 📚 Documentation: Markdown (81.0%), Text (19.0%)
* 📊 Commits: 177
* 📈 Lines of Code: 26865
* 📄 Lines of Documentation: 1381
* 🏷️ Tags: 26
* 📅 Development Period: 2024-01-20 to 2026-10-16
* 🏆 Score: 45.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.5.4 (2026-10-16)


=> showcase/quicklog/image-1.png quicklog screenshot

Quicklog is a lightweight note-capture app for Android (primary) and Linux desktop, rewritten in Flutter from an earlier Go/Fyne app. Its purpose is minimal-friction journaling: you type a thought, tap **Log text**, and the note is written as a timestamped Markdown file (`ql-YYMMDD-HHMMSS.md`) to a configurable directory — by default the app-specific Android folder, which Syncthing can sync to a home computer without any storage permissions. Beyond the single-screen editor (with character counter and a 5,000-character warning), it offers an entry browser with in-place editing and delete-with-confirmation, Android share-target integration (shared text either prefills the editor or logs immediately), and JSON-based settings export/import for backups and device migration. There is no telemetry, and local-only is the default.

=> showcase/quicklog/image-2.png quicklog screenshot

Architecturally, the app supports three storage modes: local only, S3 only, or dual write (local + S3) against any path-style S3-compatible endpoint, with defaults aimed at Garage. Outage resilience is a key design point: if an S3 write fails, the note is saved locally immediately and never lost, S3 is skipped for an hour with a retry control, and S3-only mode automatically moves local notes into the bucket once connectivity returns — with optional scheduled retries, including opt-in Android background jobs. A companion Dart CLI (`bin/quicklog_drain.dart`) drains bucket notes onto a laptop using an ack-based streaming protocol that deletes each remote object only after a successful import (e.g., into taskwarrior via the consumer's wrapper scripts). Building on Flutter's stable channel requires no NDK or container tooling for Android cross-compilation; releases are versioned from `pubspec.yaml`, packaged for F-Droid (built from source), and covered by a `flutter test`/`flutter analyze` suite, including an optional live S3 smoke test.

=> https://github.com/snonux/quicklog View on GitHub

---

### 11. s3tools

* 💻 Languages: Go (99.5%), Docker (0.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 24
* 📈 Lines of Code: 6074
* 📄 Lines of Documentation: 232
* 🏷️ Tags: 5
* 📅 Development Period: 2026-10-07 to 2026-10-17
* 🏆 Score: 43.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.1.4 (2026-10-17)


`s3rm` is a Go-based CLI tool for safely deleting selected top-level prefixes from S3-compatible buckets, supporting AWS S3, Ceph RADOS Gateway, and Garage. It's designed for both interactive terminal use and non-interactive automation in containers and CI pipelines. Because bulk deletion is inherently risky, the tool builds in multiple safeguards: protected prefixes that can never be removed, exact bucket-name confirmation with `--confirm-bucket`, a `--dry-run` mode that previews eligible object counts and bytes without deleting anything, and a final verification pass after deletion completes.

The tool is implemented in Go with flexible configuration: a bucket can be configured in a TOML file (`~/.config/s3rm/config.toml`) or via environment variables (`S3RM_BUCKET`, `S3RM_REGION`, credentials), with command-line flags providing explicit overrides for automation scenarios—such as requiring a target prefix and matching bucket confirmation before a destructive operation. Development and quality control are managed through Mage task targets, with the `mage check` gate running `go vet`, tests with the race detector enabled, `gofmt` formatting verification, and `errcheck` to catch unhandled errors. Docker support and additional usage documentation are provided in a separate usage guide.

=> https://github.com/snonux/s3tools View on GitHub

---

### 12. ior

* 💻 Languages: Go (90.0%), C (9.3%), C/C++ (0.4%), Shell (0.2%)
* 📚 Documentation: Markdown (63.4%), Text (36.6%)
* 📊 Commits: 2043
* 📈 Lines of Code: 293308
* 📄 Lines of Documentation: 10100
* 🏷️ Tags: 11
* 📅 Development Period: 2024-01-18 to 2026-10-05
* 🏆 Score: 41.6 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v1.2.0 (2026-10-05)


=> showcase/ior/image-1.gif ior screenshot

I/O Riot NG (`ior`) is a syscall observability tool for Linux that uses eBPF to trace what processes actually do — timings, call counts, file paths, and I/O activity — and visualizes it in an interactive terminal dashboard with a live flamegraph. It's the Go/C/eBPF rewrite of the original SystemTap-based I/O Riot, trading legacy kernel instrumentation for low-overhead, modern tracing. It's useful for performance analysis and debugging: you pick a process (or all of them) and watch its syscall behavior live across tabbed views, with a probes dialog that attaches or detaches trace families and individual syscalls while it runs. The tool also supports headless operation and exports results to Parquet, CSV, or its compressed `.ior.zst` format, which can be converted to SVG flamegraphs using standard FlameGraph tooling.

=> showcase/ior/image-2.png ior screenshot

Architecturally, `ior` embeds a CO-RE BPF object in a statically linked binary, built via Docker (or natively per its Rocky Linux 9 guide), so it can be copied to any Linux/amd64 host with kernel BTF support; tracepoints missing on the target are simply skipped. Tracing is selective and composable — filesystem syscalls by default, with time, polling, and other families, plus trace "kinds" or specific syscalls, selectable via flags or at runtime. Beyond the TUI, it offers headless recording modes (including `-pid`/`-tid` runs that stop when the traced process exits), sampling, and byte counting, documented across a tutorial and per-topic guides.

=> https://github.com/snonux/ior View on GitHub

---

### 13. gonf

* 💻 Languages: Go (99.6%), Config (0.3%)
* 📚 Documentation: Markdown (99.9%)
* 📊 Commits: 672
* 📈 Lines of Code: 153774
* 📄 Lines of Documentation: 17209
* 🏷️ Tags: 64
* 📅 Development Period: 2026-07-04 to 2026-10-12
* 🏆 Score: 39.3 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.25.2 (2026-10-12)


=> showcase/gonf/image-1.svg gonf screenshot

**Gonf** is a lightweight configuration management tool written entirely in Go, designed for personal use with a simple, converge-style model. Instead of YAML manifests or a custom DSL, configurations ("recipes") are ordinary Go programs: you write code that registers tasks, and each task declaratively resources—files, packages, services, cron jobs, users, and so on. You then build your own `gonf` binary that embeds your configuration. When run, gonf records the declared resources into a versioned plan and applies it, changing only what has drifted since the last run (convergence, in the spirit of CFEngine or Puppet). This makes it useful for keeping local machines or fleets of hosts reproducibly configured with the safety of Go's type checking and toolchain, and the simplicity of a single self-contained binary.

Architecturally, recipes import the gonf API package, register tasks in `main()`, and let `cli.Main()` handle the command line. The tool can apply plans locally or push them over SSH to Linux, OpenBSD, FreeBSD, and NetBSD hosts—cross-compiling and installing itself on targets so only the controller needs Go. Key features include dry-run previews, parallel fleet/cluster execution, privilege escalation via sudo/doas, and plan serialization to JSONL (optionally sealed with age encryption) so a plan can be generated once and applied on any host that has gonf installed.

=> https://github.com/snonux/gonf View on GitHub

---

### 14. comicredr-training-assets

* 💻 Languages: Python (52.1%), JSON (47.9%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 5
* 📈 Lines of Code: 2345
* 📄 Lines of Documentation: 682
* 🏷️ Tags: 0
* 📅 Development Period: 2026-10-10 to 2026-10-10
* 🏆 Score: 34.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


This repository is a companion to [ComicRedr](https://github.com/snonux/comicredr) that provides supplementary training data and generation scripts for its comic panel detector. It contains 1,123 synthetic comic pages (in 141 fake books) derived from a private collection of 180 books (13,239 pages): each page preserves a real page's *layout*—gutter and frame-border pixels are kept from the original—while all art inside frames is replaced with procedurally generated artwork (flat k-means color regions, ink lines, hatching, halftone dots, speed lines), so no original drawing, lettering, or balloons survive. Layouts that can't be read unambiguously (full-bleed art, inseparable touching panels, non-flat gutters) are skipped rather than guessed at, yielding exact axis-aligned labels across six frame shapes and deliberately oversampling the hard cases. This targets a diagnosed weakness: the shipped model handles plain grids well (~97% of frames at IoU 0.5) but struggles with slanted, touching, notched, and polygon frames, where its boxes also loosen.

The pipeline consists of four scripts: `border_pages.py` (a scan/stats/make CLI over PDFs, CBZ, and image folders, seeded for reproducibility), `borders.py` (gutter detection, segmentation of art into solid frame pieces, splitting of touching panels, shape classification), `fake_art.py` (synthetic panel filler), and `real_art.py` (a variant that fills the same layouts with real art from ComicRedr's clean training pages). Output pages (1,600 px long side, with labelkit-format JSON labels in reading order) plug directly into ComicRedr's `spike/train.py` via `make train-model` targets, with a 10% validation holdout and automatic scoring against ComicRedr's three test sets. Notably, the project's own experiments showed that fake art alone hurt performance on real modern pages—the detector latched onto synthetic color boundaries—so the real-art variant is recommended, though no retrained model has yet beaten the shipped one; due to licensing constraints (layouts come from books outside ComicRedr's publishable list), models trained on these pages are kept private.

=> https://github.com/snonux/comicredr-training-assets View on GitHub

---

### 15. hexai

* 💻 Languages: Go (99.3%), Python (0.7%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 611
* 📈 Lines of Code: 52943
* 📄 Lines of Documentation: 2775
* 🏷️ Tags: 123
* 📅 Development Period: 2025-08-01 to 2026-10-15
* 🏆 Score: 28.6 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.44.2 (2026-10-13)


=> showcase/hexai/image-1.png hexai screenshot

Hexai brings AI-assisted development to the Helix editor by implementing AI features as an LSP server—the integration point Helix supports since it lacks a plugin system. This gives Helix users code completions (from one model or comparable suggestions from several), inline chat for asking questions within a file, inline edits driven by natural-language instructions, and code actions like rewriting, documenting, fixing diagnostics, and generating Go tests from a selection. It supports Ollama (local or cloud, the built-in default), OpenAI, OpenRouter, and Anthropic, making it useful both for privacy-conscious developers running local models and those preferring commercial APIs.

=> showcase/hexai/image-2.gif hexai screenshot

The project is written in Go and ships as four separate binaries reflecting a modular architecture: `hexai-lsp-server` handles the editor integration, `hexai` is a standalone CLI LLM client with response caching and multi-model comparison, `hexai-tmux-action` exposes actions through a tmux popup menu, and `ask` is a project task manager built on Taskwarrior with stable task aliases, dependencies, and Fish shell completion. Users can define their own custom actions and invoke them from either Helix or tmux, and the companion guide walks through setup and all features with animated terminal demos.

=> https://github.com/snonux/hexai View on GitHub

---

### 16. f3sctl

* 💻 Languages: Go (98.9%), JavaScript (1.0%), YAML (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 223
* 📈 Lines of Code: 37770
* 📄 Lines of Documentation: 1662
* 🏷️ Tags: 29
* 📅 Development Period: 2026-08-08 to 2026-09-29
* 🏆 Score: 28.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.11.3 (2026-09-29)


**f3sctl** is a power-management control tool for the f3s homelab: it wakes, shuts down, and reports on a rack of FreeBSD bhyve hosts (f0–f3), switches the rack-fan and f-host mains-AC smart plugs, mutes/unmutes Gogios monitoring around planned work, and can cold-cycle the entire rack. It replaces an ad-hoc bash script, and its value lies in encoding operational lessons as safe, ordered procedures — a shutdown unmounts NFS and exports the backup ZFS pool before cutting power, stops CARP failover daemons that previously wedged a host, stops guests in parallel with a kill deadline below the shutdown watchdog, confirms hosts are genuinely down via ICMP, and only then turns the fans off. Guards refuse destructive switches (`fans off`/`ac off`) while any host they serve may still be up or while a job is running — checking job state both locally and on peer API nodes, so relayd load-balancing can't hide a running job — with `--force` and the always-permitted "on" commands as the escape hatch.

It is a single Go binary with three runtime-selected modes: a CLI, a CGI program served by bozohttpd on two Raspberry Pis (pi0/pi1) behind relayd, and an agent invoked on the hosts themselves via SSH `ForceCommand`. The CGI exposes a self-describing Siren hypermedia API with constant-time API-key authentication that advertises only currently possible actions (nothing while a job runs, a confirmation field on `fans-off` while hosts draw power), and every mutation simply runs the same `f3sctl power ...` CLI child — so CLI and API can never disagree about what an operation means. The security model uses an unprivileged SSH user with root-owned `authorized_keys`, source-pinned keys, a five-verb argument-free allowlist, and exact-argv `doas` rules, with nothing running as root on the API nodes. Host inventory, SSH identities, plug credentials, and peer nodes come from compiled-in defaults overlaid by an optional JSON config file, and the project builds, tests, and cross-compiles via mage.

=> https://github.com/snonux/f3sctl View on GitHub

---

### 17. ggaze

* 💻 Languages: C (89.9%), C/C++ (8.7%), Python (0.9%), Shell (0.3%), XML (0.2%)
* 📚 Documentation: Markdown (97.3%), Text (2.7%)
* 📊 Commits: 376
* 📈 Lines of Code: 81191
* 📄 Lines of Documentation: 5096
* 🏷️ Tags: 5
* 📅 Development Period: 2026-07-12 to 2026-10-15
* 🏆 Score: 28.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: GPL-3.0
* 🏷️ Latest Release: v0.2.1 (2026-10-15)


=> showcase/ggaze/image-1.png ggaze screenshot

**ggaze** is a lightweight, keyboard-first image viewer for Fedora Linux written in C with GTK4. Its purpose is narrow and deliberate: quickly previewing a folder of photos downloaded from a camera and culling the rejects — in the spirit of minimal viewers like `feh`, `nsxiv`, and `qiv`, but with a GNOME-native presentation (header bar, thumbnail grid, full-window viewer) and explicitly no photo library, database, or sidecar files. The workflow is grid → large view → flip through the shoot, with vi-style and traditional keybindings for navigation, multi-select/marking, trashing (into a per-folder `.Trash` with batch undo), moving images to destinations, opening them externally, running shell scripts, and copying to the clipboard. Additional touches include an info overlay with EXIF metadata and RGB/luminance histograms, zoom/pan/fullscreen/slideshow, animated GIF/WebP playback, and touchscreen gestures (pinch-zoom, swipe).

=> showcase/ggaze/image-2.png ggaze screenshot

The implementation emphasizes modularity and testability. It builds with Meson/Ninja and treats decode backends as optional features that activate when present: GEGL enables a non-destructive edit panel (layered presets with adjustable strength, crop, straighten, 90° rotation — originals are never modified; edits save as copies), while JPEG XL, AVIF, HEIF, and libjpeg add format support, with a minimal GdkPixbuf-only build remaining fully valid and covered by a dedicated CI lane. Quality is reinforced through Meson unit/integration test suites, an ≥80% coverage target for plain-C modules, clang-format enforcement, and procedurally regenerated screenshots under Xvfb. Installation targets `~/.local` by default (via `make install` or a Fedora helper script) and registers the app with GNOME through a desktop entry, icon, man page, and GSettings schema. The project is well-documented (living plan tracker, architecture, UI specs, coding conventions) and licensed GPL-3.0-or-later.

=> https://github.com/snonux/ggaze View on GitHub

---

### 18. bgtutor-mcp

* 💻 Languages: Go (89.6%), JSON (9.0%), Docker (0.7%), YAML (0.7%)
* 📚 Documentation: Markdown (98.5%), Text (1.5%)
* 📊 Commits: 3
* 📈 Lines of Code: 3655
* 📄 Lines of Documentation: 616
* 🏷️ Tags: 1
* 📅 Development Period: 2026-09-30 to 2026-10-03
* 🏆 Score: 27.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.30.0 (2026-10-03)


**bgtutor-mcp** is a standalone MCP (Model Context Protocol) server that turns English podcast transcripts into voice-guided Bulgarian listening lessons. A voice AI — such as Claude or ChatGPT voice mode — connects to the server and pulls prepared episode content paragraph by paragraph: it translates each paragraph into Bulgarian live, reads it aloud, and teaches the accompanying grammar, vocabulary, and background notes along the way. This makes it useful for learners who want structured listening practice built from real-world content, with personal learner state (a vocabulary notebook of saved terms and grammar rules) persisted across sessions. A second "citizenship" mode repurposes the same machinery for Bulgarian citizenship exam preparation, providing live-lesson workflows, drills, interview rehearsal, and mock exams with grading.

The implementation is a single Go binary with a clean split between content preparation and serving. Episodes are prepared offline by a coding agent (e.g. Claude Code, Codex) that follows `PREPARE.md` to segment a transcript, translate it, and write teaching notes into an episode folder; the CLI then validates and publishes the draft so it can be served (real episodes live in a separate assets repo, since podcast transcripts are third-party content). The server exposes MCP over Streamable HTTP in stateless mode — the AI passes the content id and paragraph index on every call — with tools for listing episodes, fetching individual paragraphs with their translations and teach notes, and managing the vocabulary notebook, returning errors phrased so the AI can read them aloud. It binds to localhost by default with optional bearer-token auth for remote access, and ships as a distroless Docker image (with a k3s deployment) so it can be hosted behind HTTPS for voice AI connectors that require a public URL.

=> https://github.com/snonux/bgtutor-mcp View on GitHub

---

### 19. foo.zone

* 💻 Languages: XML (98.3%), Shell (1.4%), Go (0.3%)
* 📚 Documentation: Text (86.5%), Markdown (13.5%)
* 📊 Commits: 1953
* 📈 Lines of Code: 20579
* 📄 Lines of Documentation: 178
* 🏷️ Tags: 0
* 📅 Development Period: 2021-04-29 to 2026-10-17
* 🏆 Score: 21.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


This repository contains the static files powering foo.zone, a personal internet site published simultaneously over two protocols: the classic web (https://foo.zone) and the Gemini protocol (gemini://foo.zone), a lightweight, privacy-focused alternative to HTTP. Rather than maintaining separate copies of content for each format, the project organizes output by medium into dedicated Git branches—`content-gemtext` for Gemini's native Gemtext format, `content-html` for the web, and `content-md` for Markdown—allowing each representation to be versioned and served independently while originating from the same source material.

The site is generated rather than hand-maintained, using the author's own static site generator, gemtexter (available at codeberg.org/snonux/gemtexter), which handles converting content into the various output formats. This architecture is useful because it decouples content authoring from presentation: a single edit can be propagated across the web and Gemini spaces without duplication, and the branch-per-format structure keeps each deployment target clean and self-contained. It's a practical example of multi-protocol publishing that embraces the growing Gemini ecosystem without abandoning the traditional web.

=> https://github.com/snonux/foo.zone View on GitHub

---

### 20. bgtutor-assets

* 💻 Languages: JSON (80.3%), Python (19.7%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 11
* 📈 Lines of Code: 10660
* 📄 Lines of Documentation: 4038
* 🏷️ Tags: 0
* 📅 Development Period: 2026-09-25 to 2026-10-03
* 🏆 Score: 20.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


**bgtutor-assets** is a content repository for the Bulgarian Podcast Tutor (bgtutor), an MCP server for language learners. It hosts carefully prepared podcast episodes adapted for Bulgarian learners at defined proficiency levels — for example, a Cal Newport podcast segment at B1 level with ads removed, and a Fallthrough episode at A2 level with Bulgarian notes, the latter transcribed from audio using Whisper with speakers inferred. Beyond podcast episodes, it also includes a citizenship-test guide covering the Bulgarian language exam required for naturalisation, complete with study lists and three original practice tests. The project is useful because it turns authentic English-language podcasts into structured, level-appropriate study material while also providing practical exam preparation resources — all intended for personal study, with the underlying English content belonging to its original creators.

Architecturally, each episode lives in its own folder under `episodes/` following a strict format of two files: `meta.json` and `paragraphs.json`, as defined in the companion `totalrecall` repository's docs. The workflow is decoupled from serving: episodes are prepared in a totalrecall checkout, validated and published with Go CLI commands (`validate` and `publish`), then copied here and committed for version control. Deployment to the hosting environment (f3s) is handled separately via a `just` recipe that uploads an episode folder. This design keeps content curation, validation, and serving as distinct, repeatable steps anchored around a simple, well-defined episode format.

=> https://github.com/snonux/bgtutor-assets View on GitHub

---

### 21. fdroid

* 💻 Languages: YAML (70.2%), Python (28.8%), HTML (1.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 29
* 📈 Lines of Code: 496
* 📄 Lines of Documentation: 815
* 🏷️ Tags: 0
* 📅 Development Period: 2026-09-26 to 2026-10-16
* 🏆 Score: 19.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🧪 Status: Experimental (no releases yet)


=> showcase/fdroid/image-1.svg fdroid screenshot

This project is a personal F-Droid repository that distributes the author's own Android apps—nine in total, spanning productivity tools (Quicklog for timestamped notes, TurboNotes for markdown editing, TurboLaunch for search-based app launching), a REST API browser, a guided-view comic reader, a media player, a system monitor, a file browser client, and a platformer game—so they install and update automatically through the F-Droid app rather than requiring manual sideloading. Users add the repository once via a QR code or link (verified by a fingerprint), after which the apps appear alongside any other F-Droid apps with automatic update notifications. Because APKs are served unchanged and keep their original developer signatures, apps installed from this repo remain interoperable with other sources that ship the same binaries, such as the official F-Droid repository.

=> showcase/fdroid/image-2.png fdroid screenshot

Architecturally, nothing is built in this repository itself. Each app's own repo builds, signs, and attaches APKs to GitHub releases for each `vX.Y.Z` tag. A publish workflow here—triggered on pushes to main, every six hours, on demand, or by a `repository_dispatch` event fired from an app's release process—runs `scripts/sync_apps.py` to download the two most recent releases of every app listed in `apps.yml`, along with their fastlane store text and screenshots. It then runs `fdroid update` to generate and cryptographically sign the repository index using a signing key stored in GitHub Actions secrets (`FDROID_KEYSTORE`/`FDROID_KEYSTORE_PASS`), deploying the result to GitHub Pages. This decentralized design means a new app release propagates to users' phones within six hours with no action taken in this repo, and onboarding a new app requires only adding it to `apps.yml`, a metadata file, and the README.

=> https://github.com/snonux/fdroid View on GitHub

---

### 22. timesamurai

* 💻 Languages: Go (98.5%), Shell (1.1%), JSON (0.3%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 174
* 📈 Lines of Code: 22019
* 📄 Lines of Documentation: 210
* 🏷️ Tags: 17
* 📅 Development Period: 2025-06-25 to 2026-10-10
* 🏆 Score: 14.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: BSD-2-Clause
* 🏷️ Latest Release: v0.10.3 (2026-10-10)


=> showcase/timesamurai/image-1.png timesamurai screenshot

`timesamurai` is a command-line worktime tracker that records work sessions, breaks, and time off as an append-only JSONL log stored per host. It supports the full lifecycle of time accounting: opening and closing work sessions (`work start/stop/status`), crediting or debiting durations (`add/sub`, `day-off`, `usebuffer` for moving self-development buffer hours into work), and reporting/inspecting data (`report`, `list`, `search`). Entries can be corrected after the fact via `modify`, `delete`, `undo`, and block editing in `$EDITOR`, and the tool provides one-shot `migrate`, `export`, and `import` commands for interoperability with its legacy `db.<host>.json` and `report.txt` formats. This makes it a robust, auditable solution for developers tracking their hours across multiple machines, with a full undo trail rather than fragile in-place edits.

The project is implemented in Go as a single CLI binary (built via `mage` or `go build`), currently at v0.10.3 in a mature maintenance phase. Its architecture emphasizes a clean separation between human- and machine-facing output: all text output is terminal-colored with themable roles and styles configured via a `[colors]` section in `config.toml`, while `--format json`, version output, and completion scripts are never colored — and colors never leak into pipes or files. Color can be disabled through `report.color = false`, the `--no-color` flag, or `NO_COLOR`. Additional polish includes a legacy flag shim for backward compatibility and generated shell completion scripts, all covered by tests.

=> https://github.com/snonux/timesamurai View on GitHub

---

### 23. tasksamurai

* 💻 Languages: Go (99.9%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 390
* 📈 Lines of Code: 22584
* 📄 Lines of Documentation: 743
* 🏷️ Tags: 43
* 📅 Development Period: 2025-06-19 to 2026-10-11
* 🏆 Score: 14.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: BSD-2-Clause
* 🏷️ Latest Release: v0.24.2 (2026-10-11)


=> showcase/tasksamurai/image-1.png tasksamurai screenshot

Task Samurai is a fast, fully keyboard-driven terminal interface for Taskwarrior, written in Go with the Bubble Tea framework. It was created as a quicker, snappier alternative to existing Taskwarrior frontends like the Python-based vit, and it presents your tasks in a table where every operation—from adding a task (press `+`) to starting, completing, or annotating one—happens via a single hotkey. Beyond basic task management, it offers filter toggling on configurable number keys (e.g., `+agent`/`-agent`, `+track`/`-track`), recurring task editing, a recent completions window, a detail view with search, auto-refresh cycling, compact/ultra display modes, and even a "disco mode" that randomizes the theme on each task change.

=> showcase/tasksamurai/image-2.png tasksamurai screenshot

Architecturally, Task Samurai doesn't touch Taskwarrior's data directly; instead it invokes the `task` CLI to read and modify tasks, rendering the results as Bubble Tea table rows and refreshing automatically after every action so the view stays current. It also includes a `:` command prompt that passes arbitrary arguments through to Taskwarrior—with tab completion, UUID prefilling for the selected task, and the ability to pop the command out into `$EDITOR`—and every screen supports scrolling, paging, and jump-to-top/bottom navigation. Configurable via CLI flags (custom hotkeys, browser commands for opening URLs, debug logging), it ships with diagnostic hooks (built with `-tags debugsignals`, sending SIGUSR1/SIGUSR2 captures goroutine stacks and profiles) for troubleshooting hangs. It can be installed with a simple `go install` or built from source using mage.

=> https://github.com/snonux/tasksamurai View on GitHub

---

### 24. ebpf-for-sres

* 💻 Languages: HTML (65.0%), Shell (19.2%), C (11.1%), Make (2.5%), JSON (2.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 1
* 📈 Lines of Code: 811
* 📄 Lines of Documentation: 160
* 🏷️ Tags: 0
* 📅 Development Period: 2026-09-26 to 2026-09-26
* 🏆 Score: 13.3 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


This project is an educational resource introducing eBPF to site reliability engineers through a combination of a slide deck and hands-on, runnable code. The 23-slide presentation covers what BPF is, why it is valuable during on-call work, and how [ior](https://github.com/snonux/ior) (I/O Riot NG) uses it to trace I/O syscalls. Its main value is pairing conceptual material with working examples, so SREs can move beyond theory and actually observe kernel-level I/O tracing on a real system.

The project is organized into two components: a `presentation/` directory containing one HTML file per slide (1920×1080, in the Claude Slides artifact format) along with a `deck.json` for slide order, sections, and fonts, and a `speaker-notes.md` file with per-slide notes; and an `examples/` directory where every example from the slides is packaged as a standalone script with a test runner. The examples target Rocky Linux 9 and are executed via a setup script followed by `run-all.sh`, which runs each example for a few seconds under a small file I/O workload and reports PASS/FAIL. Verification results are included: on a 6.18 kernel with bpftrace 0.20.2, 7 of 9 examples passed, with the kprobe variant and BCC tools unavailable due to the sandbox kernel lacking kprobe support and kernel headers (these remain unverified on Rocky 9).

=> https://github.com/snonux/ebpf-for-sres View on GitHub

---

### 25. restforge

* 💻 Languages: Go (48.0%), Dart (31.5%), JavaScript (14.0%), C (3.1%), C/C++ (1.0%), Python (0.5%), Shell (0.5%), CMake (0.5%), C++ (0.3%), XML (0.3%), Kotlin (0.2%), YAML (0.2%)
* 📚 Documentation: Markdown (99.6%), Text (0.4%)
* 📊 Commits: 123
* 📈 Lines of Code: 52847
* 📄 Lines of Documentation: 3303
* 🏷️ Tags: 9
* 📅 Development Period: 2026-08-08 to 2026-10-10
* 🏆 Score: 13.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.7.0 (2026-09-26)


=> showcase/restforge/image-1.svg restforge screenshot

RESTForge is a generic hypermedia browser for APIs that use the [Siren](https://github.com/kevinswiber/siren) format. Pointed at any endpoint, it renders whatever that API offers — properties, sub-entities, links, and actions — letting users navigate by following links, execute actions (after a confirmation step), and re-read the resulting document to observe changes, including polling until long-running operations complete. Its value lies in a strict design constraint: the client never constructs URLs and contains no server-specific code, so a single browser works with any Siren-compliant API without modification. This invariant is enforced systematically — the codebase even includes checks in `just check` that scan for leaked API keys and any server vocabulary sneaking into the generic client.

Architecturally, the repository contains three fully independent implementations sharing no code, bound only by a common behavioral contract documented once in `docs/DESIGN.md`: a **Pebble watchapp** (C plus ES5 JavaScript on the Rebble SDK) split across the watch (renders frames, reports button presses) and the phone (PebbleKit JS handles everything else); a **Flutter Android app** (Dart) that also runs on Linux desktop for development; and a **Go CLI** offering both an interactive Bubble Tea TUI and scriptable one-shot subcommands (`restforge get`, `restforge act`). Each app has its own `Justfile`, with a root Justfile forwarding commands and running cross-cutting checks — `just test` executes all three test suites without needing emulators, and `just check` must pass cleanly.

=> https://github.com/snonux/restforge View on GitHub

---

### 26. gitsyncer

* 💻 Languages: Go (96.5%), Shell (3.4%), JSON (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 280
* 📈 Lines of Code: 21476
* 📄 Lines of Documentation: 2500
* 🏷️ Tags: 59
* 📅 Development Period: 2025-06-23 to 2026-10-13
* 🏆 Score: 13.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: BSD-2-Clause
* 🏷️ Latest Release: v0.21.5 (2026-10-13)


GitSyncer is a Go-based command-line tool that synchronizes git repositories across multiple hosting organizations—primarily GitHub and Forgejo—plus optional one-way SSH backup locations such as a home NAS. It's useful for developers who want to maintain mirrors of their projects on several platforms without manual effort: it can discover and sync public GitHub repositories, automatically create missing repositories and branches on remote hosts, and safely merge divergent changes across all destinations. Safety is a core design principle—GitSyncer never deletes branches or tags, aborts clearly on merge conflicts, and only pushes (never pulls) from backup locations. Beyond core syncing, it offers AI-generated release notes and releases via the Forgejo API, an AI-powered project showcase generator that produces portfolio documentation in Gemini Gemtext format, per-repo sync throttling and daily rate limits, and a `manage batch-run` mode designed for cron-driven weekly automation.

The implementation is configuration-driven: a JSON file defines organizations (each designated as a sync peer, a `pushOnly` one-way mirror, an `optional` peer that can be skipped when offline, or a `backupLocation`) along with repository lists, branch inclusion/exclusion regexes, and showcase settings. Architecturally, GitSyncer clones a repository from the first configured organization, adds the others as git remotes, and then for each selected branch fetches from all remotes, merges, and pushes everywhere—moving git data over SSH while using Forgejo's Gitea-compatible REST API for metadata operations like repository creation, descriptions, and releases (with tokens supplied via environment variable or a `0600`-mode file). The CLI is organized into commands (`sync`, `release`, `showcase`, `manage`, `list`, `test`, `version`), persistent sync state is tracked in `.gitsyncer-state.json`, and AI features shell out to external tools—defaulting to ollama with fallbacks to `hexai`, `claude`, and `amp`—while gracefully degrading when destinations like Forgejo or backup servers are unreachable.

=> https://github.com/snonux/gitsyncer View on GitHub

---

### 27. syncmaster

* 💻 Languages: Go (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 38
* 📈 Lines of Code: 8070
* 📄 Lines of Documentation: 675
* 🏷️ Tags: 9
* 📅 Development Period: 2026-08-24 to 2026-09-13
* 🏆 Score: 10.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v0.6.1 (2026-09-13)


syncmaster is a Go command-line tool that imports files from USB devices mounted via GVFS — currently Fujifilm and RICOH GR cameras and the Supernote Nomad — serving as a robust port of an original bash script. It unifies several workflows behind one interface: camera photos are imported flat into destination "inbox" folders (JPEG/video kept separate from RAW files) and geotagged from GPX track files using exiftool, while Supernote content is backed up with rsync (never deleting local files) and `.note` files are converted to PDFs via supernote-tool. Usability and safety features include automatic device detection, explicit device selection when multiple are connected, environment-variable configuration, clear exit codes, and — critically — a dry-run-by-default mode that only executes when `--run` or `SYNCMASTER_RUN=1` is passed, making it safe for both interactive and scripted use.

The architecture centers on a pluggable driver design: the orchestrator knows only a `Driver` interface and a registry, with each device implemented as a small package composing a generic recursive copier with optional transforms (GPX geotagging, note conversion). Adding a new sync source requires only implementing one `Driver` and registering it in a single `wire.go` file, with no changes to the orchestrator or existing drivers. Cross-cutting concerns such as shell execution, filesystem access, the clock, and GVFS mounting are isolated behind injected interfaces with in-memory fakes, so every package is unit-testable without hardware or external tools — with most packages reportedly at 80–100% coverage. The build uses mage with targets for testing (with race detection and coverage), linting, and installation.

=> https://github.com/snonux/syncmaster View on GitHub

---

### 28. comicforge

* 💻 Languages: Go (99.4%), YAML (0.6%)
* 📚 Documentation: Markdown (96.7%), Text (3.3%)
* 📊 Commits: 82
* 📈 Lines of Code: 14689
* 📄 Lines of Documentation: 1239
* 🏷️ Tags: 3
* 📅 Development Period: 2026-04-19 to 2026-10-15
* 🏆 Score: 8.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.1.1 (2026-08-22)


=> showcase/comicforge/image-1.png comicforge screenshot

ComicForge is a Go command-line tool that transforms a simple vocabulary list into an illustrated comic book, designed primarily for language learners and educators. Given a word list, it uses Google's Gemini API to generate a story that incorporates the vocabulary, produces comic artwork for each page, and exports the results as story files, PNG pages, PDF documents (via ImageMagick), and optional MP3 narration (via ffmpeg). The tool is configurable through a YAML file, letting users control the story language and script, page count, and artistic style or genre. It also supports generating a single standalone image from a direct prompt, and includes a `stylegrid` utility for previewing all available styles and genres before committing to a set.

Architecturally, ComicForge is organized as modular Go packages with a provider abstraction layer for generative backends, built and orchestrated through Mage tasks. Users interact via CLI flags (specifying vocabulary, config, output directory, and narration), while a generation pipeline handles the story-to-comic flow and writes structured output: per-comic assets under a slug-based directory, gallery copies, and print-ready PDFs with flexible page shapes including A4 print and book layouts with compression. The project also emphasizes reproducibility and agent-friendly workflows, with documented verification steps, rerun support, and manual prompt options, making it usable both interactively and in automated pipelines.

=> https://github.com/snonux/comicforge View on GitHub

---

### 29. shuriken.sh

* 💻 Languages: Shell (99.0%), Config (0.4%), Perl (0.4%), Docker (0.1%), XML (0.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 363
* 📈 Lines of Code: 24256
* 📄 Lines of Documentation: 951
* 🏷️ Tags: 36
* 📅 Development Period: 2011-11-19 to 2026-08-04
* 🏆 Score: 6.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.14.1 (2026-08-04)


=> showcase/shuriken.sh/image-1.svg shuriken.sh screenshot

shuriken is a Bash script for Linux, macOS, and FreeBSD that turns a directory of photos into a static web photo album composed of pure HTML+CSS — no JavaScript — making the resulting site fast, simple, and dependency-free to view. Generation is driven by a single `shuriken.conf` file (bootstrapped with `--init`) plus customizable HTML templates, and key features include a splash page featuring a random album photo, per-photo details pages with EXIF summaries, chronological ordering by EXIF capture date or seeded shuffle, and reproducible builds via `RANDOM_SEED`. It also offers an optional no-JavaScript EXIF stats site (camera leaderboard, shooting dates, and megapixel/aspect/orientation breakdowns, where each bucket doubles as a clickable filter mini-album), a `--dry-run` preview mode, and one-command publishing of the output directory to configured remote hosts via rsync.

The project is implemented as a single Bash script (built from `src/` with `just`) requiring Bash 5.1+, ImageMagick, and GNU coreutils/findutils. For portability across platforms, it relies on GNU-only tool extensions (`find -printf`, `stat -c`, `cp -a`, `sort -R`) and at startup resolves each tool to its actual GNU binary, preferring `g`-prefixed siblings like `gfind` on macOS/FreeBSD; if a genuine GNU tool can't be found, it aborts with a clear error naming the missing tool. Generation is efficiently incremental: existing image artifacts and cached EXIF tags are reused on rebuilds (with `--force` to fully regenerate), image processing runs in configurable parallel jobs with timeouts, and the final album lands in `dist/` ready to sync. A live example built with shuriken, including its config and templates as a reference, is available at irregular.ninja.

=> https://github.com/snonux/shuriken.sh View on GitHub

---

### 30. ychat

* 💻 Languages: C++ (49.9%), Shell (21.3%), C/C++ (19.6%), Perl (2.7%), Config (2.1%), HTML (2.1%), Make (1.0%), CSS (0.9%), Docker (0.4%)
* 📚 Documentation: Markdown (95.2%), Text (4.8%)
* 📊 Commits: 67
* 📈 Lines of Code: 42571
* 📄 Lines of Documentation: 568
* 🏷️ Tags: 11
* 📅 Development Period: 2008-05-15 to 2026-10-04
* 🏆 Score: 6.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.9.5 (2026-08-14)


This repository revives three small, legacy C++ projects by Paul C. Buetow (~2003–2007) that share a common socket/event/template engine: **ychat**, an HTTP-based web chat server where browsers act as clients using only CSS/HTML/JS; **yhttpd**, a tiny standalone HTTP server derived from ychat's socket/threading engine; and **ycurses**, a curses front-end demo. ychat is the flagship—it has been substantially fixed and modernized during the revival, with legacy build repairs, a from-scratch streaming-chat layer, and a security/bug sweep—while yhttpd builds reliably under load and ycurses remains a demonstration-only component. The project is useful both as a working, lightweight web chat and as a piece of maintained historical C++ code, all released under GPL-2.0.

Implementation-wise, ychat is built via a multi-stage Dockerfile (Rocky Linux 9 builder plus a slim runtime image) that compiles everything inside the container, requiring no host toolchain. Chat runs on a configurable port (default 2000) with settings baked into the image via `ychat.conf` and overridable at runtime with `-o key value`. A mandatory embedded-SQLite backend persistently stores registered nick/password accounts across restarts, while sessions, rooms, and online state remain in memory (guest sessions are wiped on restart). The UI is a browser frameset with a streaming message view, online-user list, and input box, styled with the vendored MIT-licensed Pico CSS. Security hardening includes complete removal of the `/exec` command module (which had a shell-injection RCE) and requiring database-authenticated registered accounts for operator status, so unregistered guests can never gain privileges.

=> https://github.com/snonux/ychat View on GitHub

---

### 31. foostore

* 💻 Languages: Go (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 154
* 📈 Lines of Code: 15384
* 📄 Lines of Documentation: 384
* 🏷️ Tags: 16
* 📅 Development Period: 2018-05-26 to 2026-10-15
* 🏆 Score: 6.5 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.9.2 (2026-09-24)


**foostore** is a Go tool for encrypting and storing text and binary documents (meant for smaller files like notes, credentials, and PDFs), targeting macOS, Linux, and Android via Termux. All documents live in a Git repository — giving you version history and sync with multiple remote repositories for geo-redundancy — while file names themselves are kept encrypted in encrypted indices. The default backend is a KeePass database (`.kdbx`, password plus optional key file); a legacy `geheim` backend stores AES-256-CBC encrypted `.index`/`.data` pairs in Git with an IV derived from a user PIN, though it lacks an authentication tag and isn't recommended for new secrets.

Interactive use centers on a built-in shell: indices are searchable via `fzf`, text entries are edited in Helix or any `$EDITOR`, clipboard paste works on macOS and GNOME, and there's a themed picker with keybindings, batch import/export with shredding, and fish shell tab-completion with a `ge` wrapper. For automation, a strict non-interactive `read` command (KeePass backend only) emits exactly the requested field or attachment bytes, never prompting, with deterministic exit codes (not-found, ambiguous, corrupt, etc.), a whole-read timeout, and passphrase resolution via an inherited file descriptor or a permission-checked pass file rather than environment variables or prompts. The project is explicitly pre-alpha personal software, so formats and behavior are unstable and upgrades aren't guaranteed.

=> https://github.com/snonux/foostore View on GitHub

---

### 32. totalrecall

* 💻 Languages: Go (98.8%), HTML (0.4%), CSS (0.3%), Shell (0.3%), YAML (0.2%)
* 📚 Documentation: Markdown (96.0%), Text (4.0%)
* 📊 Commits: 282
* 📈 Lines of Code: 22960
* 📄 Lines of Documentation: 400
* 🏷️ Tags: 45
* 📅 Development Period: 2025-07-14 to 2026-09-30
* 🏆 Score: 5.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.29.6 (2026-09-30)


=> showcase/totalrecall/image-1.png totalrecall screenshot

**TotalRecall** is a Go-based tool that automates the creation of rich Anki flashcard materials for Bulgarian vocabulary learners. For each word, it generates an audio pronunciation file, an English translation, an IPA phonetic transcription, and one or more AI-generated images depicting a memorable scene for the word. It supports both a keyboard-driven GUI (the default launch mode) and a CLI, along with batch processing from text files. The batch format is flexible: words alone (auto-translated), Bulgarian=English pairs, English-only entries (auto-translated to Bulgarian), or monolingual Bulgarian definitions using `==`—all of which can be mixed in a single file. Provided translations skip the translation API entirely, saving time and quota, and results export directly as Anki APKG packages with media embedded.

=> showcase/totalrecall/image-2.png totalrecall screenshot

Architecturally, the project defaults entirely to Google Gemini APIs: Gemini TTS for audio (using a random voice, all voices, or a specific one, with ffmpeg conversion to space-saving mp3), the "Nano Banana" model for image generation, and Gemini for translation and phonetic lookups. An optional OpenAI DALL-E path remains available for image generation, selectable via CLI flags or a `config.yaml` provider setting. Generated assets are stored under `~/.local/state/totalrecall/`, with configurable output directories and deck names. Notably, the tool was largely "vibe coded" using Claude Code CLI, making it an example of AI-assisted development producing a practical, installer-ready application (including GNOME desktop integration on Fedora).

=> https://github.com/snonux/totalrecall View on GitHub

---

### 33. fastforge

* 💻 Languages: C (93.2%), C/C++ (5.4%), JavaScript (0.7%), Make (0.7%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 112
* 📈 Lines of Code: 4908
* 📄 Lines of Documentation: 278
* 🏷️ Tags: 9
* 📅 Development Period: 2026-04-06 to 2026-09-10
* 🏆 Score: 5.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v1.6.0 (2026-09-10)


=> showcase/fastforge/image-1.png fastforge screenshot

FastForge is a watchapp for the Pebble smartwatch platform that helps users track intermittent fasting. It offers a menu for managing fasts, a live countdown screen showing fasting progress at a glance, and a history view for reviewing past sessions. Putting the tracker on the wrist makes the running fast continuously visible without needing a phone, and the app is published on the Rebble-run Pebble Appstore. It supports multiple device form factors, with screenshots confirming compatibility with both the round Pebble Round 2 and the rectangular Pebble Time 2.

=> showcase/fastforge/image-2.png fastforge screenshot

The project is built with the Rebble SDK (4.9+) and follows the standard native Pebble development pipeline: code is compiled into a Pebble package and tested against SDK emulators rather than requiring physical hardware. The documented environment targets Fedora Linux, using `uv`-managed `pebble-tool` for SDK installation and builds, with `just` serving as a task runner that wraps the whole workflow—`just dev` builds and installs to the gabbro (Pebble Round 2) emulator, `just dev-emery` targets the emery (Pebble Time 2) emulator, and companion commands cover live log streaming, screenshots, emulator shutdown, and build cleanup. This gives developers a tight build-install-debug loop for iterating on the UI across both display shapes.

=> https://github.com/snonux/fastforge View on GitHub

---

### 34. gt

* 💻 Languages: Go (98.0%), Shell (2.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 415
* 📈 Lines of Code: 19850
* 📄 Lines of Documentation: 4351
* 🏷️ Tags: 8
* 📅 Development Period: 2025-11-25 to 2026-09-06
* 🏆 Score: 4.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.5.2 (2026-08-22)


=> showcase/gt/image-1.svg gt screenshot

**gt** is a command-line calculator written in Go that combines two paradigms: natural-language-style percentage queries (e.g., `gt '20% of 150'` → 30) and RPN (Reverse Polish Notation) stack arithmetic (e.g., `gt '3 4 +'` → 7). Beyond these core modes, it supports a rich feature set including built-in constants (like `pi`), unit-aware calculations (`100Mbps 1hr *`), variables and assignment, symbols, stack manipulation, fast integer exponentiation, logarithm and n-ary "hyper" operators, comparisons/booleans, and a rational number mode. It can be used for one-off evaluations, in shell pipelines, or as an interactive REPL, with Fish shell completions for convenient tab-completion.

Architecturally, the project is organized into focused modules matching its feature areas — an expression evaluator with an RPN stack, a metrics/units subsystem supporting conversions and user-defined custom metrics, and a CLI layer handling piping and REPL sessions. Build and test workflows are automated with [mage](https://github.com/magefile/mage), and installation is a simple `go install`. Notably, gt also serves a secondary purpose: it's a deliberate experiment in using local LLMs (Qwen, Gemma, Nemotron, GPT OSS) as pair programmers, making it as much a case study in AI-assisted development as a calculator. Detailed documentation for every feature lives in the `docs/` directory.

=> https://github.com/snonux/gt View on GitHub

---

### 35. hypr

* 💻 Languages: TypeScript (49.7%), Ruby (32.6%), JSON (9.0%), Shell (4.2%), TOML (3.7%), Python (0.8%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 162
* 📈 Lines of Code: 11285
* 📄 Lines of Documentation: 3105
* 🏷️ Tags: 0
* 📅 Development Period: 2026-03-21 to 2026-10-12
* 🏆 Score: 3.9 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


=> showcase/hypr/image-1.svg hypr screenshot

`hypr` is a Ruby-based automation tool that manages the entire lifecycle of rented GPU cloud VMs on Hyperstack—provisioning, secure networking, and LLM serving—so you can run coding agents against self-hosted open models instead of third-party APIs. It deploys two A100 80GB VMs concurrently, each running a different model (e.g., Qwen3.8 27B FP8 and Gemma 4 31B) via vLLM with tuned flags like prefix caching, speculative decoding, and 262K context. This gives you full control over model choice, quantization, and performance—vLLM's FlashAttention, chunked prefill, and block-level KV cache reuse substantially outperform Ollama on both throughput and latency.

Architecturally, the Ruby orchestrator `hyperstack.rb` (configured via per-VM TOML files defining VM specs, network rules, and named model presets) drives commands for `create`, `delete`, `status`, `test`, `watch`, and `model switch`. A single `create` command spins up VMs via the Hyperstack API, runs `wg1-setup.sh` to establish a WireGuard tunnel (one interface on the local host with a peer block per VM), and provisions vLLM in a Docker container exposing an OpenAI-compatible API on port 11434, firewalled to the tunnel subnet. Pi coding agents connect directly over the tunnel using custom providers declared in `models.json` (symlinked as `~/.pi`), with fish shell abbreviations routing each session to a specific VM and TypeScript extensions adding tools like web search. Supporting features include hot model switching without reprovisioning, live GPU/engine monitoring via a `watch` dashboard, and host key pinning for safe SSH.

=> https://github.com/snonux/hypr View on GitHub

---

### 36. gogios

* 💻 Languages: Go (99.7%), JSON (0.3%)
* 📚 Documentation: Markdown (96.9%), Text (3.1%)
* 📊 Commits: 132
* 📈 Lines of Code: 7264
* 📄 Lines of Documentation: 641
* 🏷️ Tags: 19
* 📅 Development Period: 2023-04-17 to 2026-09-26
* 🏆 Score: 3.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.7.1 (2026-09-26)


=> showcase/gogios/image-1.png gogios screenshot

Gogios is a lightweight, minimalistic monitoring tool written in Go, designed for small-scale self-hosted infrastructure—typically just a handful of servers or VMs—where full-featured systems like Nagios, Icinga, or Prometheus add unnecessary complexity (databases, web UIs, clustering, contact groups). Designed to be driven by CRON rather than running as a daemon, it executes standard Nagios/Icinga check plugins such as `check_ping` and `check_http`, persists check results in a `state.json` file between runs, and—via the local MTA—emails a report only when check statuses change, summarizing critical, warning, unknown, stale, and OK counts. This keeps setup and maintenance trivial while still reliably catching outages.

Architecturally, it's a single binary configured through a JSON file defining each check's plugin path and arguments, with features like per-check retries, random spread to avoid simultaneous check storms, run intervals, and dependencies (`DependsOn` skips and reports UNKNOWN for checks whose prerequisite failed, e.g., HTTP checks when ping fails). It also integrates with Prometheus Alertmanager (with special Watchdog handling to detect a broken Alertmanager), supports file-based alert suppression for maintenance windows, and serializes runs via a lock file with atomic, fsynced state writes and timeouts to prevent stuck executions. For high availability, two instances can monitor each other over NRPE on staggered cron schedules, or use peer failover where a DNS-based standby election keeps one active checker that mirrors its peer's state while the passive node runs only its own local checks.

=> https://github.com/snonux/gogios View on GitHub

---

### 37. goprecords

* 💻 Languages: Go (97.8%), Shell (2.0%), Docker (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 174
* 📈 Lines of Code: 8303
* 📄 Lines of Documentation: 1075
* 🏷️ Tags: 19
* 📅 Development Period: 2013-03-22 to 2026-08-22
* 🏆 Score: 3.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.6.1 (2026-08-22)


**goprecords** is a Go command-line tool that transforms the raw uptime statistics collected by `uptimed` on individual machines into global "Top N" leaderboards across an entire fleet. While the stock `uprecords` utility only reports a single host's boot history, goprecords aggregates the per-host `*.records` files from many machines and ranks them in categories such as Host, Kernel, KernelMajor, and KernelName, using metrics like Boots (total boot count), Uptime, Downtime, Lifespan (uptime + downtime), and Score (a combined meta-metric). Reports can be rendered in plaintext, Markdown, Gemtext, or HTML, and include niceties like a host classification column (server, workstation, hybrid, or unknown) and recency markers showing whether a host has reported recently.

Architecturally, the tool supports three interchangeable workflows: (1) an `import`/`query` mode that loads records into a SQLite database for repeat reporting; (2) a no-subcommand mode that generates reports directly from a stats directory with no database; and (3) a daemon mode — a plain HTTP server built on Go's `net/http` (TLS terminated externally via a reverse proxy or ingress) — which serves the same reports via `GET /report`, exposes Kubernetes-style liveness/readiness probes, and accepts `PUT /upload/{HOSTNAME}/{kind}` uploads from client machines. Uploads are authenticated with per-client bearer tokens stored in a separate SQLite auth database, and the accompanying upload-client script (for Linux, BSD, and macOS) can automate hourly pushes via cron or systemd timers. Further operational features include marking decommissioned hosts as excluded for Prometheus alert filtering (with auto-unexclude when a host resumes uploading) and a `/metrics` endpoint, making the tool suitable both as a personal CLI utility and as a centrally deployed uptime collection service.

=> https://github.com/snonux/goprecords View on GitHub

---

### 38. loadbars

* 💻 Languages: Go (85.8%), Python (7.8%), Shell (6.4%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 548
* 📈 Lines of Code: 7440
* 📄 Lines of Documentation: 591
* 🏷️ Tags: 39
* 📅 Development Period: 2010-11-05 to 2026-09-30
* 🏆 Score: 3.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v0.13.2 (2026-08-22)


=> showcase/loadbars/image-1.gif loadbars screenshot

**Loadbars** is a real-time system monitoring tool for Linux servers that displays CPU, memory, network traffic, load average, and disk I/O as colored bars side by side in a compact window. Like `top` or `vmstat`, it focuses on showing what is happening right now rather than recording data or drawing graphs for later analysis. It scales from monitoring a single local machine to observing large fleets — hosts can be listed individually (with brace expansion like `server{01..20}.example.com`), pulled from cluster definitions in `/etc/clusters`, and wrapped into rows for many servers. CPU can be shown summarized or core by core, and the view is controlled through hotkeys, command-line options, and a persistent config file (`~/.loadbarsrc`).

The tool is written in Go and uses SDL2 (via the go-sdl2 bindings) for rendering the display. Architecturally, it monitors the local machine by reading directly from the `/proc` filesystem, while remote servers are observed over SSH using public key authentication — loadbars streams a small collector script to each host, so remote machines require nothing beyond Linux and bash. Metrics from all hosts are collected concurrently and rendered as live, colored bars in a single window. The build is managed with Mage task definitions or a plain `go build`, and while local monitoring is Linux-only, macOS can serve as a client for watching remote Linux servers.

=> https://github.com/snonux/loadbars View on GitHub

---

### 39. ds-sim

* 💻 Languages: Java (98.6%), Shell (0.9%), CSS (0.4%)
* 📚 Documentation: Markdown (98.7%), Text (1.3%)
* 📊 Commits: 474
* 📈 Lines of Code: 28576
* 📄 Lines of Documentation: 3103
* 🏷️ Tags: 2
* 📅 Development Period: 2008-05-15 to 2026-03-30
* 🏆 Score: 2.3 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: 1.1.0 (2026-03-27)


=> showcase/ds-sim/image-1.png ds-sim screenshot

DS-Sim is an open-source distributed systems simulator written in Java, designed as a learning and experimentation environment for distributed systems concepts. Through an interactive Swing-based GUI, users can simulate and observe the behavior of distributed algorithms, with built-in support for protocol simulation (including PingPong, Two-Phase Commit, and Berkeley time synchronization), event handling, and logical clock implementations using both Lamport and Vector time. This makes it a practical tool for students and developers who want to explore how distributed algorithms behave in practice—covering things like message passing, event ordering, and failure scenarios—without needing to deploy real distributed infrastructure. The project also features comprehensive logging, timestamp-triggered events, and saved simulation files for reproducibility.

Architecturally, DS-Sim follows a modular design organized into distinct packages: `core` for process and message handling, `events` for the event system, `protocols` for distributed algorithms, `simulator` for the main simulation engine, and `utils` for shared helpers. It targets Java 21 and is built with Maven, producing a self-contained executable JAR with all dependencies bundled. Extensibility is a key focus—the developer guide explains how to create new protocols and events—while quality is ensured by 141 headless-compatible unit tests covering core components, the event system, and protocol implementations. The project is a modernized evolution of the original VS-Sim simulator, combining a modern Java-based architecture with strong documentation (architecture, developer, and testing guides) to support both users and contributors.

=> https://github.com/snonux/ds-sim View on GitHub

---

### 40. irregular.ninja

* 💻 Languages: Config (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 21
* 📈 Lines of Code: 112
* 📄 Lines of Documentation: 48
* 🏷️ Tags: 0
* 📅 Development Period: 2026-06-15 to 2026-07-18
* 🏆 Score: 2.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


This repository generates the two static photo sites served at irregular.ninja and alt.irregular.ninja by using [shuriken.sh](https://codeberg.org/snonux/shuriken.sh), a lightweight, shell-based photo album generator. Its purpose is simple and focused: turn directories of source photos into static web albums with minimal tooling, while supporting two separate publications — the main site for the author's preferred photos, and the alternate site for "second-order" selections the author likes less. Because everything is static, the resulting sites are fast and easy to host, and the workflow stays reproducible: photos go in, a build command runs, and finished albums come out.

Architecturally, the project is organized around the `just` command runner with a two-level build system. A top-level `Justfile` delegates to per-album `Justfiles` inside `irregular.ninja/` and `alt.irregular.ninja/`, so each album is self-contained: a `shuriken.conf` defines album settings (title, geometry, templates), an `incoming/` symlink points at the source photo directory, and the main album additionally has an `incoming-invalid/` staging area for rejected or invalid files. Available recipes include `generate` for a single album, `all` for both, and `dry-run-all` to preview changes without writing, giving a clean, config-driven pipeline where each site's content and build are isolated but can be rebuilt together with one command.

=> https://github.com/snonux/irregular.ninja View on GitHub

---

### 41. gemtexter

* 💻 Languages: Shell (52.2%), CSS (35.5%), HTML (10.5%), Config (1.9%)
* 📚 Documentation: Text (75.1%), Markdown (24.9%)
* 📊 Commits: 493
* 📈 Lines of Code: 3430
* 📄 Lines of Documentation: 1195
* 🏷️ Tags: 6
* 📅 Development Period: 2021-05-21 to 2026-10-12
* 🏆 Score: 2.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: GPL-3.0
* 🏷️ Latest Release: 3.0.0 (2024-10-01)


Gemtexter is a blog engine and static site generator written entirely in GNU Bash. Authors write content once in the Gemini protocol's Gemtext markup format (`.gmi` files), and the tool converts it into multiple static output formats with zero JavaScript: XHTML for the regular web, Markdown for GitHub/Codeberg Pages, and Atom feeds—all alongside the original Gemtext for native Gemini capsules. Publishing a post is as simple as creating a dated Gemtext file (e.g., `2023-02-26-my-post.gmi`); running the generator then automatically links it from the site indexes, updates the Atom feed, and converts it to all formats. This "write once, publish everywhere" approach makes the tool useful for anyone wanting to maintain a presence across both the Gemini protocol and the conventional web from a single source of truth.

The implementation is a deliberate experiment in Bash scalability, relying on standard Unix tools (GNU Sed, Date, Grep) rather than a traditional programming language. Content lives in a configured content directory with one subdirectory per output format, where `gemtext/` serves as the editable source and the others are generated. Notable architectural features include: a template system (`.gmi.tpl` files) that evaluates inline and multiline Bash code to generate Gemtext, supporting dynamic pages, auto-generated tables of contents, and "related posts" index links; syntax highlighting of code blocks via GNU Source Highlight; themable HTML output; and optional Git integration, where each format can live in its own repository, with commands like `--git-add`, `--git-sync`, and `--publish` handling commits and remote synchronization. The tool also respects hosting-specific files (Codeberg's `.domains`, GitHub Pages' `_config.yml` and `CNAME`), supports Mastodon verification markup, and offers a regex-based content filter for fast single-file previews.

=> https://github.com/snonux/gemtexter View on GitHub

---

### 42. gos

* 💻 Languages: Go (99.6%), JSON (0.2%), Shell (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 412
* 📈 Lines of Code: 5055
* 📄 Lines of Documentation: 477
* 🏷️ Tags: 20
* 📅 Development Period: 2024-05-04 to 2026-09-11
* 🏆 Score: 1.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.3.4 (2026-09-11)


=> showcase/gos/image-1.png gos screenshot

**Gos** is a free, open-source command-line alternative to Buffer.com, written in Go (1.24+), for scheduling and publishing social media posts to Mastodon and LinkedIn—plus a "Noop" pseudo-platform that tracks posts without publishing them. It was built out of frustration with Buffer's slow UI, restrictive free tier (10 scheduled posts), and intrusive AI features. Gos is designed for automation: it can run from shell startup or on an interval, making it easy to maintain a steady posting cadence hands-off, with features like a dry-run mode for safe testing, configurable pause periods (e.g., vacations), and OAuth2 authentication for LinkedIn with automatic token refresh.

=> showcase/gos/image-2.png gos screenshot

Architecturally, posts are plain `.txt` files placed in a queue directory (`~/.gosdir`), with behavior controlled by tags embedded in filenames or file content—such as `share:` to target/exclude platforms, `prio`/`soon` for priority, `ask` for confirmation, and `now` for immediate posting. On each run, files move through a lifecycle within `db/platforms/PLATFORM`: from `.txt` → `.queued` (with a timestamp) → `.posted` after successful publishing. Message selection respects a weekly posting target, a lookback window for post history, minimum pause days between posts, and a run interval to prevent back-to-back posting. Platform credentials and settings live in a JSON config file, a companion binary `gosc` opens `$EDITOR` for quick composing, and extras include platform size limits, Syncthing-friendly replication, and generation of Gemini Gemtext summaries of past posts for blogs. Build, test, and lint automation is handled via Mage.

=> https://github.com/snonux/gos View on GitHub

---

### 43. yoga

* 💻 Languages: Go (69.1%), HTML (30.9%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 17
* 📈 Lines of Code: 6498
* 📄 Lines of Documentation: 196
* 🏷️ Tags: 9
* 📅 Development Period: 2025-10-01 to 2026-03-07
* 🏆 Score: 1.7 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.4.0 (2026-01-28)


=> showcase/yoga/image-1.png yoga screenshot

Yoga is a terminal-based (TUI) application for browsing and playing local yoga video collections, designed as a fast, keyboard-driven alternative to GUI media managers. It scans a configurable directory (defaulting to `~/Yoga`, which it creates on first launch) for common video formats (.mp4, .mkv, .mov, etc.), following symlinks during the scan. Users can navigate the video list with arrow keys, play any video in VLC with a single keypress, and refine the list through a filter dialog supporting name matching, min/max duration bounds, and tag matching. Additional features include sorting by name, length, or age; editing tags; toggling VLC crop (useful for aspect-ratio adjustment); selecting a random video from filtered results; and toggling the help footer. Durations are probed once and cached per directory in a JSON file, so subsequent launches are fast.

The project is implemented in Go and ships as a single binary with three CLI flags (`--root`, `--crop`, `--version`). Its architecture separates concerns into a directory scanner with metadata caching, a TUI layer with modal dialogs (filter/tag), and playback integration that shells out to VLC. Development workflow is managed through Mage build targets (build, test, install, coverage), with code formatted via gofumpt and a CI-style gate requiring test coverage above 85%. Note that the project is deprecated and no longer maintained, so it should be used at one's own risk.

=> https://github.com/snonux/yoga View on GitHub

---

### 44. rcm

* 💻 Languages: Ruby (99.6%), TOML (0.4%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 109
* 📈 Lines of Code: 1719
* 📄 Lines of Documentation: 778
* 🏷️ Tags: 3
* 📅 Development Period: 2024-12-05 to 2026-03-02
* 🏆 Score: 1.6 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v0.1.1 (2026-03-01)


=> showcase/rcm/image-1.png rcm screenshot

RCM (Ruby Configuration Management) is a lightweight, "KISS" configuration management system written in Ruby for personal use, conceived primarily as a deep-dive into Ruby metaprogramming (90% human-written). It enables declarative, idempotent management of system state—files, directories, symlinks, touch markers, line entries, notifications, and (experimentally) packages—through a readable DSL instead of scripts or ad-hoc shell commands. Its usefulness lies in automating repetitive setup tasks (like provisioning configs across hosts) with sensible safety defaults, notably automatic backups before any modification or deletion: content is stored in a `.rcmbackup/` directory using SHA-256-hash naming so identical content is never backed up twice.

Architecturally, everything centers on a `configure` block DSL in which resources—`file`, `directory`, `symlink`, `touch`, `given`, `notify`, `package`—are registered and accumulated across calls (`configure_from_scratch` clears the registry, useful for tests). Metaprogramming is the backbone: undefined methods are "absorbed" via chained calls, enabling natural-language syntax where modifier keywords (`is absent`, `from template`, `requires `**X**` and requires `**Y**`, `manage directory`, `without backup`, `path`) act as fluent declarators rather than rigid keyword arguments. Key capabilities include ERB templating, state modifiers (present/absent/purged/updated), permissions/ownership, hostname-conditional execution (`given { hostname is ... }` plus a `--hosts` CLI flag), inter-resource dependency resolution with loop detection, TOML-based configuration, and dry-run/debug modes. It can run as a Rake task, a Bundler-installed gem, a standalone script, or via the `rcm` CLI.

=> https://github.com/snonux/rcm View on GitHub

---

### 45. scifi

* 💻 Languages: JSON (37.8%), JavaScript (29.6%), CSS (29.0%), HTML (3.6%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 30
* 📈 Lines of Code: 1757
* 📄 Lines of Documentation: 901
* 🏷️ Tags: 0
* 📅 Development Period: 2026-01-25 to 2026-09-26
* 🏆 Score: 1.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


**Sci-Fi Books Showcase** is a fully self-contained static website that presents a personal science fiction book collection. It renders the books as a responsive grid with locally stored cover images, supports filtering by author or format (Paperback, eBook, Audiobook) plus free-text search, and opens a detail view with a plot summary when a book is clicked. Because all assets—HTML, CSS, JavaScript, JSON, and images—are hosted locally with zero external dependencies after build, the site works completely offline, loads fast, and passes W3C HTML validation. This makes it useful as a robust, low-maintenance showcase that can be served from any static web host without runtime dependencies.

Architecturally, content is cleanly separated from presentation: book metadata lives in a single `data/books.json`, while plot summaries are maintained as individual Markdown files in `summaries/` keyed by book ID. A Node-based build script (`build.js`) embeds those Markdown summaries into the JSON and produces a deployable `dist/` directory, with a Justfile wrapping the build, deploy, and local-dev-server commands. Client-side behavior—grid rendering, filtering, and the detail modal—is handled by plain JavaScript in `js/app.js`, with no frameworks or libraries. Adding a book is a simple three-step process: append an entry to `books.json`, drop in a cover image, write a Markdown summary, and re-run the build.

=> https://github.com/snonux/scifi View on GitHub

---

### 46. timr

* 💻 Languages: Go (96.0%), Shell (4.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 32
* 📈 Lines of Code: 1538
* 📄 Lines of Documentation: 99
* 🏷️ Tags: 5
* 📅 Development Period: 2025-06-25 to 2026-01-02
* 🏆 Score: 1.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.3.0 (2026-01-02)


**timr** is a minimalist command-line time tracking tool, written in Go, that functions as a stopwatch-style timer for your terminal. Its core value lies in workflow-friendly time tracking: commands like `start`, `stop`/`pause`, `cont`, `reset`, and `track` let you begin, interrupt, and log work sessions with optional descriptions, while `status` reports the running state and accumulated elapsed time (with raw output modes for scripting). Because timer state is persisted to the system between invocations, you can pause work one day and seamlessly resume tracking later. It also offers a `prompt` command that outputs a compact status string, designed for integration into shell prompts—demonstrated with Fish shell via an included installation script.

Architecturally, the project follows a standard Go layout with a `cmd/timr` entry point and uses [Mage](https://magefile.org/) as its build system (with a plain `go build` fallback). Beyond basic CLI commands, the most notable feature is `timr live`, an interactive full-screen mode that renders the timer in large ASCII-art fonts (doom, mono12, rebel, ansi, ansiShadow—some adapted from the pomo project) with real-time keyboard controls (`s` to start/stop, `r` to reset, `f` to cycle fonts, `q` to quit) and randomized or explicitly selected fonts. Notably, the codebase was largely developed via AI-assisted "vibe coding" using Gemini CLI and Claude Code CLI, keeping the project intentionally lightweight and focused.

=> https://github.com/snonux/timr View on GitHub

---

### 47. foostats

* 💻 Languages: Perl (100.0%)
* 📚 Documentation: Markdown (54.6%), Text (45.4%)
* 📊 Commits: 98
* 📈 Lines of Code: 1902
* 📄 Lines of Documentation: 423
* 🏷️ Tags: 2
* 📅 Development Period: 2023-01-02 to 2025-11-01
* 🏆 Score: 1.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v0.2.0 (2025-10-21)


**Summary:** foostats is a privacy-respecting analytics tool for OpenBSD that parses HTTP/HTTPS server logs (from `httpd`) alongside Gemini protocol logs (from `vger` and `relayd`) to produce anonymous site statistics, originally built for the foo.zone ecosystem. Its main value lies in its privacy-first design: visitor IP addresses are immediately hashed with SHA3-512, no cookies or tracking scripts are used, only aggregated data is stored, and unusually high-frequency requests (>1/second) are filtered out. Beyond basic traffic metrics like unique visitors and top URLs, it tracks Atom/RSS and Gemfeed subscriber counts, filters suspicious requests (e.g., WordPress/phpMyAdmin probing) via configurable URI patterns, supports both IPv4 and IPv6, and can replicate statistics between partner nodes for a distributed view of traffic.

**Implementation:** The tool is written in Perl (5.38+) and organized into a modular pipeline: `Logreader` parses both log types, `Filter` drops requests matching suspicious patterns and logs them, `Aggregator` computes per-day statistics, `FileOutputter` persists them as gzip-compressed JSON (`YYYY-MM-DD-hostname.json.gz`), and `Replicator`/`Merger` combine stats across nodes. The `Reporter` module then renders human-readable daily reports and rolling 30-day summaries in both Gemtext (`.gmi`) and HTML. Operation is CLI-driven (`--parse-logs`, `--replicate`, `--report`, or `--all`), with paths for stats storage, report output, and partner nodes configurable via flags. Development is supported by a `Justfile` (formatting with `perltidy`, tests via `prove`, syntax checks, local report generation from sample data) and a unit-test suite under `t/` that works because the script defers CLI execution when loaded as a module.

=> https://github.com/snonux/foostats View on GitHub

---

### 48. log4jbench

* 💻 Languages: Java (78.9%), XML (21.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 4
* 📈 Lines of Code: 774
* 📄 Lines of Documentation: 119
* 🏷️ Tags: 0
* 📅 Development Period: 2026-01-09 to 2026-01-09
* 🏆 Score: 1.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🧪 Status: Experimental (no releases yet)


**Log4j2 Benchmark Tool Summary**

This project is a Java 17 benchmarking utility that measures logging throughput across different Log4j2 configurations, reporting results in events/sec and MB/sec. Its value lies in quantifying the real-world performance trade-offs between logging strategies—for example, synchronous file appenders that flush to disk on every event versus asynchronous loggers that queue events in a ring buffer for background I/O. Developers can use it to tune production logging setups, validate that buffering or async logging delivers the expected gains, and compare durability (flush-on-write) against raw speed with consistent, reproducible numbers.

=> https://github.com/snonux/log4jbench View on GitHub

---

### 49. wireguardmeshgenerator

* 💻 Languages: Ruby (66.0%), YAML (34.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 44
* 📈 Lines of Code: 967
* 📄 Lines of Documentation: 208
* 🏷️ Tags: 1
* 📅 Development Period: 2025-04-18 to 2026-08-04
* 🏆 Score: 1.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.0.0 (2025-05-11)


The WireGuard Mesh Generator is a Ruby/Rake-based tool that automates the creation and deployment of WireGuard VPN configurations for a mesh network, where every node can reach every other peer directly. Building such a setup by hand is tedious and error-prone, since each host needs its own config listing all peers with the correct keys, endpoints, and routing rules. This project centralizes that in a single YAML file (`wireguardmeshgenerator.yaml`) and exposes three Rake tasks: `rake generate` produces the config files from the declared topology, `rake install` deploys them to the remote machines, and `rake clean` removes generated files. It's aimed at self-hosted infrastructure—such as the FreeBSD-based Kubernetes cluster described in the author's linked blog post—where a hand-maintained VPN fabric would quickly become unmanageable.

Architecturally, the tool builds on `wireguard-tools` and Bundler, and manages identity centrally by generating per-host keypairs stored under `keys/<host>/`, so keys remain stable across re-generations rather than living only on each device. It also handles Android-specific quirks: hosts declared under `android_gateways` receive one full-tunnel configuration per gateway, with tunnel names limited to 15 characters (e.g., `p7p-blowfish.conf`) to satisfy the WireGuard Android app. Crucially, all variants for a device reuse the same host keypair—users import each config and switch gateways manually instead of generating separate keys in the app.

=> https://github.com/snonux/wireguardmeshgenerator View on GitHub

---

### 50. ioriot

* 💻 Languages: C (58.7%), C/C++ (22.5%), Config (17.9%), Make (1.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 80
* 📈 Lines of Code: 13609
* 📄 Lines of Documentation: 899
* 🏷️ Tags: 7
* 📅 Development Period: 2018-03-01 to 2026-03-19
* 🏆 Score: 0.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Apache-2.0
* 🏷️ Latest Release: 0.5.1 (2019-01-04)


=> showcase/ioriot/image-1.png ioriot screenshot

I/O Riot is a Linux file-I/O benchmarking tool that captures real production workloads on one host and replays them identically on another, letting operators test how new hardware, file systems, or kernel tuning would affect an existing application's I/O performance. Unlike traditional benchmarking tools that rely on artificial or pre-defined I/O patterns, I/O Riot reproduces actual production behavior, and its workflow requires only two machines (one for capture, one for replay) instead of a complex distributed load-testing environment. Its five-step workflow—capture, generate, initialize, replay, and analyze—also enables "what-if" experimentation: replay logs can be modified (e.g., removing reads, changing replay speed) or even synthesized from scratch to evaluate hypothetical applications before any code exists, and the captured traces can expose I/O inefficiencies in applications for developers to fix.

Architecturally, the tool splits into a capture layer and a replay engine. Capture happens in Linux kernel space via SystemTap (with a kernel module for targeted per-PID capture), keeping overhead minimal even under heavy I/O load, while the replay engine is a lightweight C program supporting configurable worker/thread parallelism and optional cache dropping. The generator transforms the raw `.capture` log into a `.replay` file that rewrites production paths to replay-local ones, safely relocating symlink targets and rejecting links that would escape the replay tree. It supports a broad syscall surface—including open/read/write, stat, rename, unlink, mkdir, fsync, chmod, and chown variants plus legacy 32-bit ABI names—across ext2/ext4, XFS, ZFS, and Btrfs, initially built at Mimecast for their specific use case.

=> https://github.com/snonux/ioriot View on GitHub

---

### 51. quicklogger

* 💻 Languages: Go (84.1%), Shell (11.4%), Java (4.0%), TOML (0.4%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 47
* 📈 Lines of Code: 1808
* 📄 Lines of Documentation: 472
* 🏷️ Tags: 7
* 📅 Development Period: 2024-01-20 to 2026-08-08
* 🏆 Score: 0.8 (combines recent activity, code size, tags, and release status)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.2.0 (2026-08-08)


=> showcase/quicklogger/image-1.png quicklogger screenshot

**Quick Logger** is a small, cross-platform GUI application written in Go using the Fyne framework, designed for capturing ideas and notes with minimal friction. Its core purpose is speed and simplicity: users type a message into a plain text editor, tap "Log text," and the note is saved as a plain text file in a log directory. On Android, this makes it easy to jot down ideas anywhere, which are then automatically synchronized to other machines (e.g., a home computer) via Syncthing. A notable feature is Android share-intent support—text shared from any app can be routed directly into Quick Logger, either through the editor or straight to a file if "Auto-log shared text" is enabled.

=> showcase/quicklogger/image-2.png quicklogger screenshot

Architecturally, the project uses **Mage** (a Go-based build tool) to manage builds across platforms: desktop binaries compile directly, while Android APKs are built either locally with the Fyne CLI and Android NDK or via containerized cross-compilation using fyne-cross with Docker/Podman. Because Fyne's Android builds don't support custom Java code or `ACTION_SEND` intents, share functionality is implemented through clever APK post-processing: a script patches the compiled APK to inject a `ShareActivity`, add the necessary intent filter to the manifest, and re-sign it, passing shared text to the Go app via a cache file. Similar workarounds address keyboard/IME suggestion limitations. Notably, the project is now **deprecated** in favor of its successor, [Quicklog](https://github.com/snonux/quicklog), precisely because these Fyne-on-Android constraints proved too fragile to maintain.

=> https://github.com/snonux/quicklogger View on GitHub

---

### 52. sillybench

* 💻 Languages: Go (90.9%), Shell (9.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 5
* 📈 Lines of Code: 33
* 📄 Lines of Documentation: 3
* 🏷️ Tags: 0
* 📅 Development Period: 2025-04-03 to 2025-04-03
* 🏆 Score: 0.4 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


I'd be glad to write that summary, but the content you've pasted is only the project title—"Silly Benchmark"—and a single tagline stating its purpose: comparing performance on FreeBSD versus a Linux guest running under Bhyve (FreeBSD's native hypervisor). There isn't enough information here for me to describe the implementation, key features, or architecture without simply inventing details, which wouldn't give you an accurate summary.

Based on what's provided, all I can honestly say is that it appears to be a small, lightheartedly named benchmarking project meant to answer a practical question: does running workloads natively on FreeBSD outperform running them in a virtualized Linux guest under Bhyve? That's a question many systems administrators care about when deciding whether to run services directly on the host or inside VMs.

=> https://github.com/snonux/sillybench View on GitHub

---

### 53. terraform

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

This project is a Terraform-based personal cloud infrastructure that self-hosts open-source services on AWS, giving the owner full control of their data instead of relying on third-party SaaS providers. The services deployed include popular self-hostable applications such as Nextcloud (file sync/sharing), Vaultwarden (password manager), Wallabag (read-it-later), Anki sync server, and Audiobookshelf, all accessible under a personal wildcard domain (e.g., `cool.buetow.org`) with TLS encryption.

The implementation follows a modular architecture split across several Terraform repositories: `org-buetow-base` provisions the foundational networking (VPC, subnets) and shared persistent storage via EFS; `org-buetow-bastion` provides an EC2 jump box used to prepare EFS subdirectories for each service's data; `org-buetow-elb` sets up an Application Load Balancer for routing traffic; and `org-buetow-ecs` runs the services as containers on ECS/Fargate. Some steps remain manual — creating secrets (e.g., database passwords) in AWS Secrets Manager, setting up the DNS zone with a wildcard TLS certificate (whose ARN is referenced by the base module), creating EFS directories, and enabling daily EFS backups. Planned improvements include input variables to select which ECS services to deploy and CloudWatch monitoring with email alerts.

=> https://github.com/snonux/terraform View on GitHub

---

### 54. photoalbum

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

photoalbum is a minimal Bash script for Unix-like systems (such as Linux) that generates static web photo albums from a directory of images. The output is pure HTML and CSS with no JavaScript, which makes the resulting albums fast-loading and easy to deploy — the generated `dist` directory can simply be copied to any static web server. The project is considered complete, with development continuing in its successor, shuriken.sh.

Implementation-wise, the tool is driven by subcommands (`generate`, `clean`, `version`) and relies on ImageMagick for image processing, preferring the modern `magick` command and falling back to `convert` when needed. Its architecture centers on customizable Bash-HTML template files that users can tweak to control the album's appearance, along with a configuration system that defaults to `/etc/default/photoalbum` or a locally generated `photoalbumrc`. The `makemake` command bootstraps a project setup by creating both a Makefile and a config file in the current directory, supporting a simple workflow: configure, run `make` (or `photoalbum generate`) to build the album, publish the `dist` folder, then clean up with `make clean`.

=> https://github.com/snonux/photoalbum View on GitHub

---

### 55. guprecords

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

**guprecords – Global Uptime Records** is a command-line tool, written in Raku, that generates "global" uptime leaderboards from the record files produced by `uptimed`, a daemon available for Linux, the *BSDs, and macOS. While `uptimed` only tracks a single machine, guprecords pools record files from many hosts—typically collected into a central git repository—and ranks them together. Reports can be generated across four categories (per-`Host`, per-`Kernel`, grouped by `KernelMajor` such as "Linux 6...", and by `KernelName` such as Linux/FreeBSD) and five metrics: `Boots`, total `Uptime`, a combined `Score`, `Downtime`, and `Lifespan` (uptime plus downtime). This makes it useful for sysadmins and hobbyists who want to see at a glance which of their machines has been running longest, which reboots most often, or which kernel family dominates their fleet. Output can be rendered as Plaintext tables, Markdown, or Gemtext, with configurable entry limits and an `--all` mode that produces every report at once.

Architecturally, the project is a single Raku script built around a small class hierarchy: an `Aggregator` parses the raw records (lines of `total_uptime:boot_time:kernel_string`) into `Aggregate` objects (with a `HostAggregate` subclass for host-specific data, plus an `Epoch` value class), while `Reporter`/`HostReporter` classes—assisted by the `OutputHelper` role—render the aggregated data into formatted output. Behavior is controlled entirely through CLI flags (`--stats-dir`, `--category`, `--metric`, `--limit`, `--output-format`, `--include-kernel`, and `--stats-order` for custom section ordering), and a built-in test runner is invoked with `./guprecords.raku test`. Note that the project is deprecated and has been rewritten in Go as **goprecords**, which is the recommended successor.

=> https://github.com/snonux/guprecords View on GitHub

---

### 56. geheim

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

Geheim.rb is a lightweight, personal-use Ruby script that serves as an encrypted document vault. It encrypts text and binary files (such as PDFs and other small documents) using AES-256-CBC, with the initialization vector derived from a user-supplied PIN. Its value lies in combining strong encryption with everyday convenience: sensitive documents can be stored, searched, edited, and backed up securely, all from a single script that runs on macOS, Linux, and even Android via Termux. Note that the project is now deprecated and unmaintained, as the author has moved to another solution.

Architecturally, everything revolves around a Git repository as the storage backend. File contents are encrypted before being committed, and file names are encrypted too, kept in encrypted indices that are searchable through the `fzf` fuzzy finder. The Git foundation also enables synchronization with multiple remote repositories (e.g., several VMs) for geo-redundant backups. The script integrates with NeoVim for text editing (with file caching and swapping disabled for security), offers clipboard support on macOS and GNOME, and includes an interactive shell, batch import/export of documents, and the ability to securely shred previously exported data.

=> https://github.com/snonux/geheim View on GitHub

---

### 57. gorum

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

Gorum (also referred to as "Gogios" in the README) is a minimalistic quorum manager — a lightweight tool for coordinating distributed health checks. Based on the roadmap's mention of controlling "remote Gorum check execution," it appears designed to orchestrate checks running across multiple nodes, likely aggregating their results with quorum-based logic so that a service is only considered healthy when a sufficient majority of nodes agree. This approach is useful in distributed environments where a single node's check result can be misleading due to local network faults, providing a consensus-driven view of system health rather than a single point of observation.

The project is explicitly pre-alpha software and still under active development, so technical documentation is sparse — the README does not yet describe storage, communication protocols, or configuration details, and the language is only suggested by the naming (the "Go" prefix implies it's written in Go). Remaining roadmap items include finishing remote check execution, completing the TODO/documentation, making an initial release, and writing a blog post introducing the project.

=> https://github.com/snonux/gorum View on GitHub

---

### 58. docker-radicale-server

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

Note: only the title came through, not the README body, so this summary is based on what's publicly known about that project — paste the full text if you'd like it tailored exactly.

This project is a Docker image that packages Radicale, a lightweight open-source CalDAV/CardDAV server written in Python. Radicale lets you sync calendars, contacts, and to-do lists across devices and clients (e.g., Thunderbird, Apple Calendar, DAVx5) from your own hardware, and containerizing it turns deployment into a single `docker run` or Compose command. That makes it easy to self-host on a home server, NAS, or Raspberry Pi while keeping your data private, persistent in a volume, and portable — no third-party cloud sync service required.

=> https://github.com/snonux/docker-radicale-server View on GitHub

---

### 59. randomjournalpage

* 💻 Languages: Shell (94.1%), Make (5.9%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 9
* 📈 Lines of Code: 51
* 📄 Lines of Documentation: 26
* 🏷️ Tags: 0
* 📅 Development Period: 2022-06-02 to 2026-08-05
* 🏆 Score: 0.2 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

This project is a simple personal utility—a shell script called `randomjournalpage.sh`—that opens a random selection of pages from the author's archive of scanned PDFs, which primarily consists of digitized bullet journals along with book notes and miscellaneous ideas. The purpose is serendipitous reflection: rather than browsing sequentially, the user gets a random glimpse into past entries, which can resurface old thoughts, remind them of books they've read, or surface ideas worth reconsidering.

Implementation-wise, it's a lightweight Bash script that leverages two command-line tools: `pdfinfo` (from `poppler-utils`) presumably to determine PDF metadata such as page counts, and `qpdf` to extract the randomly chosen pages into a viewable file. Configuration is done by directly editing variables in the script itself (the journal directory path and preferred PDF viewer), after which running the script handles the entire workflow of selection, extraction, and display. There's no formal test suite, which the author acknowledges is appropriate given the script's simplicity, but the code is linted with ShellCheck to ensure basic quality. The tool is Fedora-oriented (installation instructions use `dnf`) and illustrates a pragmatic, minimal approach: gluing together standard Linux utilities rather than building anything more elaborate.

=> https://github.com/snonux/randomjournalpage View on GitHub

---

### 60. algorithms

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

This project is a collection of exercises drawn from an Algorithms lecture, intended as a refresher on core algorithmic concepts. Its value is primarily educational: rather than treating algorithms as purely theoretical, it provides hands-on practice implementing them as working code, with built-in tooling to verify both correctness and performance. This makes it a practical study resource for students revisiting lecture material or developers wanting to sharpen their algorithm fundamentals.

The implementation follows a conventional, tool-driven structure centered on a Makefile with two main entry points. `make test` runs a unit test suite that validates the correctness of each algorithm implementation, while `make bench` executes benchmarks to measure their runtime performance. This separation between testing and benchmarking suggests an architecture where algorithm code, test harnesses, and performance-measurement code are kept distinct, allowing correctness and efficiency to be evaluated independently. Note that the README is quite minimal—it doesn't specify the programming language or enumerate which algorithms are covered—so those details would need to come from the source code itself.

=> https://github.com/snonux/algorithms View on GitHub

---

### 61. staticfarm-apache-handlers

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

**staticfarm-apache-handlers** is a small collection of custom handlers written for mod_perl 2, designed to be integrated directly into an Apache 2 web server. Based on its name, the project appears to focus on serving static content — a "static farm" being a common architecture pattern where static assets (images, CSS, JavaScript, etc.) are handled separately and efficiently from dynamic application traffic. By implementing mod_perl 2 handlers, the project allows Apache's request-processing pipeline to be extended or customized at the web server level using Perl, rather than relying on application-layer logic, which can improve performance and simplify static asset delivery.

Implementation-wise, the handlers are Perl modules loaded into Apache via the embedded mod_perl 2 interpreter, giving them direct access to Apache's request lifecycle. **Important caveat:** the project is explicitly deprecated — the maintainers have stated that no further updates, bug fixes, or feature additions will be made, and it should be used at your own risk. Given its abandoned status, anyone considering it should be cautious about compatibility with modern versions of Apache and mod_perl, and may want to look for actively maintained alternatives instead.

=> https://github.com/snonux/staticfarm-apache-handlers View on GitHub

---

### 62. ipv6test

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

This project is a lightweight, Perl-based web service for testing IPv6 connectivity. It operates across three hostnames with deliberately different DNS configurations: a dual-stack main domain (reachable over both IPv4 and IPv6), an IPv4-only subdomain, and an IPv6-only subdomain. This setup lets visitors determine which protocol their client actually used to connect when visiting the main site, while the protocol-specific subdomains allow each address family to be tested in isolation. The tool is useful for diagnosing a network's IPv6 readiness, verifying that DNS AAAA records and routing are configured correctly, and troubleshooting dual-stack connectivity issues—similar in spirit to dedicated IPv6 test portals. It is deployed publicly at `ipv6test.f3s.buetow.org` and its two protocol-specific subdomains.

In terms of implementation, the site is written in Perl and packaged as a Docker image (found in the `docker-image` directory), making it easy to spin up on any host. Deployment relies on proper DNS configuration—A records for the IPv4-reachable names and AAAA records for the IPv6-reachable names—so the server can infer the visitor's connectivity based on which hostname and protocol the connection arrives over. The service is served over HTTPS, implying TLS termination as part of the deployment setup.

=> https://github.com/snonux/ipv6test View on GitHub

---

### 63. sway-autorotate

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

**sway-autorotate** is a lightweight bash script that adds automatic screen rotation to the Sway Wayland compositor, bringing smartphone-style behavior to 2-in-1 devices. It is a fork of tedk0n's `autorotate_sway_script`, adapted by the author for a Microsoft Surface Go 2 running Fedora Linux, and is also known to work on a Lenovo Thinkpad Helix. Its main value is that it makes a desktop-oriented window manager usable in tablet form: flipping the device from landscape to portrait (or any orientation in between) rotates the display and touch inputs automatically, with no manual commands required.

Architecturally, the script is driven by the output of `monitor-sensor`, a command from the `iio-sensor-proxy` package that reports orientation changes detected by the device's accelerometer. The script consumes that stream and, on each orientation event, uses `swaymsg` to set the display output's rotation accordingly. Critically, it also rotates the input devices listed in the `WAYLANDINPUT` array (touchscreens, styluses, etc.), so that touch coordinates remain correctly mapped after the screen turns—rotating the display alone would otherwise leave inputs misaligned. Usable input devices can be enumerated via `swaymsg -t get_inputs` to configure the array. The intended deployment runs the sensor stream piped into the script in the background (e.g., `echo 'monitor-sensor | bash autorotate.sh &> autorotate.log' | at now`), with all activity logged to a file.

=> https://github.com/snonux/sway-autorotate View on GitHub

---

### 64. mon

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

**mon** (also invoked as the shorter `m`) is a Perl-based command-line client for the RESTlos monitoring API, giving administrators a scriptable, operator-friendly way to query and manage monitoring objects such as hosts and contacts directly from the shell. It exposes SQL-like commands (`get`, `insert`, `update`, `delete`, `post`, `put`, plus `edit` and `view` workflows that open results in `$EDITOR`/`$PAGER`) with `where` clauses and a range of operators—`like` pushes filtering to the API as a query string, while `matches`, `eq`, `ne`, `lt`/`le`/`gt`/`ge` pre-fetch results and filter client-side. Key conveniences include an interactive mode, shorthand command aliases, zsh auto-completion, format-string templating that substitutes values from the current object (e.g., `set name = @host_name`), and `verify`/`restart`/`reload` operations for validating and applying configuration changes with automatic rollback on failure. The tool is useful because it turns a REST API into something suitable for bulk edits, shell pipelines, and automation—for example, it can write an error status file that Puppet checks to retry failed operations on its next run.

Architecturally, mon is a layered Perl script that merges configuration from `/etc/mon.conf`, `/etc/mon.d/*.conf`, and user-level `~/.mon(.d)` files (with per-key command-line overrides like `--restlos.api.port=10043`), then communicates with the RESTlos API over HTTPS with configurable CA certificates. It enforces a clean I/O separation—JSON on STDOUT for easy redirection, diagnostics on STDERR—and builds in safety and observability features: automatic JSON backups before every modification (pruned by age), a read-only dry-run mode, syslog logging, base64-encoded password support, and well-defined exit codes. It also accepts flexible JSON input, including a compact list-style format that it converts to proper objects. Note that the project is deprecated and no longer maintained.

=> https://github.com/snonux/mon View on GitHub

---

### 65. fapi

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

fapi is a command-line tool for managing F5 BIG-IP load balancers via the iControl API. It wraps common administrative tasks—managing monitors, nodes, pools, and virtual servers, plus extended operations like folders, self IPs, traffic groups, and VLANs—into simple CLI commands. This makes it useful for quickly provisioning standard load balancer setups: creating nodes from hostnames with automatic IP resolution, assembling pools with members and health monitors, and configuring virtual servers for nPath, HTTP NAT, and SNAT services, including SSL offloading by creating and attaching client-SSL profiles. It also offers conveniences such as flexible naming (FQDN, hostname, or IP, with optional ports and automatic port suffixes) and the ability to list all objects in a partition.

Implementation-wise, fapi is a Python tool built on the bigsuds library, F5's Python iControl client, which exposes the full iControl API surface. It's configured via a `~/.fapi.conf` file (copied from a bundled sample) and can be installed either from a personal apt repository or from source with `make install`. Written as a spare-time personal project by Paul C. Buetow and hosted privately on Codeberg, it was only tested on Debian Wheezy and is now formally deprecated, with no further updates, bug fixes, or features planned.

=> https://github.com/snonux/fapi View on GitHub

---

### 66. pingdomfetch

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

pingdomfetch is a Perl-based command-line tool that retrieves availability (uptime) statistics from the Pingdom website monitoring service and reports the results via email or stdout. Its main value over Pingdom's built-in notifications is the concept of "top level services" (TLS): since Pingdom only knows about individual checks, pingdomfetch lets you group related checks—such as the `http://` and `https://` variants of the same site—into a logical unit and calculates an aggregate (optionally weighted) average availability for the group. Users can query all services, all top-level services, or specific ones, filter by Pingdom check ID, and specify flexible time ranges using natural-language dates (e.g., `yesterday`, `last week`) with a `--flatten` option to normalize intervals to full days.

The tool is configuration-driven, reading layered config files (`/etc/pingdomfetch.conf`, `/etc/pingdomfetch.d/*.conf`, and `~/.pingdomfetch*` equivalents), with later files overriding earlier ones—enabling a global config plus per-top-level-service drop-ins. Config sections define TLS groupings as lists of URLs like `PROTOCOL://FQDN`, and individual services support per-service overrides such as `weight` (for traffic-proportional averaging) and `warning` thresholds. Notifications are threshold-based (warning/critical levels configured globally and per-service), with additional modes for unconditional informational emails and a `--notify-dummy` dry-run that prints emails to stdout instead of sending them. Date handling relies on the CPAN module `Time::ParseDate`. Note that the project is deprecated and no longer maintained.

=> https://github.com/snonux/pingdomfetch View on GitHub

---

### 67. fype

* 💻 Languages: C (77.3%), C/C++ (13.1%), HTML (7.5%), Make (2.1%)
* 📚 Documentation: Text (65.8%), LaTeX (20.5%), Markdown (13.7%)
* 📊 Commits: 93
* 📈 Lines of Code: 7904
* 📄 Lines of Documentation: 2774
* 🏷️ Tags: 0
* 📅 Development Period: 2008-05-15 to 2026-02-28
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

**Fype** ("For Your Program Execution") is a lightweight, BSD-licensed scripting language by Paul C. Buetow that can execute script files or inline code (`fype -e "say 1 + 2;"`). Despite its small footprint, it offers a fairly complete language: dynamic typing with automatic (and explicit) conversion between integers, doubles, and strings; arithmetic, comparison, and bitwise operators; flexible control flow (`if`/`ifnot`, `while`/`until`, `do-while`, `do-until`, `break`/`next`); procedures that share the caller's scope versus functions with their own scope, parameters, and multiple return values; arrays with indexing and half-open slice ranges; lexical block scoping; and "synonyms"—aliases created with `\foo` that share the underlying value. Built-ins round out the toolset with I/O (`say`, `put`), introspection (`defined`, `syms`, `scope`), process forking, and manual garbage collection.

Architecturally, Fype's defining trait is its single-pass design: there is no abstract syntax tree. The scanner produces a flat token list that the interpreter consumes and executes directly as it parses, keeping the implementation simple and fast to build (`make` yields a binary installable to `/usr/local/bin`). Memory and symbol management rely on a garbage collector, which also lets aliases outlive the original symbol they point to—undefining `foo` leaves `bar` valid if it was assigned as `\foo`. With canonical examples for every language feature in `examples/` (culminating in `uber.fy`), Fype doubles as a compact, practical case study in interpreter construction.

=> https://github.com/snonux/fype View on GitHub

---

### 68. pwgrep

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

pwgrep is a minimalist, command-line password manager for Unix-like systems. It stores passwords as GPG-encrypted files within a directory tree, and its name reflects its core interface: grep-style, regular-expression-powered search across the password store. Its main appeal is simplicity and transparency — rather than a proprietary database or dedicated GUI application, it's a small set of plain-text shell scripts built on ubiquitous Unix tools (Bash, GNU AWK, GnuPG, GNU find), so it has minimal dependencies, works nearly anywhere, and the entire implementation can be audited just by reading the code.

Architecturally, it delegates the hard problems to proven tools. GPG handles confidentiality: each entry is individually encrypted with the user's key(s), so nothing sensitive sits in plaintext on disk. A revision control system such as Git is layered on top to track every change to the store, providing a full audit history and the ability to recover earlier versions of an entry if a password is accidentally overwritten. GNU AWK supplies the text-processing and pattern-matching logic for searching entries, with Bash gluing the components into a simple command-line tool. Note that the project is now deprecated and unmaintained, so it should not be relied upon for new security-critical uses.

=> https://github.com/snonux/pwgrep View on GitHub

---

### 69. xerl

* 💻 Languages: Perl (98.3%), Config (1.2%), Make (0.5%)
* 📊 Commits: 143
* 📈 Lines of Code: 1675
* 🏷️ Tags: 1
* 📅 Development Period: 2011-03-06 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.0.0 (2018-12-22)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

**Xerl** (a Perl-based web framework, as indicated by its `Xerl::Page::Base` namespace) is a deprecated project for building web pages in Perl. Its README now warns that the software is no longer maintained—no further updates, bug fixes, or features will be released—and anyone using it does so at their own risk. While the documentation provided focuses more on conventions than features, the module structure suggests a page-oriented web application architecture built from reusable Perl packages.

The implementation is pure Perl, targeting version 5.14 and up, with `strict` and `warnings` pragmas mandatory in every package. It follows a strictly object-oriented design: methods use prototypes and explicit object typing (e.g., `my Package::Name $self`), subs with no meaningful return value explicitly `return undef`, private methods are prefixed with an underscore and callable only within their package, and static (non-OOP) subs are written in ALL CAPS—with static privates combining both conventions. Code formatting is automatically enforced via `perltidy` (`make perltidy`), and unfinished work is tagged with `TODO:` comments that can be located project-wide using `make todo`.

=> https://github.com/snonux/xerl View on GitHub

---

### 70. playground

* 💻 Languages: Ruby (100.0%)
* 📊 Commits: 5
* 📈 Lines of Code: 15
* 🏷️ Tags: 0
* 📅 Development Period: 2021-01-02 to 2025-06-09
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

I don't see a project attached to your message — no code, files, or documentation were included. Could you share the project you'd like summarized? For example, you could paste:

Once you provide the material, I'll write a concise 1-2 paragraph summary covering what the project does, its usefulness, and its implementation approach.

=> https://github.com/snonux/playground View on GitHub

---

### 71. japi

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

**japi** is a small, simple Perl command-line tool that fetches the newest unresolved and unclosed tickets from a Jira project, intended to give developers an at-a-glance terminal view of outstanding work without opening a browser. It's designed to be run manually or scheduled via cron—e.g., writing results to a local file once an hour and displaying them with `cat ~/.issues` whenever you open a new shell. Note that the project is now deprecated and no longer maintained, so it should be used at your own risk.

The tool is implemented in Perl and depends on the `JIRA::REST` module from CPAN, which it uses to query the Jira REST API (defaulting to `rest/api/2`). Configuration is handled almost entirely through command-line flags, including the Jira base URI, username, and a customizable JQL search query (by default `project=MT and status not in (Resolved,Closed)`), along with options like `--unassigned` to filter for unassigned issues only, and `--nocolor`/`--debug` for output control. Results are displayed with colored text by default. Authentication credentials are managed through an optional file (`~/.japipass`) containing the Base64-encoded Jira password—recommended to be secured with `chmod 0600`—with a fallback to an interactive password prompt if the file is missing.

=> https://github.com/snonux/japi View on GitHub

---

### 72. gotop

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

**gotop** is a terminal-based I/O monitor for Linux that serves as an alternative to iotop, the standard utility for watching disk activity on a per-process basis. Its core job is the same as iotop's: show which processes are performing reads and writes, how much data they're moving, and at what rates, making it useful for diagnosing disk bottlenecks and identifying runaway I/O consumers. The main argument for a replacement comes from its implementation: it's written entirely in Go, so it compiles to a single static binary with no Python interpreter or external dependencies to install — handy for minimal systems, containers, and quick deployment, and typically faster to start than an interpreted equivalent.

Implementation details beyond the language choice are sparse — the README is essentially just a title and a one-line description — but a tool of this type on Linux generally works by reading per-process I/O accounting exposed by the kernel (e.g., `/proc/<pid>/io` or the taskstats interface) and rendering it as a live, sortable terminal display. Notably, the project is officially deprecated: no further updates, bug fixes, or feature additions will be made. It remains usable as-is, but anyone depending on it should be aware they'll get no maintenance, and may prefer actively maintained alternatives such as iotop itself or the C rewrite iotop-c.

=> https://github.com/snonux/gotop View on GitHub

---

### 73. awksite

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

**Awksite** is a small, now-deprecated CGI application for generating dynamic HTML websites using only GNU AWK. Its main appeal is its extreme minimalism and portability: since GNU awk comes preinstalled on virtually all *NIX systems, awksite requires no additional runtime—no PHP, Python, Perl interpreters, or database server—to serve dynamically generated pages. This made it useful for lightweight dynamic hosting on minimal or legacy systems, and it serves as a neat demonstration of how far AWK can be pushed beyond its usual text-processing duties. However, given that the project is unmaintained and receives no bug fixes or updates, it's best treated today as an educational example or curiosity rather than a production-ready tool.

Architecturally, awksite follows the classic CGI model: the web server invokes the AWK-based application for each HTTP request, and the script assembles and emits HTML (to standard output) which the server passes back as the response body. AWK's natural strengths—pattern matching, text manipulation, and its ubiquity across Unix systems—make it a surprisingly workable choice for this kind of page generation. The overall design is deliberately simple, with the entire "stack" consisting of just the operating system, GNU awk, and any web server with CGI support, keeping the dependency footprint and complexity to a bare minimum.

=> https://github.com/snonux/awksite View on GitHub

---

### 74. perldaemon

* 💻 Languages: Perl (72.7%), Shell (23.9%), Config (3.4%)
* 📊 Commits: 111
* 📈 Lines of Code: 611
* 🏷️ Tags: 6
* 📅 Development Period: 2011-02-05 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.4 (2022-04-29)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

PerlDaemon is a lightweight, extensible daemon framework for Linux and other UNIX-like systems, written in Perl. Its purpose is to handle all the boilerplate plumbing of running a background service—automatic daemonizing, logging with logrotate support (SIGHUP), clean shutdown on SIGTERM, and pidfile management with startup conflict checks—so that developers only need to write the actual task logic. Custom functionality is added by dropping Perl modules into the `PerlDaemonModules::` namespace (essentially by copying and modifying an example module), where they're automatically discovered and run by the daemon. Configuration is intentionally simple: settings live in a single conf file, can be overridden temporarily via command line (e.g., `./control start daemon.interval=10`), and a wrapper script provides start/stop/restart/foreground-mode commands. The project is, however, deprecated and no longer maintained.

Architecturally, the daemon runs an event loop that triggers registered modules in sequential order at a configurable interval. It uses `Time::HiRes` for high-resolution timing and tracks a "carry" value each cycle—accumulating any lost execution time and adding it to the next loop run—to keep module invocations on schedule despite processing delays. For operational monitoring, the daemon touches an "alive file" every interval, which external health checks can compare against to detect a hung or dead process. Modules currently execute sequentially rather than in parallel, a noted limitation for future threading/process-based enhancement.

=> https://github.com/snonux/perldaemon View on GitHub

---

### 75. rubyfy

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

**Rubyfy** is a lightweight, self-contained Ruby script that automates running shell commands on remote servers over SSH—the author describes it simply as "a fancy SSH loop." It targets the gap between manually SSH-ing into individual machines and heavyweight configuration management tools like Ansible or Puppet: sysadmins can feed a list of hostnames via stdin and execute a command across them all with a single invocation. Note that the project is deprecated and no longer maintained, so while it may still function, it will receive no updates, bug fixes, or security patches.

As for implementation, `rubyfy.rb` reads hostnames from stdin and establishes SSH connections to each target server to run a given command (`-c`). Its key features, drawn from the configuration options, include parallel execution across a configurable number of simultaneous servers (`--parallel N`), running commands as root via sudo (`--root`), backgrounding long-running scripts (`-b`), redirecting output to named files under `./out/` (`-n`), and a precondition mechanism that gates execution on remote file checks—illustrated by the example of rebooting a server only if `/var/run/maintenance.lock` is absent. The tool was tested against Ruby 2.2.x on Fedora 22 and Mac OS X.

=> https://github.com/snonux/rubyfy View on GitHub

---

### 76. netdiff

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

Deprecation note aside, **netdiff** is a lightweight utility for comparing a file or directory on two different hosts over the network. Its workflow is peer-to-peer by design: you run the exact same command on both hosts simultaneously (typically via Cluster-SSH), passing the hostname of one of the two machines and a fully qualified path. This makes it especially handy for system administrators who need to spot configuration drift between similar systems—for example, verifying that PAM configurations match across a fleet, where settings are scattered across many small files in `/etc/pam.d` and tedious to compare manually. It also supports an optional custom port (with a default defined in `/etc/default/netdiff`) and pass-through of additional `diff` options.

Architecturally, the script uses automatic role detection: whichever hostname you pass as the argument determines which host acts as the client and which acts as the server, so no separate setup is needed on either side. The client recursively transfers the contents of the specified path to the peer over the network, with encryption handled via OpenSSL/AES, and the comparison is then performed using the standard `diff` tool. The project was authored by Paul Buetow and is documented at netdiff.buetow.org, though it is no longer maintained and carries an explicit "use at your own risk" warning.

=> https://github.com/snonux/netdiff View on GitHub

---

### 77. perl-c-fibonacci

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

I don't see a project included in our conversation yet — there's no code, documentation, or description for me to summarize. Could you share it? You can paste the source code, a README, or even just a description of what the project does and how it's built. If it's a large codebase, the README plus the main entry point or a few core modules is usually enough to capture the key features and architecture.

Once you share it, I'll put together a concise 1-2 paragraph summary covering what it does, why it's useful, and how it's implemented.

=> https://github.com/snonux/perl-c-fibonacci View on GitHub

---

### 78. muttdelay

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

muttdelay is a bash script that lets users of the mutt terminal email client schedule messages to be sent automatically at a specific future time, rather than immediately. Unlike mutt's built-in "postpone" feature—which merely saves a draft for later editing—muttdelay actually queues the mail for unprompted delivery, making it useful for scenarios like writing a reply late at night that should arrive in the morning, or composing a message now and timing its delivery for later. Note that the project is deprecated and no longer maintained.

The implementation combines three lightweight components. First, a Vim plugin (installed into `~/.vim/plugin/` and mapped to the `,L` keystroke) lets the user schedule a mail while still composing it: pressing `,L` saves the message to `~/.muttdelay/` under a filename that encodes both the desired send timestamp and the compose timestamp. Second, an hourly cron job invokes `muttdelay cron`, which scans that directory and sends any files whose send timestamp is in the past, using mutt's command-line mode. Finally, the core bash script ties these pieces together, so the whole system relies on simple timestamp-encoded files, Vim integration, and standard cron—no daemons or complex state management required.

=> https://github.com/snonux/muttdelay View on GitHub

---

### 79. cpuinfo

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

**cpuinfo** is a small command-line utility by Paul Buetow that displays CPU information in a human-readable format. The Linux kernel exposes detailed processor data through the `/proc/cpuinfo` file, but its raw output is verbose, repetitive, and low-level—one block of technical fields per logical CPU. This tool addresses that by distilling the relevant information into a concise summary, so users can quickly get an overview of their system's processor without manually parsing kernel output or remembering which fields matter.

In terms of implementation, cpuinfo takes a deliberately minimal approach: it is essentially a wrapper that invokes AWK to parse `/proc/cpuinfo` and print a formatted, human-friendly version of the data. Rather than being a compiled program with complex dependencies, it leverages AWK—a text-processing tool present on virtually every Unix-like system—which keeps the utility lightweight and portable across Linux distributions. The synopsis shows it takes no arguments (`cpuinfo` alone), so the interface is simply running the command. This "glue script" architecture is characteristic of classic Unix philosophy: instead of reimplementing parsing logic, the tool composes existing standard tools to accomplish its task. More details are available at the project website, cpuinfo.buetow.org.

=> https://github.com/snonux/cpuinfo View on GitHub

---

### 80. dyndns

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

This project is a lightweight dynamic DNS (DynDNS) updater built around standard Unix tools, designed for scenarios where a machine's IP address changes frequently (e.g., a PPP dial-up or home broadband connection) but its DNS records need to stay current. It allows a client behind a changing IP to keep its hostname's A record in sync with its actual address by remotely invoking an update script on a BIND DNS server. While the project is officially deprecated and no longer maintained, it demonstrates a simple, dependency-light approach to self-hosted dynamic DNS without relying on third-party services.

Architecturally, it uses a client-server split: the DNS server runs BIND with a dedicated zone and a restricted `dyndns` user account, which holds per-host `nsupdate` TSIG keys and a log file for update tracking. The client triggers updates by running an SSH command (`ssh dyndns@dyndnsserver dyndns-update host TYPE new-entry TIMEOUT`), using RSA key-based authentication so no interactive password is needed. The server-side script then performs the DNS record update via `nsupdate`. Notably, it supports full automation through PPP integration—when a connection comes up, the `ppp.linkup` file fires a background SSH command that substitutes the dynamic address via the `MYADDR` variable. A very low TTL (e.g., 30 seconds) ensures DNS changes propagate quickly, and tools like `nslookup` and `dig` can be used for verification.

=> https://github.com/snonux/dyndns View on GitHub

---

### 81. debroid

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

**Debroid** is a set of scripts and instructions for installing a full Debian GNU/Linux environment as a chroot on a rooted LG G3 D855 running CyanogenMod 13 (Android 6), effectively turning the phone into a portable Debian machine. This lets users run native ARM Debian packages, standard command-line tools, and background services (the README demonstrates with `uptimed`) alongside the normal Android system. Note that the project is deprecated and no longer maintained.

The implementation uses a two-stage debootstrap process split across two machines. Stage one runs on a separate Linux host (e.g., Fedora), where a 5 GB disk image is created, formatted as ext4, and populated with a minimal Debian Jessie base for ARM (armel). That image is gzipped and pushed to the phone's external SD card via ADB. On the device itself, the image is loop-mounted and Android's `/proc`, `/dev`, `/sys`, and shared storage are bind-mounted into the chroot so the guest system can interoperate with the host. The second debootstrap stage then completes inside the chroot on the phone. Ongoing access is handled by a `jessie.sh` helper script, while service startup is managed through a custom `/etc/rc.debroid` script — deliberately bypassing Debian's standard runlevels — which is hooked into the Android boot process via a `userinit.sh` script installed in `/data/local`, so Debian services launch automatically at phone boot.

=> https://github.com/snonux/debroid View on GitHub

---

### 82. netcalendar

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

**NetCalendar** is a lightweight, Java-based calendar application (requiring JRE 6+) built around a client-server architecture that communicates over TCP/IP. It supports three deployment modes: fully stand-alone (client and server running as two threads in the same process), distributed with plain communication (server launched with `--server-only`, clients connecting via a specified server address), or distributed with SSL encryption, configured through Java key stores and trust stores. The project is now deprecated and no longer maintained.

=> showcase/netcalendar/image-2.png netcalendar screenshot

Its usefulness lies in enabling shared, network-accessible calendars that remain simple to deploy—everything ships in a single executable JAR, and the server can even be shut down remotely from the client GUI. Key features include a color-coded event display that conveys urgency at a glance (red for events within 24 hours, orange within a week, yellow within 28 days, and so on), visual distinction between yearly recurring events (blue) and one-time events (green), configuration via a flat `netcalendar.conf` file or through GUI preferences, and interoperability with the traditional UNIX `calendar` tool, allowing `~/.calendar` to serve directly as the database directory.

=> https://github.com/snonux/netcalendar View on GitHub

---

### 83. jsmstrade

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

**jsmstrade** is a minimal, JavaScript-based (as its name suggests) GUI application for sending SMS messages through the smstrade.de SMS gateway. Rather than requiring users to interact with the gateway's simple HTTP API directly—via scripts, curl calls, or custom code—it provides a lightweight graphical front end where the user can enter a recipient number, compose message text, supply their smstrade account credentials (typically an API key), and dispatch the message with a click. Its value lies in convenience: smstrade.de was a pay-per-message SMS relay service, and jsmstrade gives its customers a quick, no-programming-required way to send one-off text messages from a desktop.

In terms of architecture, the README offers little beyond the one-line description, so specifics such as the UI framework, packaging (browser-based vs. desktop shell), and configuration handling cannot be stated definitively—though the "js" prefix and "minimal" designation point to a small, dependency-light JavaScript codebase. Notably, the project carries a prominent deprecation warning: its maintainers have stated that no further updates, bug fixes, or features will be made, and the software should be used "at your own risk." Since its entire functionality depends on the third-party smstrade.de gateway remaining available, the project is best regarded today as unmaintained legacy code rather than a dependable messaging tool.

=> https://github.com/snonux/jsmstrade View on GitHub

---

### 84. template

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

This project is a template for creating Debian packages, providing a pre-configured skeleton so developers can package their own software without building Debian packaging infrastructure from scratch. (Note: the project is deprecated and unmaintained, and was tested against older Debian releases, Squeeze and Wheezy, so it should be treated as a reference rather than a production dependency.) Its usefulness lies in handling the boilerplate: the included example is a simple script in `bin/template` that prints a version number, but the entire packaging workflow around it is already working out of the box. Users clone the template, rename everything from "template" to their project name using provided `git mv` and `sed` one-liners, customize the files, and get a distributable `.deb`.

The implementation is centered on a top-level `Makefile` that orchestrates both compilation and packaging: `make` builds the project, while `make deb` produces a full set of package artifacts (`.deb`, `.dsc`, `.changes`, and source `.tar.gz`) in the parent directory. Documentation uses POD format—editing `docs/template.pod` and running `make documentation` generates a man page that is automatically included in the package. Package metadata follows the standard Debian layout in a `debian/` directory (`control`, `copyright`, `README`), with release versioning handled via `dch -i` to update the changelog. Required tooling includes standard Debian packaging utilities (`dpkg-dev`, `devscripts`, `lintian`, `make`, and `perl`), and packages can be validated with `lintian --pedantic` and installed with `dpkg -i`. The template is deliberately minimal and extensible—users can swap POD for LaTeX, compile C instead of scripts, or add library directories by extending the Makefile's install rules.

=> https://github.com/snonux/template View on GitHub

---

### 85. vs-sim

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

VS-Sim ("Verteilte Systeme Simulator," German for "Distributed Systems Simulator") is an open-source simulator for distributed systems, written in Java. Developed as a diploma thesis at Aachen University of Applied Sciences, it was designed to help users model and experiment with distributed systems concepts—such as communication between networked nodes—without requiring actual physical hardware. Its academic origins suggest it serves primarily as an educational tool, allowing students and researchers to visualize and study how distributed algorithms and interactions behave in a controlled environment. The project features a graphical interface, as evidenced by its included screenshots, making it accessible for hands-on experimentation.

The project was written entirely in Java, a natural choice for a distributed systems simulator given Java's built-in networking capabilities and platform independence. However, VS-Sim is now deprecated and no longer maintained. Users interested in this type of tool are directed to its successor, [ds-sim](https://codeberg.org/snonux/ds-sim), which is a modernized and English-translated version of the project hosted on Codeberg. Note that the README provides limited detail about the internal architecture and specific feature set, so deeper technical specifics would need to come from the source code itself.

=> https://github.com/snonux/vs-sim View on GitHub

---

### 86. perl-poetry

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

**perl-poetry** is a collection of poems written in the Perl programming language. Each piece is a valid Perl script that compiles under the specified Perl version, but it is deliberately crafted to be read rather than to compute anything — the aesthetic lies in making source code that doubles as verse. Its usefulness is artistic and cultural rather than practical: it entertains programmers, exemplifies the long tradition of "code poetry," and showcases Perl's famously permissive grammar, which (as in much Perl poetry) allows English-like phrases to function as syntactically valid statements.

Architecturally, the project is intentionally minimal. It consists of standalone Perl source files — one per poem — with no application logic, module structure, or dependencies to speak of. The defining constraint is that every file must remain compilable Perl, while the README makes clear that the code "is not supposed to do something useful except looking nice." In other words, correctness here is measured by whether the poem compiles and how it reads, not by what it produces.

=> https://github.com/snonux/perl-poetry View on GitHub

---

### 87. hsbot

* 💻 Languages: Haskell (98.5%), Make (1.5%)
* 📊 Commits: 81
* 📈 Lines of Code: 601
* 🏷️ Tags: 0
* 📅 Development Period: 2009-11-22 to 2026-03-07
* 🏆 Score: 0.1 (combines recent activity, code size, tags, and release status)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be inactive or no longer maintained. The average age of its last 42 commits exceeds 2 years. Use at your own risk.

This project is a deprecated (no longer maintained) Haskell application built against the GHC 6 toolchain, as indicated by its `libghc6-*` package requirements. Based on its dependencies, it combines two core capabilities: network communication and persistent relational data storage. The `libghc6-network-dev` dependency points to the standard Haskell `network` library, suggesting the project implements some form of networked service—such as a server daemon, client, or message-passing component—while `libghc6-hsql-mysql-dev` provides MySQL database access. A database-backed network application of this kind is typically useful for coordinating state across multiple connected hosts, persisting user or transaction data, or serving as a data-driven service backend.

Architecturally, the project sits between two layers: the Haskell `network` package handles socket creation, connection management, and TCP/IP data transfer, while the HSQL library's MySQL driver exposes SQL queries to the Haskell code through a database abstraction interface. Application logic would dispatch between incoming network events and database reads/writes. However, it's worth noting that the available information—a deprecation notice and a requirements list—does not reveal the project's specific purpose, features, or domain. A truly complete summary of its functionality and value would require the project description or source code; from the given excerpt alone, only the implementation language and architectural building blocks can be reliably inferred.

=> https://github.com/snonux/hsbot View on GitHub

---

### 88. jailman

* 📊 Commits: 0
* 📈 Lines of Code: 0
* 🏷️ Tags: 0
* 📅 Development Period:  to 
* 🏆 Score: 0.0 (combines recent activity, code size, tags, and release status)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


I don't see any project materials in our conversation—no code, files, or descriptions have been shared yet. To write the summary you're asking for, I'll need you to provide the project details.

You could share any of the following:

=> https://github.com/snonux/jailman View on GitHub
