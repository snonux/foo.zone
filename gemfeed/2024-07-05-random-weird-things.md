# Random Weird Things

> Published at 2024-07-05T10:59:59+03:00

Every so often, I come across random, weird, and unexpected things on the internet. I thought it would be neat to share them here from time to time. As a start, here are ten of them.

```
		       /\_/\
WHOA!! 	     ( o.o )
		       > ^ <
		      /  -  \
		    /        \
		   /______\  \
```

## Table of Contents

* [⇢ Random Weird Things](#random-weird-things)
* [⇢ ⇢ 1. `bad.horse` traceroute](#1-badhorse-traceroute)
* [⇢ ⇢ 2. ASCII cinema](#2-ascii-cinema)
* [⇢ ⇢ 3. Netflix's Hello World application](#3-netflix-s-hello-world-application)
* [⇢ ⇢ C programming](#c-programming)
* [⇢ ⇢ ⇢ 4. Indexing an array](#4-indexing-an-array)
* [⇢ ⇢ ⇢ 5. Variables with prefix `$`](#5-variables-with-prefix-)
* [⇢ ⇢ 6. Object oriented shell scripts using `ksh`](#6-object-oriented-shell-scripts-using-ksh)
* [⇢ ⇢ 7. This works in Go](#7-this-works-in-go)
* [⇢ ⇢ 8. "I am a Teapot" HTTP response code](#8-i-am-a-teapot-http-response-code)
* [⇢ ⇢ 9. `jq` is a functional programming language](#9-jq-is-a-functional-programming-language)
* [⇢ ⇢ 10. Regular expression to verify email addresses](#10-regular-expression-to-verify-email-addresses)

## 1. `bad.horse` traceroute

Run traceroute to get the poem (or song).

```bash
% traceroute bad.horse
traceroute to bad.horse (162.252.205.157), 30 hops max, 60 byte packets
 1  dsldevice.lan (192.168.1.1)  5.712 ms  5.800 ms  6.466 ms
 2  87-243-116-2.ip.btc-net.bg (87.243.116.2)  8.017 ms  7.506 ms  8.432 ms
 3  * * *
 4  * * *
 5  xe-1-2-0.mpr1.fra4.de.above.net (80.81.194.26)  39.952 ms  40.155 ms  40.139 ms
 6  ae12.cs1.fra6.de.eth.zayo.com (64.125.26.172)  128.014 ms * *
 7  * * *
 8  * * *
 9  ae10.cs1.lhr15.uk.eth.zayo.com (64.125.29.17)  120.625 ms  121.117 ms  121.050 ms
10  * * *
11  * * *
12  * * *
13  ae5.mpr1.tor3.ca.zip.zayo.com (64.125.23.118)  192.605 ms  205.741 ms  203.607 ms
14  64.124.217.237.IDIA-265104-ZYO.zip.zayo.com (64.124.217.237)  204.673 ms  134.674 ms  131.442 ms
15  * * *
16  67.223.96.90 (67.223.96.90)  128.245 ms  127.844 ms  127.843 ms
17  bad.horse (162.252.205.130)  128.194 ms  122.854 ms  121.786 ms
18  bad.horse (162.252.205.131)  128.831 ms  128.341 ms  186.559 ms
19  bad.horse (162.252.205.132)  185.716 ms  180.121 ms  180.042 ms
20  bad.horse (162.252.205.133)  203.170 ms  203.076 ms  203.168 ms
21  he.rides.across.the.nation (162.252.205.134)  203.115 ms  141.830 ms  141.799 ms
22  the.thoroughbred.of.sin (162.252.205.135)  147.965 ms  148.230 ms  170.478 ms
23  he.got.the.application (162.252.205.136)  165.161 ms  164.939 ms  159.085 ms
24  that.you.just.sent.in (162.252.205.137)  162.310 ms  158.569 ms  158.896 ms
25  it.needs.evaluation (162.252.205.138)  162.927 ms  163.046 ms  163.085 ms
26  so.let.the.games.begin (162.252.205.139)  233.363 ms  233.545 ms  233.317 ms
27  a.heinous.crime (162.252.205.140)  237.745 ms  233.614 ms  233.740 ms
28  a.show.of.force (162.252.205.141)  237.974 ms  176.085 ms  175.927 ms
29  a.murder.would.be.nice.of.course (162.252.205.142)  181.838 ms  181.858 ms  182.059 ms
30  bad.horse (162.252.205.143)  187.731 ms  187.416 ms  187.532 ms
```

## 2. ASCII cinema

Fancy watching Star Wars Episode IV in ASCII? Head to the ASCII cinema:

[https://asciinema.org/a/569727](https://asciinema.org/a/569727)  

## 3. Netflix's Hello World application

Netflix has got the Hello World application run in production 😱

*  https://www.Netflix.com/helloworld
 
> By the time this is posted, it seems that Netflix has taken it offline... I should have created a screenshot!

## C programming

### 4. Indexing an array

In C, you can index an array like this: `array[i]` (not surprising). But this works as well and is valid C code: `i[array]`, 🤯 It's because after the spec `A[B]` is equivalent to `*(A + B)` and the ordering doesn't matter for the `+` operator. All 3 loops are producing the same output. Would be funny to use `i[array]` in a merge request of some code base on April Fool's day!

```c
#include <stdio.h>

int main(void) {
  int array[5] = { 1, 2, 3, 4, 5 };

  for (int i = 0; i < 5; i++)
    printf("%d\n", array[i]);

  for (int i = 0; i < 5; i++)
    printf("%d\n", i[array]);

  for (int i = 0; i < 5; i++)
    printf("%d\n", *(i + array));
}
```

### 5. Variables with prefix `$`

In C you can prefix variables with `$`! E.g. the following is valid C code 🫠:

```c
#include <stdio.h>

int main(void) {
  int $array[5] = { 1, 2, 3, 4, 5 };

  for (int $i = 0; $i < 5; $i++)
    printf("%d\n", $array[$i]);

  for (int $i = 0; $i < 5; $i++)
    printf("%d\n", $i[$array]);

  for (int $i = 0; $i < 5; $i++)
    printf("%d\n", *($i + $array));
}
```

## 6. Object oriented shell scripts using `ksh`

Experienced software developers are aware that scripting languages like Python, Perl, Ruby, and JavaScript support object-oriented programming (OOP) concepts such as classes and inheritance. However, many might be surprised to learn that the latest version of the Korn shell (Version 93t+) also supports OOP. In ksh93, OOP is implemented using user-defined types:

```ksh
#!/usr/bin/ksh93
 
typeset -T Point_t=(
    integer -h 'x coordinate' x=0
    integer -h 'y coordinate' y=0
    typeset -h 'point color'  color="red"

    function getcolor {
        print -r ${_.color}
    }

    function setcolor {
        _.color=$1
    }

    setxy() {
        _.x=$1; _.y=$2
    }

    getxy() {
        print -r "(${_.x},${_.y})"
    }
)
 
Point_t point
 
echo "Initial coordinates are (${point.x},${point.y}). Color is ${point.color}"
 
point.setxy 5 6
point.setcolor blue
 
echo "New coordinates are ${point.getxy}. Color is ${point.getcolor}"
 
exit 0
```

[Using types to create object oriented Korn shell 93 scripts](https://blog.fpmurphy.com/2010/05/ksh93-using-types-to-create-object-orientated-scripts.html)  

## 7. This works in Go

There is no pointer arithmetic in Go like in C, but it is still possible to do some brain teasers with pointers 😧:

```go
package main

import "fmt"

func main() {
	var i int
	f := func() *int {
		return &i
	}
	*f()++
	fmt.Println(i)
}
```

[Go playground](https://go.dev/play/p/sPRdyDvXefK?__s=mk8u899owb9yurl256gw)  

## 8. "I am a Teapot" HTTP response code

Defined in 1998 as one of the IETF's traditional April Fools' jokes (RFC 2324), the Hyper Text Coffee Pot Control Protocol specifies an HTTP status code that is not intended for actual HTTP server implementation. According to the RFC, this code should be returned by teapots when asked to brew coffee. This status code also serves as an Easter egg on some websites, such as Google.com's "I'm a teapot" feature. Occasionally, it is used to respond to a blocked request, even though the more appropriate response would be the 403 Forbidden status code.

[https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#418](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#418)  

## 9. `jq` is a functional programming language

Many know of `jq`, the handy small tool and swiss army knife for JSON parsing. 

[https://github.com/jqlang/jq](https://github.com/jqlang/jq)  

What many don't know that `jq` is actually a full blown functional programming language `jqlang`, have a look at the language description: 

[https://github.com/jqlang/jq/wiki/jq-Language-Description](https://github.com/jqlang/jq/wiki/jq-Language-Description)  

As a matter of fact, the language is so powerful, that there exists an implementation of `jq` in `jq` itself:

[https://github.com/wader/jqjq](https://github.com/wader/jqjq)  

Here some snipped from `jqjq`, to get a feel of `jqlang`:

```
def _token:
	def _re($re; f):
	  ( . as {$remain, $string_stack}
	  | $remain
	  | match($re; "m").string
	  | f as $token
	  | { result: ($token | del(.string_stack))
	    , remain: $remain[length:]
	    , string_stack:
	        ( if $token.string_stack == null then $string_stack
	          else $token.string_stack
	          end
	        )
	    }
	  );
	if .remain == "" then empty
	else
	  ( . as {$string_stack}
	  | _re("^\\s+"; {whitespace: .})
	  // _re("^#[^\n]*"; {comment: .})
	  // _re("^\\.[_a-zA-Z][_a-zA-Z0-9]*"; {index: .[1:]})
	  // _re("^[_a-zA-Z][_a-zA-Z0-9]*"; {ident: .})
	  // _re("^@[_a-zA-Z][_a-zA-Z0-9]*"; {at_ident: .})
	  // _re("^\\$[_a-zA-Z][_a-zA-Z0-9]*"; {binding: .})
	  # 1.23, .123, 123e2, 1.23e2, 123E2, 1.23e+2, 1.23E-2 or 123
	  // _re("^(?:[0-9]*\\.[0-9]+|[0-9]+)(?:[eE][-\\+]?[0-9]+)?"; {number: .})
	  // _re("^\"(?:[^\"\\\\]|\\\\.)*?\\\\\\(";
	      ( .[1:-2]
	      | _unescape
	      | {string_start: ., string_stack: ($string_stack+["\\("])}
	      )
	    )
	 .
	 .
	 .
```

## 10. Regular expression to verify email addresses

This is a pretty old meme, but still worth posting here (as some may be unaware). The RFC822 Perl regex to validate email addresses is 😱:

```
(?:(?:\r\n)?[ \t])*(?:(?:(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t]
)+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:
\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(
?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ 
\t]))*"(?:(?:\r\n)?[ \t])*))*@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\0
31]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\
>(?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+
(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:
(?:\r\n)?[ \t])*))*|(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z
|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)
?[ \t])*)*\<(?:(?:\r\n)?[ \t])*(?:@(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\
r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[
 \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)
?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t]
)*))*(?:,@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[
 \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*
)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t]
)+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*)
*:(?:(?:\r\n)?[ \t])*)?(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+
|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r
\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:
\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t
>))*"(?:(?:\r\n)?[ \t])*))*@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031
>+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](
?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?
:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?
:\r\n)?[ \t])*))*\>(?:(?:\r\n)?[ \t])*)|(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?
:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?
[ \t]))*"(?:(?:\r\n)?[ \t])*)*:(?:(?:\r\n)?[ \t])*(?:(?:(?:[^()<>@,;:\\".\[\] 
\000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|
\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>
@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"
(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*))*@(?:(?:\r\n)?[ \t]
)*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\
".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?
:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[
\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*|(?:[^()<>@,;:\\".\[\] \000-
\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(
?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)*\<(?:(?:\r\n)?[ \t])*(?:@(?:[^()<>@,;
:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([
^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\"
.\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\
>\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*(?:,@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\
[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\
r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] 
\000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]
|\\.)*\](?:(?:\r\n)?[ \t])*))*)*:(?:(?:\r\n)?[ \t])*)?(?:[^()<>@,;:\\".\[\] \0
00-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\
.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,
;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]]))|"(?
:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*))*@(?:(?:\r\n)?[ \t])*
(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".
\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t])*(?:[
^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\]
>))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*\>(?:(?:\r\n)?[ \t])*)(?:,\s*(
?:(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\
".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)(?:\.(?:(
?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[
\["()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t
>)*))*@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t
>)+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?
:\.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|
\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*|(?:
[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".\[\
>]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)*\<(?:(?:\r\n)
?[ \t])*(?:@(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["
()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)
?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>
@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*(?:,@(?:(?:\r\n)?[
 \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,
;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\.(?:(?:\r\n)?[ \t]
)*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\
".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*)*:(?:(?:\r\n)?[ \t])*)?
(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\["()<>@,;:\\".
\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])*)(?:\.(?:(?:
\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z|(?=[\[
"()<>@,;:\\".\[\]]))|"(?:[^\"\r\\]|\\.|(?:(?:\r\n)?[ \t]))*"(?:(?:\r\n)?[ \t])
*))*@(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])
+|\Z|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*)(?:\
.(?:(?:\r\n)?[ \t])*(?:[^()<>@,;:\\".\[\] \000-\031]+(?:(?:(?:\r\n)?[ \t])+|\Z
|(?=[\["()<>@,;:\\".\[\]]))|\[([^\[\]\r\\]|\\.)*\](?:(?:\r\n)?[ \t])*))*\>(?:(
?:\r\n)?[ \t])*))*)?;\s*)
```

[https://pdw.ex-parrot.com/Mail-RFC822-Address.html](https://pdw.ex-parrot.com/Mail-RFC822-Address.html)  

I hope you had some fun. E-Mail your comments to `paul@nospam.buetow.org` :-)

other related posts are:

[Back to the main site](../)  
