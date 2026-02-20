# Meta slash-commands to manage prompts, skills, and context for coding agents

> Published at 2026-02-14T13:44:45+02:00, last updated Tue 17 Feb 14:00:00 EET 2026

I work on many small, repeatable tasks. Instead of retyping the same instructions every time, I want to turn successful prompts into reusable slash-commands and keep background knowledge in loadable context files. This post describes a set of *meta* slash-commands: commands that create, update, and delete other commands, context files, and skills. They live as markdown in a dotfiles repo and work with any coding agent that supports slash-commands—Claude Code CLI, Cursor Agent, OpenCode, Ampcode, and others.

> Updated Tue 17 Feb: Added section about skill management commands and the differences between commands and skills

```
    ┌─────────────────────────────────────────────────────────────┐
    │  Cursor Agent                                    [~][□][X]  │
    ├─────────────────────────────────────────────────────────────┤
    │                                                             │
    │   → /load-context api-guidelines                            │
    │                                                             │
    │   Context loaded: api-guidelines.md                         │
    │   Ready. Ask me to implement something.                     │
    │                                                             │
    │   → /create-skill docker-compose                            │
    │                                                             │
    │   Analyzing "docker-compose"...                              │
    │   Generated: SKILL.md with frontmatter + instructions.      │
    │   Save to skills/docker-compose/ ? [Y]                      │
    │                                                             │
    │   ✓ Saved. Use /docker-compose anytime.                     │
    │                                                             │
    └─────────────────────────────────────────────────────────────┘
                          │
                          │  slash-commands & skills
                          ▼
    ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
    │ /load-   │  │ /create- │  │ /create- │  │ /docker-  │
    │ context  │  │ command  │  │ skill    │  │ compose   │
    └──────────┘  └──────────┘  └──────────┘  └──────────┘
         │              │              │              │
         └──────────────┴──────────────┴──────────────┘
                              │
                    coding agent executes
                    your prompt library
```

## Table of Contents

* [⇢ Meta slash-commands to manage prompts, skills, and context for coding agents](#meta-slash-commands-to-manage-prompts-skills-and-context-for-coding-agents)
* [⇢ ⇢ Motivation: collecting prompts for later re-use](#motivation-collecting-prompts-for-later-re-use)
* [⇢ ⇢ Loading whole context before asking the agent to do something](#loading-whole-context-before-asking-the-agent-to-do-something)
* [⇢ ⇢ Works with any coding agent that supports slash-commands](#works-with-any-coding-agent-that-supports-slash-commands)
* [⇢ ⇢ Commands that manage slash-commands](#commands-that-manage-slash-commands)
* [⇢ ⇢ ⇢ `/create-command`](#create-command)
* [⇢ ⇢ ⇢ `/update-command`](#update-command)
* [⇢ ⇢ ⇢ `/delete-command`](#delete-command)
* [⇢ ⇢ Commands vs skills: when to use which](#commands-vs-skills-when-to-use-which)
* [⇢ ⇢ Commands that manage skills](#commands-that-manage-skills)
* [⇢ ⇢ ⇢ `/create-skill`](#create-skill)
* [⇢ ⇢ ⇢ `/update-skill`](#update-skill)
* [⇢ ⇢ ⇢ `/delete-skill`](#delete-skill)
* [⇢ ⇢ Commands that manage context files](#commands-that-manage-context-files)
* [⇢ ⇢ ⇢ `/create-context`](#create-context)
* [⇢ ⇢ ⇢ `/update-context`](#update-context)
* [⇢ ⇢ ⇢ `/delete-context`](#delete-context)
* [⇢ ⇢ ⇢ `/load-context`](#load-context)
* [⇢ ⇢ Summary](#summary)

## Motivation: collecting prompts for later re-use

When I use a coding agent, I often find myself repeating the same kind of request: "review this function," "explain this error," "add tests for this module," "format this as a blog post" and may other cases. Typing long prompts from scratch is tedious, and ad-hoc prompts are easy to forget. I'd rather capture what works and reuse it.

The solution is to treat prompts as first-class artefacts: store them as markdown files (one file per slash-command or per context), and use a small set of *meta* commands to manage them. The agent then creates, updates, or deletes these files through conversation—no hand-editing of markdowns. I can say `/create-command review-code we just did a code review` and the agent generates the command file based on the current agent's context, shows a preview, and saves it. Later I run `/review-code` and get a consistent workflow every time.

Because everything is just markdown in directories (`commands/` for commands, `skills/` for skills, and `context/` for context), I can version it in git, sync it across machines, and gradually build a library of prompts. When a command grows too complex for a single file, I promote it to a skill—a structured directory with YAML frontmatter, a "When to Use" section, and detailed instructions.

## Loading whole context before asking the agent to do something

A separate but related need is *context*: background information the agent should have before I ask it to do anything. For example, I might have a document describing our Kubernetes setup, API conventions, or the architecture of a specific service. If I ask "add a new endpoint for X" without that context, the agent guesses and without having a reference to an existing project with an `AGENTS.md`. If I first load the relevant context file, the agent knows the naming conventions, the existing patterns, and the infrastructure—and its edits are more accurate.

So I keep three kinds of artefacts:

* Commands — Reusable workflows (e.g. "review code", "explain error"). They live as single `.md` files in a `commands/` directory. Meta-commands create, update, and delete them. Commands are simple: one file, one prompt. They work with any coding agent.
* Skills — Richer, more structured artefacts than commands. Each skill lives in its own directory (e.g. `skills/go-best-practices/SKILL.md`) and includes YAML frontmatter with metadata (name, description), a "When to Use" section, and detailed multi-step instructions. Skills can include additional files alongside the `SKILL.md`. They are the right choice when a workflow needs more structure, domain knowledge, or multiple steps.
* Context — Reusable background (project rules, API notes, infrastructure docs, personas). They live as `.md` files in a `context/` directory. I can create, update, delete, and—importantly—*load* them. Loading a context file injects that content into the conversation so the agent has it in mind for subsequent requests.

The use case is: start a session, run `/load-context api-guidelines` (or whatever context name), then ask the agent to implement a feature or fix a bug. The agent already knows the guidelines. No need to paste a wall of text every time; the context is on demand.

## Works with any coding agent that supports slash-commands

I use different agents depending on the task: Claude Code CLI, Cursor Agent (CLI), OpenCode, Ampcode and others. What they have in common is support for custom slash-commands (or the ability to read prompt files). My meta-commands, skills, and context files are just markdown; there is no lock-in. Point your agent at the same directories and you get the same prompts, skills, and context. I don't need an MCP server returning prompts right now—the files on disk are enough.

## Commands that manage slash-commands

These meta-commands create, update, and delete other slash-commands. The target files live in `~/Notes/Prompts/commands/` (or your chosen path). Each command is one `.md` file. You can see the commands (and the context files) here:

[https://codeberg.org/snonux/dotfiles/src/branch/master/prompts/](https://codeberg.org/snonux/dotfiles/src/branch/master/prompts/)  

### `/create-command`

Creates a new slash-command by inferring its purpose from the name you give.

* Parameter: `command_name` (e.g. `review-code`, `explain-error`, `optimize-function`)
* What it does: The agent analyses the name, infers intent and parameters, writes a description and prompt, shows a preview, and saves `{{command_name}}.md` to the commands directory.
* Good for: Turning the current task or a recurring need into a reusable command without editing files by hand.

Example usage:

```
/create-command review-code
/create-command explain-error
```

### `/update-command`

Updates an existing slash-command step by step.

* Parameter: `command_name` (e.g. `create-command`, `review-code`)
* What it does: Reads the existing `.md` file, shows the current content, asks what to change (description, parameters, prompt text), applies edits, shows a preview, and saves.
* Good for: Refining a command after you've used it a few times or when requirements change.

Example usage:

```
/update-command create-command
/update-command review-code
```

### `/delete-command`

Removes a slash-command by deleting its definition file.

* Parameter: `command_name` (e.g. `testing`, `review-code`)
* What it does: Verifies the file exists, shows what will be deleted, asks for confirmation, then deletes the file.
* Good for: Cleaning up experiments or commands you no longer use.

Example usage:

```
/delete-command testing
/delete-command review-code
```

## Commands vs skills: when to use which

Commands and skills both produce reusable slash-commands, but they differ in structure and intent:

```
| Aspect          | Command                        | Skill                                  |
|-----------------|--------------------------------|----------------------------------------|
| File layout     | Single .md file in commands/   | Directory with SKILL.md in skills/     |
| Metadata        | Markdown heading + description | YAML frontmatter (name, description)   |
| Structure       | Free-form prompt text          | "When to Use" + structured instructions|
| Complexity      | Simple, single-purpose prompts | Multi-step workflows, domain knowledge |
| Extra files     | No                             | Yes (can include supporting files)     |
| Best for        | Quick one-shot tasks           | Rich, repeatable processes             |
```

Use a **command** when you need a quick, single-purpose prompt—something like "review this PR" or "explain this error." Use a **skill** when the workflow is more involved: it needs structured instructions, domain-specific knowledge, or multiple steps that the agent should follow in order. For example, my `go-best-practices` skill contains detailed conventions for project structure, naming, error handling, and testing—far more than would fit comfortably in a flat command file.

The YAML frontmatter in skills (`name` and `description` between `---` fences at the top of the file) is what makes skills discoverable by the coding agent. When the agent starts a session, it scans the skills directory and reads the frontmatter to build a list of available skills—without having to parse the entire file. The `name` field gives the skill its slash-command name, and the `description` tells the agent (and the user) what the skill does, so the agent can suggest the right skill for a given task. Commands don't need this metadata because they are simpler: the filename *is* the command name, and the first heading serves as the description.

In practice, I start with a command and promote it to a skill once it grows beyond a simple prompt.

## Commands that manage skills

These meta-commands create, update, and delete skills. Skills live in `~/Notes/Prompts/skills/`, each in its own directory containing a `SKILL.md` file with YAML frontmatter.

### `/create-skill`

Creates a new skill by inferring its purpose from the name you give.

* Parameter: `skill_name` (e.g. `docker-compose`, `rust-conventions`)
* What it does: The agent analyses the name, infers intent, creates a directory `skills/{{skill_name}}/`, generates a `SKILL.md` with YAML frontmatter (`name`, `description`), a "When to Use" section, and detailed instructions. Shows a preview before saving.
* Good for: Creating structured, multi-step workflows that need more organisation than a simple command.

Example usage:

```
/create-skill docker-compose
/create-skill rust-conventions
```

### `/update-skill`

Updates an existing skill step by step.

* Parameter: `skill_name` (e.g. `go-best-practices`, `compose-blog-post`)
* What it does: Reads the existing `SKILL.md`, shows its current content, asks what to change (description, "When to Use" section, instructions), applies edits, shows a preview, and saves.
* Good for: Refining a skill after real-world usage or when conventions evolve.

Example usage:

```
/update-skill go-best-practices
/update-skill compose-blog-post
```

### `/delete-skill`

Removes a skill by deleting its entire directory.

* Parameter: `skill_name` (e.g. `docker-compose`, `rust-conventions`)
* What it does: Verifies the skill exists, shows what will be deleted, asks for confirmation, then removes the `skills/{{skill_name}}/` directory.
* Good for: Cleaning up experimental or unused skills.

Example usage:

```
/delete-skill docker-compose
/delete-skill rust-conventions
```

## Commands that manage context files

These meta-commands create, update, delete, and *load* context files. Context files live in `~/Notes/Prompts/context/`. Loading a context injects its content into the conversation so the agent can use it for subsequent requests.

### `/create-context`

Creates a new context file.

* Parameter: `context_name` (without `.md`), e.g. `epimetheus`, `api-guidelines`
* What it does: Checks if the context already exists, asks what the context should contain (background, structure, sections), then writes `{{context_name}}.md` to the context directory.
* Good for: Capturing project rules, API conventions, or infrastructure notes once and reusing them via `/load-context`.

Example usage:

```
/create-context epimetheus
/create-context api-guidelines
```

### `/update-context`

Updates an existing context file by adding, modifying, or removing content.

* Parameter: `context_name` (e.g. `epimetheus`, `api-guidelines`). If omitted, lists available context files.
* What it does: Reads the existing file, asks what to change (add section, modify section, remove section, rewrite, or full overhaul), applies changes, and saves.
* Good for: Keeping context up to date as the project or infrastructure evolves.

Example usage:

```
/update-context epimetheus
/update-context api-guidelines
/update-context
```

### `/delete-context`

Deletes a context file after confirmation.

* Parameter: `context_name` (e.g. `epimetheus`, `old-api-guidelines`). If omitted, lists available context files.
* What it does: Verifies the file exists, shows a preview or summary, asks for confirmation, then deletes the file.
* Good for: Removing outdated or unused context.

Example usage:

```
/delete-context epimetheus
/delete-context old-api-guidelines
/delete-context
```

### `/load-context`

Loads a context file into the conversation so the agent has that background for subsequent requests.

* Parameter: `context_name` (e.g. `epimetheus`, `api-guidelines`). If omitted, lists available context files.
* What it does: Reads the context file, displays its content, and confirms it is loaded. From then on, the agent can use that information when you ask it to implement features, fix bugs, or answer questions.
* Good for: Starting a session with "load our API guidelines" or "load our Kubernetes runbook" so the agent knows the infrastructure and conventions before you ask it to do something.

Example usage:

```
/load-context epimetheus
/load-context api-guidelines
/load-context
```

## Summary

```
| Meta-command       | Purpose                                      | Good for                                          |
|--------------------|----------------------------------------------|---------------------------------------------------|
| /create-command    | Create new slash-command from name           | Turning current or recurring tasks into commands  |
| /update-command    | Edit existing slash-command                  | Refining commands over time                       |
| /delete-command    | Remove slash-command file                    | Cleaning up unused commands                       |
| /create-skill      | Create new skill with structured instructions| Building rich, multi-step workflows               |
| /update-skill      | Edit existing skill                          | Refining skills as conventions evolve             |
| /delete-skill      | Remove skill directory                       | Cleaning up experimental or unused skills         |
| /create-context    | Create new context file                      | Capturing project/infra knowledge once            |
| /update-context    | Edit existing context file                   | Keeping context up to date                        |
| /delete-context    | Remove context file                          | Removing outdated context                         |
| /load-context      | Load context into conversation               | Giving the agent background before tasks          |
```

Context is what the agent *knows*; commands and skills are what the agent *does*—commands for simple prompts, skills for structured multi-step workflows. All three are markdown files you can create, update, and delete on the fly through the same coding agent—Claude Code CLI, Cursor Agent, OpenCode, Ampcode, or any other that supports slash-commands or prompt files. Start with commands for quick tasks, promote to skills when complexity grows, and load context when the agent needs background knowledge.

Other related posts:

[2026-02-14 Meta slash-commands to manage prompts, skills, and context for coding agents (You are currently reading this)](./2026-02-14-meta-slash-commands-for-prompts-and-context.md)  
[2026-02-02 A tmux popup editor for Cursor Agent CLI prompts](./2026-02-02-tmux-popup-editor-for-cursor-agent-prompts.md)  

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
