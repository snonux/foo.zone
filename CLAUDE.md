# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static site generator project that uses **Gemtext** as the source format and generates multiple output formats. The project uses "Gemtexter" (a Bash-based static site generator) to convert Gemtext files into HTML, Markdown, and various feed formats.

**Key Architecture:**
- **Source files**: Gemtext (`.gmi`) and template files (`.gmi.tpl`) in the `/gemtext` directory
- **Generated outputs**: HTML in `../html/`, Markdown in `../md/`, with caching in `../cache/`
- **Content structure**: Blog posts in `gemfeed/`, personal notes in `notes/`, about pages in `about/`
- **Template system**: `.gmi.tpl` files are processed to generate final `.gmi` files with dynamic content

## Build Commands

Since this project uses Gemtexter (a Bash-based static site generator), the build process involves:

**Main generation command:**
```bash
# From the parent directory (/home/paul/git/foo.zone-content/)
# Look for gemtexter script or build scripts in the parent directory
```

**File structure patterns:**
- `.gmi.tpl` → `.gmi` (template processing)
- `.gmi` → `.html` + `.md` + feeds (multi-format generation)

## Content Architecture

**Template System:**
- Files with `.gmi.tpl` extension are templates that get processed
- Templates can include dynamic content like timestamps and automatic content generation
- Example: `index.gmi.tpl` generates `index.gmi` with current timestamp

**Output Formats:**
- **Gemtext**: Native format for Gemini protocol (`.gmi` files)
- **HTML**: Web-ready format with embedded CSS and fonts
- **Markdown**: For GitHub Pages deployment
- **Atom feeds**: For blog subscription (XML format)
- **Gemfeeds**: Gemini-specific feed format

**Content Organization:**
- `gemfeed/`: Blog posts with date-prefixed naming (YYYY-MM-DD-title.gmi)
- `notes/`: Book notes and technical references
- `about/`: Personal information and resource lists

## Development Workflow

1. **Content Creation**: Write new content in Gemtext format (`.gmi` files)
2. **Template Updates**: Modify `.gmi.tpl` files for dynamic content
3. **Generation**: Run Gemtexter to generate all output formats
4. **Multi-format Output**: Content automatically appears in HTML, Markdown, and feed formats

## Important Notes

- The current working directory is `/gemtext` but build tools are likely in the parent directory
- Generated files should not be edited directly - edit source `.gmi` or `.gmi.tpl` files instead
- The project generates a complete multi-format website from simple Gemtext sources
- Cache files in `../cache/` help with performance during regeneration