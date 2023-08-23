#lang pie

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Intermediate Law of Application 
;;
;; If f is a 
;;   (Pi ((Y U))
;;     X)
;; and Z is a U, then
;;   (f Z)
;; is an X
;;   where every Y has been consistently replaced by Z.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 103:41
(claim elim-Pair_1 ; no hoisting
  (Pi ((A U)
       (D U)
       (X U))
    (-> (Pair A D)
        (-> A D
          X)
      X)))
(define elim-Pair_1
  (lambda (A D X)
    (lambda (p f)
      (f (car p) (cdr p)))))

; 103:42
(claim kar_1
  (-> (Pair Nat Nat)
    Nat))
(define kar_1
  (lambda (p)
    (elim-Pair_1
      Nat Nat
      Nat
      p
      (lambda (a d)
        a))))

; 103:42
(claim kdr_1
  (-> (Pair Nat Nat)
    Nat))
(define kdr_1
  (lambda (p)
    (elim-Pair_1
      Nat Nat
      Nat
      p
      (lambda (a d)
        d))))

; 104:43
(claim swap
  (-> (Pair Nat Atom)
    (Pair Atom Nat)))
(define swap
  (lambda (p)
    (elim-Pair_1
      Nat Atom
      (Pair Atom Nat)
      p
      (lambda (a d)
        (cons d a)))))

; 104:43
(claim twin
  (Pi ((T U))
    (-> T
      (Pair T T))))
(define twin
  (lambda (T)
    (lambda (v)
      (cons v v))))

