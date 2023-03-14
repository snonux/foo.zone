# The fibonacci.pl.raku.c Polyglot

> Published at 2014-03-24T21:32:53+00:00; Updated at 2022-04-23

In computing, a polyglot is a computer program or script written in a valid form of multiple programming languages, which performs the same operations or output independent of the programming language used to compile or interpret it.

[https://en.wikipedia.org/wiki/Polyglot_(computing)](https://en.wikipedia.org/wiki/Polyglot_(computing))  

## The Fibonacci numbers

For fun, I programmed my own Polyglot, which is both valid Perl, Raku, C and C++ code (I have added C++ and Raku support in 2022). The exciting part about C and C++ is that $ is a valid character to start variable names with:

```
#include <stdio.h>

#define $arg function_argument
#define my int
#define sub int
#define BEGIN int main(void)

my $arg;

sub hello() {
    printf("Hello, welcome to the Fibonacci Numbers!\n");
    printf("This program is all, valid C and C++ and Perl and Raku code!\n");
    printf("It calculates all fibonacci numbers from 0 to 9!\n\n");
    return 0;
}

sub fibonacci() {
    my $n = $arg;

    if ($n < 2) {
        return $n;
    }

    $arg = $n - 1;
    my $fib1 = fibonacci();
    $arg = $n - 2;
    my $fib2 = fibonacci();

    return $fib1 + $fib2;
}

BEGIN {
    hello();
    my $i = 0;

    while ($i <= 10) {
        $arg = $i;
        printf("fib(%d) = %d\n", $i, fibonacci());
        $i++;
    }
}
```

You can find the full source code at GitHub:

[https://codeberg.org/snonux/perl-c-fibonacci](https://codeberg.org/snonux/perl-c-fibonacci)  

### Let's run it with C and C++

```
% gcc fibonacci.pl.raku.c -o fibonacci
% ./fibonacci
Hello, welcome to the Fibonacci Numbers!
This program is all, valid C and C++ and Perl and Raku code!
It calculates all fibonacci numbers from 0 to 9!

fib(0) = 0
fib(1) = 1
fib(2) = 1
fib(3) = 2
fib(4) = 3
fib(5) = 5
fib(6) = 8
fib(7) = 13
fib(8) = 21
fib(9) = 34
fib(10) = 55

% g++ fibonacci.pl.raku.c -o fibonacci
% ./fibonacci
Hello, welcome to the Fibonacci Numbers!
This program is all, valid C and C++ and Perl and Raku code!
It calculates all fibonacci numbers from 0 to 9!

fib(0) = 0
fib(1) = 1
fib(2) = 1
fib(3) = 2
fib(4) = 3
fib(5) = 5
fib(6) = 8
fib(7) = 13
fib(8) = 21
fib(9) = 34
fib(10) = 55
```

### Let's run it with Perl and Raku

```
% perl fibonacci.pl.raku.c
Hello, welcome to the Fibonacci Numbers!
This program is all, valid C and C++ and Perl and Raku code!
It calculates all fibonacci numbers from 0 to 9!

fib(0) = 0
fib(1) = 1
fib(2) = 1
fib(3) = 2
fib(4) = 3
fib(5) = 5
fib(6) = 8
fib(7) = 13
fib(8) = 21
fib(9) = 34
fib(10) = 55

% raku fibonacci.pl.raku.c
Hello, welcome to the Fibonacci Numbers!
This program is all, valid C and C++ and Perl and Raku code!
It calculates all fibonacci numbers from 0 to 9!

fib(0) = 0
fib(1) = 1
fib(2) = 1
fib(3) = 2
fib(4) = 3
fib(5) = 5
fib(6) = 8
fib(7) = 13
fib(8) = 21
fib(9) = 34
fib(10) = 55
```

It's entertaining to play with :-).

[E-Mail your comments to hi@paul.cyou :-)](../contact.md)  

[More entries](./index.md)  
