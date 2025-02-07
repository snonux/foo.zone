# Random Weird Things - Part Ⅱ

Every so often, I come across random, weird, and unexpected things on the internet. I thought it would be neat to share them here from time to time. This is the second run.

<< template::inline::index random-weird-things

```
/\_/\           /\_/\
( o.o ) WHOA!! ( o.o )
> ^ <           > ^ <
/   \    MOEEW! /   \
/______\       /______\
```

<< template::inline::toc

## 11. Go functions can have methods

Have a look at this snippet:

```go
package main

import "log"

type fun func() string

func (f fun) Bar() string {
        return "Bar"
}

func main() {
        var f fun = func() string {
                return "Foo"
        }
        log.Println("Example 1: ", f())
        log.Println("Example 2: ", f.Bar())
        log.Println("Example 3: ", fun(f.Bar).Bar())
        log.Println("Example 4: ", fun(fun(f.Bar).Bar).Bar())
}
```

It runs just fin:

```sh
❯ go run main.go
2025/02/07 22:56:14 Example 1:  Foo
2025/02/07 22:56:14 Example 2:  Bar
2025/02/07 22:56:14 Example 3:  Bar
2025/02/07 22:56:14 Example 4:  Bar
```

## 12. ß and ss are treated the same on MacOS X

Know german? In german, there is the "sarp s", written ß. ß is treated the same as ss on MacOS X.

On a case-insensitive file system like MacOS X, not only are uppercase and lowercase letters treated the same, but non-Latin characters like the German "ß" are also considered equivalent to their Latin counterparts (in this case, "ss").

So, even though "Maß" and "Mass" are not strictly equivalent, the MacOS X file system still treats them as the same filename due to its handling of Unicode characters. This can sometimes lead to unexpected behavior:

```sh
❯ touch Maß
❯ ls -l
-rw-r--r--@ 1 paul  wheel  0 Feb  7 23:02 Maß
❯ touch Mass
❯ ls -l
-rw-r--r--@ 1 paul  wheel  0 Feb  7 23:02 Maß
❯ rm Mass
❯ ls -l

❯ touch Mass
❯ ls -ltr
-rw-r--r--@ 1 paul  wheel  0 Feb  7 23:02 Mass
❯ rm Maß
❯ ls -l

```

## 13. Polyglots - programs written in multiple languages

A coding polyglot is a program or script that is written in such a way that it can be executed in multiple programming languages without modification. This is typically achieved by leveraging syntax overlaps or crafting code that is valid and meaningful in each targeted language. Polyglot programs are often created as a challenge or for demonstration purposes to showcase language similarities or clever coding techniques.

Check out my very own polyglot:

=> ./2014-03-24-the-fibonacci.pl.c-polyglot.gmi The `fibonatti.pl.c` Polyglot

## 14. Languages, where indices start at 1

Array indices start at 1 instead of 0 in some programming languages, which is known as one-based indexing. This can be controversial because zero-based indexing is more common in popular languages like C, C++, Java, and Python. One-based indexing can lead to off-by-one errors when developers switch between languages with different indexing schemes.

Languages with One-Based Indexing:

*  Fortran
*  MATLAB
*  Lua
*  R (for vectors and lists)
*  Smalltalk
*  Julia (by default, although zero-based indexing is also possible)

`foo.lua` example:

```lua
arr = {10, 20, 30, 40, 50}
print(arr[1]) -- Accessing the first element
````

```sh
❯ lua foo.lua
10
```

One-based indexing is more natural for human-readable, mathematical, and theoretical contexts, where counting traditionally starts from one.

## 15. Perl Poetry

Perl Poetry is a playful and creative practice within the programming community where Perl code is written in the form of a poem. These poems are crafted to be both syntactically valid Perl code and to make sense as poetic text, often with whimsical or humorous intent. This showcases Perl's flexibility and expressiveness, as well as the creativity of its programmers.

See this Peotry of my own:

```perl
# (C) 2006 by Paul C. Buetow

Christmas:{time;#!!!

Children: do tell $wishes;

Santa: for $each (@children) { 
BEGIN { read $each, $their, wishes and study them; use Memoize#ing

} use constant gift, 'wrapping'; 
package Gifts; pack $each, gift and bless $each and goto deliver
or do import if not local $available,!!! HO, HO, HO;

redo Santa, pipe $gifts, to_childs;
redo Santa and do return if last one, is, delivered; 

deliver: gift and require diagnostics if our $gifts ,not break;
do{ use NEXT; time; tied $gifts} if broken and dump the, broken, ones;
The_children: sleep and wait for (each %gift) and try { to => untie $gifts };

redo Santa, pipe $gifts, to_childs;
redo Santa and do return if last one, is, delivered; 

The_christmas_tree: formline s/ /childrens/, $gifts;
alarm and warn if not exists $Christmas{ tree}, @t, $ENV{HOME};  
write <<EMail
 to the parents to buy a new christmas tree!!!!111
 and send the
EMail
;wait and redo deliver until defined local $tree;

redo Santa, pipe $gifts, to_childs;
redo Santa and do return if last one, is, delivered ;}

END {} our $mission and do sleep until next Christmas ;}

__END__

This is perl, v5.8.8 built for i386-freebsd-64int
```

=> ./2008-06-26-perl-poetry.gmi More Perl Poetry of mine

## 16. CSS3 is turing complete

CSS3 is turing complete https://stackoverflow.com/questions/2497146/is-css-turing-complete

### 17. MacOS X colon as file path separator

MacOS x colon as file path separator https://social.jvns.ca/@b0rk/113041293527832730
and https://narrativ.es/@janl/113041301678495651

### 18. SQLite codebase is a gem

sqlite codebase is a gem https://wetdry.world/@memes/112717700557038278


### 19. The biggest shell programs 
The Biggest Shell Programs in the World https://github.com/oils-for-unix/oils/wiki/The-Biggest-Shell-Programs-in-the-World via @wallabagapp


### Official Go font

I hope you had some fun. E-Mail your comments to `paul@nospam.buetow.org` :-)

other related posts are:

=> ../ Back to the main site
