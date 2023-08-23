#lang pie

; 109:3
(claim expectations
  (List Atom))
(define expectations
  (:: 'cooked
    (:: 'eaten
      (:: 'tried-cleaning
        (:: 'understood
          (:: 'slept nil))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of List
;;
;; If E is a type,
;; then (List E) is a type.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 112:20
(claim rugbrod
  (List Atom))
(define rugbrod
  (:: 'rye-flour
    (:: 'rye-kernels
      (:: 'water
        (:: 'sourdough
          (:: 'salt nil))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of nil
;;
;; nil is a (List E), no matter what type E is.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of ::
;;
;; If e is an E and es is a (List E),
;; then (:: e es) is a (List E).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 115:31
(claim toppings
  (List Atom))
(define toppings
  (:: 'potato
    (:: 'butter nil)))

; 115:31
(claim condiments
  (List Atom))
(define condiments
  (:: 'chives
    (:: 'mayonnaise nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of rec-List
;;
;; If target is a (List E), base is an X, and step is an
;;   (-> E (List E) X
;;     X),
;; then
;;   (rec-List target
;;     base
;;     step)
;; is an X.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment of rec-List
;;
;; If (rec-List
;;      base
;;      step)
;; is an X, then it is the same X as base.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment of rec-List
;;
;; If (rec-List (:: e es)
;;      base
;;      step)
;; is an X, then it is the same X as
;;   (step e es
;;     (rec-List es
;;       base
;;       step)).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 118:38
(claim step-length
  (Pi ((E U))
    (-> E (List E) Nat
      Nat)))
(define step-length
  (lambda (E)
    (lambda (e es length_es)
      (add1 length_es))))

; 119:39
(claim length
  (Pi ((E U))
    (-> (List E)
      Nat)))
(define length
  (lambda (E)
    (lambda (es)
      (rec-List es
        0
        (step-length E)))))

; 119:42
(claim length-Atom
  (-> (List Atom)
    Nat))
(define length-Atom
  (length Atom))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; List Entry Types
;;
;; All the entries in a list must have the same type.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 122:54
(claim step-append
  (Pi ((E U))
    (-> E (List E) (List E)
      (List E))))
(define step-append
  (lambda (E)
    (lambda  (e es step-append_es)
      (:: e step-append_es))))

; 122:54
(claim append
  (Pi ((E U))
    (-> (List E) (List E)
      (List E))))
(define append
  (lambda (E)
    (lambda (start end)
      (rec-List start
        end
        (step-append E)))))

; 124:62
(claim snoc
  (Pi ((E U))
    (-> (List E) E
      (List E))))
(define snoc
  (lambda (E)
    (lambda (start end)
      (rec-List start
        (:: end nil)
        (step-append E)))))

; 125:66
(claim step-reverse
  (Pi ((E U))
    (-> E (List E) (List E)
      (List E))))
(define step-reverse
  (lambda (E)
    (lambda (e es step-reverse_es)
      (snoc E step-reverse_es e))))

; 125:66
(claim reverse
  (Pi ((E U))
    (-> (List E)
      (List E))))
(define reverse
  (lambda (E)
    (lambda (es)
      (rec-List es
        (the (List E) nil)
        (step-reverse E)))))

; 125:67
(claim kartoffelmad
  (List Atom))
(define kartoffelmad
  (append Atom
    (append Atom
      condiments toppings)
    (reverse Atom
      (:: 'plate
        (:: 'rye-bread nil)))))
