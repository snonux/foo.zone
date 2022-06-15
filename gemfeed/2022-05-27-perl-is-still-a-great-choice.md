# Perl is still a great choice

[![./2022-05-27-perl-is-still-a-great-choice/regular_expressions.png](./2022-05-27-perl-is-still-a-great-choice/regular_expressions.png)](./2022-05-27-perl-is-still-a-great-choice/regular_expressions.png)  

> Published by Paul at 2022-05-27, Comic source: XKCD

Perl (the Practical Extraction and Report Language) is a battle-tested, mature, multi-paradigm dynamic programming language. Note that it's not called PERL, neither P.E.R.L. nor Pearl. "Perl" is the name of the language and "perl" the name of the interpreter or the interpreter command.

Unfortunately (it makes me sad), Perl's popularity has been declining over the last years as Google trends shows:

[![./2022-05-27-perl-is-still-a-great-choice/googletrendsperl.jpg](./2022-05-27-perl-is-still-a-great-choice/googletrendsperl.jpg)](./2022-05-27-perl-is-still-a-great-choice/googletrendsperl.jpg)  

So why is that? Once the de-facto standard super-glue language for the web nowadays seems to have a bad repetition. Often, people state:

* Perl is a write-only language. Nobody can read Perl code.
* Perl? Isn't it abandoned? It's still at version 5!
* Why use Perl as there are better alternatives?
* Why all the sigils? It looks like an exploding ASCII factory!!

## Write-only language

Is Perl really a write-only language? You have to understand that Perl 5 was released in 1994 (28 years ago as of this writing) and when we refer to Perl we usually mean Perl 5. That's many years, and there are many old scripts not following the modern Perl best practices (as they didn't exist yet). So yes, legacy scripts may be difficult to read. Japanese may be difficult to read too if you don't know Japanese, though.

To come back to the question: Is Perl a write-only language? I don't think so. Like in any other language, you have to apply best practices in order to keep your code maintainable. Some other programming languages enforce best practices, but that makes these languages less expressive. Perl follows the principles "there is more than one way to do it" (aka TIMTOWDI) and "making easy things easy and hard things possible".

Perl gives the programmer more flexibility in how to do things, and this results in a stronger learning curve than for lesser expressive languages like for example Go or Python. But, like in everything in life, common sense has to be applied. You should not take TIMTOWDI to the extreme in a production piece of code. In my personal opinion, it is also more satisfying to program in an expressive language.

Some good books on "good" Perl I can recommend are:

[Modern Perl](http://modernperlbooks.com)  
[Higher Order Perl](https://hop.perl.plover.com)  

Due to Perl's expressiveness you will find a lot of obscure code in the interweb in form of obfuscation, fancy email signatures (JAPHs), art, polyglots and even poetry in Perl syntax. But that's not what you will find in production code. That's only people having fun with the language which is different to "getting things done". The expressiveness is a bonus. It makes the Perl programmers love Perl.

[JAPH](https://en.wikipedia.org/wiki/Just_another_Perl_hacker)  
[http://www.cpan.org/misc/japh](http://www.cpan.org/misc/japh)  
[Perl Poetry](https://www.perlmonks.org/index.pl?next=20;node_id=1590)  

Even I personally have written some poetry in Perl and experimented with a polyglot script:

[My very own Perl Poetry](./2008-06-26-perl-poetry.md)  
[A Perl-Raku-C polyglot generating the Fibonacci sequence](./2014-03-24-the-fibonacci.pl.c-polyglot.md)  

This all doesn't mean that you can't "get things done" with Perl. Quite the opposite is the case. Perl is a very pragmatic programming language and is suitable very well for rapid prototyping and any kind of small to medium-sized scripts and programs. You can write large enterprise scale application in Perl too, but that wasn't the original intend of why Perl was invented (more on that later).

## Is Perl abandoned?

As I pointed out in the previous section, Perl 5 is around for quite some time without any new major version released. This can lead to the impression that development is not progressing and that the project is abandoned. Nothing can be further from the truth. Perl 5.000 was released in 1994 and the latest version (as of this writing) Perl 5.34.1 was released two months ago in 2022. You can check the version history on Wikipedia. You will notice releases being made regularly:

[Perl 5 version history](https://en.wikipedia.org/wiki/Perl_5_version_history)  

As you can see, Perl 5 is under active development. Actually, Perl is a family of two high-level, general-purpose, interpreted, dynamic programming languages. "Perl" refers to Perl 5, but from 2000 to 2019 it also referred to its redesigned "sister language", Perl 6, before the latter's name was officially changed to Raku in October 2019 as the differences between Perl 5 and Perl 6 were too groundbreaking. Raku would be a different topic (mostly out of scope of this blog article) but I at least wanted it to mention here. In my opinion, Raku is the "most powerful" programming language out there (I recently started learning it and intend to use it for some of my future personal programming projects):

[The Raku Programming Language](https://raku.org)  

So it means that Perl and Raku now exist in parallel. They influence each other, but are different programming languages now. So why not just all use Raku instead of Perl? There are still a couple of reasons of why to choose Perl over Raku:

* Many programmers already know Perl and many scripts are already written in Perl. It's possible to call Perl code from Raku (either inline or as a library) and it is also possible to auto-convert Perl code into Raku code, but that's either a workaround or involves some kind of additional work.
* Perl 5 comes with a great backwards compatibility. Perl scripts from 5.000 will generally still work on a recent version of Perl. New features usually have to be enabled via a so-called "use pragmas". For example, in order to enable sub signatures, "use signatures;" has to be specified.
* Perl is pre-installed almost everywhere. Fancy running a quick one-off script? In almost all cases, there's no need to install Perl first - it's already there on almost any Linux or *BSD or Unix or other Unix like operating system!
* Perl has been ported to "zillions" of platforms. One day I found myself on a VMS box. Perl doesn't come installed by default on VMS, but the admin installed Perl there already. The whole operating system was very strange to me, but I was able to write "shell scripts" in Perl and became productive pretty quickly on VMS without knowing almost anything about VMS :-).
* Perl is reliable. It has been proven itself "millions" of times, over and over again. Large enterprises, such as booking.com, heavily rely on Perl. Did you know that the package manager of the OpenBSD operating system is programmed in Perl, too?
* Perl is a great language to program in (given that you follow the modern best practices). Don't get confused when Perl is doing some things differently than other programming languages.

[Perl feature pragmas](https://perldoc.perl.org/feature)  
[The OpenBSD Operating System](https://www.OpenBSD.org)  
[Why does OpenBSD still include Perl in its base installation?](https://news.ycombinator.com/item?id=23360338)  

The renaming of Perl 6 to Raku has now opened the door for a future Perl 7. As far as I understand, Perl 7 will be Perl 5 but with modern features enabled by default (e.g. pragmas "use strict; use warnings; use signatures;" and so on. Also, the hope is that a Perl 7 with modern standards will attract more beginners. There aren't many Perl jobs out there nowadays. That's mostly due to Perl's bad (bad for no real reasons) repetition.

[Announcing Perl 7](https://www.perl.com/article/announcing-perl-7/)  
[What happened to Perl 7? (maybe have to use "use v7;")](http://blogs.perl.org/users/psc/2022/05/what-happened-to-perl-7.html)  

## Why use Perl as there are better alternatives?

Here, common sense must be applied. I don't believe there is anything like "the perfect" programming language. Everyone has got his preferred (or a set of preferred) programming language to chose from. All programming languages come with their own set of strengths and weaknesses. These are the strengths making Perl shine, and you (technically) don't need to bother to look for "better" alternatives:

* Perl is better than Shell/awk/sed scripts. There's a point where shell scripts become fairly complex. The next step-up is to switch to Perl. There are many different versions of shells and awk and sed interpreters. Do you always know which versions (mawk, nawk, gawk, sed, gsed, ...) are currently installed? These commands aren't fully compatible to each other. However, there is only one Perl 5. Simply: Perl is faster, more powerful, more expressive than any shell script can ever be, and it is also extendible through CPAN. Perl can directly talk to databases, which shell scripts can't.
* Perl code tends to be compact so that it's much better suitable for "shell scripting" and quick "one-liners" than other languages. In my own experience: Ruby and Python code tends to blow up quickly. It doesn't mean that Ruby and Python are not suitable for this task, but I think Perl does much better.
* Perl 5 has proven itself for decades and is a very stable/robust language. It is a battle-tested and mature as something can ever become.
* Perl is the reference standard for regular expressions. Even so much that there is a PCRE library (Perl Compatible Regular Expressions) used by many other languages now. Perl fully integrates regular expression syntax into the language, which doesn't feel like an odd add-on like in most other languages.
* Perl 5 is the master of text processing (well, maybe after Raku now. But you might not have the latest Raku available everywhere). The chief objective of developing the language was for text processing, and this is where Perl (Practical extraction and report language) really shines.
* Perl is a "deep" language. That means Perl got a lot of features and syntactic sugar and magic. Depending on the perspective, this could be interpreted as a downside too. But IMHO mastery of a "deep" language brings big rewards. The code can be very compact, and it is fun to code in it.
* Perl is the only language I know which can do "taint checking". Running a script in taint mode makes Perl sanitize all external input and that's a great security feature. Ruby used to have this feature too, but it got removed (as I understand there were some problems with the implementation not completely safe and it was easier just to remove it from the language than to fix it).

About the first point, using Perl for better "shell" scripts was actually the original intend of why Perl was invented in the first place.

[Perl one-liners](https://nostarch.com/perloneliners)  
[Mastering Regular Expressions](http://regex.info/book.html)  
[Taint checking](https://en.wikipedia.org/wiki/Taint_checking)  

Here are some reasons why not to chose Perl and look for "better" alternatives:

* If performance is your main objectives, then Perl might not be the language to use. Perl is a dynamic interpreted language, and it will generally never be as fast as statically typed languages compiled to native binaries (e.g. C/C++/Rust/Haskell) or statically typed languages run in a VM with JIT (e.g. Java) or gradually typed languages run in a VM (e.g. Raku) or languages like Golang (statically typed, compiled to a binary but still with a runtime in the binary). Perl might be still faster than the other language listed here in certain circumstances (e.g. faster startup time than Java), but usually it's not. It's not a problem of Perl, it's a problem of all dynamic scripting languages including Python, Ruby, ....
* Don't use Perl (just yet) if you want to code object-oriented. Perl supports OOP, but it feels clunky and odd to use (blessed references to any data types are objects) and doesn't support real encapsulation out of the box. There are many (many) extensions available on CPAN to make OOP better, but that's totally fragmented. The most popular extension, Moose, comes with a huge dependency tree. But wait for Perl 7. It will maybe come with a new object system (an object system inspired by Raku).
* It's possible to write large programs in Perl (make difficult things possible), but it might not be the best choice here. This also leads back to the clunky object system Perl has. You could write your projects in a procedural or functional style (Perl perfectly fits here), but OOP seems to be the gold standard for large projects nowadays. Functional programming requires a different mindset, and pure procedural programming lacks abstractions.
* Apply common sense. What is the skill set your team has? What's already widely used and supported at work? Which languages comes with the best modules for the things you want to work on? Maybe Python is the answer (better machine learning modules). Maybe Perl is the better choice (better Bioinformatic modules). Perhaps Ruby is already the de-facto standard at work and everyone knows at least a little Ruby (as it happened to be at my workplace) and Ruby is "good enough" for all the tasks already. But that's not a hindrance to throw in a Perl one-liner once in a while :P.

[Cor - A minimal object system for the Perl core - proposal](https://gist.github.com/Ovid/68b33259cb81c01f9a51612c7a294ede)  

## Why all the sigils? It looks like an exploding ASCII factory!!

The sigils $ @ % & (where Perl is famously known for) serve a purpose. They seem confusing at first, but they actually make the code better readable. $scalar is a scalar variable (holding a single value), @array is an array (holding a list of values), %hash holds a list of key-value pairs and &sub is for subroutines. A given variable $ref can also hold reference to something. @$arrayref dereferences a reference to an array, %$hashref to a hash, $$scalarref to a scalar, &$subref dereferences a referene to a subroutine, etc. That can be encapsulated as deep as you want. (This paragraph only scratched the surface here of what Perl can do, and there is a lot of syntactic sugar not mentioned here).

In most other programming languages, you won't know instantly what's the "basic type" of a given variable without looking at the variable declaration or the variable name (If named intelligently, e.g. a variable name containing a list of socks is "sock_list"). Even Ruby makes some use of sigils (@ @@ an $), but that's for a different purpose than in Perl (in Ruby it is about object scope, class scope and global scope). Raku uses all the sigils Perl uses plus an additional bunch of twigils, e.g. $.foo for a scalar object variable with public accessors, $!foo for a private scalar object variable, @.foo, @!foo, %.foo, %!foo and so on. Sigils (and twigils) are very convenient once you get used to them. Don't let them scare you off - they are there to help you!

[https://www.perl.com/article/on-sigils/](https://www.perl.com/article/on-sigils/)  

## Where do I personally still use perl?

* I use Rexify for my OpenBSD server automation. Rexify is a configuration management system developed in Perl with similar features to Ansible but less bloated. It suits my personal needs perfectly.
* I have written a couple of smaller to medium-sized Perl scripts which I (mostly) still use regularly. You can find them on my Codeberg page.
* My day-to-day workflow heavily relies on "ack-grep". Ack is a tool developed in Perl aimed at programmers and can be used for quick searches on source code at the command line.
* I aim to leave my OpenBSD servers as "vanilla" as possible (trying to rely only on the standard/base installation without installing additional software from the packaging system or ports tree). All my scripts are written either Bourne shell or in Perl here. So there is no need to install additional interpreters.
* Here and there, I drop a Perl one-liner in order to get stuff done (work and personally). A wise Perl Monk would say: "One one-liner a day keeps the troubles away".

Btw.: Did you know that the first version of PHP was a set of Perl snippets? Only later, PHP became an independent programming language.

[https://www.perl.org](https://www.perl.org)  

E-Mail me your comments to paul at buetow dot org!

[Go back to the main site](../)  


