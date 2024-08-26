# Gemtexter 2.1.0 - Let's Gemtext again³

> Published at 2023-07-21T10:19:31+03:00

I proudly announce that I've released Gemtexter version `2.1.0`. What is Gemtexter? It's my minimalist static site generator for Gemini Gemtext, HTML and Markdown, written in GNU Bash.

=> https://codeberg.org/snonux/gemtexter

```
-=[ typewriters ]=-  1/98
                                        .-------.
       .-------.                       _|~~ ~~  |_
      _|~~ ~~  |_       .-------.    =(_|_______|_)
    =(_|_______|_)=    _|~~ ~~  |_     |:::::::::|
      |:::::::::|    =(_|_______|_)    |:::::::[]|
      |:::::::[]|      |:::::::::|     |o=======.|
      |o=======.|      |:::::::[]|     `"""""""""`
 jgs  `"""""""""`      |o=======.|
  mod. by Paul Buetow  `"""""""""`
```

<< template::inline::toc

## Why Bash?

This project is too complex for a Bash script. Writing it in Bash was to try out how maintainable a "larger" Bash script could be. It's still pretty maintainable and helps me try new Bash tricks here and then!

Let's list what's new!

## Switch to GPL3 license

Many (almost all) of the tools and commands (GNU Bash, GMU Sed, GNU Date, GNU Grep, GNU Source Highlight) used by `Gemtexter` are licensed under the GPL anyway. So why not use the same? This was an easy switch, as I was the only code contributor so far!

## Source code highlighting support

The HTML output now supports source code highlighting, which is pretty neat if your site is about programming. The requirement is to have the `source-highlight` command, which is GNU Source Highlight, to be installed. Once done, you can annotate a bare block with the language to be highlighted. E.g.:

```
 ```bash
 if [ -n "$foo" ]; then
   echo "$foo"
 fi
 ```
```

The result will look like this (you can see the code highlighting only in the Web version, not in the Geminispace version of this site):

```bash
if [ -n "$foo" ]; then
  echo "$foo"
fi
```

Please run `source-highlight --lang-list` for a list of all supported languages.

## HTML exact variant

Gemtexter is there to convert your Gemini Capsule into other formats, such as HTML and Markdown. An HTML exact variant can now be enabled in the `gemtexter.conf` by adding the line `declare -rx HTML_VARIANT=exact`. The HTML/CSS output changed to reflect a more exact Gemtext appearance and to respect the same spacing as you would see in the Geminispace. 

## Use of Hack webfont by default

The Hack web font is a typeface designed explicitly for source code. It's a derivative of the Bitstream Vera and DejaVu Mono lineage, but it features many improvements and refinements that make it better suited to reading and writing code.

The font has distinctive glyphs for every character, which helps to reduce confusion between similar-looking characters. For example, the characters "0" (zero), "O" (capital o), and "o" (lowercase o), or "1" (one), "l" (lowercase L), and "I" (capital i) all have distinct looks in Hack, making it easier to read and understand code at a glance.

Hack is open-source and freely available for use and modification under the MIT License.

## HTML Mastodon verification support

The following link explains how URL verification works in Mastodon:

=> https://joinmastodon.org/verification

So we have to hyperlink to the Mastodon profile to be verified and also to include a `rel='me'` into the tag. In order to do that add this to the `gemtexter.conf` (replace the URI to your Mastodon profile accordingly):

```bash
declare -xr MASTODON_URI='https://fosstodon.org/@snonux'
```

and add the following into your `index.gmi`:

```
=> https://fosstodon.org/@snonux Me at Mastodon
```

The resulting line in the HTML output will be something as follows:

```html
<a href='https://fosstodon.org/@snonux' rel='me'>Me at Mastodon</a>
```

## More

Additionally, there were a couple of bug fixes, refactorings and overall improvements in the documentation made. 

E-Mail your comments to `paul@nospam.buetow.org` :-)

Other related posts are:

<< template::inline::index gemtext gemini

=> ../ Back to the main site
