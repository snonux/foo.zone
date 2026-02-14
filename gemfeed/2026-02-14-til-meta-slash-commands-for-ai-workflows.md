# TIL: Meta slash-commands for reusable AI prompts and context

> Published at 2026-02-14T14:00:00+02:00

Short post in "This week I learned" style: what I tried, why it worked, and how you can replicate it. Format: Problem → Approach → Copy/paste → Result → Gotchas. Full reference for the meta-commands lives in a separate post.

[Full reference: Meta slash-commands to manage prompts and context for coding agents](./2026-02-14-meta-slash-commands-for-prompts-and-context.md)  

## TIL

### Problem

When I use a coding agent (Cursor Agent, Claude Code CLI, Ampcode, etc.), I repeat the same requests: "review this function," "explain this error," "add tests for this module," "format this as a blog post." Typing long prompts from scratch is tedious; ad-hoc prompts are easy to forget. I also keep pasting the same background (API conventions, project rules, infra notes) into every session so the agent doesn't guess blindly.

### Approach

Treat prompts and context as first-class artefacts: store them as markdown files (one per slash-command or per context) in a dotfiles repo. Use a small set of *meta* slash-commands so the agent itself creates, updates, and deletes these files from the conversation—no hand-editing. Two kinds of artefacts:

* Commands — Reusable workflows (e.g. review-code, explain-error). Live in `commands/` as `.md` files.
* Context — Reusable background (API guidelines, runbooks, personas). Live in `context/` as `.md` files; you *load* one at session start so the agent has it in mind.

### Copy/paste

Minimal workflow:

```
/load-context api-guidelines
```

Then ask the agent to implement a feature or fix a bug; it already has the guidelines.

To turn something you just did into a reusable command:

```
/create-command review-code
```

Full command reference (all meta-commands, parameters, examples):

[Meta slash-commands — full reference](./2026-02-14-meta-slash-commands-for-prompts-and-context.md)  

### Result

No more retyping long prompts; same prompt library across Cursor Agent, Claude Code CLI, OpenCode, Ampcode. Context is load-on-demand per session instead of pasting walls of text. Everything is versioned in git and synced across machines.

### Gotchas

* Requires an agent that supports custom slash-commands (or reading prompt files from disk).
* Context is explicit: you must run `/load-context <name>` at session start; it's not implicit like some "skills" systems.
* A flat directory of commands can grow; if it gets unwieldy, consider grouping by skill or exposing via an MCP server later.

## Before/After

* Before: Retyping or pasting long prompts each time; pasting API/project context into every session; prompts scattered and inconsistent across tools.
* After: `/load-context <name>` once per session; `/<command>` for repeatable tasks; commands and context in git, same library across agents.

## Workflow recipe

* Steps: (1) Create or update context/commands via meta-commands when you have something worth reusing. (2) Start a session → run `/load-context <name>`. (3) Use slash-commands or ask ad-hoc; agent has background and consistent prompts.
* Tools: Cursor Agent (CLI), Claude Code CLI, OpenCode, Ampcode; markdown in e.g. `~/Notes/Prompts/commands/` and `~/Notes/Prompts/context/`.
* Impact: Saves retyping and keeps prompts consistent; one-time cost is creating the first context/command with the agent.

## Micro-template (quick reference)

| Meta-command       | Purpose                        | Good for                                  |
|--------------------|--------------------------------|-------------------------------------------|
| /create-command    | Create new slash-command       | Turn current or recurring tasks into one  |
| /update-command    | Edit existing slash-command    | Refine after use                          |
| /delete-command    | Remove slash-command file      | Clean up unused commands                  |
| /create-context    | Create new context file        | Capture project/infra knowledge once      |
| /update-context    | Edit existing context file     | Keep context up to date                   |
| /delete-context    | Remove context file            | Remove outdated context                   |
| /load-context      | Load context into conversation | Give agent background before tasks        |

Example usage: `/load-context api-guidelines`, `/create-command review-code`, `/update-command review-code`. Full details and examples in the main post linked above.

Other related posts:

[2026-02-14 Meta slash-commands to manage prompts and context for coding agents](./2026-02-14-meta-slash-commands-for-prompts-and-context.md)  
[2026-02-02 A tmux popup editor for Cursor Agent CLI prompts](./2026-02-02-tmux-popup-editor-for-cursor-agent-prompts.md)  

E-Mail your comments to `paul@nospam.buetow.org` :-)

[Back to the main site](../)  
