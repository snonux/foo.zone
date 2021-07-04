# The Well-Grounded Rubyist

> Written by Paul Buetow 2021-07-04

When I was a Linux System Administrator, I have been programming in Perl for years. I still maintain some personal Perl programming projects (e.g. Xerl, guprecords, Loadbars). After switching jobs a couple of years ago (becoming a Site Reliability Engineer), I found Ruby (and some Python) widely used there. As I wanted to do something new, I then decided to give Ruby a go for all medium-sized programming and scripting projects.

You should learn or try out one new programming language once yearly anyway. If you end up not using the new language, that's not a problem. You will have gained experience and insights into different ways of thinking with each new programming language. Also, having some background in similar programming languages makes it reasonably easy to get started. Besides that, learning a new programming language is fun.

=> ./2021-07-04-the-well-grounded-rubyist/book-cover.jpg
=> ./2021-07-04-the-well-grounded-rubyist/book-backside.jpg

Superficially, Perl seems to have many similarities to Ruby (but, of course, it is entirely different to Perl when you look closer), which pushed me towards Ruby instead of Python. I have tried Python a couple of times before, and I managed to write good code, but I never felt satisfied with the language. I didn't love the syntax, especially the indentations used; they always confused me. I don't dislike Python, but I don't prefer to program in it if I have a choice, especially when there are more propelling alternatives available. 

Yukihiro Matsumoto, inventor of Ruby said: "I wanted a scripting language that was more powerful than Perl and more object-oriented than Python" - So I can see where some of the similarities come from. I personally don't believe that Ruby is more powerful than Perl, though, especially when you take CPAN and/or Perl 6 (now known as Raku) into the equation. But I want to stay pragmatic and use what's already used at my workplace.

Being stuck in Ruby-mediocrity

I wrote a lot of Ruby code over the last couple of years. There were many small to medium-sized tools and other projects such as Nagios monitoring checks, even an internal monitoring & reporting site based on Sinatra. All Ruby scripts I wrote do their work well; I didn't encounter any significant problems using Ruby for any of these tasks. Of course, there's nothing that couldn't be written in Perl (or Python), though, after all, these languages are all Turing-complete :-).

I don't use Ruby for all programming projects, though. 

* I am using Bash for small scripts and ad-hoc command-line automation.
* I program in Google Go on more comprehensive tools (e.g. DTail) and for solving problems involving data crunching.
* Occasionally, I write some lines of Java code for minor feature enhancements and fixes to improve the reliability of some the services.
* Occasionally, I still program in good old C. This is for special projects (e.g. I/O Riot) or low-level PoCs.

For all other in-between tasks I mainly use the Ruby programming language (unless I decide to give something new a shot once in a while).

As a Site Reliability Engineer there were many tasks and problems to be solved as efficiently and quickly as possible and, of course, without bugs. So I learned Ruby relatively fast by doing and the occasional web search for "how to do thing X", and I was eager to get the problem at hand done. I never read a whole book or took a course on Ruby. As a result, I found myself writing Ruby in a Perl-ish procedural style (with Perl, you can do object-oriented programming too, but Perl wasn't designed from the ground up to be an object-oriented language). I didn't take advantage of all the specialities Ruby has to offer as I invested most of my time in the problem at hand and not at what is the Ruby idiomatic way of programming. (An unexpected benefit was that my Ruby code was easy to follow and extend or fix, even by people who usually don't speak Ruby, as there wasn't too much magic involved in my code - however, I could have done still better).

Looking at other Ruby projects, I noticed over time that there is so much more to the language I wanted to explore. New techniques and Ruby best practise, and much more knowledge about how things work under the hood.

O'Reilly Safari Books Online

I do have an O'Reilly Safari Online subscription (thank you, employer). To my liking, I found the "The Well-Grounded Rubyist" book there (the text version and also the video version of it). I watched the video version for a couple of weeks, chunking the content into small pieces so it was able to fit into my schedule, increasing the playback speed for the topics I knew already well enough and slowed it down to actual pace when there was something new to learn and occasionally jumped back to the text book to review what I just learned. To my satisfaction, I was already familiar with over half of the language. But there was still the big chunk, especially how the magic happens under the hood in Ruby, which I missed out on, but I am happy now to be aware of it now.

I also loved the occasional dry humour in the book: "An enumerator is like a brain in a science fiction movie, sitting on a table with no connection to a body but still able to think". :-)

Will I rewrite and refactor all of my existing Ruby programs? Probably not, as they all do their work as intended. Some of these scripts will be eventually replaced or retired. But depending on the situation, I might refactor a module, class or a method or two once in a while. I already knew how to program in an object-oriented style from other languages (e.g. Java, C++, Perl Moose and plain) before I started Ruby, so my existing Ruby code is not as bad as you might assume after reading this article :-). In contrast to Java/C++, Ruby is a dynamic language, and the idiomatic ways of doing things differs from statically typed languages.

# Key takeaways

## "Everything" is an object

In Ruby, everything is an object. However, Ruby is not Smalltalk. It depends on what you mean by "everything". Fixnums are objects. Classes also are, as instances of class Class. Methods, operators and blocks aren't but can be wrapped by objects via a "Proc". A simple assignment is not and can't. Statements like "while" also aren't and can't. Comments obviously also fall in the latter group. Ruby is more object-oriented than everything else I have ever seen, except for Smalltalk.

In Ruby, like in Java/C++, classes are classes, objects are instances of classes, and there are class inheritances. There is single inheritance in Ruby, but with the power of mixing in modules, you can extend your classes in a better way than multiple class inheritances (like in C++) would allow. It's also different to Java interfaces, as interfaces in Java only come with the method prototypes and not with the actual method implementations like Ruby modules.

## "Normal" objects and singleton objects

In Ruby, you can also have singleton objects. A singleton object can be an instance of a class but be modified after its creation (e.g. a method added to only this particular instance after its instantiation). Or, another variant of a singleton object is a class (yes, classes are also objects in Ruby). All of that is way better described in the Ruby book, so have a read by yourself if you are confused now; just remember: Rubys object system is very dynamic and flexible. At runtime, you can add and modify classes, objects of classes, singleton objects and modules. You don't need to restart the Ruby interpreter; you can change the code during runtime dynamically through Ruby code.

## Ruby is "self-ish"

Ruby will fall back to the default "self" object if you don't specify an object method receiver. To give you an example, some more explanation is needed: There is the "Kernel" module mixed into almost every Ruby object. The method "puts" is just a method of "Kernel". When you write "puts :foo", Ruby sends the message "puts" to the current object "self". The class of object "self" is "Object". Class Object has module "Kernel" mixed in, and "Kernel" defines the method "puts". 

```
>> self
=> main
>> self.class
=> Object
>> self.class.included_modules
=> [PP::ObjectMixin, Kernel]
>> Kernel.class
=> Module
>> Kernel.methods.grep(/puts/)
=> [:puts]
>> puts 'Hello Ruby'
Hello Ruby
=> nil
```

Ruby offers a lot of syntactic sugar and seemingly magic, but it all comes back to objects and messages to objects under the hood. As all is hidden win objects, you can unwrap and even change the magic and see what's happening under the hood.

## Functional programming

Ruby embraces an object-oriented programming style. But there is good news for fans of the functional programming paradigm: From immutable data (frozen objects), pure functions, lambdas and higher-order functions, lazy evaluation, tail-recursion optimization, method chaining, currying and partial function application, all of that is there. I am delighted about that, as I am a big fan of functional programming (having played with Haskell and Standard ML already).

Remember, however, that Ruby is not a pure functional programming language. You, as a programmer, need to explicitly decide when to apply a functional style, as, by heart, Ruby is designed to be an object-oriented language. The language will not enforce side effect avoidance, and you will have to enable tail-recursion optimization (as of Ruby 2.5) explicitly, and variables/objects aren't immutable by default either. But that all does not hinder you from using these features. 

I liked this book so much so that I even bought myself a (used) paper copy of it. To my delight, there was also a free eBook version in ePub format included, which I now have on my Kobo Forma eBook reader. :-)

E-Mail me your thoughts at comments@mx.buetow.org!

[Go back to the main site](../)  
