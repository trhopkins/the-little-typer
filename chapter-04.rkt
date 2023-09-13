#lang pie

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Intermediate Law of Application                                          ;;
;;                                                                              ;;
;; If f is a                                                                    ;;
;;   (Π ((Y U))                                                                ;;
;;     X)                                                                       ;;
;; and Z is a U, then                                                           ;;
;;   (f Z)                                                                      ;;
;; is an X                                                                      ;;
;;   where every Y has been consistently replaced by Z.                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 103:41
(claim elim-Pair_1 ; no hoisting
  (Π ((A U)
       (D U)
       (X U))
    (-> (Pair A D)
        (-> A D
          X)
      X)))
(define elim-Pair_1
  (λ (A D X)
    (λ (p f)
      (f (car p) (cdr p)))))

; 103:42
(claim kar_1
  (-> (Pair Nat Nat)
    Nat))
(define kar_1
  (λ (p)
    (elim-Pair_1
      Nat Nat
      Nat
      p
      (λ (a d)
        a))))

; 103:42
(claim kdr_1
  (-> (Pair Nat Nat)
    Nat))
(define kdr_1
  (λ (p)
    (elim-Pair_1
      Nat Nat
      Nat
      p
      (λ (a d)
        d))))

; 104:43
(claim swap
  (-> (Pair Nat Atom)
    (Pair Atom Nat)))
(define swap
  (λ (p)
    (elim-Pair_1
      Nat Atom
      (Pair Atom Nat)
      p
      (λ (a d)
        (cons d a)))))

; 104:43
(claim twin
  (Π ((T U))
    (-> T
      (Pair T T))))
(define twin
  (λ (T)
    (λ (v)
      (cons v v))))

