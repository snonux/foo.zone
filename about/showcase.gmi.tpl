# Project Showcase

Generated on: 2025-10-14

This page showcases my side projects, providing an overview of what each project does, its technical implementation, and key metrics. Each project summary includes information about the programming languages used, development activity, and licensing. The projects are ordered by recent activity, with the most actively maintained projects listed first.

<< template::inline::toc

## Overall Statistics

* 📦 Total Projects: 56
* 📊 Total Commits: 11,220
* 📈 Total Lines of Code: 274,377
* 📄 Total Lines of Documentation: 52,861
* 💻 Languages: Go (31.1%), Java (14.7%), C++ (13.5%), Shell (7.8%), C/C++ (7.4%), C (7.0%), Perl (6.5%), HTML (4.6%), Config (1.7%), Ruby (1.0%), HCL (1.0%), Make (0.7%), YAML (0.6%), Python (0.6%), CSS (0.5%), JSON (0.3%), Raku (0.3%), XML (0.2%), Haskell (0.2%), TOML (0.1%)
* 📚 Documentation: Markdown (76.7%), Text (22.2%), LaTeX (1.1%)
* 🎵 Vibe-Coded Projects: 4 out of 56 (7.1%)
* 🤖 AI-Assisted Projects (including vibe-coded): 11 out of 56 (19.6% AI-assisted, 80.4% human-only)
* 🚀 Release Status: 36 released, 20 experimental (64.3% with releases, 35.7% experimental)

## Projects

### yoga

* 💻 Languages: Go (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 11
* 📈 Lines of Code: 3376
* 📄 Lines of Documentation: 82
* 📅 Development Period: 2025-10-01 to 2025-10-12
* 🔥 Recent Activity: 8.8 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.2.5 (2025-10-12)
* 🤖 AI-Assisted: This project was partially created with the help of generative AI


=> showcase/yoga/image-1.png yoga screenshot

# Yoga

=> https://codeberg.org/snonux/yoga View on Codeberg
=> https://github.com/snonux/yoga View on GitHub

---

### hexai

* 💻 Languages: Go (69.5%), HTML (30.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 238
* 📈 Lines of Code: 26565
* 📄 Lines of Documentation: 564
* 📅 Development Period: 2025-08-01 to 2025-10-04
* 🔥 Recent Activity: 21.7 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.15.1 (2025-10-03)
* 🤖 AI-Assisted: This project was partially created with the help of generative AI


=> showcase/hexai/image-1.png hexai screenshot

Hexai is an AI-powered extension designed to enhance the Helix Editor by integrating advanced code assistance features through Language Server Protocol (LSP) and large language models (LLMs). Its core capabilities include LSP-based code auto-completion, code actions, and an in-editor chat interface that allows users to interact directly with AI models for coding help and suggestions. Additionally, Hexai provides a standalone command-line tool for interacting with LLMs outside the editor. It supports multiple AI backends, including OpenAI, GitHub Copilot, and Ollama, making it flexible for various user preferences and workflows.

The project is implemented primarily in Go and uses Mage as its build and task automation tool. The architecture consists of two main binaries: one for general LLM interaction and another for LSP integration with the editor. Hexai communicates with LLM providers via their APIs, relaying code context and user queries to generate intelligent responses or code completions. The modular design allows for easy configuration and extension, and while it is tailored for Helix, it may work with other editors that support LSP. This makes Hexai a valuable tool for developers seeking AI-assisted productivity directly within their coding environment.

=> https://codeberg.org/snonux/hexai View on Codeberg
=> https://github.com/snonux/hexai View on GitHub

---

### conf

* 💻 Languages: Perl (31.5%), Shell (23.2%), YAML (22.9%), Config (5.6%), CSS (5.4%), TOML (4.8%), Ruby (4.1%), Lua (1.2%), Docker (0.6%), JSON (0.5%)
* 📚 Documentation: Text (73.7%), Markdown (26.3%)
* 📊 Commits: 1008
* 📈 Lines of Code: 6055
* 📄 Lines of Documentation: 1356
* 📅 Development Period: 2021-12-28 to 2025-10-13
* 🔥 Recent Activity: 26.4 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


conf
====

=> https://codeberg.org/snonux/conf View on Codeberg
=> https://github.com/snonux/conf View on GitHub

---

### foo.zone

* 💻 Languages: Shell (71.8%), Go (27.8%), YAML (0.4%)
* 📚 Documentation: Markdown (99.5%), Text (0.5%)
* 📊 Commits: 3131
* 📈 Lines of Code: 227
* 📄 Lines of Documentation: 29792
* 📅 Development Period: 2021-04-29 to 2025-10-12
* 🔥 Recent Activity: 43.5 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)
* 🤖 AI-Assisted: This project was partially created with the help of generative AI


This project hosts the static files for the foo.zone website, which is accessible via both the Gemini protocol (gemini://foo.zone) and the web (https://foo.zone). The repository is organized with separate branches for each content format—such as Gemtext, HTML, and Markdown—allowing the site to be served in multiple formats tailored to different protocols and user preferences. This structure makes it easy to maintain and update content across platforms, ensuring consistency and flexibility.

The site is maintained using a suite of open-source tools, including Neovim for editing, GNU Bash for scripting, and ShellCheck for shell script linting. It is deployed on OpenBSD, utilizing the vger Gemini server (managed via relayd and inetd) for Gemini content and the native httpd server for the HTML site. Source code and hosting are managed through Codeberg. The static content is generated with the help of the gemtexter tool, which streamlines the process of converting and managing content in various formats. This architecture emphasizes simplicity, security, and portability, making it a robust solution for multi-protocol static site hosting.

=> https://codeberg.org/snonux/foo.zone View on Codeberg
=> https://github.com/snonux/foo.zone View on GitHub

---

### foostats

* 💻 Languages: Perl (100.0%)
* 📚 Documentation: Markdown (54.4%), Text (45.6%)
* 📊 Commits: 96
* 📈 Lines of Code: 1910
* 📄 Lines of Documentation: 421
* 📅 Development Period: 2023-01-02 to 2025-09-28
* 🔥 Recent Activity: 59.2 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v0.1.0 (2025-07-12)


**foostats** is a privacy-focused web analytics tool designed specifically for OpenBSD environments, with support for both traditional web (HTTP/HTTPS) and Gemini protocol logs. Its primary function is to generate anonymous, comprehensive site statistics for the foo.zone ecosystem and similar sites, while strictly preserving visitor privacy. This is achieved by hashing all IP addresses with SHA3-512 before storage, ensuring no personally identifiable information is retained. The tool provides detailed daily, monthly, and summary reports in Gemtext format, tracks feed subscribers, and includes robust filtering to block and log suspicious requests based on configurable patterns.

Architecturally, foostats is modular, with components for log parsing, filtering, aggregation, replication, and reporting. It processes logs from OpenBSD httpd and Gemini servers (vger/relayd), aggregates statistics, and outputs compressed JSON files and human-readable reports. Its distributed design allows replication and merging of stats across multiple nodes, supporting comprehensive analytics for federated sites. Key features include multi-protocol and IPv4/IPv6 support, privacy-first data handling, and flexible configuration for filtering and reporting, making it a secure and privacy-respecting alternative to conventional analytics platforms.

=> https://codeberg.org/snonux/foostats View on Codeberg
=> https://github.com/snonux/foostats View on GitHub

---

### gitsyncer

* 💻 Languages: Go (91.0%), Shell (7.4%), YAML (0.9%), JSON (0.6%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 110
* 📈 Lines of Code: 10036
* 📄 Lines of Documentation: 2433
* 📅 Development Period: 2025-06-23 to 2025-09-08
* 🔥 Recent Activity: 81.6 days (avg. age of last 42 commits)
* ⚖️ License: BSD-2-Clause
* 🏷️ Latest Release: v0.9.2 (2025-09-08)
* 🎵 Vibe-Coded: This project has been vibe coded


**GitSyncer** is an automation tool designed to synchronize git repositories across multiple organizations and hosting platforms, such as GitHub, Codeberg, and private SSH servers. Its primary purpose is to keep all branches and tags in sync between these platforms, ensuring that codebases remain consistent and up-to-date everywhere. GitSyncer is especially useful for developers and teams managing projects across different git hosts, providing features like automatic branch and repository creation, one-way backups to offline or private servers, and robust error handling for merge conflicts and missing resources. It also includes advanced capabilities like AI-powered project showcase generation, batch synchronization for automation, and flexible configuration for branch exclusions and backup strategies.

The tool is implemented as a modern CLI application in Go, with a modular, command-based architecture. Users configure organizations, repositories, and backup locations via a JSON file, and interact with GitSyncer through intuitive commands (e.g., `gitsyncer sync`, `gitsyncer release create`). Under the hood, GitSyncer clones repositories, adds all remotes, fetches and merges branches, and pushes updates to all destinations, handling repository and branch creation as needed. SSH backup locations are supported for one-way, opt-in backups, with automatic bare repo initialization. The AI-powered showcase feature analyzes repositories and uses Claude or other AI tools to generate comprehensive project summaries and statistics. The architecture emphasizes automation, safety (never deleting branches), and extensibility, making GitSyncer a powerful solution for multi-platform git management and backup.

=> https://codeberg.org/snonux/gitsyncer View on Codeberg
=> https://github.com/snonux/gitsyncer View on GitHub

---

### totalrecall

* 💻 Languages: Go (98.9%), Shell (0.5%), YAML (0.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 88
* 📈 Lines of Code: 12003
* 📄 Lines of Documentation: 361
* 📅 Development Period: 2025-07-14 to 2025-08-02
* 🔥 Recent Activity: 84.4 days (avg. age of last 42 commits)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.7.5 (2025-08-02)
* 🎵 Vibe-Coded: This project has been vibe coded


=> showcase/totalrecall/image-1.png totalrecall screenshot

**Summary of totalrecall - Bulgarian Anki Flashcard Generator**

=> showcase/totalrecall/image-2.png totalrecall screenshot

`totalrecall` is a specialized tool designed to streamline the creation of Anki flashcards for Bulgarian vocabulary learners. It automates the generation of high-quality study materials—including audio pronunciations, AI-generated contextual images, phonetic transcriptions (IPA), and translations—by leveraging OpenAI’s TTS and DALL-E APIs. The tool supports both a fast, keyboard-driven graphical user interface (GUI) and a flexible command-line interface (CLI), making it accessible for users with different preferences. Key features include batch processing of word lists, randomization of voices and art styles for variety, and seamless export to Anki-compatible formats (APKG and CSV), ensuring that learners can quickly build rich, multimedia flashcard decks.

Architecturally, totalrecall is implemented in Go and integrates with OpenAI services via API keys for audio and image generation. It processes input in various formats, automatically handling translation and media generation as needed. Output files—including MP3s, images, and Anki packages—are organized in a user’s local state directory, with configuration options for customization. The project’s modular design allows for easy installation, desktop integration (especially on GNOME/Fedora), and extensibility. By automating the most time-consuming aspects of flashcard creation and enhancing cards with multimedia and phonetic data, totalrecall significantly improves the efficiency and quality of language learning for Bulgarian.

=> https://codeberg.org/snonux/totalrecall View on Codeberg
=> https://github.com/snonux/totalrecall View on GitHub

---

### timr

* 💻 Languages: Go (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 25
* 📈 Lines of Code: 929
* 📄 Lines of Documentation: 80
* 📅 Development Period: 2025-06-25 to 2025-09-29
* 🔥 Recent Activity: 93.6 days (avg. age of last 42 commits)
* ⚖️ License: BSD-2-Clause
* 🏷️ Latest Release: v0.1.1 (2025-09-29)
* 🎵 Vibe-Coded: This project has been vibe coded


**Summary of the `timr` Project**

`timr` is a lightweight, command-line time tracking tool designed to help users monitor the time they spend on tasks directly from their terminal. Its core functionality revolves around simple commands to start, stop, pause, reset, and check the status of a stopwatch-style timer, making it ideal for developers, freelancers, or anyone who prefers a minimalist workflow without the overhead of complex time-tracking applications. The tool also offers a live, full-screen timer mode with keyboard controls and can display the timer status in real-time within the fish shell prompt, enhancing productivity by keeping time tracking seamlessly integrated into the user's environment.

From an architectural standpoint, `timr` is implemented in Go, ensuring cross-platform compatibility and efficient performance. The timer's state is persistently stored on the user's system, allowing for accurate tracking even across sessions. The command structure is straightforward, with subcommands for each primary action (`start`, `stop`, `status`, etc.), and the project includes shell integration scripts for fish to display timer status in the prompt. This combination of simplicity, persistence, and shell integration makes `timr` a practical and unobtrusive solution for time management at the command line.

=> https://codeberg.org/snonux/timr View on Codeberg
=> https://github.com/snonux/timr View on GitHub

---

### tasksamurai

* 💻 Languages: Go (99.8%), YAML (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 217
* 📈 Lines of Code: 6168
* 📄 Lines of Documentation: 162
* 📅 Development Period: 2025-06-19 to 2025-10-05
* 🔥 Recent Activity: 107.6 days (avg. age of last 42 commits)
* ⚖️ License: BSD-2-Clause
* 🏷️ Latest Release: v0.9.3 (2025-10-05)
* 🎵 Vibe-Coded: This project has been vibe coded


=> showcase/tasksamurai/image-1.png tasksamurai screenshot

**Task Samurai** is a fast, keyboard-driven terminal interface for [Taskwarrior](https://taskwarrior.org/), designed to streamline task management directly from the command line. Built in Go using the [Bubble Tea](https://github.com/charmbracelet/bubbletea) TUI framework, it displays tasks in an interactive table and allows users to add, modify, and complete tasks efficiently using intuitive hotkeys. The interface is optimized for speed and responsiveness, offering a modern alternative to other Taskwarrior UIs like `vit`.

=> showcase/tasksamurai/image-2.png tasksamurai screenshot

The core architecture leverages the Bubble Tea framework for rendering the terminal UI, while all task operations are performed by invoking the native `task` command-line tool. Each user action—such as adding or completing a task—triggers the corresponding Taskwarrior command, and the UI refreshes automatically to reflect changes. Key features include hotkey-driven task management, real-time updates, and support for all Taskwarrior filters and queries. Optional features like "disco mode" add visual flair by changing the theme after each task modification. Installation is straightforward via Go tooling, and the project is particularly useful for users who want a fast, fully keyboard-controlled Taskwarrior experience in the terminal.

=> https://codeberg.org/snonux/tasksamurai View on Codeberg
=> https://github.com/snonux/tasksamurai View on GitHub

---

### ior

* 💻 Languages: Go (50.4%), C (43.1%), Raku (4.5%), Make (1.1%), C/C++ (1.0%)
* 📚 Documentation: Text (69.7%), Markdown (30.3%)
* 📊 Commits: 337
* 📈 Lines of Code: 13072
* 📄 Lines of Documentation: 680
* 📅 Development Period: 2024-01-18 to 2025-10-09
* 🔥 Recent Activity: 122.8 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)
* 🤖 AI-Assisted: This project was partially created with the help of generative AI


=> showcase/ior/image-1.png ior screenshot

**I/O Riot NG (ior)** is a Linux-based tool designed to trace and analyze synchronous I/O system calls using BPF (Berkeley Packet Filter) technology. Its primary function is to monitor how long each synchronous I/O syscall takes, providing detailed timing information that can be visualized as flamegraphs. These flamegraphs help developers and system administrators identify performance bottlenecks in I/O operations, making it easier to optimize applications and systems.

=> showcase/ior/image-2.svg ior screenshot

The project is implemented using a combination of Go, C, and BPF, leveraging the `libbpfgo` library to interface with BPF from Go. Unlike its predecessor (which used SystemTap and C), I/O Riot NG offers a more modern and flexible architecture. The tool captures syscall events at the kernel level, processes the timing data in user space, and outputs results suitable for visualization with tools like Inferno Flamegraphs. Its architecture consists of BPF programs for efficient kernel tracing, a Go-based user-space component for data aggregation, and integration with third-party visualization tools. This makes I/O Riot NG a powerful and extensible solution for low-overhead, high-resolution I/O performance analysis on Linux systems.

=> https://codeberg.org/snonux/ior View on Codeberg
=> https://github.com/snonux/ior View on GitHub

---

### gos

* 💻 Languages: Go (99.8%), JSON (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 394
* 📈 Lines of Code: 4102
* 📄 Lines of Documentation: 357
* 📅 Development Period: 2024-05-04 to 2025-09-24
* 🔥 Recent Activity: 146.1 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.2.0 (2025-09-24)


=> showcase/gos/image-1.png gos screenshot

**Gos (Go Social Media)** is a command-line tool written in Go that serves as a self-hosted, scriptable alternative to Buffer.com for scheduling and managing social media posts. Designed for users who prefer automation, privacy, and control, Gos enables posting to Mastodon and LinkedIn (with OAuth2 authentication for LinkedIn) directly from the terminal. It supports features like dry-run mode for safe testing, flexible configuration via flags and environment variables, image previews for LinkedIn, and a pseudo-platform ("Noop") for tracking posts without publishing. Gos is particularly useful for developers, power users, or anyone who wants to automate their social media workflow, avoid third-party service limitations, and integrate posting into their own scripts or shell startup routines.

=> showcase/gos/image-2.png gos screenshot

**Architecturally**, Gos operates on a file-based queueing system: users compose posts as text files (optionally using the companion `gosc` composer tool) in a designated directory. Posts are tagged via filenames or inline tags to control target platforms, priorities, and behaviors (e.g., immediate posting, pausing, or requiring confirmation). When Gos runs, it processes these files, moves them through platform-specific queues, and posts them according to user-defined cadence, priorities, and pause intervals. The configuration is managed via a JSON file storing API credentials and scheduling preferences. Gos also supports generating Gemini Gemtext summaries of posted content for blogging or archival purposes. The system is highly scriptable, easy to integrate into automated workflows, and can be synced or backed up using tools like Syncthing, making it a robust, extensible solution for personal or small-team social media management.

=> https://codeberg.org/snonux/gos View on Codeberg
=> https://github.com/snonux/gos View on GitHub

---

### dtail

* 💻 Languages: Go (93.9%), JSON (2.8%), C (2.0%), Make (0.5%), C/C++ (0.3%), Config (0.2%), Shell (0.2%), Docker (0.1%)
* 📚 Documentation: Text (79.4%), Markdown (20.6%)
* 📊 Commits: 1046
* 📈 Lines of Code: 20091
* 📄 Lines of Documentation: 5674
* 📅 Development Period: 2020-01-09 to 2025-06-20
* 🔥 Recent Activity: 149.7 days (avg. age of last 42 commits)
* ⚖️ License: Apache-2.0
* 🏷️ Latest Release: v4.3.3 (2024-08-23)
* 🤖 AI-Assisted: This project was partially created with the help of generative AI


=> showcase/dtail/image-1.png dtail screenshot

DTail is an open-source distributed log management tool designed for DevOps engineers to efficiently tail, cat, and grep log files across thousands of servers simultaneously. Written in Go, it supports advanced features such as on-the-fly decompression (gzip, zstd) and distributed MapReduce-style aggregations, making it highly useful for large-scale log analysis and troubleshooting in complex environments. By leveraging SSH for secure communication and adhering to UNIX file permission models, DTail ensures both security and compatibility with existing infrastructure.

=> showcase/dtail/image-2.gif dtail screenshot

The architecture consists of a client-server model: DTail servers run on each target machine, while a DTail client—typically on an engineer’s workstation—connects to all servers concurrently to aggregate and process logs in real time. This design enables scalable, parallel log operations and can be extended to a serverless mode for added flexibility. DTail’s implementation emphasizes performance, security, and ease of use, making it a valuable tool for organizations needing to monitor and analyze distributed logs efficiently.

=> https://codeberg.org/snonux/dtail View on Codeberg
=> https://github.com/snonux/dtail View on GitHub

---

### wireguardmeshgenerator

* 💻 Languages: Ruby (73.5%), YAML (26.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 33
* 📈 Lines of Code: 396
* 📄 Lines of Documentation: 24
* 📅 Development Period: 2025-04-18 to 2025-05-11
* 🔥 Recent Activity: 169.0 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.0.0 (2025-05-11)


The **WireGuard Mesh Generator** is a tool designed to automate the creation and deployment of WireGuard VPN configurations for a network of machines, forming a secure mesh network. This is particularly useful for system administrators or DevOps engineers who need to connect multiple servers or nodes (for example, in a Kubernetes cluster) with encrypted, peer-to-peer tunnels, ensuring secure and private communication across potentially untrusted networks.

The project is implemented using Ruby, with tasks managed via Rake, and configuration defined in a YAML file (`wireguardmeshgenerator.yaml`). Key features include automated generation of WireGuard configuration files (`rake generate`), streamlined installation of these files to remote machines (`rake install`), and easy cleanup of generated artifacts (`rake clean`). The architecture leverages WireGuard’s lightweight VPN capabilities and Ruby’s scripting power to simplify and standardize the setup of complex mesh VPN topologies, reducing manual errors and saving time in multi-node deployments.

=> https://codeberg.org/snonux/wireguardmeshgenerator View on Codeberg
=> https://github.com/snonux/wireguardmeshgenerator View on GitHub

---

### ds-sim

* 💻 Languages: Java (98.9%), Shell (0.6%), CSS (0.5%)
* 📚 Documentation: Markdown (98.7%), Text (1.3%)
* 📊 Commits: 438
* 📈 Lines of Code: 25762
* 📄 Lines of Documentation: 3101
* 📅 Development Period: 2008-05-15 to 2025-06-27
* 🔥 Recent Activity: 182.4 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)
* 🤖 AI-Assisted: This project was partially created with the help of generative AI


=> showcase/ds-sim/image-1.png ds-sim screenshot

DS-Sim is an open-source Java-based simulator designed for modeling and experimenting with distributed systems. It provides a robust environment for simulating distributed protocols, handling events, and visualizing system behavior through an interactive Swing GUI. Key features include support for simulating core distributed algorithms (such as Lamport clocks, vector clocks, PingPong, Two-Phase Commit, and Berkeley Time), comprehensive event handling, and detailed logging. DS-Sim is particularly useful for students, educators, and developers who want to learn about or prototype distributed systems concepts in a controlled, observable setting.

Architecturally, DS-Sim is organized into modular components: core process and message handling, an extensible event system, protocol implementations, and a main simulation engine. The project uses Maven for build automation and dependency management, and includes a thorough suite of unit tests and a dedicated protocol simulation testing framework. Users can quickly build and run the simulator via Maven commands, and the project structure is well-documented to support both usage and extension. This modular, test-driven approach makes DS-Sim both a practical teaching tool and a flexible platform for distributed systems research and development.

=> https://codeberg.org/snonux/ds-sim View on Codeberg
=> https://github.com/snonux/ds-sim View on GitHub

---

### sillybench

* 💻 Languages: Go (90.9%), Shell (9.1%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 5
* 📈 Lines of Code: 33
* 📄 Lines of Documentation: 3
* 📅 Development Period: 2025-04-03 to 2025-04-03
* 🔥 Recent Activity: 194.9 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


The **Silly Benchmark** project is a simple benchmarking tool designed to compare the performance of code execution between a native FreeBSD system and a Linux virtual machine running under Bhyve (the FreeBSD hypervisor). Its primary purpose is to provide a straightforward, reproducible way to measure and contrast the computational speed or efficiency of these two environments. This can help users or system administrators understand the performance impact of virtualization and the differences between operating systems when running the same workload.

Implementation-wise, the project likely consists of a small, easily portable program—often written in C or a scripting language—that performs a set of computational tasks or loops, measuring the time taken to complete them. The key features include its simplicity, ease of use, and focus on raw execution speed rather than complex benchmarking scenarios. The architecture is minimal: the benchmark is run natively on FreeBSD and then inside a Linux VM managed by Bhyve, with results compared to highlight any performance discrepancies attributable to the OS or virtualization overhead. This approach is useful for system tuning, hardware evaluation, or making informed decisions about deployment environments.

=> https://codeberg.org/snonux/sillybench View on Codeberg
=> https://github.com/snonux/sillybench View on GitHub

---

### rcm

* 💻 Languages: Ruby (99.8%), TOML (0.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 76
* 📈 Lines of Code: 1373
* 📄 Lines of Documentation: 48
* 📅 Development Period: 2024-12-05 to 2025-02-28
* 🔥 Recent Activity: 235.6 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)


The **rcm** project is a lightweight, personal Ruby-based configuration management system designed with the KISS (Keep It Simple, Stupid) principle in mind. Its primary purpose is to automate and manage configuration tasks, such as setting up services or environments, in a straightforward and minimalistic way. This makes it especially useful for users who want a simple, customizable tool for managing their own system configurations without the overhead and complexity of larger solutions like Ansible or Chef.

Key features include a test suite (run via `rake test`) to ensure reliability, and a task-based invocation system using Rake, Ruby's build automation tool. Users can execute specific configuration tasks (e.g., `rake wireguard -- --debug`) from within a project directory, allowing for modular and scriptable management of services. The architecture leverages Ruby and Rake for task definition and execution, keeping dependencies minimal and the codebase easy to understand and extend for personal workflows.

=> https://codeberg.org/snonux/rcm View on Codeberg
=> https://github.com/snonux/rcm View on GitHub

---

### gemtexter

* 💻 Languages: Shell (68.3%), CSS (28.4%), Config (1.9%), HTML (1.3%)
* 📚 Documentation: Text (76.1%), Markdown (23.9%)
* 📊 Commits: 466
* 📈 Lines of Code: 2285
* 📄 Lines of Documentation: 1180
* 📅 Development Period: 2021-05-21 to 2025-08-31
* 🔥 Recent Activity: 281.0 days (avg. age of last 42 commits)
* ⚖️ License: GPL-3.0
* 🏷️ Latest Release: 3.0.0 (2024-10-01)


**Summary of the Gemtexter Project**

Gemtexter is a static site generator and blog engine designed to manage and publish content written in the Gemini Gemtext format, a lightweight markup language used in the Gemini protocol. Its key feature is the ability to convert Gemtext source files into multiple static output formats—specifically Gemini Gemtext, XHTML (HTML), and Markdown—without relying on JavaScript. This enables the same content to be served across different platforms, including Gemini capsules, traditional web pages, and code hosting services like Codeberg and GitHub Pages. Gemtexter also supports Atom feed generation, source code syntax highlighting, theming, and advanced templating, making it a versatile tool for technical bloggers and those interested in multi-platform publishing.

The project is implemented as a large Bash script, leveraging standard GNU utilities (sed, grep, date, etc.) for text processing and file management. Content is organized in a configurable directory structure, with separate folders for each output format. The script automates tasks such as content conversion, Atom feed updates, and Git integration for version control and deployment. Advanced features include content filtering for selective regeneration, customizable themes, Bash-based templating for dynamic content generation, and support for source code highlighting via GNU Source Highlight. Configuration is flexible, supporting both local and user-specific config files, and the system is designed to be extensible and maintainable despite being written in Bash. This architecture makes Gemtexter particularly useful for users who value simplicity, transparency, and control over their publishing workflow, especially in environments where minimalism and static content are preferred.

=> https://codeberg.org/snonux/gemtexter View on Codeberg
=> https://github.com/snonux/gemtexter View on GitHub

---

### quicklogger

* 💻 Languages: Go (96.1%), XML (1.9%), Shell (1.2%), TOML (0.7%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 35
* 📈 Lines of Code: 1133
* 📄 Lines of Documentation: 78
* 📅 Development Period: 2024-01-20 to 2025-09-13
* 🔥 Recent Activity: 501.6 days (avg. age of last 42 commits)
* ⚖️ License: MIT
* 🏷️ Latest Release: v0.0.4 (2025-09-13)


=> showcase/quicklogger/image-1.png quicklogger screenshot

Quick Logger is a lightweight graphical application designed for quickly capturing and saving ideas or notes as plain text files, primarily targeting Android devices but also runnable on Linux desktops. Built with the Go programming language and the Fyne GUI framework, the app provides a simple interface where users can enter a message, which is then saved to a designated folder. This folder can be synchronized across devices using tools like Syncthing, ensuring that notes taken on a mobile device are automatically available on a home computer.

=> showcase/quicklogger/image-2.png quicklogger screenshot

The project’s key features include its minimalistic design, cross-platform compatibility (Android and Linux), and seamless integration with file synchronization workflows. Architecturally, Quick Logger leverages Fyne for its user interface, enabling a consistent look and feel across platforms, and uses Go’s standard library for file operations. The build process supports both direct compilation and containerized cross-compilation (using fyne-cross and Podman/Docker), making it accessible to developers on different systems. This combination of simplicity, portability, and easy synchronization makes Quick Logger a practical tool for quickly jotting down ideas on the go.

=> https://codeberg.org/snonux/quicklogger View on Codeberg
=> https://github.com/snonux/quicklogger View on GitHub

---

### docker-radicale-server

* 💻 Languages: Make (57.5%), Docker (42.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 5
* 📈 Lines of Code: 40
* 📄 Lines of Documentation: 3
* 📅 Development Period: 2023-12-31 to 2025-08-11
* 🔥 Recent Activity: 535.2 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


This project provides a Docker image for the [Radicale server](https://radicale.org), an open-source CalDAV and CardDAV server for managing calendars and contacts. By containerizing Radicale, the project makes it easy to deploy and run the server in isolated, reproducible environments, ensuring consistent behavior across different systems. This is particularly useful for users who want to quickly set up personal or small-team calendar/contact synchronization without complex installation steps or dependency management.

The Docker image is typically implemented using a `Dockerfile` that installs Radicale and its dependencies into a minimal base image, exposes the necessary ports, and defines configuration options via environment variables or mounted volumes. Key features include ease of deployment, portability, and simplified updates—users can start a Radicale server with a single `docker run` command, mount their data/configuration for persistence, and benefit from Docker’s security and resource isolation. The architecture leverages Docker’s containerization to encapsulate Radicale, making it suitable for both development and production use.

=> https://codeberg.org/snonux/docker-radicale-server View on Codeberg
=> https://github.com/snonux/docker-radicale-server View on GitHub

---

### terraform

* 💻 Languages: HCL (96.6%), Make (1.9%), YAML (1.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 125
* 📈 Lines of Code: 2851
* 📄 Lines of Documentation: 52
* 📅 Development Period: 2023-08-27 to 2025-08-08
* 🔥 Recent Activity: 571.4 days (avg. age of last 42 commits)
* ⚖️ License: MIT
* 🧪 Status: Experimental (no releases yet)


This project is a Terraform-based infrastructure-as-code setup designed to automate the deployment and management of a cloud environment on AWS. Its primary goal is to provision and configure core AWS resources—such as VPCs, subnets, EFS (Elastic File System), ECS (Elastic Container Service) with Fargate, and Application Load Balancers—while also integrating essential operational features like CloudWatch monitoring and EFS backups. The project is modular, with separate Terraform modules or directories (e.g., `org-buetow-base`, `org-buetow-bastion`, `org-buetow-elb`, `org-buetow-ecs`) handling different aspects of the infrastructure, promoting reusability and maintainability.

Key features include the ability to specify which ECS services to deploy, automated creation of networking and storage resources, and integration with AWS Secrets Manager for secure credential handling. Some steps, such as creating DNS zones, TLS certificates, and certain EFS subdirectories, are performed manually to ensure security and compliance with organizational policies. The architecture leverages a bastion host for secure EFS management, and uses AWS-native services for high availability and scalability. CloudWatch monitoring with email alerts (planned) will enhance operational visibility. Overall, this project streamlines the deployment of containerized applications on AWS, making it easier to manage complex environments with infrastructure as code.

=> https://codeberg.org/snonux/terraform View on Codeberg
=> https://github.com/snonux/terraform View on GitHub

---

### gogios

* 💻 Languages: Go (94.4%), YAML (3.4%), JSON (2.2%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 77
* 📈 Lines of Code: 1096
* 📄 Lines of Documentation: 287
* 📅 Development Period: 2023-04-17 to 2025-06-12
* 🔥 Recent Activity: 612.3 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.1.0 (2024-05-03)
* 🤖 AI-Assisted: This project was partially created with the help of generative AI


=> showcase/gogios/image-1.png gogios screenshot

Gogios is a lightweight, minimalistic server monitoring tool designed for small-scale, self-hosted environments—such as personal servers or a handful of virtual machines—where simplicity and low resource usage are priorities. Unlike more complex solutions like Nagios or Prometheus, Gogios focuses on essential monitoring: it periodically runs standard Nagios/Icinga-compatible plugins to check system health and sends concise email notifications when the status of any monitored service changes. This makes it ideal for users who want straightforward, email-based alerts without the overhead of web interfaces, databases, or advanced clustering features.

Architecturally, Gogios is implemented in Go for efficiency and ease of deployment. It uses a JSON configuration file to define which checks to run, their dependencies, retry logic, and notification settings. Checks are executed as external scripts (Nagios plugins), and results are tracked in a persistent state file to ensure notifications are only sent on status changes. Email notifications are handled via a local Mail Transfer Agent (MTA), and the tool is typically run as a scheduled CRON job under a dedicated system user for security. High-availability can be achieved by deploying Gogios on multiple servers with staggered schedules, though this results in duplicate notifications by design. Overall, Gogios is useful for users seeking a no-frills, reliable monitoring solution that is easy to install, configure, and maintain for small infrastructures.

=> https://codeberg.org/snonux/gogios View on Codeberg
=> https://github.com/snonux/gogios View on GitHub

---

### gorum

* 💻 Languages: Go (91.3%), JSON (6.4%), YAML (2.3%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 82
* 📈 Lines of Code: 1525
* 📄 Lines of Documentation: 15
* 📅 Development Period: 2023-04-17 to 2023-11-19
* 🔥 Recent Activity: 798.3 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

Gorum is a minimalistic quorum manager designed to coordinate and manage quorum-based operations, typically used in distributed systems to ensure consensus and reliability. Its primary function is to oversee the execution of checks or tasks across multiple nodes, ensuring that a specified minimum number (a quorum) agree or complete the task before proceeding. This is particularly useful in scenarios where fault tolerance and consistency are critical, such as distributed databases or clustered services.

The project is still under development, but its planned features include remote execution control—allowing users to trigger and monitor quorum checks on remote systems. The architecture is likely lightweight, focusing on simplicity and ease of integration rather than complex orchestration. Key features will revolve around managing quorum thresholds, tracking node responses, and providing a minimal interface for triggering and observing quorum checks. This approach makes Gorum useful for developers and operators who need a straightforward tool to add quorum-based decision-making to their distributed applications or infrastructure.

=> https://codeberg.org/snonux/gorum View on Codeberg
=> https://github.com/snonux/gorum View on GitHub

---

### randomjournalpage

* 💻 Languages: Shell (94.1%), Make (5.9%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 8
* 📈 Lines of Code: 51
* 📄 Lines of Documentation: 26
* 📅 Development Period: 2022-06-02 to 2024-04-20
* 🔥 Recent Activity: 863.1 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

This project is a personal script designed to help the user revisit past thoughts and ideas by randomly selecting and displaying pages from their collection of scanned bullet journal PDFs. By running the script, the user can reflect on previous journal entries, book notes, and spontaneous ideas, fostering self-reflection and inspiration. The script automates the process of choosing a random journal file and a random set of pages within it, making the experience effortless and serendipitous.

The implementation relies on standard Linux utilities: `qpdf` for manipulating PDF files and `pdfinfo` (from `poppler-utils`) for extracting metadata such as page counts. The user configures the script with the path to their journal PDFs and their preferred PDF viewer. When executed, the script randomly selects a PDF and extracts a random range of pages, which are then opened for viewing. The architecture is intentionally simple, leveraging shell scripting for automation and requiring minimal setup, making it a lightweight and practical tool for personal knowledge management.

=> https://codeberg.org/snonux/randomjournalpage View on Codeberg
=> https://github.com/snonux/randomjournalpage View on GitHub

---

### sway-autorotate

* 💻 Languages: Shell (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 8
* 📈 Lines of Code: 41
* 📄 Lines of Documentation: 17
* 📅 Development Period: 2020-01-30 to 2025-04-30
* 🔥 Recent Activity: 1156.6 days (avg. age of last 42 commits)
* ⚖️ License: GPL-3.0
* 🧪 Status: Experimental (no releases yet)


**sway-autorotate** is a Bash script designed to automatically rotate the display orientation in the Sway window manager, particularly useful for convertible laptops and tablets like the Microsoft Surface Go 2 running Fedora Linux. The script listens for orientation changes from the device's built-in sensors (using the `monitor-sensor` command from the `iio-sensor-proxy` package) and then issues commands to Sway to rotate both the screen and relevant input devices accordingly. This ensures that the display and touch input remain aligned with the physical orientation of the device, providing a seamless experience when switching between portrait and landscape modes.

The script is implemented by piping the output of `monitor-sensor` into `autorotate.sh`, which parses sensor events and uses `swaymsg` to adjust the display and input device orientations. The devices to be rotated are specified in the `WAYLANDINPUT` array, which can be populated by querying available input devices with `swaymsg -t get_inputs`. This approach leverages existing Linux utilities and Sway's IPC interface, making it lightweight and easily adaptable to different hardware setups. The project is particularly useful for users who need automatic screen rotation on devices running Sway, where such functionality is not provided out-of-the-box.

=> https://codeberg.org/snonux/sway-autorotate View on Codeberg
=> https://github.com/snonux/sway-autorotate View on GitHub

---

### photoalbum

* 💻 Languages: Shell (80.1%), Make (12.3%), Config (7.6%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 153
* 📈 Lines of Code: 342
* 📄 Lines of Documentation: 39
* 📅 Development Period: 2011-11-19 to 2022-04-02
* 🔥 Recent Activity: 1376.2 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.5.0 (2022-02-21)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**Summary:**  
The `photoalbum` project is a minimal Bash script designed for Linux systems to automate the creation of static web photo albums. Its primary function is to take a collection of images from a specified directory, process them, and generate a ready-to-deploy static website that displays these photos in an organized album format. This tool is particularly useful for users who want a simple, dependency-light way to publish photo galleries online without relying on complex web frameworks or dynamic content management systems.

**Key Features & Architecture:**  
`photoalbum` operates through a set of straightforward commands: `generate` (to build the album), `clean` (to remove temporary files), `version` (to display version info), and `makemake` (to set up configuration files and a Makefile). Configuration is handled via a customizable rcfile, allowing users to tailor settings such as source and output directories. The script uses HTML templates, which can be edited for custom album layouts. The workflow involves copying images to an "incoming" folder, running the `generate` command to create the album in a `dist` directory, and optionally cleaning up with `clean`. Its minimalist Bash implementation ensures ease of use, transparency, and compatibility with most Linux environments, making it ideal for users seeking a lightweight, easily customizable static photo album generator.

=> https://codeberg.org/snonux/photoalbum View on Codeberg
=> https://github.com/snonux/photoalbum View on GitHub

---

### geheim

* 💻 Languages: Ruby (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 67
* 📈 Lines of Code: 671
* 📄 Lines of Documentation: 26
* 📅 Development Period: 2018-05-26 to 2025-09-04
* 🔥 Recent Activity: 1471.0 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)


**Summary of the Project:**

The `geheim.rb` project is a Ruby-based tool designed for secure encryption and management of text and binary documents. It leverages the AES-256-CBC encryption algorithm, with initialization vectors derived from a user-supplied PIN, ensuring strong cryptographic protection. The tool is cross-platform, running on macOS, Linux, and Android (via Termux), and is particularly suited for handling smaller files such as text documents and PDFs. A key feature is its integration with Git: all encrypted files and their (also encrypted) filenames are stored in a Git repository, allowing users to version, backup, and synchronize their secure data across multiple remote locations for redundancy.

**Key Features and Architecture:**

The architecture centers around a local Git repository that acts as the secure storage backend. File encryption and decryption are handled by the Ruby script, which also manages encrypted indices for filenames, making it possible to search for documents using `fzf`, a fuzzy finder tool. Editing is streamlined through NeoVim, with safety measures like disabled caching and swapping to prevent data leaks. The script supports clipboard operations on macOS and GNOME, provides an interactive shell for user commands, and includes batch import/export as well as secure shredding of exported data. This combination of strong encryption, Git-based storage, and user-friendly search and editing makes `geheim.rb` a practical solution for individuals seeking portable, encrypted document management with robust redundancy and usability features.

=> https://codeberg.org/snonux/geheim View on Codeberg
=> https://github.com/snonux/geheim View on GitHub

---

### algorithms

* 💻 Languages: Go (99.2%), Make (0.8%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 82
* 📈 Lines of Code: 1728
* 📄 Lines of Documentation: 18
* 📅 Development Period: 2020-07-12 to 2023-04-09
* 🔥 Recent Activity: 1527.4 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

This project is a collection of exercises and implementations based on an Algorithms lecture, designed primarily as a refresher for key algorithmic concepts. It provides a hands-on environment for practicing and reinforcing understanding of fundamental algorithms, such as sorting, searching, and possibly data structures, through practical coding exercises. The project is structured to facilitate both learning and assessment, featuring built-in unit tests to verify correctness and benchmarking tools to evaluate performance.

Key features include a modular codebase where each algorithm or exercise is likely implemented in its own file or module, making it easy to navigate and extend. The use of Makefile commands (make test and make bench) streamlines the workflow: make test runs automated unit tests to ensure the algorithms work as expected, while make bench executes performance benchmarks to compare efficiency. This architecture supports iterative development and experimentation, making the project useful for students, educators, or anyone looking to refresh their algorithm skills in a practical, test-driven manner.

=> https://codeberg.org/snonux/algorithms View on Codeberg
=> https://github.com/snonux/algorithms View on GitHub

---

### perl-c-fibonacci

* 💻 Languages: C (80.4%), Make (19.6%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 4
* 📈 Lines of Code: 51
* 📄 Lines of Documentation: 69
* 📅 Development Period: 2014-03-24 to 2022-04-23
* 🔥 Recent Activity: 2008.3 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

perl-c-fibonacci: source code repository.

=> https://codeberg.org/snonux/perl-c-fibonacci View on Codeberg
=> https://github.com/snonux/perl-c-fibonacci View on GitHub

---

### guprecords

* 💻 Languages: Raku (100.0%)
* 📊 Commits: 95
* 📈 Lines of Code: 195
* 📅 Development Period: 2013-03-22 to 2023-03-09
* 🔥 Recent Activity: 2223.4 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: v1.0.0 (2023-04-29)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

`guprecords` is a command-line tool written in Raku that generates comprehensive uptime reports for multiple hosts by aggregating and analyzing raw record files produced by the `uptimed` daemon. Its primary purpose is to provide system administrators and enthusiasts with detailed, customizable statistics on system reliability and availability across a fleet of machines. By supporting various categories (such as Host, Kernel, KernelMajor, and KernelName) and metrics (including Boots, Uptime, Score, Downtime, and Lifespan), `guprecords` enables users to identify trends, compare system stability, and track performance over time. Reports can be output in plaintext, Markdown, or Gemtext formats, making them suitable for different documentation or publishing needs.

The architecture of `guprecords` is modular, with classes dedicated to parsing epoch data, aggregating statistics, and formatting output. The tool reads uptime record files collected from multiple hosts (typically centralized via a git repository), processes them to compute the desired metrics, and generates ranked tables highlighting top performers or outliers. Users can tailor reports using command-line options to select categories, metrics, output formats, and entry limits. The design emphasizes flexibility and extensibility, allowing for easy integration into existing monitoring workflows. While `guprecords` does not handle the collection of raw data itself, it complements existing `uptimed` deployments by transforming raw uptime logs into actionable insights and historical records.

=> https://codeberg.org/snonux/guprecords View on Codeberg
=> https://github.com/snonux/guprecords View on GitHub

---

### ioriot

* 💻 Languages: C (55.5%), C/C++ (24.0%), Config (19.6%), Make (1.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 50
* 📈 Lines of Code: 12420
* 📄 Lines of Documentation: 610
* 📅 Development Period: 2018-03-01 to 2020-01-22
* 🔥 Recent Activity: 2549.8 days (avg. age of last 42 commits)
* ⚖️ License: Apache-2.0
* 🏷️ Latest Release: 0.5.1 (2019-01-04)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

=> showcase/ioriot/image-1.png ioriot screenshot

**I/O Riot** is a Linux-based I/O benchmarking tool designed to capture real I/O operations from a production server and replay them on a test machine. Unlike traditional benchmarking tools that use synthetic workloads, I/O Riot records actual I/O activity—including file reads, writes, and metadata operations—over a specified period. This captured workload can then be replayed in a controlled environment, allowing users to analyze system and hardware performance, identify bottlenecks, and experiment with different OS or hardware configurations to optimize I/O performance.

The tool operates in five main steps: capturing I/O on the production server, transferring the log to a test machine, initializing the test environment, replaying the I/O while monitoring system metrics, and iteratively adjusting system parameters for further testing. I/O Riot leverages SystemTap and kernel-level tracing for efficient, low-overhead data capture, and replays I/O using a C-based tool for minimal performance impact. Its architecture supports a wide range of file systems (ext2/3/4, xfs) and syscalls, making it flexible for various Linux environments. Key features include the ability to modify or synthesize I/O logs, test new hardware or OS settings, and analyze real-world application behavior without altering application code, making it a powerful tool for performance tuning and cost optimization in production-like scenarios.

=> https://codeberg.org/snonux/ioriot View on Codeberg
=> https://github.com/snonux/ioriot View on GitHub

---

### staticfarm-apache-handlers

* 💻 Languages: Perl (96.4%), Make (3.6%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 3
* 📈 Lines of Code: 919
* 📄 Lines of Documentation: 12
* 📅 Development Period: 2015-01-02 to 2021-11-04
* 🔥 Recent Activity: 3058.6 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.1.3 (2015-01-02)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

The **staticfarm-apache-handlers** project provides a set of custom handlers written for use with Apache2's mod_perl2 module. These handlers are designed to be easily integrated into an Apache2 web server, allowing developers to extend or customize the server's behavior using Perl code. The primary utility of this project lies in its ability to leverage the power and flexibility of Perl within the Apache2 environment, enabling advanced request handling, dynamic content generation, or specialized logging and authentication mechanisms that go beyond standard Apache modules.

In terms of implementation, the project consists of Perl modules that conform to the mod_perl2 handler API. These modules are loaded by Apache2 via its configuration files, typically using the `PerlModule` and `PerlHandler` directives. Once integrated, the handlers can intercept and process HTTP requests at various stages of the request lifecycle, providing hooks for custom logic. The architecture is modular, allowing users to include only the handlers they need, and it takes advantage of the tight integration between Perl and Apache2 offered by mod_perl2 for high performance and flexibility. This makes **staticfarm-apache-handlers** particularly useful for Perl-centric web environments requiring custom server-side logic.

=> https://codeberg.org/snonux/staticfarm-apache-handlers View on Codeberg
=> https://github.com/snonux/staticfarm-apache-handlers View on GitHub

---

### dyndns

* 💻 Languages: Shell (100.0%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 3
* 📈 Lines of Code: 18
* 📄 Lines of Documentation: 49
* 📅 Development Period: 2014-03-24 to 2021-11-05
* 🔥 Recent Activity: 3294.4 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

This project is a **Dynamic DNS (DynDNS) updater** designed to automatically update DNS records (such as A records) on a BIND DNS server when a client's IP address changes—common for hosts with dynamic IPs. It enables a remote client (the DynDNS client) to securely update its DNS entry on the server via SSH, using the `nsupdate` tool and key-based authentication, ensuring that the domain always points to the correct, current IP address.

**Key features and architecture:**  
- **Security:** Uses a dedicated `dyndns` user and SSH key-based authentication to allow passwordless, secure updates from the client to the server.
- **Automation:** The client triggers the update script (e.g., from a PPP link-up event) to call the server-side script with the new IP, record type, and timeout.
- **Integration with BIND:** Relies on BIND's `nsupdate` utility and TSIG keys for authenticated DNS updates.
- **Logging:** Maintains a log file for update tracking.
- **Implementation:** The architecture consists of a client-side trigger (e.g., via PPP or a cron job) that SSHes into the server as the `dyndns` user, running a script that updates the DNS zone using `nsupdate` with the provided parameters.

This setup is useful for anyone running their own DNS server who needs to keep DNS records current for hosts with changing IP addresses, such as home servers or remote devices, without relying on third-party DynDNS providers.

=> https://codeberg.org/snonux/dyndns View on Codeberg
=> https://github.com/snonux/dyndns View on GitHub

---

### mon

* 💻 Languages: Perl (96.5%), Shell (1.8%), Make (1.2%), Config (0.4%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 7
* 📈 Lines of Code: 5360
* 📄 Lines of Documentation: 789
* 📅 Development Period: 2015-01-02 to 2021-11-05
* 🔥 Recent Activity: 3561.1 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.0.1 (2015-01-02)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**Summary of the "mon" Project**

The "mon" tool is a command-line monitoring API client designed to interact with the [RESTlos](https://github.com/Crapworks/RESTlos) monitoring backend. It provides a flexible and scriptable interface for querying, editing, and managing monitoring objects (such as hosts, contacts, and services) via RESTful API calls. "mon" is particularly useful for system administrators and DevOps engineers who need to automate monitoring configuration, perform bulk updates, or integrate monitoring management into scripts and CI/CD pipelines. Its concise command syntax, support for interactive and batch modes, and ability to output and manipulate JSON make it a powerful alternative to manual web UI operations.

**Key Features and Architecture**

"mon" is implemented as a Perl-based CLI tool with a modular architecture. It reads configuration from layered config files and environment variables, supporting overrides via command-line options for maximum flexibility. The tool supports a wide range of operations, including querying (get, view), editing (edit, update), inserting, deleting, and validating monitoring objects, with advanced filtering using operators like `like`, `eq`, and regex `matches`. It can operate in interactive mode, supports colored output, syslog integration, and automatic JSON backups with retention policies. The architecture cleanly separates concerns: API communication, configuration management, command parsing, and output formatting. "mon" is extensible, script-friendly (with predictable JSON output to STDOUT), and includes features like shell auto-completion (for ZSH), error tracking for automation (e.g., with Puppet), and robust backup/restore mechanisms for safe configuration changes.

=> https://codeberg.org/snonux/mon View on Codeberg
=> https://github.com/snonux/mon View on GitHub

---

### rubyfy

* 💻 Languages: Ruby (98.5%), JSON (1.5%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 34
* 📈 Lines of Code: 273
* 📄 Lines of Documentation: 32
* 📅 Development Period: 2015-09-29 to 2021-11-05
* 🔥 Recent Activity: 3565.3 days (avg. age of last 42 commits)
* ⚖️ License: Apache-2.0
* 🏷️ Latest Release: 0 (2015-10-26)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**Rubyfy** is a command-line tool designed to execute shell commands on multiple remote servers over SSH, streamlining administrative tasks across large server fleets. Its primary utility lies in automating repetitive or bulk operations—such as running scripts, gathering system information, or performing maintenance—by allowing users to specify commands and target hosts, then executing those commands in parallel, optionally with elevated privileges or background execution.

The tool is implemented as a Ruby script (`rubyfy.rb`) and leverages Ruby's standard libraries to manage SSH connections and parallel execution. Key features include:  
- **Parallel execution**: Users can specify how many servers to target simultaneously, improving efficiency for large-scale operations.  
- **Privilege escalation**: Commands can be run as root via `sudo`.  
- **Background execution**: Long-running scripts can be dispatched without waiting for completion.  
- **Precondition checks**: Commands can be conditionally executed based on the presence or absence of files on the remote server.  
- **Flexible input/output**: Hosts can be provided via standard input, and output can be redirected to files for later review.  
The architecture is simple but effective: it reads a list of servers, establishes SSH sessions, and loops through the list to execute the specified command(s), handling parallelism and options as directed by the user. This makes Rubyfy a lightweight yet powerful tool for sysadmins managing multiple Unix-like systems.

=> https://codeberg.org/snonux/rubyfy View on Codeberg
=> https://github.com/snonux/rubyfy View on GitHub

---

### pingdomfetch

* 💻 Languages: Perl (97.3%), Make (2.7%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 9
* 📈 Lines of Code: 1839
* 📄 Lines of Documentation: 412
* 📅 Development Period: 2015-01-02 to 2021-11-05
* 🔥 Recent Activity: 3644.9 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.0.2 (2015-01-02)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**Summary of the Project:**

**pingdomfetch** is a command-line tool designed to retrieve availability statistics from the Pingdom monitoring service and send notifications via email based on configurable thresholds. Its primary use is to automate the collection and reporting of uptime data for multiple monitored services, making it easier for system administrators and DevOps teams to track service health and respond to outages or performance issues. Unlike Pingdom’s built-in notifications, pingdomfetch allows for custom aggregation of services into "top level services" (TLS), enabling users to group related checks and calculate average availability across them, with support for weighted importance and individualized warning thresholds.

**Implementation and Architecture:**

pingdomfetch is implemented as a script that reads configuration files from standard locations (e.g., `/etc/pingdomfetch.conf`, `~/.pingdomfetch.conf`, and directory-based configs for TLS definitions). The configuration supports both global and per-service options, such as custom weights and warning levels. The tool interacts with the Pingdom API to fetch availability data for specified time intervals and services, aggregates results as needed, and formats notifications. It supports a variety of command-line options for flexible operation, including listing services, fetching stats for specific periods or groups, and controlling notification behavior (e.g., dry-run, info-only, or actual email sending). The architecture is modular, allowing extension for additional processing or notification methods, and is designed for easy integration into automated monitoring workflows.

=> https://codeberg.org/snonux/pingdomfetch View on Codeberg
=> https://github.com/snonux/pingdomfetch View on GitHub

---

### gotop

* 💻 Languages: Go (98.0%), Make (2.0%)
* 📚 Documentation: Markdown (50.0%), Text (50.0%)
* 📊 Commits: 57
* 📈 Lines of Code: 499
* 📄 Lines of Documentation: 8
* 📅 Development Period: 2015-05-24 to 2021-11-03
* 🔥 Recent Activity: 3655.6 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.1 (2015-06-01)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

gotop is a command-line utility written in Go that serves as a modern replacement for iotop on Linux systems. Its primary function is to monitor and display real-time disk I/O usage by processes, helping users identify which applications are consuming the most disk bandwidth. This is particularly useful for system administrators and developers who need to diagnose performance bottlenecks or monitor resource usage on servers and workstations.

The tool is implemented in Go, which offers advantages in terms of performance, portability, and ease of installation compared to traditional Python-based tools like iotop. gotop typically features a terminal-based, interactive interface that presents sortable tables of processes, showing metrics such as read/write speeds and total I/O. Its architecture leverages Linux kernel interfaces (such as /proc and /sys filesystems) to gather accurate, up-to-date statistics without significant overhead. Key features often include filtering, sorting, and color-coded output, making it both powerful and user-friendly for real-time system monitoring.

=> https://codeberg.org/snonux/gotop View on Codeberg
=> https://github.com/snonux/gotop View on GitHub

---

### xerl

* 💻 Languages: Perl (98.3%), Config (1.2%), Make (0.5%)
* 📊 Commits: 670
* 📈 Lines of Code: 1675
* 📅 Development Period: 2011-03-06 to 2018-12-22
* 🔥 Recent Activity: 3711.3 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.0.0 (2018-12-22)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

This project establishes a Perl coding style guide and best practices framework, particularly tailored for teams working on modular, object-oriented Perl applications. It enforces the use of strict and warnings pragmas, modern Perl features (v5.14+), and a consistent object-oriented approach with explicit method prototypes and object typing. The guide also standardizes naming conventions for public, private, static, and static-private methods, ensuring code clarity and maintainability. Additionally, it integrates tools like Pidy for automatic code formatting and provides mechanisms (like TODO: tags) for tracking unfinished work.

The implementation is primarily documentation-driven, meant to be included at the top of Perl modules and packages. Developers are instructed to use specific base classes (e.g., Xerl::Page::Base for universal definitions), follow explicit method signatures, and adhere to naming conventions that distinguish between method types and visibility. The architecture encourages encapsulation (private methods prefixed with _), explicit return values (including undef when appropriate), and modular design. This approach is useful because it reduces ambiguity, streamlines onboarding for new developers, and helps maintain a high standard of code quality across large Perl codebases.

=> https://codeberg.org/snonux/xerl View on Codeberg
=> https://github.com/snonux/xerl View on GitHub

---

### debroid

* 💻 Languages: Shell (92.0%), Make (8.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 16
* 📈 Lines of Code: 88
* 📄 Lines of Documentation: 148
* 📅 Development Period: 2015-06-18 to 2015-12-05
* 🔥 Recent Activity: 3759.4 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

=> showcase/debroid/image-1.png debroid screenshot

**Debroid** is a project that enables users to install and run a full Debian GNU/Linux environment (using chroot) on an LG G3 D855 smartphone running CyanogenMod 13 (Android 6). By leveraging root access and developer mode, Debroid allows advanced users to prepare a Debian Jessie base image on a Linux PC, transfer it to the phone’s SD card, and then mount and chroot into it from Android. This setup provides a powerful Linux userland alongside Android, making it possible to use standard Debian tools, install packages, and even run services, all from within the Android device.

The implementation involves several key steps: first, a Debian image is created using debootstrap on a Linux PC, formatted, and compressed for transfer. The image is then copied to the phone, decompressed, and mounted as a loop device. Essential Android and Linux filesystems (like /proc, /dev, /sys, and storage) are bind-mounted into the chroot environment to ensure compatibility. The second stage of debootstrap is completed inside the chroot on the phone, finalizing the Debian installation. Custom scripts are used to automate entering the chroot and starting services, and integration with Android’s startup sequence allows Debian to launch automatically. This architecture provides a flexible, portable Linux system on Android hardware, useful for development, experimentation, or running Linux-specific applications that aren’t available on Android.

=> https://codeberg.org/snonux/debroid View on Codeberg
=> https://github.com/snonux/debroid View on GitHub

---

### fapi

* 💻 Languages: Python (96.6%), Make (3.1%), Config (0.3%)
* 📚 Documentation: Text (98.3%), Markdown (1.7%)
* 📊 Commits: 219
* 📈 Lines of Code: 1681
* 📄 Lines of Documentation: 539
* 📅 Development Period: 2014-03-10 to 2021-11-03
* 🔥 Recent Activity: 4037.4 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.0.2 (2014-11-17)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**Summary:**

The `fapi` project is a command-line tool designed to simplify the management of F5 BigIP load balancers by providing an easy-to-use interface for interacting with the F5 iControl API. It allows administrators to perform essential tasks such as managing monitors, nodes, pools, and virtual servers, as well as more advanced operations like handling folders, self IPs, traffic groups, and VLANs. This tool is particularly useful for system administrators who prefer automation and scripting over manual configuration through the F5 web interface, streamlining repetitive or complex tasks and enabling rapid deployment and management of load balancer resources.

**Key Features and Architecture:**

`fapi` is implemented as a Python script that relies on the `bigsuds` library to communicate with the F5 iControl API. The tool is designed for Unix-like environments (tested on Debian Wheezy) and can be installed via package manager or from source. Its architecture is modular, mapping high-level commands (like `fapi node`, `fapi pool`, `fapi vserver`) to corresponding API calls, with intelligent parsing of object names and parameters (supporting hostnames, FQDNs, and IP:port formats). The tool automates common workflows such as creating nodes, pools, and virtual servers, attaching monitors, configuring VLANs, and managing SSL profiles, making it a practical solution for efficient and scriptable F5 load balancer administration.

=> https://codeberg.org/snonux/fapi View on Codeberg
=> https://github.com/snonux/fapi View on GitHub

---

### template

* 💻 Languages: Make (89.2%), Shell (10.8%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 22
* 📈 Lines of Code: 65
* 📄 Lines of Documentation: 228
* 📅 Development Period: 2013-03-22 to 2021-11-04
* 🔥 Recent Activity: 4091.8 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.0.0.0 (2013-03-22)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

This project is a template designed to help developers quickly create Debian packages for their own software projects. It provides a minimal, customizable structure that includes all the necessary files, scripts, and instructions to build, test, and package an application for Debian-based systems. The template is especially useful because it streamlines the often-complex process of Debian packaging, making it accessible even for those who are new to the process. By following the provided steps, users can install required dependencies, compile their project, generate a Debian package, and test the installation—all with clear, reproducible commands.

Key features of the template include a Makefile that automates compilation and packaging tasks, integration with standard Debian packaging tools (like `lintian`, `dpkg-dev`, and `devscripts`), and support for generating manual pages from POD documentation. The architecture is modular and intended for easy customization: users are encouraged to rename files, update documentation, and modify build rules to fit their own project’s needs. The template also demonstrates best practices for Debian packaging, such as maintaining a changelog and editing package metadata. Overall, this project serves as a practical starting point for developers aiming to distribute their software in the Debian ecosystem.

=> https://codeberg.org/snonux/template View on Codeberg
=> https://github.com/snonux/template View on GitHub

---

### muttdelay

* 💻 Languages: Make (47.1%), Shell (46.3%), Vim Script (5.9%), Config (0.7%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 41
* 📈 Lines of Code: 136
* 📄 Lines of Documentation: 96
* 📅 Development Period: 2013-03-22 to 2021-11-05
* 🔥 Recent Activity: 4104.8 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.2.0 (2014-07-05)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**Summary of muttdelay Project**

The `muttdelay` project is a Bash script designed to enable scheduled email sending for users of the Mutt email client. Unlike simply postponing a draft, `muttdelay` allows users to specify an exact future time for an email to be sent. This is particularly useful for situations where you want to compose an email now but have it delivered later—such as sending reminders, timed announcements, or messages that should arrive during business hours.

**Key Features and Architecture**

The core functionality is implemented through a combination of Vim integration, cron jobs, and file-based scheduling. After composing an email in Mutt using Vim, the user triggers the scheduling process with a custom Vim command (`,L`), which saves the email and its intended send time to a special directory (`~/.muttdelay/`). Each scheduled email is stored as a file named with its send timestamp. An hourly cron job then checks this directory and sends any emails whose scheduled time has arrived, using Mutt's command-line interface. This architecture leverages standard Unix tools and user workflows, making it lightweight, easy to configure, and highly compatible with existing setups.

=> https://codeberg.org/snonux/muttdelay View on Codeberg
=> https://github.com/snonux/muttdelay View on GitHub

---

### netdiff

* 💻 Languages: Shell (52.2%), Make (46.3%), Config (1.5%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 42
* 📈 Lines of Code: 134
* 📄 Lines of Documentation: 106
* 📅 Development Period: 2013-03-22 to 2021-11-05
* 🔥 Recent Activity: 4112.3 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.1.5 (2014-06-22)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**Summary of the netdiff Project:**

netdiff is a command-line utility designed to compare files or directories between two remote hosts over a network. Its primary function is to identify differences in specified paths (such as configuration directories) between systems, which is especially useful for system administrators managing clusters or ensuring consistency across servers. For example, netdiff can quickly highlight discrepancies in complex configuration directories like `/etc/pam.d`, which are otherwise tedious to compare manually.

The tool operates by having users simultaneously run the same command on both hosts, specifying the counterpart's hostname and the path to compare. netdiff automatically determines whether it should act as a client or server based on the hostname provided. It securely transfers the target files or directories (recursively, using OpenSSL/AES encryption) between the hosts, then uses the standard `diff` tool to compute and display differences. Configuration options such as the network port are customizable via a system-wide config file. The architecture is simple yet effective: it leverages secure file transfer, automatic role assignment, and familiar diffing tools to streamline cross-host file comparison.

=> https://codeberg.org/snonux/netdiff View on Codeberg
=> https://github.com/snonux/netdiff View on GitHub

---

### japi

* 💻 Languages: Perl (78.3%), Make (21.7%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 41
* 📈 Lines of Code: 286
* 📄 Lines of Documentation: 144
* 📅 Development Period: 2013-03-22 to 2021-11-05
* 🔥 Recent Activity: 4160.6 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.4.3 (2014-06-16)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**Summary of the "japi" Project:**

"japi" is a lightweight command-line tool designed to interact with Jira, specifically to fetch the latest unresolved and unclosed tickets from a specified Jira project. Its primary use case is to provide users—either manually or via automated scripts (such as cron jobs)—with up-to-date lists of outstanding issues, which can be conveniently displayed each time a new shell session is started. This helps developers and project managers stay aware of pending tasks without needing to navigate Jira’s web interface, streamlining daily workflows and improving productivity.

The tool is implemented in Perl and relies on the "JIRA::REST" CPAN module to communicate with the Jira REST API. Users configure "japi" through command-line options, specifying details such as the Jira instance URL, API version, user credentials (optionally stored in a Base64-encoded password file), and custom JQL queries. Key features include colorized output (with an option to disable), filtering for unassigned issues, and debugging support. The architecture is intentionally simple: it acts as a wrapper around the Jira REST API, parsing and presenting ticket data in a terminal-friendly format, making it easy to integrate into shell-based workflows or automation scripts.

=> https://codeberg.org/snonux/japi View on Codeberg
=> https://github.com/snonux/japi View on GitHub

---

### perl-poetry

* 💻 Languages: Perl (100.0%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 2
* 📈 Lines of Code: 191
* 📄 Lines of Documentation: 8
* 📅 Development Period: 2014-03-24 to 2014-03-24
* 🔥 Recent Activity: 4221.9 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

The **perl-poetry** project is a creative collection of Perl scripts designed to resemble poetry, blending programming with artistic expression. Rather than serving a practical computational purpose, these scripts are crafted to be aesthetically pleasing and to explore the expressive potential of Perl syntax. The project's usefulness lies in its demonstration of code as an art form, inspiring programmers to think about the beauty and structure of code beyond its functionality.

In terms of implementation, each script is written to be syntactically correct and to compile with a specified Perl compiler, ensuring that the "poems" are valid Perl code. However, the scripts are intentionally not designed to perform meaningful tasks or produce useful outputs. The key feature of the project is its focus on code readability, structure, and visual appeal, using Perl's flexible syntax to create poetic forms. The architecture is simple: a collection of standalone Perl files, each representing a different poetic experiment, highlighting the intersection of programming and creative writing.

=> https://codeberg.org/snonux/perl-poetry View on Codeberg
=> https://github.com/snonux/perl-poetry View on GitHub

---

### ipv6test

* 💻 Languages: Perl (100.0%)
* 📊 Commits: 7
* 📈 Lines of Code: 80
* 📅 Development Period: 2011-07-09 to 2015-01-13
* 🔥 Recent Activity: 4301.9 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

This project is a simple Perl-based web application designed to test and demonstrate IPv6 connectivity. By leveraging three specifically configured hosts—one dual-stack (IPv4 and IPv6), one IPv4-only, and one IPv6-only—the website allows users to verify whether their network and browser can access resources over both IP protocols. This is particularly useful for diagnosing connectivity issues, validating IPv6 deployment, and educating users or administrators about the differences between IPv4 and IPv6 access.

The implementation relies on Perl scripts running on a web server, with DNS and server configurations ensuring each hostname responds only over its designated protocol(s). The main site (ipv6.buetow.org) is accessible via both IPv4 and IPv6, while the test subdomains restrict access to a single protocol. The website likely presents users with status messages or test results based on their ability to reach each host, making it a practical tool for network troubleshooting and IPv6 readiness checks. The architecture is straightforward, emphasizing clear separation of protocol access through DNS and server configuration, with Perl handling the web logic and user interface.

=> https://codeberg.org/snonux/ipv6test View on Codeberg
=> https://github.com/snonux/ipv6test View on GitHub

---

### cpuinfo

* 💻 Languages: Shell (53.2%), Make (46.8%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 28
* 📈 Lines of Code: 124
* 📄 Lines of Documentation: 75
* 📅 Development Period: 2010-11-05 to 2021-11-05
* 🔥 Recent Activity: 4342.6 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 1.0.2 (2014-06-22)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**cpuinfo** is a lightweight command-line utility designed to display detailed information about the system’s CPU in a human-readable format. Its primary function is to extract and present data such as processor model, speed, number of cores, and other relevant attributes, making it easier for users and administrators to quickly assess hardware specifications without manually parsing system files.

The tool achieves this by invoking AWK, a powerful text-processing utility, to parse the `/proc/cpuinfo` file—a standard Linux file containing raw CPU details. By automating this parsing and formatting process, cpuinfo saves users time and reduces the likelihood of errors when interpreting CPU data. Its simple architecture (a script leveraging AWK) ensures minimal dependencies and fast execution, making it especially useful for scripting, troubleshooting, or system inventory tasks.

=> https://codeberg.org/snonux/cpuinfo View on Codeberg
=> https://github.com/snonux/cpuinfo View on GitHub

---

### loadbars

* 💻 Languages: Perl (97.4%), Make (2.6%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 527
* 📈 Lines of Code: 1828
* 📄 Lines of Documentation: 100
* 📅 Development Period: 2010-11-05 to 2015-05-23
* 🔥 Recent Activity: 4372.7 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.7.5 (2014-06-22)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

loadbars: source code repository.

=> https://codeberg.org/snonux/loadbars View on Codeberg
=> https://github.com/snonux/loadbars View on GitHub

---

### pwgrep

* 💻 Languages: Shell (85.0%), Make (15.0%)
* 📚 Documentation: Text (72.4%), Markdown (27.6%)
* 📊 Commits: 142
* 📈 Lines of Code: 493
* 📄 Lines of Documentation: 29
* 📅 Development Period: 2009-09-27 to 2015-05-23
* 🔥 Recent Activity: 4386.1 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: 0.9.3 (2014-06-14)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**pwgrep** is a lightweight password manager designed for Unix-like systems, implemented primarily in Bash and GNU AWK. It securely stores and retrieves passwords by encrypting them with GPG (GNU Privacy Guard), ensuring that sensitive information remains protected. Version control for password files is handled using an RCS (Revision Control System) such as Git, allowing users to track changes, revert to previous versions, and maintain an audit trail of password updates. This approach leverages familiar command-line tools, making it accessible to users comfortable with shell environments.

The core features of pwgrep include encrypted password storage, easy retrieval and search functionality (using AWK for pattern matching), and robust version control integration. The architecture is modular and script-based: Bash scripts orchestrate user interactions and file management, AWK handles efficient searching within password files, GPG provides encryption/decryption, and Git (or another RCS) manages version history. This combination offers a secure, auditable, and scriptable solution for password management without relying on heavyweight external applications or GUIs.

=> https://codeberg.org/snonux/pwgrep View on Codeberg
=> https://github.com/snonux/pwgrep View on GitHub

---

### perldaemon

* 💻 Languages: Perl (72.3%), Shell (23.8%), Config (3.9%)
* 📊 Commits: 110
* 📈 Lines of Code: 614
* 📅 Development Period: 2011-02-05 to 2022-04-21
* 🔥 Recent Activity: 4422.2 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v1.4 (2022-04-29)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**Summary of PerlDaemon Project**

PerlDaemon is a lightweight, extensible daemon framework written in Perl for Linux and other UNIX-like systems. Its primary purpose is to provide a robust foundation for building background services (daemons) that can be easily customized and extended with user-defined modules. Key features include automatic daemonization, flexible logging with log rotation, clean shutdown handling, PID file management, and straightforward configuration via both files and command-line options. The architecture is modular, allowing users to add or modify functionality by creating Perl modules within a designated directory, making it adaptable for a wide range of automation or monitoring tasks.

The implementation centers around a main daemon process that manages the event loop, module execution, and system signals. High-resolution scheduling is achieved using Perl’s `Time::HiRes` module, ensuring precise timing for periodic tasks and compensating for any delays between loop iterations. Configuration is managed through a central file (`perldaemon.conf`) or overridden at runtime, and the included control script simplifies starting, stopping, and reconfiguring the daemon. Modules are executed sequentially at configurable intervals, and the system is designed to be both easy to set up and extend, making it a practical tool for Perl developers needing custom background services.

=> https://codeberg.org/snonux/perldaemon View on Codeberg
=> https://github.com/snonux/perldaemon View on GitHub

---

### awksite

* 💻 Languages: AWK (72.1%), HTML (16.4%), Config (11.5%)
* 📚 Documentation: Text (60.0%), Markdown (40.0%)
* 📊 Commits: 3
* 📈 Lines of Code: 122
* 📄 Lines of Documentation: 10
* 📅 Development Period: 2011-01-27 to 2014-06-22
* 🔥 Recent Activity: 4753.2 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: v0.2 (2011-01-27)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

Awksite is a lightweight CGI application designed to generate dynamic HTML websites using GNU AWK, a powerful text-processing language commonly available on Unix-like systems. By leveraging AWK scripts, Awksite enables users to create dynamic web content without the need for more complex web frameworks or languages. This makes it particularly useful for environments where simplicity, portability, and minimal dependencies are important—such as small servers, embedded systems, or situations where installing additional software is impractical.

The core architecture of Awksite consists of AWK scripts executed via the Common Gateway Interface (CGI), allowing web servers to process HTTP requests and generate HTML responses dynamically. Key features include ease of deployment (since it only requires GNU AWK and a CGI-capable web server), the ability to process and transform text data into HTML on-the-fly, and compatibility with most Unix-like operating systems. Awksite’s implementation emphasizes minimalism and portability, making it a practical solution for generating dynamic websites in constrained or resource-limited environments.

=> https://codeberg.org/snonux/awksite View on Codeberg
=> https://github.com/snonux/awksite View on GitHub

---

### jsmstrade

* 💻 Languages: Java (76.0%), Shell (15.4%), XML (8.6%)
* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 20
* 📈 Lines of Code: 720
* 📄 Lines of Documentation: 6
* 📅 Development Period: 2008-06-21 to 2021-11-03
* 🔥 Recent Activity: 4815.8 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🏷️ Latest Release: v0.3 (2009-02-08)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

=> showcase/jsmstrade/image-1.png jsmstrade screenshot

JSMSTrade is a lightweight graphical user interface (GUI) application designed to simplify the process of sending SMS messages through the smstrade.de service. By providing a clean and minimal interface, it allows users to quickly compose and dispatch SMS messages without needing to interact directly with the smstrade.de API or use command-line tools. This makes it especially useful for individuals or small businesses who want a straightforward way to manage SMS communications from their desktop.

The application is implemented as a desktop GUI, likely using a framework such as Electron or a Python toolkit (e.g., Tkinter or PyQt), and communicates with the smstrade.de API to send messages. Key features include easy message composition, address book integration, and real-time feedback on message status. The architecture centers around a user-friendly front end that handles user input and displays results, while the back end manages API authentication, message formatting, and communication with the SMS service. This separation ensures both usability and reliability, making JSMSTrade a practical tool for anyone needing to send SMS messages efficiently.

=> https://codeberg.org/snonux/jsmstrade View on Codeberg
=> https://github.com/snonux/jsmstrade View on GitHub

---

### ychat

* 💻 Languages: C++ (50.4%), Shell (21.3%), C/C++ (20.8%), Perl (2.3%), HTML (2.3%), Config (2.2%), Make (0.7%), CSS (0.1%)
* 📚 Documentation: Text (100.0%)
* 📊 Commits: 67
* 📈 Lines of Code: 73818
* 📄 Lines of Documentation: 127
* 📅 Development Period: 2008-05-15 to 2014-07-01
* 🔥 Recent Activity: 5407.2 days (avg. age of last 42 commits)
* ⚖️ License: GPL-2.0
* 🏷️ Latest Release: yhttpd-0.7.2 (2013-04-06)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

**yChat** is a free, open-source, HTTP-based chat server written in C++ that allows users to communicate in real time using only a standard web browser—no special client software is required. Designed for portability and performance, yChat runs as a standalone web server (with its own lightweight HTTP engine, yhttpd) and supports POSIX-compliant operating systems like Linux and BSD. Key features include multi-threading (using POSIX threads), modular architecture with dynamically loadable modules, MySQL-based user management, customizable HTML and language templates, and an ncurses-based administration interface. The system is highly configurable via XML-based config files and supports advanced features like session management, logging (including Apache-style logs), and a smart garbage collection engine for efficient resource handling.

yChat’s architecture is built around a core C++ engine that handles HTTP requests directly, bypassing the need for external web servers like Apache. It uses hash maps for fast data access, supports CGI scripting, and allows for easy customization of both appearance and functionality through templates and modules. The project is organized into several branches (CURRENT, STABLE, BASIC, LEGACY) to balance stability and feature development, and it provides tools for easy installation, configuration, and administration. Its modular design, performance optimizations, and ease of customization make it a practical solution for organizations or communities seeking a lightweight, browser-accessible chat platform that is easy to deploy and extend.

=> https://codeberg.org/snonux/ychat View on Codeberg
=> https://github.com/snonux/ychat View on GitHub

---

### netcalendar

* 💻 Languages: Java (83.0%), HTML (12.9%), XML (3.0%), CSS (0.8%), Make (0.2%)
* 📚 Documentation: Text (89.7%), Markdown (10.3%)
* 📊 Commits: 50
* 📈 Lines of Code: 17380
* 📄 Lines of Documentation: 947
* 📅 Development Period: 2009-02-07 to 2021-05-01
* 🔥 Recent Activity: 5446.5 days (avg. age of last 42 commits)
* ⚖️ License: GPL-2.0
* 🏷️ Latest Release: v0.1 (2009-02-08)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

=> showcase/netcalendar/image-1.png netcalendar screenshot

NetCalendar is a Java-based calendar application designed for both standalone and distributed use, allowing users to manage and share calendar events across multiple computers. Its key features include a graphical client interface, support for both local and networked operation, and optional SSL encryption for secure communication. The application can be run in a simple standalone mode—where both client and server operate within the same process—or in a distributed mode, where the server and client run on separate machines and communicate over TCP/IP. For enhanced security, NetCalendar supports SSL, requiring Java keystore and truststore configuration.

=> showcase/netcalendar/image-2.png netcalendar screenshot

NetCalendar is implemented as a Java application (requiring JRE 6 or higher) and is launched via command-line options that determine its mode of operation (standalone, server-only, or client-only). Configuration can be managed through a GUI or by editing a configuration file. The client visually distinguishes event types and timeframes using color coding, and it can integrate with the UNIX `calendar` database for compatibility with existing calendar data. The architecture is modular, separating client and server logic, and supports flexible deployment scenarios, making it useful for both individual users and small teams needing a simple, networked calendar solution.

=> https://codeberg.org/snonux/netcalendar View on Codeberg
=> https://github.com/snonux/netcalendar View on GitHub

---

### hsbot

* 💻 Languages: Haskell (98.5%), Make (1.5%)
* 📊 Commits: 80
* 📈 Lines of Code: 601
* 📅 Development Period: 2009-11-22 to 2011-10-17
* 🔥 Recent Activity: 5542.2 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

This project appears to be a Haskell-based application or library that interfaces with MySQL databases and provides network functionality. It leverages the HSQL library (specifically, the MySQL driver) for database connectivity, and the Haskell network library for handling network operations such as socket communication or client-server interactions. The key features likely include establishing connections to MySQL databases, executing SQL queries, and possibly serving or consuming data over a network interface.

The architecture is modular, relying on external Haskell packages: libghc6-hsql-mysql-dev for database operations and libghc6-network-dev for networking. This separation of concerns allows the project to efficiently manage data storage and retrieval while also supporting network-based communication, making it useful for applications such as web services, data processing tools, or networked applications that require persistent data storage. The use of Haskell ensures strong type safety and reliability in both database and network code.

=> https://codeberg.org/snonux/hsbot View on Codeberg
=> https://github.com/snonux/hsbot View on GitHub

---

### vs-sim

* 📚 Documentation: Markdown (100.0%)
* 📊 Commits: 411
* 📈 Lines of Code: 0
* 📄 Lines of Documentation: 7
* 📅 Development Period: 2008-05-15 to 2015-05-23
* 🔥 Recent Activity: 5903.1 days (avg. age of last 42 commits)
* ⚖️ License: No license found
* 🏷️ Latest Release: v1.0 (2008-08-24)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

VS-Sim is an open-source Java-based simulator designed to model and analyze distributed systems. Its primary purpose is to provide a virtual environment where users can create, configure, and observe the behavior of distributed algorithms and networked components without the need for physical hardware. This makes it a valuable tool for researchers, educators, and students who want to experiment with distributed system concepts, test fault tolerance mechanisms, or visualize communication protocols in a controlled and repeatable manner.

The simulator features a modular architecture, allowing users to define custom network topologies, node behaviors, and communication protocols. Key components include a graphical user interface for system configuration and visualization, an event-driven simulation engine to manage the timing and sequencing of distributed events, and extensible APIs for integrating new algorithms or system models. By abstracting the complexities of real-world distributed environments, VS-Sim enables rapid prototyping and debugging, making it an effective platform for both teaching and research in distributed computing.

=> https://codeberg.org/snonux/vs-sim View on Codeberg
=> https://github.com/snonux/vs-sim View on GitHub

---

### fype

* 💻 Languages: C (71.3%), C/C++ (20.6%), HTML (6.6%), Make (1.5%)
* 📚 Documentation: Text (60.2%), LaTeX (39.8%)
* 📊 Commits: 99
* 📈 Lines of Code: 8906
* 📄 Lines of Documentation: 1431
* 📅 Development Period: 2008-05-15 to 2021-04-29
* 🔥 Recent Activity: 5949.0 days (avg. age of last 42 commits)
* ⚖️ License: Custom License
* 🧪 Status: Experimental (no releases yet)

⚠️  **Notice**: This project appears to be finished, obsolete, or no longer maintained. Last meaningful activity was over 2 years ago. Use at your own risk.

fype: source code repository.

=> https://codeberg.org/snonux/fype View on Codeberg
=> https://github.com/snonux/fype View on GitHub
