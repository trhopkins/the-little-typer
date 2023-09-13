#lang pie

;; PREREQUISITES
(claim + (-> Nat Nat Nat))
(define + (λ (lhs rhs) (iter-Nat lhs rhs (λ (n) (add1 n)))))
(claim double (-> Nat Nat))
(define double (λ (n) (iter-Nat n 0 #;(λ (x) (add1 (add1 x))) (+ 2))))
(claim Even (-> Nat U))
(define Even (λ (n) (Σ ((half Nat)) (= Nat n (double half)))))
(claim zero-is-even (Even zero))
(define zero-is-even (cons zero (same zero)))
(claim Odd (-> Nat U))
(define Odd (λ (n) (Σ ((haf Nat)) (= Nat n (add1 (double haf))))))
(claim add1-even->odd (Π ((n Nat)) (-> (Even n) (Odd (add1 n)))))
(define add1-even->odd (λ (n) (λ (even_n) (cons (car even_n) (cong (cdr even_n) (+ 1))))))
(claim add1-odd->even (Π ((n Nat)) (-> (Odd n) (Even (add1 n)))))
(define add1-odd->even (λ (n) (λ (odd_n) (cons (add1 (car odd_n)) (cong (cdr odd_n) (+ 1))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Either                                                            ;;
;;                                                                              ;;
;; (Either L R) is a type if L is a type and R is a type.                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of left                                                              ;;
;;                                                                              ;;
;; (left lt) is an (Either L R) if lt is an L.                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of right                                                             ;;
;;                                                                              ;;
;; (right lt) is an (Either L R) if rt is an R.                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of ind-Either                                                        ;;
;;                                                                              ;;
;; If target is an (Either L R), mot is an                                      ;;
;;   (-> (Either L R)                                                           ;;
;;     U),                                                                      ;;
;; base-left is a                                                               ;;
;;   (Π ((x L))                                                                ;;
;;     (mot (left x))),                                                         ;;
;; and base-right is a                                                          ;;
;;   (Π ((y R))                                                                ;;
;;     (mot (right y))),                                                        ;;
;; then                                                                         ;;
;;   (ind-Either target                                                         ;;
;;     mot                                                                      ;;
;;     base-left                                                                ;;
;;     base-right)                                                              ;;
;; is a (mot target).                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment of ind-Either                                          ;;
;;                                                                              ;;
;;   (ind-Either (left x)                                                       ;;
;;     mot                                                                      ;;
;;     base-left                                                                ;;
;;     base-right)                                                              ;;
;; is the same (mot (left x)) as (base-left x).                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment of ind-Either                                         ;;
;;                                                                              ;;
;;   (ind-Either (right y)                                                      ;;
;;     mot                                                                      ;;
;;     right                                                                    ;;
;;     base-right)                                                              ;;
;; is the same (mot (right y)) as (right y).                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 283:16
(claim mot-even-or-odd
  (-> Nat
    U))
(define mot-even-or-odd
  (λ (n)
    (Either (Even n) (Odd n))))

; 286:30
(claim mot-step-even-or-odd
  (Π ((n-1 Nat)
       (even-or-odd_n-1 (mot-even-or-odd n-1)))
    U))
(define mot-step-even-or-odd
  (λ (n-1 even-or-odd_n-1)
    (mot-even-or-odd (add1 n-1))))

; 286:30
(claim step-even-or-odd
  (Π ((n Nat))
    (-> (mot-even-or-odd n)
        (mot-even-or-odd (add1 n)))))
(define step-even-or-odd
  (λ (n-1)
    (λ (even-or-odd_n-1)
      (ind-Either even-or-odd_n-1
        #;(λ (even-or-odd)
          (mot-even-or-odd (add1 n-1)))
        (mot-step-even-or-odd n-1)
        (λ (even_n-1)
          (right (add1-even->odd n-1 even_n-1)))
        (λ (odd_n-1)
          (left (add1-odd->even n-1 odd_n-1)))))))

; 287:31
(claim even-or-odd
  (Π ((n Nat))
    (Either (Even n) (Odd n))))
(define even-or-odd
  (λ (n)
    (ind-Nat n
      mot-even-or-odd
      (left zero-is-even)
      step-even-or-odd)))

