# Gemtexter 3.0.0 - Let's Gemtext again⁴

> Published at 2024-10-01T21:46:26+03:00

I proudly announce that I've released Gemtexter version `3.0.0`. What is Gemtexter? It's my minimalist static site generator for Gemini Gemtext, HTML and Markdown, written in GNU Bash.

=> https://github.com/snonux/gemtexter

```
-=[ typewriters ]=-  1/98
                                      .-------.
       .-------.                     _|~~ ~~  |_
      _|~~ ~~  |_       .-------.  =(_|_______|_)
    =(_|_______|_)=    _|~~ ~~  |_   |:::::::::|    .-------.
      |:::::::::|    =(_|_______|_)  |:::::::[]|   _|~~ ~~  |_
      |:::::::[]|      |:::::::::|   |o=======.| =(_|_______|_)
      |o=======.|      |:::::::[]|   `"""""""""`   |:::::::::|
 jgs  `"""""""""`      |o=======.|                 |:::::::[]|
  mod. by Paul Buetow  `"""""""""`                 |o=======.|
                                                   `"""""""""`
```

<< template::inline::toc

## Why Bash?

This project is too complex for a Bash script. Writing it in Bash was to try out how maintainable a "larger" Bash script could be. It's still pretty maintainable and helps me try new Bash tricks here and then!

Let's list what's new!

## HTML exact variant is the only variant

The last version of Gemtexter introduced the HTML exact variant, which wasn't enabled by default. This version of Gemtexter removes the previous (inexact) variant and makes the exact variant the default. This is a breaking change, which is why there is a major version bump of Gemtexter. Here is a reminder of what the exact variant was:

> Gemtexter is there to convert your Gemini Capsule into other formats, such as HTML and Markdown. An HTML exact variant can now be enabled in the `gemtexter.conf` by adding the line `declare -rx HTML_VARIANT=exact`. The HTML/CSS output changed to reflect a more exact Gemtext appearance and to respect the same spacing as you would see in the Geminispace. 

## Table of Contents auto-generation

Just add...

```
 << template::inline::toc
```

...into a Gemtexter template file and Gemtexter will automatically generate a table of contents for the page based on the headings (see this page's ToC for example). The ToC will also have links to the relevant sections in HTML and Markdown output. The Gemtext format does not support links, so the ToC will simply be displayed as a bullet list. 

## Configurable themes

It was always possible to customize the style of a Gemtexter's resulting HTML page, but all the config options were scattered across multiple files. Now, the CSS style, web fonts, etc., are all configurable via themes.

Simply configure `HTML_THEME_DIR` in the `gemtexter.conf` file to the corresponding directory. For example:

```bash
declare -xr HTML_THEME_DIR=./extras/html/themes/simple
```

To customize the theme or create your own, simply copy the theme directory and modify it as needed. This makes it also much easier to switch between layouts.

## No use of webfonts by default

The default theme is now "back to the basics" and does not utilize any web fonts. The previous themes are still part of the release and can be easily configured. These are currently the `future` and `business` themes. You can check them out from the themes directory.

## More

Additionally, there were a couple of bug fixes, refactorings and overall improvements in the documentation made. 

E-Mail your comments to `paul@nospam.buetow.org` :-)

Other related posts are:

<< template::inline::rindex gemtext gemini

=> ../ Back to the main site
