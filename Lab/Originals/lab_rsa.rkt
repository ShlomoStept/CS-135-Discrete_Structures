#lang eopl

#|-------------------------------------------------------------------------------
 | Name:
 | Pledge:
 |-------------------------------------------------------------------------------|#


#|-------------------------------------------------------------------------------|
 |                       Lab 9: RSA Cryptosystem (20 PTS)                        |
 |-------------------------------------------------------------------------------|#


#| In this lab, we'll implement the RSA cryptosystem.
 | Remarkably, one of the most widely used cryptographic schemes
 |   is relatively easy to implement... it's just hard to break!
 |
 | The type "natural" refers to an integer ≥ 0.
 | "x % y" represents the arithmetic operation which returns
 |   the smallest nonnegative integer that is congruent to x modulo y.
 |#




#|-------------------------------------------------------------------------------|
 |                         Part 1: Key Generation (3 PTS)                        |
 |-------------------------------------------------------------------------------|#


#| First, we'll set up key generation.
 | RSA keys come in pairs:
 |   a public key used for encryption and
 |   a corresponding private key for decryption.
 | The two keys are generated from a "seed" of three values: p, q, and e.
 | p and q must be unequal primes.
 | e must be coprime with lcm(p - 1, q - 1).
 | e must be in the range [2, lcm(p - 1, q - 1)].
 |
 | Some implementations of RSA use slightly different constraints for the key seed values,
 |   including the description of RSA you saw in class,
 |   but these small differences are inconsequential.
 |#


#| Here's a helper function "seed-valid?"
 |   which accepts seed values p, q, and e,
 |   and returns whether they consistute a valid seed for key generation
 |   based on the constraints stated above.
 | You won't need to use this function in any of the code you write;
 |   it merely serves as a santity check so that if you create a test case which fails,
 |   you can check whether it was due to a bad combination of seed values.
 |#

;; Type signature: (seed-valid? natural natural natural) -> boolean
(define (seed-valid? p q e)
  (define (prime? n)
    (define cap (sqrt n))
    (define (h i)
      (cond [(> i cap) #t]
            [(zero? (modulo n i)) #f]
            [else (h (+ i 1))]))
    (if (< n 2) #f (h 2)))
  (define L (lcm (- p 1) (- q 1)))
  (and (not (= p q))
       (< e L) (> e 1)
       (= 1 (gcd e L))
       (prime? p) (prime? q)))




#| Here's an efficient implementation of modular inverse,
 |   which accepts relatively prime naturals a and b
 |   and uses the pulverizer to compute and return
 |   the smallest nonnegative integer
 |   which is congruent to a inverse mod b.
 | You'll actually need this function!
 |#

;; Type signature: (mul-inv natural natural) -> natural
(define (mul-inv a b)
  (define (pulverize a b)
    (if (zero? a) (list b 0 1)
        (let ([p (pulverize (modulo b a) a)])
          (list (car p)
                (- (caddr p)
                   (* (quotient b a) (cadr p)))
                (cadr p)))))
  (modulo (cadr (pulverize a b)) b))




#| Implement "generate" to accept naturals p, q, and e,
 |   and return the public and private RSA keys generated from those seed values.
 | You may assume that the input values constitute a valid seed.
 |
 | There are a few values we need to compute:
 |   m = p * q.
 |   L = lcm(p - 1, q - 1).
 |   d = e inverse mod L.
 |
 | Use EOPL's function (lcm a b) to compute lcm(a, b).
 |
 | The public key is the list (m e), and the private key is the list (m d).
 | "generate" returns the list of these two keys: ((m e) (m d)).
 |
 | Examples:
 |   (generate 17 7 5)        -> ((119 5) (119 29))
 |   (generate 1193 457 4033) -> ((545201 4033) (545201 46801))
 |   (generate 997 4889 727)  -> ((4874333 727) (4874333 651247))
 |   (generate 5507 6547 77)  -> ((36054329 77) (36054329 17084975))
 |#

;; Type signature: (generate natural natural natural) -> ((natural natural) (natural natural))
;; 3 PTS
(define (generate p q e)
  "TODO: Implement")




#|-------------------------------------------------------------------------------|
 |                    Part 2: Encryption/Decryption (17 PTS)                     |
 |-------------------------------------------------------------------------------|#


#| With key generation implemented, we can write the encryption and decryption functions
 |   which convert between plaintext strings and ciphertext integer lists.
 | But first, we need an efficient algorithm for modular exponentiation.
 |#



#| Implement "mod-exp" to accept three naturals b, e, and m,
 |   and return (b^e) % m.
 | You may assume b > 0, e ≥ 0, and m > 0.
 | We need this function to compute quickly with large numbers,
 |   so we'll use a recursive algorithm called modular binary exponentiation.
 | There are three cases to consider with respect to the exponent's value:
 |   1. e = 0.
 |      In this case, (b ^ e) % m = (b ^ 0) % m = 1 % m = 1.
 |   2. e > 0 and e is even.
 |      In this case, (b ^ e) % m = ([b^(e/2) % m] ^ 2) % m.
 |      Use recursion to compute b^(e/2) % m.
 |      Use exponentiation to square the result of the recursive call.
 |        If you instead recurse twice, the recursion will expand out exponentially!
 |   3. e > 0 and e is odd.
 |      In this case, (b ^ e) % m = ([b^(e-1) % m] * b) % m.
 |      Use recursion to compute b^(e-1) % m.
 |
 | Helpful EOPL functions:
 |   (modulo a b) returns a % b.
 |   (expt a b)   returns a ^ b.  <- DO NOT use this to compute b ^ e.
 |
 | Examples:
 |   (mod-exp 30 28 1)     -> 0
 |   (mod-exp 1 15 2)      -> 1
 |   (mod-exp 750 0 15)    -> 1
 |   (mod-exp 2 7 3)       -> 2
 |   (mod-exp 5493 62 2)   -> 1
 |   (mod-exp 2020 89 76)  -> 16
 |   (mod-exp 123 456 789) -> 699
 |   (mod-exp 325 3467 357457)    -> 143472
 |   (mod-exp 13579 24680 124578) -> 76657
 |#

;; Type signature: (mod-exp natural natural natural) -> natural
;; 5 points
(define (mod-exp b e m)
  "TODO: Implement")




#| Implement "encrypt" to accept a plaintext string and a public key as a list
 |   and return the corresponding ciphertext, encrypted via RSA using the public key.
 | The key will be the list (m e) where m and e are naturals.
 | The ciphertext output should be a list of naturals.
 | Each character in the string should be independently encrypted
 |   via the function E(c) = (c ^ e) % m, where m and e are the provided key values,
 |   and c is the character's ASCII value.
 | For this procedure to work correctly, you'll have to split up the plaintext into a list of characters,
 |   then explicitly convert each character to its ASCII integer value.
 |
 | This encryption algorithm only works when the ASCII value of each character is less than m.
 | You may assume this condition is satisfied in all test cases used.
 | To play it safe, ensure m is greater than 128 when creating your own test cases.
 |
 | Don't concern yourself with hunting for edge cases while testing this function.
 | All test cases used to grade "encrypt" will be similar to those provided below,
 |   so if your function works for "reasonable" test cases such as the examples,
 |   it should pass the grading cases without issue.
 |
 | Helpful EOPL functions:
 |   (string->list s)  converts string s to a list of characters.
 |   (char->integer c) converts a character to its corresponding ASCII integer.
 |
 | Examples:
 |   (encrypt "aaa" '(119 5))
 |     -> (20 20 20)
 |   (encrypt "Hello World!" '(1363 71))
 |     -> (1001 566 8 8 430 84 609 430 1104 8 506 932)
 |   (encrypt "CS-135 RSA" '(1147 53))
 |     -> (428 699 948 441 732 747 311 763 699 1003)
 |   (equal? (encrypt "Sandeep???" '(4874333 727)) '(3444448 1344944 3898311 2111037 2139699 2139699 2762161 4321108 4321108 4321108))
 |     -> #t
 |   (equal? (encrypt "RACKET IS GREAT" '(24135217 999)) '(9341462 9800674 1236858 11178682 5150537 17216396 13663157 12215098 21249706 13663157 10223961 9341462 5150537 9800674 17216396))
 |     -> #t
 |#

;; Type signature: (encrypt string (natural natural)) -> list-of-naturals
;; 6 PTS
(define (encrypt plaintext key)
  "TODO: Implement")




#| Implement "decrypt" to accept a ciphertext (list of naturals) and a private key as a list
 |   and return the corresponding plaintext, decrypted via RSA using the private key.
 | The key will be the list (m d) where m and d are naturals.
 | The plaintext output should be a string.
 | Each natural in the ciphertext should be independently decrypted
 |   via the function D(n) = (n ^ e) % m, where m and d are the provided key values,
 |   and n is the natural. The output will be the ASCII integer value of a character.
 | For this procedure to work correctly, you'll have to convert each decrypted integer
 |   back into a character, then collapse all of the characters back into a string.
 |
 | You may assume that the input ciphertext is the result of encrypting a plaintext via
 |   the public key which corresponds to the input private key.
 | This is the case for the examples provided and will be the case for the grading tests.
 | If you try inputting a random list of integers and a random private key,
 |   you'll see that the output is likely incomprehensible,
 |   and therefore not useful for meaningfully testing your function.
 |
 | Helpful EOPL functions:
 |   (list->string l)  converts a list of characters l into a string made up of said characters.
 |   (integer->char n) converts an integer to its corresponding character based on ASCII values.
 |
 | Examples:
 |   (decrypt '(20 20 20) '(119 29))
 |     -> "aaa"
 |   (decrypt '(1001 566 8 8 430 84 609 430 1104 8 506 932) '(1363 127))
 |     -> "Hello World!"
 |   (decrypt '(428 699 948 441 732 747 311 763 699 1003) '(1147 17))
 |     -> "CS-135 RSA"
 |   (decrypt '(3444448 1344944 3898311 2111037 2139699 2139699 2762161 4321108 4321108 4321108) '(4874333 651247))
 |     -> "Sandeep???"
 |   (decrypt '(9341462 9800674 1236858 11178682 5150537 17216396 13663157 12215098 21249706 13663157 10223961 9341462 5150537 9800674 17216396) '(24135217 1642119))
 |     -> "RACKET IS GREAT"
 |#

;; Type signature: (decrypt list-of-naturals (natural natural)) -> string
;; 6 PTS
(define (decrypt ciphertext key)
  "TODO: Implement")




#|-------------------------------------------------------------------------------|
 |                                 Miscellanea                                   |
 |-------------------------------------------------------------------------------|#


#| "check" is a helper function which will help verify that
 |   your implementations are working correctly.
 | If your input to "check" is valid, the function will encrypt and then decrypt
 |   the input string, and see if the result matches the original string.
 | If your input is invalid, the function will state as such.
 |#

;; Type signature: (check string natural natural natural) -> string
(define (check s p q e)
  (if (seed-valid? p q e)
      (let ([keys (generate p q e)])
        (cond
          [(member #f (map (lambda (c) (< (char->integer c) (caar keys)))
                           (string->list s)))
           "Invalid: modulo is too small"]
          [(string=? (decrypt (encrypt s (car keys))
                              (cadr keys))
                     s)
           "Correct: original string matches decrypted ciphertext"]
          [else "Incorrect: original string does not match decrypted ciphertext"]))
      "Invalid: seed values p, q, e are not valid"))




#| As a bonus challenge, see if you can decrypt these messages encrypted with RSA.
 | Consider how difficult this would be if m were hundreds of digits long instead of 3 or 4 !
 | You don't need to submit your answers anywhere, and they're not worth any points.
 |
 | PUBLIC KEY                 CIPHERTEXT
 | m =  247   e =  23         (159 80 85 138 128 49 80 91 128 201 80 91 154 237 128 86 43 67)
 | m =  145   e =  17         (23 102 45 80 11 11 52 44 115 2 115 104 55 45 96 2 104 11 102 80)
 | m = 5963   e = 151         (1080 4133 5460 4133 10 1117 4133 10 3635 4133 5605 5877 4133 1080 5605)
 |#