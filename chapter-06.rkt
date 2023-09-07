#lang pie

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Vec
;;
;; If E is a type and k is a Nat,
;; then (Vec E k) is a type.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of vecnil
;;
;; vecnil is a (Vec E zero).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of vec::
;;
;; If e is an E and es is a(Vec E k),
;; then (vec:: e es) is a (Vec E (add1 k)).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 134:24
(claim first-of-one
  (Pi ((E U))
    (-> (Vec E 1)
      E)))
(define first-of-one
  (lambda (E)
    (lambda (es)
      (head es))))

; 134:27
(claim first-of-two
  (Pi ((E U))
    (-> (Vec E 2)
      E)))
(define first-of-two
  (lambda (E)
    (lambda (es)
      (head es))))

; 136:34
(claim first
  (Pi ((E U)
       (l Nat))
    (-> (Vec E (add1 l))
      E)))
(define first
  (lambda (E l)
    (lambda (es)
      (head es))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Pi
;;
;; The expression
;;   (Pi ((y Y))
;;     X)
;; is a type when Y is a type, and X is a type if y is a Y.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Use a More Specific Type
;;
;; Make a function total by using a more specific type out rule out unwanted
;; arguments.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -> and Pi
;;
;; The type
;;   (-> Y
;;     X)
;; is a shorter way of saying
;;   (Pi ((y Y))
;;     X)
;; when y is not used in X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Final law of lambda
;; 
;; If x is an X when y is a Y, then
;;   (lambda (y)
;;     x)
;; is a
;;   (Pi ((y Y))
;;     X).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Final Law of Application
;; 
;; If f is a
;;   (Pi ((y Y))
;;     X)
;; and z is a Y, then
;;   (f z)
;; is an X
;;   where every y has been consistently replaced by z.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Final First Commandment of lambda
;; 
;; If two lambda-expressions can be made the same
;;   (Pi ((y Y))
;;     X),
;; by consistently renaming their variables, then they are the same.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Final Second Commandment of lambda
;; 
;; If f is a 
;;   (Pi ((y Y))
;;     X),
;; and y does not occur in f, then if is the same as
;;   (lambda (y)
;;     (f y)).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 141:44
(claim rest
  (Pi ((E U)
       (l Nat))
    (-> (Vec E (add1 l))
      (Vec E l))))
(define rest
  (lambda (E l)
    (lambda (es)
      (tail es))))
