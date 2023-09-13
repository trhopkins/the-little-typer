#lang pie

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Chapter 1 of The Little Typer:                                               ;;
;; The More Things Change, the More They Stay the Same                          ;;
;;                                                                              ;;
;; Code examples assembled by Travis Reid Hopkins (trhopkins)                   ;;
;; https://github.com/trhopkins                                                 ;;
;;                                                                              ;;
;; Get yourself this wonderful book at the MIT Press:                           ;;
;; https://mitpress.mit.edu/9780262536431/the-little-typer/                     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of Atoms:

'ratatouille

'---

'Atom

'cœurs-d-artichauts

'άτομου

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Tick Marks:                                                       ;;
;;                                                                              ;;
;; A tick mark directly followed by one or more letters and hyphens is an Atom. ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of judgments:
;
; A judgment is an attitude that a person takes towards expressions, like an
; observation with blank spaces in it.
;
; 'ratatouille is an Atom. ; true
; zero is an Atom.         ; false
;
; 'ratatouille is the same Atom as 'ratatouille. ; true
; 'pomme is the same Atom as 'orange.            ; false
;
; (Pair Atom Atom) is a type. ; true
; 'baguette is a type.        ; false
;
; Atom and Atom are the same type.             ; true
; Atom and (Pair Atom Atom) are the same type. ; false

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Commandment of Tick Marks:                                               ;;
;;                                                                              ;;
;; Two expressions are the same Atom if their values are tick marks followed by ;;
;; identical letters and hyphens.                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of Pairs:

#;(cons 'rataouille 'baguette)
(the (Pair Atom Atom) (cons 'rataouille 'baguette))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Atom:                                                             ;;
;;                                                                              ;;
;; Atom is a type.                                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Four Forms of Judgment:                                                  ;;
;;                                                                              ;;
;; 1. _ is a _.                                                                 ;;
;; 2. _ is a type.                                                              ;;
;; 3. _ is the same _ as _.                                                     ;;
;; 4. _ and _ are the same type.                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Examples of car/cdr
;
; With/without type annotations for decidability:

; 11:38
#;(car (cons 'ratatouille 'baguette))
(the Atom
  (car
    (the (Pair Atom Atom)
      (cons 'ratatouille 'baguette)))) ; 'ratatouille

; 11:39
#;(cdr (cons 'ratatouille 'baguette))
(the Atom
  (cdr
    (the (Pair Atom Atom)
      (cons 'ratatouille 'baguette)))) ; 'baguette

; 11:40
#;(car
    (cons
      (cons 'aubergine 'courgette)
      'tomato))
(the (Pair Atom Atom)
  (car
    (the (Pair (Pair Atom Atom) Atom)
      (cons
        (the (Pair Atom Atom)
          (cons 'aubergine 'courgette))
        'tomato)))) ; (cons 'aubergine 'courgette)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Normal Forms                                                                 ;;
;;                                                                              ;;
;; Given a type, every expression described by that type has a normal form,     ;;
;; which is the most direct way of writing it. If two expressions are the same, ;;
;; then they have identical normal forms, and if they have identical normal     ;;
;; forms, then they are the same.                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Normal Forms and Types                                                       ;;
;;                                                                              ;;
;; Sameness is always according to a type, so normal forms are also determined  ;;
;; by a type.                                                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment of cons                                                ;;
;;                                                                              ;;
;; Two cons-expressions are the same (Pair A D) if their cars are the same A    ;;
;; and their cdrs are the same D. Here, A and D stand for any type.             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Normal Forms of Types                                                        ;;
;;                                                                              ;;
;; Every expression that is a type has a normal form, which is the most direct  ;;
;; way of writing that type. If two expressions are the same type, then they    ;;
;; have identical normal forms, and if two types have identical normal forms,   ;;
;; then they are the same type.                                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 20:79
(claim one
  Nat)
(define one
  #;1
  #;(add1 0)
  (add1 zero))

; 20:79
(claim two
  Nat)
(define two
  (add1 one))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Claims before Definitions
;;
;; Using define to associate a name with an expression requires that the
;; expression's type has previously been associated with the name using claim.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 21:81
(claim four
  Nat)
(define four
  (add1
    (add1
      (add1
        zero))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Values
;;
;; An expression with a constructor at the top is called a value.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Values and Normal Forms
;;
;; Not every value is in normal form. This is because the arguments to a
;; constructor need not be normal. Each expression has only one normal form,
;; but it is sometimes possible to write it as a value in more than one way.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Everything is an Expression
;;
;; In Πe, values are also expressions. Evaluation in Πe finds an expression,
;; not some other kind of thing.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Commandment of zero
;;
;; zero is the same Nat as zero.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Commandment of add1
;;
;; If n is the same Nat as k, then (add1 n) is the same Nat as (add1 k).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Definitions are Forever
;;
;; Once a name has been claimed, it cannot be reclaimed, and once a name has
;; been defined, it cannot be redefined.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
