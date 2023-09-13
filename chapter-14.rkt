#lang pie

;; PREREQUISITES
(claim sandwich (-> Atom Atom))
(define sandwich (lambda (which) 'delicious))

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
  (lambda (X)
    (Either X Trivial)))

; 297:9
(claim nothing
  (Pi ((E U))
    (Maybe E)))
(define nothing
  (lambda (E)
    (right sole)))

; 297:10
(claim just
  (Pi ((E U))
    (-> E
      (Maybe E))))
(define just
  (lambda (E)
    (lambda (e)
      (left e))))

; 298:14
(claim maybe-head
  (Pi ((E U))
    (-> (List E)
      (Maybe E))))
(define maybe-head
  (lambda (E)
    (lambda (es)
      (rec-List es
        (nothing E)
        (lambda (e es maybe-head_es)
          (just E e))))))

; 298:16
(claim maybe-tail
  (Pi ((E U))
    (-> (List E)
      (Maybe (List E)))))
(define maybe-tail
  (lambda (E)
    (lambda (es)
      (rec-List es
        (nothing (List E))
        (lambda (e es maybe-tail_es)
            (just (List E) es))))))

; 300:23
(claim step-list-ref
  (Pi ((E U))
    (-> Nat (-> (List E)
              (Maybe E))
      (-> (List E)
        (Maybe E)))))
(define step-list-ref
  (lambda (E)
    (lambda (n-1 list-ref_n-1)
      (lambda (es)
        (ind-Either (maybe-tail E es)
          (lambda (maybe_tl)
            (Maybe E))
          (lambda (tl)
            (list-ref_n-1 tl))
          (lambda (none)
            (nothing E)))))))

; 300:24
(claim list-ref
  (Pi ((E U))
    (-> Nat (List E)
      (Maybe E))))
(define list-ref
  (lambda (E)
    (lambda (n)
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
  (lambda (x)
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
  (lambda (n)
    (iter-Nat n
      Absurd
      Maybe)))

; 307:57
(claim fzero
  (Pi ((n Nat))
    #;(Fin (add1 n))
    (Maybe (Fin n))))
(define fzero
  (lambda (n)
    (nothing (Fin n))))

; 308:60
(claim fadd1
  (Pi ((n Nat))
    (-> (Fin n)
      (Fin (add1 n)))))
(define fadd1
  (lambda (n)
    (lambda (i-1)
      (just (Fin n) i-1))))

; 309:65
(claim base-vec-ref
  (Pi ((E U))
    (-> (Fin 0) (Vec E 0)
      E)))
(define base-vec-ref
  (lambda (E)
    (lambda (no-value-ever es)
      (ind-Absurd no-value-ever
        E))))

; 311:70
(claim step-vec-ref
  (Pi ((E U)
       (l-1 Nat))
    (-> (-> (Fin l-1) (Vec E l-1)
          E)
      (-> (Fin (add1 l-1)) (Vec E (add1 l-1))
        E))))
(define step-vec-ref
  (lambda (E l-1)
    (lambda (vec-ref_l-1)
      (lambda (i es)
        (ind-Either i
          (lambda (maybe_i)
            E)
          (lambda (i-1)
            (vec-ref_l-1 i-1 (tail es)))
          (lambda (triv)
            (head es)))))))

; 311:71
(claim vec-ref
  (Pi ((E U)
       (l Nat))
    (-> (Fin l) (Vec E l)
      E)))
(define vec-ref
  (lambda (E l)
    (ind-Nat l
      (lambda (k)
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
  (lambda (n)
    (iter-Nat n
      Two
      (lambda (type)
        (-> Two
          Two)))))

; 315
#;(claim both-left
  (-> Two Two
    Two))
#;(define both-left
  (lambda (a b)
    (ind-Either a
      (lambda (c)
        Two)
      (lambda (left-sole)
        b)
      (lambda (right-sole)
        (right sole)))))

; 315
#;(claim step-taut
  (Pi ((n-1 Nat))
    (-> (-> (Two-Fun n-1)
          Two)
      (-> (Two-Fun (add1 n-1))
        Two))))
#;(define step-taut
  (lambda (n-1 taut_n-1)
    (lambda (f)
      (both-left
        (taut_n-1
          (f (left sole)))
        (taut_n-1
          (f (right sole)))))))
#;(define step-taut
  (lambda (n-1 taut_n-1)
    (lambda (f)
      (both-left
        (taut_n-1
          (f (left sole)))
        (taut_n-1
          (f (right sole)))))))

; 315
#;(claim taut
  (Pi ((n Nat))
    (-> (Two-Fun n)
      Two)))
#;(define taut
  (lambda (n)
    (ind-Nat n
      (lambda (k)
        (-> (Two-Fun k)
            Two))
      (lambda (x)
        x)
      step-taut)))

