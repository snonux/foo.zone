# Lazy Evaluation with Standard ML

```

      _____|~~\_____      _____________
  _-~               \    |    \
  _-    | )     \    |__/   \   \
  _-         )   |   |  |     \  \
  _-    | )     /    |--|      |  |
 __-_______________ /__/_______|  |_________
(                |----         |  |
 `---------------'--\\\\      .`--'          -Glyde-
                              `||||
```

> Written by Paul Buetow 2010-05-07

In contrast to Haskell, Standard SML does not use lazy evaluation by default but an eager evaluation. 

[https://en.wikipedia.org/wiki/Eager_evaluation](https://en.wikipedia.org/wiki/Eager_evaluation)  
[https://en.wikipedia.org/wiki/Lazy_evaluation](https://en.wikipedia.org/wiki/Lazy_evaluation)  


You can solve specific problems with lazy evaluation easier than with eager evaluation. For example, you might want to list the number Pi or another infinite list of something. With the help of lazy evaluation, each element of the list is calculated when it is accessed first, but not earlier.

## Emulating lazy evaluation in SML

However, it is possible to emulate lazy evaluation in most eager evaluation languages. This is how it is done with Standard ML (with some play with an infinite list of natural number tuples filtering out 0 elements):

```
type ’a lazy = unit -> ’a;

fun force (f:’a lazy) = f ();
fun delay x = (fn () => x) : ’a lazy;

datatype ’a sequ = NIL | CONS of ’a * ’a sequ lazy;

fun first 0 s = []
  | first n NIL = []
  | first n (CONS (i,r)) = i :: first (n-1) (force r);

fun filters p NIL = NIL
  | filters p (CONS (x,r)) =
      if p x
          then CONS (x, fn () => filters p (force r))
      else
          filters p (force r);

fun nat_pairs () =
    let
        fun from_pair (x,0) =
              CONS ((x,0), fn () => from_pair (0,x+1))
          | from_pair (up,dn) =
              CONS ((up,dn), fn () => from_pair (up+1,dn-1))
        in from_pair (0,0)
    end;

(* Test
val test = first 10 (nat_pairs ())
*)

fun nat_pairs_not_null () =
    filters (fn (x,y) => x > 0 andalso y > 0) (nat_pairs ());

(* Test
val test = first 10 (nat_pairs_not_null ());
*)
```

[http://smlnj.org/](http://smlnj.org/)  

## Real laziness with Haskell 

As Haskell already uses lazy evaluation by default, there is no need to construct a new data type. Lists in Haskell are lazy by default. You will notice that the code is also much shorter and easier to understand than the SML version. 

```
{- Just to make it look like the ML example -}
first = take
filters = filter

{- Implementation -}
nat_pairs = from_pair 0 0
    where
        from_pair x 0 = [x,0] : from_pair 0 (x+1)
        from_pair up dn = [up,dn] : from_pair (up+1) (dn-1)

{- Test:
first 10 nat_pairs
-}

nat_pairs_not_null = filters (\[x,y] -> x > 0 && y > 0) nat_pairs

{- Test:
first 10 nat_pairs_not_null
-}
```

[http://www.haskell.org/](http://www.haskell.org/)  

E-Mail me your thoughts at comments@mx.buetow.org!

[Go back to the main site](../)  
