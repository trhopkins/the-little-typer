#lang pie

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dependent Types
;;
;; A type that is determined by something that is not a type is called a dependent
;; type.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Use ind-Nat for Dependent Types
;;
;; Use ind-Nat instead of rec-Nat when the rec-Nat- or ind-Nat- expression's type
;; depends on the target Nat. The ind-Nat- expression's type is the motive applied
;; to the target.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 145:13
(claim mot-peas
  (-> Nat
    U))
(define mot-peas
  (lambda (k)
    (Vec Atom k)))

; 147:20
(claim step-peas
  (Pi ((l-1 Nat))
    (-> (mot-peas l-1)
      (mot-peas (add1 l-1)))))
(define step-peas
  (lambda (l-1)
    (lambda (peas_l-1)
      (vec:: 'pea peas_l-1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of ind-Nat
;;
;; If target is a Nat, mot is an
;;   (-> Nat
;;     U),
;; base is a (mot zero), and step is a
;;   (Pi ((n-1 Nat))
;;     (-> (mot n-1)
;;      (mot (add1 n-1)))),
;; then
;;   (ind-Nat target
;;     mot
;;     base
;;     step)
;; is a (mot traget).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment of ind-Nat
;;
;; The ind-Nat-expression
;;   (ind-Nat zero
;;     mot
;;     base
;;     step)
;; is the same (mot zero) as base.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment of ind-Nat
;;
;; The ind-Nat-expression
;;   (ind-Nat (add1 n)
;;     mot
;;     base
;;     step)
;; and
;;   (step n)
;;     (ind-Nat n
;;       mot
;;       base
;;       step))
;; are the same (mot (add1 n)).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Induction on Natural Numbers
;;
;; Building a value for any natural number by giving a value for zero and a way to
;; transform a value for n into a value for n + 1 is called induction on natural
;; numbers.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 149:25
(claim peas
  (Pi ((l Nat))
    (Vec Atom l)))
(define peas
  (lambda (l)
    (ind-Nat l
      mot-peas
      vecnil
      step-peas)))

; 150:27
(claim also-rec-Nat
  (Pi ((X U))
    (-> Nat
        X
        (-> Nat X
          X)
      X)))
(define also-rec-Nat
  (lambda (X)
    (lambda (target base step)
      (ind-Nat target
        (lambda (k)
	  X)
	base
	step))))

; 152:34
(claim base-last
  (Pi ((E U))
    (-> (Vec E 1)
      E)))
(define base-last
  (lambda (E)
    (lambda (es)
      (head es))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ind-Nat's Base Type
;;
;; In ind-Nat, the base's type is the motive applied to the target zero.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 153:40
(claim mot-last
  (-> U Nat
    U))
(define mot-last
  (lambda (E k)
    (-> (Vec E (add1 k))
      E)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ind-Nat's Step Type
;;
;; In ind-Nat, the step must take two arguments: some Nat n and an almost-answer
;; whose type is the motive applied to n. The type of the answer from the step is
;; the motive applied to (add1 n). The step's type is:
;;   (Pi ((n Nat))
;;     (-> (mot n)
;;       (mot (add1 n))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 156:49
(claim step-last
  (Pi ((E U)
       (l-1 Nat))
    (-> (mot-last E l-1)
      (mot-last E (add1 l-1)))))
(define step-last
  (lambda (E l-1)
    (lambda (last_l-1)
      (lambda (es)
        (last_l-1 (tail es))))))

; 157:54
(claim last
  (Pi ((E U)
       (l Nat))
    (-> (Vec E (add1 l))
      E)))
(define last
  (lambda (E l)
    (ind-Nat l
      (mot-last E)
      (base-last E)
      (step-last E))))

; 159:61
(claim base-drop-last
  (Pi ((E U))
    (-> (Vec E 1)
      (Vec E 0))))
(define base-drop-last
  (lambda (E)
    (lambda (es)
      vecnil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Readable Expressions
;;
;; Getting the right answer is worthless if we do not know that it is correct.
;; Understanding the answer is at least as important as having the correct answer.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 160:64
(claim mot-drop-last
  (-> U Nat
    U))
(define mot-drop-last
  (lambda (E l)
    (-> (Vec E (add1 l))
      (Vec E l))))

; 161:67
(claim step-drop-last
  (Pi ((E U)
       (l Nat))
    (-> (mot-drop-last E l)
      (mot-drop-last E (add1 l)))))
(define step-drop-last
  (lambda (E l)
    (lambda (drop-last_l-1)
      (lambda (es)
        (vec:: (head es)
          (drop-last_l-1 (tail es)))))))

; 161:69
(claim drop-last
  (Pi ((E U)
       (l Nat))
    (-> (Vec E (add1 l))
      (Vec E l))))
(define drop-last
  (lambda (E l)
    (ind-Nat l
      (mot-drop-last E)
      (base-drop-last E)
      (step-drop-last E))))

