#lang pie

;; PREREQUISITES
(claim sandwich (-> Atom Atom))
(define sandwich (λ (which) 'delicious))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Trivial                                                           ;;
;; Trivial is a type.                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of sole                                                              ;;
;;                                                                              ;;
;; sole is Trivial.                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Commandment of sole                                                      ;;
;;                                                                              ;;
;; If e is a Trivial, then e is the same as sole.                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 296:8
(claim Maybe
  (-> U
    U))
(define Maybe
  (λ (X)
    (Either X Trivial)))

; 297:9
(claim nothing
  (Π ((E U))
    (Maybe E)))
(define nothing
  (λ (E)
    (right sole)))

; 297:10
(claim just
  (Π ((E U))
    (-> E
      (Maybe E))))
(define just
  (λ (E)
    (λ (e)
      (left e))))

; 298:14
(claim maybe-head
  (Π ((E U))
    (-> (List E)
      (Maybe E))))
(define maybe-head
  (λ (E)
    (λ (es)
      (rec-List es
        (nothing E)
        (λ (e es maybe-head_es)
          (just E e))))))

; 298:16
(claim maybe-tail
  (Π ((E U))
    (-> (List E)
      (Maybe (List E)))))
(define maybe-tail
  (λ (E)
    (λ (es)
      (rec-List es
        (nothing (List E))
        (λ (e es maybe-tail_es)
            (just (List E) es))))))

; 300:23
(claim step-list-ref
  (Π ((E U))
    (-> Nat (-> (List E)
              (Maybe E))
      (-> (List E)
        (Maybe E)))))
(define step-list-ref
  (λ (E)
    (λ (n-1 list-ref_n-1)
      (λ (es)
        (ind-Either (maybe-tail E es)
          (λ (maybe_tl)
            (Maybe E))
          (λ (tl)
            (list-ref_n-1 tl))
          (λ (none)
            (nothing E)))))))

; 300:24
(claim list-ref
  (Π ((E U))
    (-> Nat (List E)
      (Maybe E))))
(define list-ref
  (λ (E)
    (λ (n)
      (rec-Nat n
        (maybe-head E)
        (step-list-ref E)))))

;; Take a short break, and maybe eat some delicious ratatouille.

; 301:28
(claim menu
  (Vec Atom 4))
(define menu
  (vec:: 'ratatouille
    (vec:: 'kartoffelmad
      (vec:: (sandwich 'hero)
        (vec:: 'prinsesstarta vecnil)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Absurd                                                            ;;
;;                                                                              ;;
;; Absurd is a type.                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 303:27
(claim similarly-absurd
  (-> Absurd
    Absurd))
(define similarly-absurd
  (λ (x)
    x)) ; I dare you to run this function!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Commandment of Absurdities                                               ;;
;;                                                                              ;;
;; Every expression if type Absurd is neutral, and all of them are the same.    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of ind-Absurd                                                        ;;
;;                                                                              ;;
;; The expression                                                               ;;
;;   (ind-Absurd target                                                         ;;
;;     mot)                                                                     ;;
;; is a mot if target is an Absurd and mot is a U.                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 306:50
(claim Fin
  (-> Nat
    U))
(define Fin
  (λ (n)
    (iter-Nat n
      Absurd
      Maybe)))

; 307:57
(claim fzero
  (Π ((n Nat))
    #;(Fin (add1 n))
    (Maybe (Fin n))))
(define fzero
  (λ (n)
    (nothing (Fin n))))

; 308:60
(claim fadd1
  (Π ((n Nat))
    (-> (Fin n)
      (Fin (add1 n)))))
(define fadd1
  (λ (n)
    (λ (i-1)
      (just (Fin n) i-1))))

; 309:65
(claim base-vec-ref
  (Π ((E U))
    (-> (Fin 0) (Vec E 0)
      E)))
(define base-vec-ref
  (λ (E)
    (λ (no-value-ever es)
      (ind-Absurd no-value-ever
        E))))

; 311:70
(claim step-vec-ref
  (Π ((E U)
       (l-1 Nat))
    (-> (-> (Fin l-1) (Vec E l-1)
          E)
      (-> (Fin (add1 l-1)) (Vec E (add1 l-1))
        E))))
(define step-vec-ref
  (λ (E l-1)
    (λ (vec-ref_l-1)
      (λ (i es)
        (ind-Either i
          (λ (maybe_i)
            E)
          (λ (i-1)
            (vec-ref_l-1 i-1 (tail es)))
          (λ (triv)
            (head es)))))))

; 311:71
(claim vec-ref
  (Π ((E U)
       (l Nat))
    (-> (Fin l) (Vec E l)
      E)))
(define vec-ref
  (λ (E l)
    (ind-Nat l
      (λ (k)
        (-> (Fin k) (Vec E k)
          E))
      (base-vec-ref E)
      (step-vec-ref E))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Turner's Teaser                                                              ;;
;;                                                                              ;;
;; Define a function that determines whether another function that accepts any  ;;
;; number of Eithers always returns left. Some say that this can be difficult   ;;
;; with types. Perhaps they are right; perhaps not.                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 315
#;(claim Two
  U)
#;(define Two
  (Either Trivial Trivial))

; 315
#;(claim Two-Fun
  (-> Nat
    U))
#;(define Two-Fun
  (λ (n)
    (iter-Nat n
      Two
      (λ (type)
        (-> Two
          Two)))))

; 315
#;(claim both-left
  (-> Two Two
    Two))
#;(define both-left
  (λ (a b)
    (ind-Either a
      (λ (c)
        Two)
      (λ (left-sole)
        b)
      (λ (right-sole)
        (right sole)))))

; 315
#;(claim step-taut
  (Π ((n-1 Nat))
    (-> (-> (Two-Fun n-1)
          Two)
      (-> (Two-Fun (add1 n-1))
        Two))))
#;(define step-taut
  (λ (n-1 taut_n-1)
    (λ (f)
      (both-left
        (taut_n-1
          (f (left sole)))
        (taut_n-1
          (f (right sole)))))))
#;(define step-taut
  (λ (n-1 taut_n-1)
    (λ (f)
      (both-left
        (taut_n-1
          (f (left sole)))
        (taut_n-1
          (f (right sole)))))))

; 315
#;(claim taut
  (Π ((n Nat))
    (-> (Two-Fun n)
      Two)))
#;(define taut
  (λ (n)
    (ind-Nat n
      (λ (k)
        (-> (Two-Fun k)
            Two))
      (λ (x)
        x)
      step-taut)))

