# Bash Golf Part 4

```

    '\       '\        '\                   .  .          |>18>>
      \        \         \              .         ' .     |
     O>>      O>>       O>>         .                 'o  |
      \       .\. ..    .\. ..   .                        |
      /\    .  /\     .  /\    . .                        |
     / /   .  / /  .'.  / /  .'    .                      |
jgs^^^^^^^`^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                        Art by Joan Stark, mod. by Paul Buetow
```

This is the third blog post about my Bash Golf series. This series is random Bash tips, tricks and weirdnesses I came across over time. 

<< template::inline::index bash-golf

## `FUNCNAME`

`FUNCNAME` is an array you are looking for a way to dynamically determine the name of the current function (which could be considered the callee in the context of its own execution), you can use the special variable `FUNCNAME`. This is an array variable that contains the names of all shell functions currently in the execution call stack. The element `FUNCNAME[0]` holds the name of the currently executing function, `FUNCNAME[1]` the name of the function that called that, and so on.

This is in particular useful for logging when you want to include the callee function in the log output. E.g. look at this log helper:

```bash
#!/usr/bin/env bash

log () {
    local -r level="$1"; shift
    local -r message="$1"; shift
    local -i pid="$$"

    local -r callee=${FUNCNAME[1]}
    local -r stamp=$(date +%Y%m%d-%H%M%S)

    echo "$level|$stamp|$pid|$callee|$message" >&2
}

at_home_friday_evening () {
    log INFO 'One Peperoni Pizza, please'
}

at_home_friday_evening
```

The output is as follows:


```bash
❯ ./logexample.sh
INFO|20231210-082732|123002|at_home_friday_evening|One Peperoni Pizza, please
```

## `:(){ :|:& };:`

This one may be widely known already, but I am including it here as I found a cute image illustrating it. But to break `:(){ :|:& };:` down:

* `:(){ }` is really a declaration of the function `:`
* the `;` is ending the current statement
* the `:` at the end is calling the function `:`
* `:|:&` is the function body

Let's break down the function body `:|:&`: 

* The first `:` is calling the function recursively
* The `|:` is piping the output to the function `:` again (parallel recursion)
* The `&` lets it run in the background.

So, it's a fork bomb. If you run it, your computer will run out of resources eventually. (Modern linux distributions could have reasonable limits configured for your login session, so it won't bring down your whole system anymore, unless you run it as `root`!)

And here the cute illustration:

=> ./bash-golf-part-3/bash-fork-bomb.jpg Bash fork bomb

## Inner functions

Bash defines variables as it is interpreting the code. Same applies to function declarations. Let's consider this code:

```bash
#!/usr/bin/env bash

outer() {
  inner() {
    echo 'Intel inside!'
  }
  inner
}

inner
outer
inner
```

And let's execute it:

```
❯ ./inner.sh
/tmp/inner.sh: line 10: inner: command not found
Intel inside!
Intel inside!
```

What happened? The first time, `inner` was called, it wasn't defined yet. That only happens after `outer` run. Note, that `inner` will still be globally defined. But functions can be declared multiple times (the last version wins):

```bash
#!/usr/bin/env bash

outer1() {
  inner() {
    echo 'Intel inside!'
  }
  inner
}

outer2() {
  inner() {
    echo 'Wintel inside!'
  }
  inner
}

outer1
inner
outer2
inner
```

And let's run it:

```
❯ ./inner2.sh
Intel inside!
Intel inside!
Wintel inside!
Wintel inside!
```

## Exporting functions

Ever wondered how to execute a shell function in parallel through `xargs`? The problem is, that this won't work:

```bash
#!/usr/bin/env bash

some_expensive_operations() {
  echo "Doing expensive operations with '$1' from pid $$"
}

for i in {0..9}; do echo $i; done \
  | xargs -P10 -I{} bash -c 'some_expensive_operations "{}"'
```

We try here to run ten parallel processes, each of them should run the `some_expensive_operations` function with a different argument. The arguments are provided to `xargs` through `STDIN` one per line. When executed, we get this:

```
❯ ./xargs.sh
bash: line 1: some_expensive_operations: command not found
bash: line 1: some_expensive_operations: command not found
bash: line 1: some_expensive_operations: command not found
bash: line 1: some_expensive_operations: command not found
bash: line 1: some_expensive_operations: command not found
bash: line 1: some_expensive_operations: command not found
bash: line 1: some_expensive_operations: command not found
bash: line 1: some_expensive_operations: command not found
bash: line 1: some_expensive_operations: command not found
bash: line 1: some_expensive_operations: command not found
```

There's an easy solution for this. Just export the function! It will then be magically available in any sub-shell!

```bash
#!/usr/bin/env bash

some_expensive_operations() {
  echo "Doing expensive operations with '$1' from pid $$"
}
export -f some_expensive_operations

for i in {0..9}; do echo $i; done \
  | xargs -P10 -I{} bash -c 'some_expensive_operations "{}"'
```

When we run this now, we get:

```
❯ ./xargs.sh
Doing expensive operations with '0' from pid 132831
Doing expensive operations with '1' from pid 132832
Doing expensive operations with '2' from pid 132833
Doing expensive operations with '3' from pid 132834
Doing expensive operations with '4' from pid 132835
Doing expensive operations with '5' from pid 132836
Doing expensive operations with '6' from pid 132837
Doing expensive operations with '7' from pid 132838
Doing expensive operations with '8' from pid 132839
Doing expensive operations with '9' from pid 132840
```

If `some_expensive_function` would call another function, so that other function must be exported as well. Otherwise, there will be a runtime error again. E.g., this won't work:

```bash
#!/usr/bin/env bash

some_other_function() {
  echo "$1"
}

some_expensive_operations() {
  some_other_function "Doing expensive operations with '$1' from pid $$"
}
export -f some_expensive_operations

for i in {0..9}; do echo $i; done \
  | xargs -P10 -I{} bash -c 'some_expensive_operations "{}"'
```

... because `some_other_function` isn't exported! You will need to add a `export -f some_other_function` as well!

## Dynamic variables with `local`

You may know `local` is the way to declare local variables in a function. What most don't know is, that those variables are actually with dynamic scope. Let's consider the following example:

```bash
#!/usr/bin/env bash

foo() {
  local foo=bar
  bar
  echo "$foo"
}

bar() {
  echo "$foo"
  foo=baz
}

foo
echo "$foo"
```

Let's pause a minute. What do you think the output would be?

Let's run it:

```
❯ ./dynamic.sh
bar
baz

```

What happened? The variable `foo` (declared with `local`) is available in the function it got declared, and in all other functions down the callstack! We can even modify the value of `foo` and the change will be visible up the callstack. It's not a global variable, as we can see that on the last line `echo "$foo"` only echoes an empty line.

Other related posts are:

<< template::inline::index bash

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
