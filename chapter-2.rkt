#lang pie

; prerequisites
(claim +
  (-> Nat Nat
    Nat))
(define +
  (lambda (lhs rhs)
    (iter-Nat lhs
      rhs
      (lambda (n-1)
        (add1 n-1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constructors and Eliminators
;;
;; Constructors build values, and eliminators take apart values built by
;; constructors.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eliminating Functions
;;
;; Applying a function to arguments is the eliminator for functions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Initial Law of Application
;;
;; If f is an
;;   (-> Y
;;     X)
;; and arg is a Y, then
;;   (f arg)
;; is an X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Initial First Commandment of lambda
;;
;; Two lambda-expressions that expect the same number of arguments are the same
;; if their bodies are the same after consistently renaming their variables.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Initial Second Commandment of lambda
;;
;; If f is an
;;   (-> Y
;;     X),
;; then f is the same
;;   (-> Y
;;     X)
;; as
;;   (lambda (y)
;;     (f y)),
;; as long as y does not occur in f.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Renaming Variables
;;
;; Consistently renaming variables can't change the meaning of anything.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Commandment of Neutral Expressions
;;
;; Neutral expressions that are written identically are the same, no matter
;; their type.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 43:35
(claim vegetables
  (Pair Atom Atom))
(define vegetables
  (cons 'celery 'carrot))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law and Commandment of define
;;
;; Following
;;   (claim name X) and (define name expr),
;; if
;;   expr is an X,
;; then
;;   name is an X
;; and
;;   name is the same X as expr.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment of cons
;;
;; If p is a (Pair A D), then it is the same (Pair A D) as (cons (car p) (cdr
;; p)).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 45:39
#;(claim five
    Nat)
#;(define five
    (+ 7 2)) ; foolish

; 45:42
#;(claim zero
    Nat)
#;(define zero
    0) ; already defined

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Names in Definitions
;;
;; In Pie, only names that are not already used, whther for constructors,
;; eliminators, or previous definitions, can be used with claim or define.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dim Names
;;
;; Unused names are written dimly, but they do need to be there.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of which-Nat
;;
;; If target is a Nat, base is an X, and step is an
;;   (-> Nat
;;     X),
;; then
;;   (which-Nat target
;;     base
;;     step)
;; is an X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment of which-Nat
;; If (which-Nat zero
;;      base
;;      step)
;; is an X, then it is the same X as base.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment of which-Nat
;;
;; If (which-Nat (add1 n)
;;      base
;;      step)
;; is an X, then it is the same X as (step n).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 49:52
(claim gauss
  (-> Nat
    Nat))

; 51:59
#;(define gauss
    (lambda (n)
      (which-Nat n
        0
        (lambda (n-1)
          (+ (add1 (n-1) (gauss n-1))))))) ; recursion is not an option

; 52:64
#;(claim forever
    (-> Nat
      Atom))
#;(define forever
    (lambda (and-ever)
      (forever and-ever))) ; --because recursion is not an option!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Type Values
;; 
;; An expression that is described by a type is a value when it has a
;; constructor at its top. Similarly, an expression that is a type is a value
;; when it has a type constructor at its top.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Every U Is a Type
;; 
;; Every expression described by U is a type, but not every type is described
;; by U.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 55:80
(claim Pear
  U)
(define Pear
  (Pair Nat Nat))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Definitions Are Unnecessary
;;
;; Everything can be done without definitions, but they do improve understanding.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 58:93
(claim Pear-maker
  U)
(define Pear-maker
  (-> Nat Nat
    Pear))

; 58:93
(claim elim-Pear
  (-> Pear Pear-maker
    Pear))
(define elim-Pear
  (lambda (pear maker)
    (maker (car pear) (cdr pear))))

; 58:93
#;(claim elim-Pear
    (-> (Pair Nat Nat)
        (-> Nat Nat
          (Pair Nat Nat))
      (Pair Nat Nat)))

; 60:100
(claim pearwise-+
  (-> Pear Pear
    Pear))
(define pearwise-+
  (lambda (anjou bosc)
    (elim-Pear anjou
      (lambda (a_1 d_1)
        (elim-Pear bosc
          (lambda (a_2 d_2)
            (cons
              (+ a_1 a_2)
              (+ d_1 d_2))))))))

