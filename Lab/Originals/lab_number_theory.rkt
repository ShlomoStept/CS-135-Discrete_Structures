#lang eopl

#|-------------------------------------------------------------------------------
 | Name:
 | Pledge:
 |-------------------------------------------------------------------------------|#


#|-------------------------------------------------------------------------------|
 |                        Lab 8: Number Theory (20 PTS)                          |
 |-------------------------------------------------------------------------------|#


#| This lab explores a few topics of number theory
 |   that have been covered in lecture thus far.
 | Some functions you'll write may come in handy for subsequent ones,
 |   while others are "standalone".
 |
 | The type "natural" refers to a nonnegative integer >= 0.
 | The type "posint" refers to a positive integer > 0.
 | You'll find the following functions built-in to EOPL useful:
 |   (modulo a b)   returns a mod b [a % b in Python].
 |   (quotient a b) returns the integer quotient of a ÷ b [a // b in Python].
 |#




#|-------------------------------------------------------------------------------|
 |                   Part 1: Greatest Common Divisor (4 PTS)                     |
 |-------------------------------------------------------------------------------|#


#| Implement "divides?" to accept naturals a and b
 |   and return whether a|b, or "a divides b".
 | If a is zero, a divides b when b is zero.
 | If a is not zero, a divides b when b % a is zero.
 |
 | "divides?" behaves the same as "p-divides?" from the peano lab,
 |   but now you can utilize all the "normal" integer arithmetic we're accustomed to.
 |
 | Examples:
 |   (divides? 0 0)  -> #t
 |   (divides? 0 3)  -> #f
 |   (divides? 3 0)  -> #t
 |   (divides? 1 7)  -> #t
 |   (divides? 7 2)  -> #f
 |   (divides? 8 8)  -> #t
 |   (divides? 3 12) -> #t
 |   (divides? 4 18) -> #f
 |#

;; Type signature: (divides? natural natural) -> boolean
;; 1 PTS
(define (divides? a b)
  "TODO: Implement")




#| Implement "gcd" to accept two naturals
 |   and return their greatest common divisor.
 | Compute the GCD with Euclid's algorithm, which recursively uses
 |   the property that gcd(a, b) = gcd(b, a mod b).
 | Do NOT use EOPL's built-in "gcd" function!
 | You may assume that at least one of the two inputs to "gcd" is not zero.
 |
 | Examples:
 |   (gcd 0 1)   -> 1
 |   (gcd 1 5)   -> 1
 |   (gcd 3 2)   -> 1
 |   (gcd 4 8)   -> 4
 |   (gcd 18 16) -> 2
 |   (gcd 20 20) -> 20
 |   (gcd 65 25) -> 5
 |   (gcd 24 78) -> 6
 |   (gcd 95 47) -> 1
 |#

;; Type signature: (gcd natural natural) -> natural
;; 2 PTS
(define (gcd a b)
  "TODO: Implement")




#| Implement "lcm" to accept two naturals
 |   and return their least common multiple,
 |   which equals the product of the two naturals
 |   divided by their greatest common divisor.
 | A special case is that the LCM of 0 and 0 is 0.
 |
 | Examples:
 |   (lcm 0 0)   -> 0
 |   (lcm 5 0)   -> 0
 |   (lcm 1 6)   -> 6
 |   (lcm 6 3)   -> 6
 |   (lcm 2 7)   -> 14
 |   (lcm 8 6)   -> 24
 |   (lcm 9 9)   -> 9
 |   (lcm 39 26) -> 78
 |   (lcm 64 20) -> 320
 |#

;; Type signature: (lcm natural natural) -> natural
;; 1 PTS
(define (lcm a b)
  "TODO: Implement")




#|-------------------------------------------------------------------------------|
 |                    Part 2: The Water Jug Problem (6 PTS)                      |
 |-------------------------------------------------------------------------------|#


#| In this section, we'll programmatically solve the water jug problem.
 | First, let's lay out the problem's specification.
 |
 | Suppose there are two jugs, jug A and jug B,
 |   which have respective capacities of cA and cB gallons.
 | The capacity of each jug is a positive integer.
 | An arbitrarily large pool of water is also available
 |   for filling and emptying the jugs.
 | The objective of the water jug problem is to perfectly measure
 |   some integer amount of gallons, g, by performing a sequence of steps
 |   in which the jugs can be emptied, filled, or poured into one another.
 | Jugs A and B begin empty, and the problem has been solved
 |   once one of the jugs contains exactly g gallons of water.
 |#




#| Implement "wj-solvable?" to accept posints cA, cB, and g,
 |   and return whether g gallons can be measured from
 |   two jugs A and B with capacities of cA and cB gallons respectively.
 | g can be measured when g is a multiple of
 |   the greatest common divisor of the capacities of the two jugs,
 |   and, of course, when one of the jugs can hold at least g gallons.
 |
 | Examples:
 |   (wj-solvable? 1 1 1)   -> #t
 |   (wj-solvable? 1 2 3)   -> #f
 |   (wj-solvable? 1 10 2)  -> #t
 |   (wj-solvable? 1 10 9)  -> #t
 |   (wj-solvable? 2 4 3)   -> #f
 |   (wj-solvable? 6 12 12) -> #t
 |   (wj-solvable? 6 12 18) -> #f
 |   (wj-solvable? 7 8 5)   -> #t
 |   (wj-solvable? 9 12 6)  -> #t
 |#

;; Type signature: (wj-solvable? posint posint posint) -> boolean
;; 2 PTS
(define (wj-solvable? cA cB g)
  "TODO: Implement")


  

#| Implement "waterjug" to accept posints cA, cB, and g,
 |   and solve the waterjug problem with jugs A and B
 |   [with respective capacities of cA and cB]
 |   and the objective of measuring g gallons.
 | The output of "waterjug" represents the sequence of amounts of water
 |   in both jugs at each step of the process.
 |
 | You may make the following assumptions about the input to "waterjug":
 |   1. cA <= cB.
 |   2. g gallons can be measured with jugs of capacities cA and cB.
 |      Before trying your own test cases with this function,
 |        validate them by hand with "wj-solvable?".
 |
 | Both jugs are initially empty.
 | At each step of the algorithm, one of the following five cases will be true,
 |   where fA is the contents of jug A and fB is the contents of jug B.
 | Whichever is the first true case should be executed:
 |   1. fB = g       -> Process is done!
 |   2. fB = cB      -> Completely empty jug B.
 |   3. fA = 0       -> Completely fill jug A.
 |   4. fA + fB > cB -> Pour from jug A into jug B until B is full.
 |   5. fA + fB ≤ cB -> Completely empty jug A into jug B.
 | Though there are other algorithms which solve this problem more efficiently,
 |   it's important that you follow the process above so your output matches the expected output.
 | The output is a list of pairs of integers,
 |   where the nth pair is the values of (fA fB) at the nth step of the process.
 |
 | Examples:
 |   (waterjug 2 2 2)   -> ((0 0) (2 0) (0 2))
 |   (waterjug 3 5 4)   -> ((0 0) (3 0) (0 3) (3 3) (1 5) (1 0) (0 1) (3 1) (0 4))
 |   (waterjug 10 12 6) -> ((0 0) (10 0) (0 10) (10 10) (8 12) (8 0) (0 8) (10 8) (6 12) (6 0) (0 6))
 |   (waterjug 13 17 9) -> ((0 0) (13 0) (0 13) (13 13) (9 17) (9 0) (0 9))
 |   (waterjug 1 7 4)   -> ((0 0) (1 0) (0 1) (1 1) (0 2) (1 2) (0 3) (1 3) (0 4))
 |   (waterjug 9 18 18) -> ((0 0) (9 0) (0 9) (9 9) (0 18))
 |#

;; Type signature: (waterjug posint posint posint) -> list-of-pairs
;; 4 PTS
(define (waterjug cA cB g)
  "TODO: Implement")




#|-------------------------------------------------------------------------------|
 |                     Part 3: Prime Factorization (7 PTS)                       |
 |-------------------------------------------------------------------------------|#


#| Implement "factorize" to accept a natural n
 |   and return the list of n's prime factors
 |   ordered from least to greatest.
 | If n = 0, return a list containing just 0.
 | If n = 1, return a list containing just 1.
 |
 | Prime factorization is famously a computationally expensive problem,
 |   but we're working with small enough numbers that your
 |   implementation doesn't have to be efficient.
 | The simplest strategy for factorizing n > 1 is:
 |   1. Find the smallest number p > 1 which divides n.
 |   2. Add p to the list of factors.
 |   3. Divide n by p.
 |   4. Repeat steps 1-3 until n = 1.
 | Do you see why this stategy works, and why p is always prime?
 |
 | The order and quantities of numbers in your output
 |   must match the examples!
 |
 | Examples:
 |   (factorize 1)    -> (1)
 |   (factorize 5)    -> (5)
 |   (factorize 9)    -> (3 3)
 |   (factorize 14)   -> (2 7)
 |   (factorize 96)   -> (2 2 2 2 2 3)
 |   (factorize 1061) -> (1061)
 |   (factorize 3549) -> (3 7 13 13)
 |   (factorize 5040) -> (2 2 2 2 3 3 5 7)
 |#

;; Type signature: (factorize natural) -> list-of-naturals
;; 5 PTS
(define (factorize n)
  "TODO: Implement")




#| Implement "prime?" to accept a natural n
 |   and return whether n is prime.
 | Take advantage of "factorize" and
 |   identify when n is prime with the following property:
 |   n is prime when n > 1 and the only prime factor of n is n.
 |
 | If you cannot get "factorize" to work,
 |   you may implement this function without the use of "factorize";
 |   it'll be more laborious but similar to "p-prime?".
 |
 | Examples:
 |   (prime? 0)  -> #f
 |   (prime? 2)  -> #t
 |   (prime? 5)  -> #t
 |   (prime? 6)  -> #f
 |   (prime? 10) -> #f
 |   (prime? 17) -> #t
 |   (prime? 91) -> #f
 |   (prime? 97) -> #t
 |#

;; Type signature: (prime? natural) -> boolean
;; 2 PTS
(define (prime? n)
  "TODO: Implement")




#|-------------------------------------------------------------------------------|
 |                     Part 4: Modular Congruence (3 PTS)                        |
 |-------------------------------------------------------------------------------|#


#| Here, we're going to implement a simple function in a unique way.
 | It may seem convoluted or unnecessary, but this implementation strategy
 |   is fundamental to functional programming.
 |
 | In past labs, we've seen that functions can be passed
 |   as parameters just like any other datatype;
 |   for instance, in (map zero? '(4 0 2 3 0 1)),
 |   the map function receives the "zero?" function as a parameter.
 | But in Racket and other functional languages,
 |   not only can functions receive functions as parameters,
 |   they can return functions as values too!
 |
 | The most direct way of returning a function
 |   is by constructing a lambda function as the return value.
 | Lambda functions are constructed similarly to regular functions,
 |   but they lack a name alongside their parameters.
 | A lambda is constructed like so:
 |   (lambda (<param1> <param2> ... <paramn>) <body>).
 |
 | An alternative way is to define a function with a subdefinition,
 |   and simply return the [unparenthesized] name of that subdefined function.
 | In the same way that you can pass a function using its name to another function,
 |   like "zero?" in the "map" example, you can return a function using its name.
 |#




#| Implement "cong-mod?" to accept a posint m
 |   and return a binary predicate representing
 |   the "congruence modulo m" equivalence relation.
 | In other words, the function that (cong-mod? m) returns
 |   should accept two naturals a and b, and return
 |   whether a and b are congruent modulo m.
 | You can choose how the return function computes whether a ≡ b (mod m),
 |   the two main ways being:
 |     1. a ≡ b (mod m) iff a mod m = b mod m.
 |     2. a ≡ b (mod m) iff m divides (a - b).
 |
 | Again, notice that "cong-mod?" only has the parameter m.
 | That's why the body of "cong-mod?" must construct
 |   a function that accepts the parameters a and b.
 | Also notice how the examples are written with an extra, but necessary,
 |   set of parentheses.
 | Also-also, observe the commented type signature of "cong-mod?".
 | It's admittedly confusing because it's not using a standard notation,
 |   but the signature indicates that the return type of the function
 |   is itself a function which accepts two naturals and returns a boolean.
 |
 | Examples:
 |   ((cong-mod? 1) 3 4)   -> #t
 |   ((cong-mod? 1) 5 0)   -> #t
 |   ((cong-mod? 2) 6 10)  -> #t
 |   ((cong-mod? 2) 13 7)  -> #t
 |   ((cong-mod? 2) 1 8)   -> #f
 |   ((cong-mod? 2) 0 0)   -> #t
 |   ((cong-mod? 3) 0 9)   -> #t
 |   ((cong-mod? 3) 7 0)   -> #f
 |   ((cong-mod? 3) 14 2)  -> #t
 |   ((cong-mod? 3) 8 19)  -> #f
 |   ((cong-mod? 8) 1 5)   -> #f
 |   ((cong-mod? 8) 9 12)  -> #f
 |   ((cong-mod? 8) 4 36)  -> #t
 |   ((cong-mod? 8) 25 25) -> #t
 |#

;; Type signature: (cong-mod? posint) -> (natural natural -> boolean)
;; 3 PTS
(define (cong-mod? m)
  "TODO: Implement")




#| Constructing "cong-mod?" in this way is useful because
 |   it simplifies future usage of the function.
 | Consider this definition:
 |   (define cong-mod-3? (cong-mod? 3))
 |
 | Now we can easily and repeatedly compare two numbers modulo 3 like so:
 |  (cong-mod-3? 8 14).
 |
 | Also, if we wanted to write another function which accepted
 |   an arbitrary equivalence relation/function as input,
 |   we could easily pass it (cong-mod? 5), for instance, as a parameter.
 |#