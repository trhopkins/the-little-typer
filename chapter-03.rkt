#lang pie

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sameness                                                                     ;;
;;                                                                              ;;
;;If a "same as" chart could show that two expressions are the same, then this  ;;
;;fact can be used anywhere without further justification. "Same As" charts are ;;
;;only to help build understanding.                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Total Function                                                               ;;
;;                                                                              ;;
;; A function that always assigns a value to every possible argument is called  ;;
;; a total function.                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of iter-Nat                                                          ;;
;;                                                                              ;;
;; If target is a Nat, base is an X, and step is an                             ;;
;;   (-> X                                                                      ;;
;;     X),                                                                      ;;
;; then                                                                         ;;
;;   (iter-Nat target                                                           ;;
;;     base                                                                     ;;
;;     step)                                                                    ;;
;; is an X.                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment of iter-Nat                                            ;;
;;                                                                              ;;
;; If (iter-Nat zero                                                            ;;
;;      base                                                                    ;;
;;      step)                                                                   ;;
;; is an X, then it is the same X as base.                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment of iter-Nat                                           ;;
;;                                                                              ;;
;; If (iter-Nat (add1 n)                                                        ;;
;;      base                                                                    ;;
;;      step)                                                                   ;;
;; is an X, then it is the same X as                                            ;;
;;   (step                                                                      ;;
;;     (iter-Nat n                                                              ;;
;;       base                                                                   ;;
;;       step)).                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 75:24
(claim +
  (-> Nat Nat
    Nat))
(define +
  (λ (lhs rhs)
    (iter-Nat lhs
      rhs
      (λ (n)
        (add1 n)))))

; 80:43
(claim step-zerop
  (-> Nat Atom
    Atom))
(define step-zerop
  (λ (n-1 zerop_n-1)
    'nil))

; 80:43
(claim zerop
  (-> Nat
    Atom))
(define zerop
  (λ (n)
    (rec-Nat n
      't
      step-zerop)))

; 82:49
(claim step-gauss
  (-> Nat Nat
    Nat))
(define step-gauss
  (λ (n-1 gauss_n-1)
    (+ (add1 n-1) gauss_n-1)))

; 83:52
(claim gauss
  (-> Nat
    Nat))
(define gauss
  (λ (n)
    (rec-Nat n
      0
      step-gauss)))

; 86:66
(claim step-*
  (-> Nat Nat Nat
    Nat))
(define step-*
  (λ (n n-1 *_n-1)
    (+ n *_n-1)))

; 88:70
(claim *
  (-> Nat Nat
    Nat))
(define *
  (λ (lhs rhs)
    (rec-Nat lhs
      0
      ; (make-step-* rhs)
      (step-* rhs))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of rec-Nat                                                           ;;
;;                                                                              ;;
;; If target is a Nat, base is an X, and step is an                             ;;
;;   (-> Nat X                                                                  ;;
;;     X)                                                                       ;;
;; then                                                                         ;;
;;   (rec-Nat target                                                            ;;
;;      base                                                                    ;;
;;      step)                                                                   ;;
;; is an X.                                                                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment of rec-Nat                                             ;;
;;                                                                              ;;
;; If (rec-Nat zero                                                             ;;
;;      base                                                                    ;;
;;      step)                                                                   ;;
;; is an X, then it is the same X as base.                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment of rec-Nat                                            ;;
;;                                                                              ;;
;; If (rec-Nat (add1 n)                                                         ;;
;;      base                                                                    ;;
;;      step)                                                                   ;;
;; is an X, then it is the same X as                                            ;;
;;   (step n                                                                    ;;
;;     (rec-Nat n                                                               ;;
;;       base                                                                   ;;
;;       step)).                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

