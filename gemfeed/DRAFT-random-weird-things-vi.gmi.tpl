# Random Weird Things - Part Ⅳ

Every so often I stumble upon random, weird, and completely unexpected things on the internet. I thought it would be neat to share them here from time to time. This is the fourth run.

```
   /\_/\      /\_/\      /\_/\  
  ( o.o )    ( o.o )    ( o.o ) 
   > ^ <      > ^ <      > ^ <  
   /\_/\    Miaaauuuu....
  ( o.o )
   > ^ < 
```

<< template::inline::index random-weird-things

<< template::inline::toc

## 31. GUI Apps in Your Terminal

term.everything is a from-scratch Wayland compositor that renders GUI apps inside your terminal. GTK, Qt, whatever — it just grabs it and draws it right there. You can run Firefox or GIMP over SSH and interact with it using your mouse. No X forwarding, no latency nonsense. It actually works.

=> ./random-weird-things-iv/term-everything.jpg term.everything demo
=> https://github.com/mmulet/term.everything term.everything

## 32. TempleOS

Terry A. Davis spent years single-handedly building a complete 64-bit operating system from scratch because God told him to. It runs at 640×480, uses a custom language called HolyC, has its own compiler, and is designed as a temple. Boot it up and you get scripture, a talking parrot, and probably the weirdest OS you'll ever see. One of the most fascinating stories in computing.

=> ./random-weird-things-iv/templeos.png TempleOS screenshot
=> https://templeos.org TempleOS

## 33. LLM via DNS

You can query an LLM using nothing but DNS. Just run `dig @ch.at "what is golang" TXT +short` and you get back an answer in the TXT records. No browser, no API key. It even works over SSH tunnels. I tried it on a server with zero internet tools installed and it just worked.

```sh
$ dig @ch.at "what is golang" TXT +short
"Golang, or Go, is an open-source programming language developed by Google.
It was created to simplify the development of reliable and efficient software.
Go is known for its simplicity, strong concurrency support, and performance
comparable to C or C++. I" "t features garbage collection, type safety, and
built-in support for concurrent programming through goroutines and channels.
Go is widely used for web servers, cloud services, and distributed systems due
to its efficiency and ease of deployme..."
```

## 34. Black Hole in ~125 Bytes

This tiny HTML/JS snippet (under 125 bytes) renders a swirling black hole in your browser tab. No frameworks, no libraries, just code-golf magic. I stared at it way longer than I care to admit.

=> https://aem1k.com/blackhole/ Black Hole

## 35. loss32: Win32 on Linux

loss32 is a Linux distro where the entire desktop is classic Win32 apps running natively. ReactOS + WINE on steroids. You get the Windows 98/2000 vibe on a modern Linux kernel. It's not trying to be practical — it's pure nostalgia for people who miss the old Windows desktop but don't want the actual Windows.

=> ./random-weird-things-iv/loss32.png loss32 desktop screenshot
=> https://loss32.org/ loss32

## 36. LLM Rescuer 🤖💰

LLM Rescuer is a tiny Ruby wrapper that retries, sanitizes outputs, handles errors, and has some token-saving logic so you don't burn through your budget. It interprets nil references automatically based on the context. Examples:

```ruby
# Classic nil safety
user = find_user(id: "nonexistent") # returns nil
puts user.email
# AI: "Analyzing context... user seems to need an email...
#      returning 'no-reply@example.com'"

# Shopping cart magic
cart = session[:cart] # nil because session expired
total = cart.total_price
# AI: "This looks like e-commerce. Based on similar patterns,
#      I'll return 0.0 to avoid charging $nil"

# The existential crisis
meaning_of_life = nil
answer = meaning_of_life.to_i
# AI: "Clearly this should be 42. I've read Douglas Adams."
```

=> https://github.com/barodeur/llm_rescuer LLM Rescuer

## 37. Filesystem Backed by an LLM

Mount a folder, and every time you read or write a file, an LLM decides what the contents should be. Want a config file? Ask the LLM. Need a todo list that rewrites itself when you look at it? There you go. There's a working FUSE implementation. Equal parts brilliant and terrifying.

=> https://healeycodes.com/filesystem-backed-by-an-llm Filesystem Backed by an LLM

## 38. QR Code with Pure SQL in Postgres

Someone generated a full QR code using nothing but SQL queries inside PostgreSQL. No extensions, no external tools — just raw Postgres doing things it was never meant to do. I ran the example and watched a QR code materialize in the query result. Mad stuff.

=> ./random-weird-things-iv/pqr.webp QR code generated with pure SQL
=> https://tanelpoder.com/posts/generate-qr-code-with-pure-sql-in-postgres/ Pure SQL QR Code

## 39. The SL Train in Your Terminal

You mistype `ls` as `sl` and a steam locomotive comes chugging across your terminal. The SL program has been around for decades and it still cracks me up. There's even a flying train variant.

=> ./random-weird-things-iv/sl-train.gif SL train in action
=> https://github.com/mtoyoda/sl sl

## 40. URL in C Code Puzzle

The following C program compiles and runs perfectly:

```
#include <stdio.h>

int main(void) {
    https://foo.zone
    printf("hello, world\n");
    return 0;
}
```

The `https:` becomes a label, the `//foo.zone` is just a comment. C parser shenanigans.

Found something weird lately? Send me a link!

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
