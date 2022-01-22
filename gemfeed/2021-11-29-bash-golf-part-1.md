# Bash Golf Part 1

```

     '\                   .  .                        |>18>>
       \              .         ' .                   |
      O>>         .                 'o                |
       \       .                                      |
       /\    .                                        |
      / /  .'                                         |
jgs^^^^^^^`^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                            Art by Joan Stark
```

> Published by Paul Buetow 2021-11-29, last updated 2022-01-05

This is the first blog post about my Bash Golf series. This series is about random Bash tips, tricks and weirdnesses I came across. It's a collection of smaller articles I wrote in an older (in German language) blog, which I translated and refreshed with some new content.

[Bash Golf Part 1 (you are reding this atm.)](./2021-11-29-bash-golf-part-1.md)  
[Bash Golf Part 2](./2022-01-01-bash-golf-part-2.md)  

## TCP/IP networking

You probably know the Netcat tool, which is a swiss army knife for TCP/IP networking on the command line. But did you know that the Bash natively supports TCP/IP networking?

Have a look here how that works:

```
❯ cat < /dev/tcp/time.nist.gov/13

59536 21-11-18 08:09:16 00 0 0 153.6 UTC(NIST) *
```

The Bash treats /dev/tcp/HOST/PORT in a special way so that it is actually establishing a TCP connection to HOST:PORT. The example above redirects the TCP output of the time-server to cat and cat is printing it on standard output (stdout).

A more sophisticated example is firing up an HTTP request. Let's create a new read-write (rw) file descriptor (fd) 5, redirect the HTTP request string to it, and then read the response back:

```
❯ exec 5<>/dev/tcp/google.de/80
❯ echo -e "GET / HTTP/1.1\nhost: google.de\n\n" >&5
❯ cat <&5 | head
HTTP/1.1 301 Moved Permanently
Location: http://www.google.de/
Content-Type: text/html; charset=UTF-8
Date: Thu, 18 Nov 2021 08:27:18 GMT
Expires: Sat, 18 Dec 2021 08:27:18 GMT
Cache-Control: public, max-age=2592000
Server: gws
Content-Length: 218
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
```

You would assume that this also works with the ZSH, but it doesn't. This is one of the few things which don't work with the ZSH but in the Bash. There might be plugins you could use for ZSH to do something similar, though.

## Process substitution

The idea here is, that you can read the output (stdout) of a command from a file descriptor:

```
❯ uptime # Without process substitution
 10:58:03 up 4 days, 22:08,  1 user,  load average: 0.16, 0.34, 0.41

❯ cat <(uptime) # With process substitution
 10:58:16 up 4 days, 22:08,  1 user,  load average: 0.14, 0.33, 0.41

❯ stat <(uptime)
  File: /dev/fd/63 -> pipe:[468130]
  Size: 64              Blocks: 0          IO Block: 1024   symbolic link
Device: 16h/22d Inode: 468137      Links: 1
Access: (0500/lr-x------)  Uid: ( 1001/    paul)   Gid: ( 1001/    paul)
Context: unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
Access: 2021-11-20 10:59:31.482411961 +0000
Modify: 2021-11-20 10:59:31.482411961 +0000
Change: 2021-11-20 10:59:31.482411961 +0000
 Birth: -
```

This example doesn't make any sense practically speaking, but it clearly demonstrates how process substitution works. The standard output pipe of "uptime" is redirected to an anonymous file descriptor. That fd then is opened by the "cat" command as a regular file.

A useful use case is displaying the differences of two sorted files:

```
❯ echo a > /tmp/file-a.txt
❯ echo b >> /tmp/file-a.txt
❯ echo c >> /tmp/file-a.txt
❯ echo b > /tmp/file-b.txt
❯ echo a >> /tmp/file-b.txt
❯ echo c >> /tmp/file-b.txt
❯ echo X >> /tmp/file-b.txt
❯ diff -u <(sort /tmp/file-a.txt) <(sort /tmp/file-b.txt)
--- /dev/fd/63  2021-11-20 11:05:03.667713554 +0000
+++ /dev/fd/62  2021-11-20 11:05:03.667713554 +0000
@@ -1,3 +1,4 @@
 a
 b
 c
+X
❯ echo X >> /tmp/file-a.txt # Now, both files have the same content again.
❯ diff -u <(sort /tmp/file-a.txt) <(sort /tmp/file-b.txt)
❯
```

Another example is displaying the differences of two directories:

```
❯ diff -u <(ls ./dir1/ | sort) <(ls ./dir2/ | sort)
```

More (Bash golfing) examples:

```
❯ wc -l <(ls /tmp/) /etc/passwd <(env)
     24 /dev/fd/63
     49 /etc/passwd
     24 /dev/fd/62
     97 total
❯

❯ while read foo; do
>    echo $foo
> done < <(echo foo bar baz)
foo bar baz
❯
```

So far, we only used process substitution for stdout redirection. But it also works for stdin. The following two commands result into the same outcome, but the second one is writing the tar data stream to an anonymous file descriptor which is substituted by the "bzip2" command reading the data stream from stdin and compressing it to its own stdout, which then gets redirected to a file:

```
❯ tar cjf file.tar.bz2 foo
❯ tar cjf >(bzip2 -c > file.tar.bz2) foo
```

Just think a while and see whether you understand fully what is happening here.

## Grouping

Command grouping can be quite useful for combining the output of multiple commands:

```
❯ { ls /tmp; cat /etc/passwd; env; } | wc -l
97
❯ ( ls /tmp; cat /etc/passwd; env; ) | wc -l
97
```

But wait, what is the difference between curly braces and normal braces? I assumed that the normal braces create a subprocess whereas the curly ones don't, but I was wrong:

```
❯ echo $$
62676
❯ { echo $$; }
62676
❯ ( echo $$; )
62676
```

One difference is, that the curly braces require you to end the last statement with a semicolon, whereas with the normal braces you can omit the last semicolon:

```
❯ ( env; ls ) | wc -l
27
❯ { env; ls } | wc -l
>
> ^C
```

In case you know more (subtle) differences, please write me an E-Mail and let me know.

> Update: A reader sent me an E-Mail and pointed me to the Bash manual page, which explains the difference between () and {} (I should have checked that by myself):

```
(list) list is executed in a subshell environment (see COMMAND EXECUTION ENVIRONMENT
       below).   Variable  assignments  and builtin commands that affect the shell's
       environment do not remain in effect after the command completes.  The  return
       status is the exit status of list.

{ list; }
       list  is simply executed in the current shell environment.  list must be ter‐
       minated with a newline or semicolon.  This is known as a group command.   The
       return  status  is the exit status of list.  Note that unlike the metacharac‐
       ters ( and ), { and } are reserved words and must occur where a reserved word
       is  permitted  to  be recognized.  Since they do not cause a word break, they
       must be separated from list by whitespace or another shell metacharacter.
```

So I was right that () is executed in a subprocess. But why does $$ not show a different PID? Also here (as pointed out by the reader) is the answer in the manual page:

```
$      Expands to the process ID of the shell.  In a () subshell, it expands to  the
       process ID of the current shell, not the subshell.
```

If we want print the subprocess PID, we can use the BASHPID variable:

```
❯ echo $BASHPID; { echo $BASHPID; }; ( echo $BASHPID; )
1028465
1028465
1028739
```

## Expansions

Let's start with simple examples:

```
❯ echo {0..5}
0 1 2 3 4 5
❯ for i in {0..5}; do echo $i; done
0
1
2
3
4
5
```

You can also add leading 0 or expand to any number range:

```
❯ echo {00..05}
00 01 02 03 04 05
❯ echo {000..005}
000 001 002 003 004 005
❯ echo {201..205}
201 202 203 204 205
```

It also works with letters:

```
❯ echo {a..e}
a b c d e
```

Now it gets interesting. The following takes a list of words and expands it so that all words are quoted:

```
❯ echo \"{These,words,are,quoted}\"
"These" "words" "are" "quoted"
```

Let's also expand to the cross product of two given lists:

```
❯ echo {one,two}\:{A,B,C}
one:A one:B one:C two:A two:B two:C
❯ echo \"{one,two}\:{A,B,C}\"
"one:A" "one:B" "one:C" "two:A" "two:B" "two:C"
```

Just because we can:

```
❯ echo Linux-{one,two,three}\:{A,B,C}-FreeBSD
Linux-one:A-FreeBSD Linux-one:B-FreeBSD Linux-one:C-FreeBSD Linux-two:A-FreeBSD Linux-two:B-FreeBSD Linux-two:C-FreeBSD Linux-three:A-FreeBSD Linux-three:B-FreeBSD Linux-three:C-FreeBSD
```

## - aka stdin and stdout placeholder

Some commands and Bash builtins use "-" as a placeholder for stdin and stdout:

```
❯ echo Hello world
Hello world
❯ echo Hello world | cat -
Hello world
❯ cat - <<ONECHEESEBURGERPLEASE
Hello world
ONECHEESEBURGERPLEASE
Hello world
❯ cat - <<< 'Hello world'
Hello world
```

Let's walk through all three examples from the above snippet:

* The first example is obvious (the Bash builtin "echo" prints its arguments to stdout).
* The second pipes "Hello world" via stdout to stdin of the "cat" command. As cat's argument is "-" it reads its data from stdin and not from a regular file named "-". So "-" has a special meaning for cat.
* The third and fourth examples are interesting as we don't use a pipe as of "|" but a so-called HERE-document and a HERE-string. But the end results are the same.

The "tar" command understands "-" too. The following example tars up some local directory and sends the data to stdout (this is what "-f -" commands it to do). stdout then is piped via an SSH session to a remote tar process (running on buetow.org) and reads the data from stdin and extracts all the data coming from stdin (as we told tar with "-f -") on the remote machine:

```
❯ tar -czf - /some/dir | ssh hercules@buetow.org tar -xzvf - 
```

This is yet another example of using "-", but this time using the "file" command:

```
$ head -n 1 grandmaster.sh
#!/usr/bin/env bash
$ file - < <(head -n 1 grandmaster.sh)
/dev/stdin: a /usr/bin/env bash script, ASCII text executable
```

Some more golfing:

```
$ cat -
hello
hello
^C
$ file -
#!/usr/bin/perl
/dev/stdin: Perl script text executable
```

## Alternative argument passing

This is a quite unusual way of passing arguments to a Bash script:

```
❯ cat foo.sh
#/usr/bin/env bash
declare -r USER=${USER:?Missing the username}
declare -r PASS=${PASS:?Missing the secret password for $USER}
echo $USER:$PASS
```

So what we are doing here is to pass the arguments via environment variables to the script. The script will abort with an error when there's an undefined argument.

```
❯ chmod +x foo.sh
❯ ./foo.sh
./foo.sh: line 3: USER: Missing the username
❯ USER=paul ./foo.sh
./foo.sh: line 4: PASS: Missing the secret password for paul
❯ echo $?
1
❯ USER=paul PASS=secret ./foo.sh
paul:secret
```

You have probably noticed this *strange* syntax:

```
❯ VARIABLE1=value1 VARIABLE2=value2 ./script.sh
```

That's just another way to pass environment variables to a script. You can write it as well as like this:

```
❯ export VARIABLE1=value1
❯ export VARIABLE2=value2
❯ ./script.sh
```

But the downside of it is that the variables will also be defined in your current shell environment and not just in the scripts sub-process.

## : aka the null command

First, let's use the "help" Bash built-in to see what it says about the null command:

```
❯ help :
:: :
    Null command.

    No effect; the command does nothing.

    Exit Status:
    Always succeeds.
```

PS: IMHO, people should use the Bash help more often. It is a very useful Bash reference. Too many fallbacks to a Google search and then land on Stack Overflow. Sadly, there's no help built-in for the ZSH shell though (so even when I am using the ZSH I make use of the Bash help as most of the built-ins are compatible). 

OK, back to the null command. What happens when you try to run it? As you can see, absolutely nothing. And its exit status is 0 (success):

```
❯ :
❯ echo $?
0
```

Why would that be useful? You can use it as a placeholder in an endless while-loop:

```
❯ while : ; do date; sleep 1; done
Sun 21 Nov 12:08:31 GMT 2021
Sun 21 Nov 12:08:32 GMT 2021
Sun 21 Nov 12:08:33 GMT 2021
^C
❯
```

You can also use it as a placeholder for a function body not yet fully implemented, as an empty function ill result in a syntax error:

```
❯ foo () {  }
-bash: syntax error near unexpected token `}'
❯ foo () { :; }
❯ foo
❯
```

Or use it as a placeholder for not yet implemented conditional branches:

```
❯ if foo; then :; else echo bar; fi
```

Or (not recommended) as a fancy way to comment your Bash code:

```
❯ : I am a comment and have no other effect
❯ : I am a comment and result in a syntax error ()
-bash: syntax error near unexpected token `('
❯ : "I am a comment and don't result in a syntax error ()"
❯
```

As you can see in the previous example, the Bash still tries to interpret some syntax of all text following after ":". This can be exploited (also not recommended) like this:

```
❯ declare i=0
❯ $[ i = i + 1 ]
bash: 1: command not found...
❯ : $[ i = i + 1 ]
❯ : $[ i = i + 1 ]
❯ : $[ i = i + 1 ]
❯ echo $i
4
```

For these kinds of expressions it's always better to use "let" though. And you should also use $((...expression...)) instead of the old (deprecated) way $[ ...expression... ] like this example demonstrates:

```
❯ declare j=0
❯ let j=$((j + 1))
❯ let j=$((j + 1))
❯ let j=$((j + 1))
❯ let j=$((j + 1))
❯ echo $j
4
```

## (No) floating point support

I have to give a plus-point to the ZSH here. As the ZSH supports floating point calculation, whereas the Bash doesn't:

```
❯ bash -c 'echo $(( 1/10 ))'
0
❯ zsh -c 'echo $(( 1/10 ))'
0
❯ bash -c 'echo $(( 1/10.0 ))'
bash: line 1: 1/10.0 : syntax error: invalid arithmetic operator (error token is ".0 ")
❯ zsh -c 'echo $(( 1/10.0 ))'
0.10000000000000001
❯
```

It would be nice to have native floating point support for the Bash too, but you don't want to use the shell for complicated calculations anyway. So it's fine that Bash doesn't have that, I guess. 

In the Bash you will have to fall back to an external command like "bc" (the arbitrary precision calculator language):

```
❯ bc <<< 'scale=2; 1/10'
.10
```

See you later for the next post of this series. E-Mail me your comments to paul at buetow dot org!

[Go back to the main site](../)  
