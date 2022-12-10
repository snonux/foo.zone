# I tried Doom Emacs, but I switched back to (Neo)Vim

As a long-lasting user of Vim (and NeoVim), I always wondered what the fuzz about Emacs is about! So I decided to give Emacs a try. I tried out Emacs, but Doom Emacs and not vanilla Emacs. I chose Doom Emacs as it is a pretty neat distribution of Emacs with `Evil mode` enabled by default. `Evil mode` allows Vi(m) key bindings, and I am pretty sure I won't be ready to give up all the Vi muscle memory I have built over more than ten years.

I used Doom Emacs for around two months, but ultimately I decided to switch back to NeoVim as my primary editor and IDE and Vim as my "always available editor" for quick edits. So why is that?

## Emacs is a monster

Emacs feels like a monster as it is much more than an editor or an integrated development environment. Emacs is a whole platform on its own. There's an E-Mail client, an IRC client, or even games you can run within Emacs. And you can also change Emacs within Emacs using its own `Lisp` dialect, `Emacs Lisp`. Therefore, Emacs is also its own programming language... You can change every aspect of Emacs within Emacs. People jokingly state Emacs is an operating system and that you should directly boot into Emacs as the init 1 process!

In many aspects, Emacs is like shooting at everything with a rail gun! However, I prefer it simple. I only wanted Emacs to be a good editor (which it is, too), but there's too much other stuff in Emacs that I, frankly, don't care about! Vim and NeoVim do one thing excellent: Being great text editors and, when loaded with plugins, a decent IDEs, too. Yes, `VimScript`, to program the editor, feels clunky and is by far not as elegant as `Emacs Lisp`, but it gets its job done! NeoVim is also programmable with `Lua`, which seems to be a step up. 

## Magit love

I almost fell in love with `Magit`, a fully integrated Git client for Emacs. But I think the best way to interact with Git is to use the `git` command line directly. I don't worry about typing out all the commands, as the most commonly used commands are in my shell history. Other useful Git programs I use frequently are `bit` and `tig`. 

`Magit` is pretty neat for basic Git operations, but I found myself searching the internet for the correct sub-commands to do the things I wanted to do in Git. Mainly I found the way how branches are managed confusing. Often, I fell back to the command line to fix up the mess I produced with `Magit` (e.g. accidentally pushing to the wrong remote branch).

## Seeking simplicity

I am not ready to dive deep into the whole world of Emacs. I prefer small and simple tools as opposed to complex tools. Emacs comes with many features out of the box, whereas in Vim/NeoVim, you would need to install many plugins to replicate the behaviour. Yes, I need to invest time managing all the Vim/NeoVim plugins I use, but I feel more in control compared to Doom Emacs, where a framework around vanilla Emacs manages all the plugins. I could use vanilla Emacs and manage all my plugins the vanilla way, but for me, it's not worth the effort to learn and dive into that as all that I want to do I can already do with Vim/NeoVim.

I am not saying that Vim/NeoVim are simple programs, but they are much simpler than Emacs with much smaller footprints; furthermore, they appear to be more straightforward as I am used to them. I only need Vim/NeoVim to be an editor, an IDE (through some plugins), and nothing more.

## Scripting it

It is possible to customize every aspect of Emacs through `Emacs Lisp`. I have done some `Elk Scheme` programming in the past (a dialect of `Lisp`), but that was a long time ago, and I am not willing to dive here again to customize my environment. I would rather take the pragmatic approach and script what I need in `VimScript` (a terrible language, but it gets the job done!). I watched Damian Conway's `VimScript` course on O'Reilly Safari Books Online, which I greatly recommend.

[Scripting Vim by Damian Conway](https://www.oreilly.com/library/view/scripting-vim/9781491996287/)  

One example is my workflow of how I write blog articles. I am writing everything in NeoVim, but I also want to have every paragraph checked against Grammarly (as English is not my first language). So I write a whole paragraph, then I select the entire paragraph via visual selection with `SHIFT+v`, and then I press `,y` to yank the paragraph to the systems clipboard, then I paste the paragraph to Grammarly's browser window, let Grammarly suggest the improvements, and then I copy the result back to the system clipboard and in NeoVim I type `,i` to insert the result back overriding the old paragraph with the new content. That all sounds a bit complicated, but it's surprisingly natural and efficient.

For the clipboard integration, I use this small `VimScript` snippet, and I didn't have to dig into any `Lisp` for this:

```
" Clipboard

if uname != 'Darwin'
  vnoremap ,y !gpaste-client<CR>ugv
  vnoremap ,i !gpaste-client --use-index get 0<CR>
  nmap ,i !wgpaste-client --use-index get 0<CR>
else
  vnoremap ,y !pbcopy<CR>ugv
  vnoremap ,i !pbpaste<CR>
  nmap ,i !wpbpaste<CR>
endif
```

## The famous Org mode


Org mode: Ranger

## Conclusion

I believe I started to understand the Emacs users now. Emacs is a incredible powerful platform for almost everything not just for text editing. If you want to have one piece of software which rules it all and you are happy to invest a large part of your time in your platform: Pick Emacs and over time Emacs will become "your" Emacs, customized to your own needs which makes the Emacs users stick even more to it. With Emacs you can do nearly everything (Editing, programming, calendar scheduling and note taking, Jira integration, play games, read/write emails, browse the web, use as a calculator, generate HTML pages, configure interactive menus, jump around between every feature and every file within one single session, chat on IRC, surf the Gotherspace, ... the options are endless....).

Vim/NeoVim comes also with a very high degree of customization options, but to a lesser extreme than Emacs. If you want to have the best editor of the world, which can also be tweaked to be a decent IDE, and that's you are only looking for: Pick Vim or NeoVim! You would also need to invest a lot of time in learning, tweaking and customizing Vim/NeoVim, but I think that's a little bit more straightforward and the end-result is much more lightweight.

