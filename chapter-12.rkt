#lang pie

;; PREREQUISITES

(claim +
  (→ Nat Nat
    Nat))
(define +
  (λ (lhs rhs)
    (iter-Nat lhs
      rhs
      (λ (n)
        (add1 n)))))

(claim double
  (→ Nat
    Nat))
(define double
  (λ (n)
    (iter-Nat n
      0
      #;(λ (x)
        (add1 (add1 x)))
      (+ 2))))


; 265:5
(claim Even
  (→ Nat
    U))
(define Even
  (λ (n)
    (Σ ((half Nat))
      (= Nat
        n
        (double half)))))

; 266:9
(claim zero-is-even
  (Even zero))
(define zero-is-even
  (cons zero (same zero)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Carefully Choose Definitions                                                 ;;
;;                                                                              ;;
;; Carefully-chosen definitions can greatly simplify later proofs.              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 270:26
(claim +-two-even
  (Π ((n Nat))
    (→ (Even n)
      (Even (+ 2 n)))))
(define +-two-even
  (λ (n)
    (λ (even_n)
      (cons (add1 (car even_n))
        (cong (cdr even_n) (+ 2))))))

; 271:28
(claim Two-Is-Even-Statement
  U)
(define Two-Is-Even-Statement
  (Even 2))

; 271:28
(claim two-is-even-proof
  Two-Is-Even-Statement)
(define two-is-even-proof
  (+-two-even 0 zero-is-even))

; 271:32
(claim Odd
  (→ Nat
    U))
(define Odd
  (λ (n)
    (Σ ((haf Nat))
      (= Nat
        n
        (add1 (double haf))))))

; 272:34
(claim one-is-odd
  (Odd 1))
(define one-is-odd
  (cons 0 (same 1)))

; 272:35
(claim 13-is-odd
  (Odd 13))
(define 13-is-odd
  (cons 6 (same 13)))

; 273:44
(claim add1-even→odd
  (Π ((n Nat))
    (→ (Even n)
      (Odd (add1 n)))))
(define add1-even→odd
  (λ (n)
    (λ (even_n)
      (cons (car even_n)
        (cong (cdr even_n) (+ 1))))))

; 276:56
(claim add1-odd→even
  (Π ((n Nat))
    (→ (Odd n)
      (Even (add1 n)))))
(define add1-odd→even
  (λ (n)
    (λ (odd_n)
      (cons (add1 (car odd_n))
        (cong (cdr odd_n) (+ 1))))))

(claim repeat
  (→ (→ Nat
        Nat)
      Nat
    Nat))
(define repeat
  (λ (f n)
    (iter-Nat n
      (f 1)
      (λ (iter_n-1)
        (f iter_n-1)))))

; Behold! Ackermann!
(claim ackermann
  (→ Nat Nat
    Nat))
(define ackermann
  (λ (n)
    (iter-Nat n
      (+ 1)
      (λ (ackermann_n-1)
        (repeat ackermann_n-1)))))

