# Task Samurai: An agentic coding learning experiment

> Published at 2025-06-22T18:49:11+03:00

=> ./task-samurai/logo.png Task Samurai Logo

<< template::inline::toc

## Introduction

Task Samurai is a fast terminal interface for Taskwarrior written in Go using the Bubble Tea framework. It displays your tasks in a table and allows you to manage them without leaving your keyboard.

=> https://taskwarrior.org
=> https://github.com/charmbracelet/bubbletea

### Why does this exist?

* I wanted to tinker with agentic coding. This project was entirely implemented using OpenAI Codex.
* I wanted a faster UI for Taskwarrior than other options, like Vit, which is Python-based.
* I wanted something built with Bubble Tea, but I never had time to dive deep into it.
* I wanted to build a toy project (like Task Samurai) first, before tackling the big ones, to get started with agentic coding.

Given the current industry trend and the rapid advancements in technology, it has become clear that experimenting with AI-assisted coding tools is almost a necessity to stay relevant. Embracing these new developments doesn't mean abandoning traditional coding; instead, it means integrating new capabilities into your workflow to stay ahead in a fast-evolving field.

### How it works

Task Samurai invokes the `task` command to read and modify tasks. The tasks are displayed in a Bubble Tea table, where each row represents a task. Hotkeys trigger Taskwarrior commands such as starting, completing or annotating tasks. The UI refreshes automatically after each action, so the table is always up to date.

=> ./task-samurai/screenshot.png Task Samurai Screenshot

## Where and how to get it

Go to:

=> https://codeberg.org/snonux/tasksamurai

And follow the `README.md`!

## Lessons Learned from Building Task Samurai with Agentic Coding

If you've ever wanted to supercharge your dev speed—or just throw a fireworks display in your terminal—here's a peek behind the scenes of building Task Samurai. This terminal interface for Taskwarrior was developed entirely through agentic coding by me, leveraging OpenAI Codex to do all the heavy lifting (and sometimes some cleanup afterwards). The project name might be snappy, but it was the iterative, semi-automated workflow that made the impact.

As a side note, I was trying out OpenAI Codex because I regularly run out of Claude Code CLI (another agentic coding tool I am trying out currently) credits (it still happens!), but Codex was still available to me. So, I seized the opportunity to push agentic coding a bit more.

### How It Went Down

Task Samurai's codebase came together quickly: the entire Git history spans from June 19 to 22, 2025, culminating in 179 commits. Here are the broad strokes:

* June 19: Scaffolded the Go boilerplate, set up tests, integrated the Bubble Tea UI framework, and got the first table views showing up.
* June 20: (The big one—120 commits!) Added hotkeys, colourized tasks, annotation support, undo/redo, and, for fun, fireworks on quit (which never worked and got removed at a later point). This is where most of the bugs, merges, and fast-paced changes happen.
* June 21: Refined searching, theming, and column sizing and documented all those hotkeys. Numerous tweaks to make the UI cleaner and more user-friendly.
* June 22: Final touches—added screenshots, polished the logo, fixed module paths… and then it was a wrap.

Most big breakthroughs (and bug introductions) came during that middle day of intense iteration. The latter stages were all about smoothing out the rough edges.

### What Went Wrong

Going agentic isn't all smooth sailing. Here are the hiccups I ran into, plus a few hard-earned lessons:

* Merge Floods: Every minor feature or fix existed on its branch, so merging was a constant process. It kept progress flowing but also drowned the committed history in noise and the occasional conflict. I found this to be an issue with OpenAI's Codex in particular. Not so much with other agentic coding tools like Claude Code CLI (not covered in this blog post.)
* Fixes on Fixes: Features like "fireworks on exit" had chains of "fix exit," "fix cell selection," etc. Sometimes, new additions introduced bugs that needed rapid patching.

### Patterns That Helped

Despite the chaos, a few strategies kept things moving:

* Scaffolding First: I started with the basic table UI and command wrappers, then layered on features—never the other way around.
* Tiny PRs: Small, atomic merges meant feedback came fast (and so did fixes).
* Tests Matter: A solid base of unit tests for task manipulations kept things from breaking entirely when experimenting.
* Live Documentation: Documentation, such as the README, is updated regularly to reflect all the hotkey and feature changes.
Maybe a better approach would have been to design the whole application from scratch before letting Codix do any of the coding. I will try that with my next toy project.

### What I Learned Using Agentic Coding

Stepping into agentic coding with Codex as my "pair programmer" was a genuine shift. I learned a ton—not just about automating code generation, but also about how you have to tightly steer, guide, and audit every line as things move at breakneck speed. I must admit, I sometimes lost track of what all the generated code was actually doing. But as the features seemed to work after a few iterations, I was satisfied. 

Discussing requirements with Codex forced me to clarify features and spot logical pitfalls earlier. All those fast iterations meant I was constantly coaxing more helpful, less ambiguous code out of the model—making me rethink how to break features into clear, testable steps. I now see agentic coding not just as a productivity tool but also as a learning accelerator.

### How Much Time Did I Save?

Here's the million-dollar (or many hours saved) question: Did it buy me speed?

Let's do some back-of-the-envelope math:

* Say each commit takes Codex 5 minutes to generate, and you need to review/guide 179 commits = about *6 hours of active development*.
* If you coded it all yourself, including all the bug fixes, features, design, and documentation, you might spend *10–20 hours*.
* That's a potential savings, so what's usually weeks of work got compressed into just a few frantic days.

## Wrapping Up

Building Task Samurai with agentic coding was a wild ride—rapid feature growth, plenty of churns, countless fast fixes, and more merge commits I'd expected. The big lessons? Keep the iterations short, keep tests and documentation concise, and review and refine for final polish at the end. Even with the bumps along the way, shipping a polished terminal UI in days instead of weeks is a testament to the raw power (and some hazards) of agentic development.

While working on Task Samuray, there were times I genuinely missed manual coding and the satisfaction that comes from writing every line yourself, debugging issues through sheer logic, and crafting solutions from scratch. However, this is the direction in which the industry seems to be shifting, unfortunately. If applied correctly, AI will boost performance, and if you don't use AI, your next performance review may be awkward.

If you're considering going agentic, be prepared for a sprint, keep your toolkit sharp, and be ready to learn a lot along the way.

Personally, I am not sure whether I like where the industry is going with agentic coding. I love "traditional" coding, and with agentic coding you operate at a higher level and don't interact directly with code as often, which I would miss. I think that in the future, designing, reviewing, and being able to read and understand code will be more important than writing code by hand.

Do you have any thoughts on that? I hope, I am partially wrong at least.

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
