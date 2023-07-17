# Gemtexter 2.1.0 - Let's Gemtext again³

```
-=[ typewriters ]=-  1/98
                                         .-------.
       .-------.                        _|~~ ~~  |_
      _|~~ ~~  |_       .-------.     =(_|_______|_)
    =(_|_______|_)=    _|~~ ~~  |_      |:::::::::|
      |:::::::::|    =(_|_______|_)     |:::::::[]|
      |:::::::[]|      |:::::::::|      |o=======.|
      |o=======.|      |:::::::[]|      `"""""""""`
 jgs  `"""""""""`      |o=======.|
  mod. by Paul Buetow  `"""""""""`
```

I proudly announce that I've released Gemtexter version `2.1.0`. What is Gemtexter? It's my minimalist static site generator for Gemini Gemtext, HTML and Markdown written in GNU Bash.

=> https://codeberg.org/snonux/gemtexter

Let's list what's new!

## Switch to GPL3 license

Many of the tools and commands (GNU Bash, GMU Sed, GNU Date, GNU Grep, GNU Source Highlight) used by `Gemtexter` are licensed under the GPL anyway. So why not use the same? This was an easy switch, as I was the only code contributor so far!

## Source code highlighting support

The HTML output now supports source code highlighting, which is pretty neat if your site is about programming. The requirement is to have the `source-highlight` command, which is GNU Source Highlight, to be installed. Once done, you can annotate a bare block with the language to be highlighted. E.g.:

```
 ```bash
 if [ -n "$foo" ]; then
   echo "$foo"
 fi
 ...
```

Please run `source-highlight --lang-list` for a list of all supported languages.

## HTML exact style

The resulting HTML has changed.

### Use of Hack webfont by default

## Mastadon verification support

## More

Additionally, there were a couple of bug fixes, refactorings and overall improvements in the documentation made. 

Other related posts are:

<< template::inline::index gemtext gemini

E-Mail your comments to paul at buetow.org :-)

=> ../ Back to the main site
