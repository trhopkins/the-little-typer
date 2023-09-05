#lang pie

;; PREREQUISITES
(claim + (-> Nat Nat Nat))
(define + (lambda (lhs rhs) (iter-Nat lhs rhs (lambda (n) (add1 n)))))

(claim step-length (Pi ((E U)) (-> E (List E) Nat Nat)))
(define step-length (lambda (E) (lambda (e es length_es) (add1 length_es))))

(claim length (Pi ((E U)) (-> (List E) Nat)))
(define length (lambda (E) (lambda (es) (rec-List es 0 (step-length E)))))

(claim mot-list->vec (Pi ((E U)) (-> (List E) U)))
(define mot-list->vec (lambda (E) (lambda (es) (Vec E (length E es)))))

(claim step-list->vec (Pi ((E U) (e E) (es (List E))) (-> (mot-list->vec E es) (mot-list->vec E (:: e es)))))
(define step-list->vec (lambda (E e es) (lambda (list->vec_es) (vec:: e list->vec_es))))

(claim list->vec (Pi ((E U) (es (List E))) (Vec E (length E es))))
(define list->vec (lambda (E es) (ind-List es (mot-list->vec E) vecnil (step-list->vec E))))

; 245:2
(claim treats
  (Vec Atom 3))
(define treats
  (vec:: 'kanelbullar
    (vec:: 'plattar
      (vec:: 'prinsesstarta vecnil))))

; 245:2
(claim drinks
  (List Atom))
(define drinks
  (:: 'coffee
    (:: 'cocoa nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of ind-Vec
;;
;; If n is a Nat, target is a (Vec E n), mot is a
;;   (Pi ((k Nat))
;;     (-> (Vec E k)
;;       U)),
;; base is a (mot zero vecnil), and step is a
;;   (Pi ((k Nat)
;;        (h E)
;;        (t (Vec E k)))
;;     (-> (mot k t)
;;       (mot (add1 k) (vec:: h t))))
;; then
;;   (ind-Vec n target
;;     mot
;;     base
;;     step)
;; is a (mot n target).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment of ind-Vec
;;
;; The ind-Vec-expression
;;   (ind-Vec zero vecnil
;;     mot
;;     base
;;     step)
;; is the same (mot zero vecnil) as base.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment of ind-Vec
;;
;; The ind-Vec-expression
;;   (ind-Vec (add1 n) (vec:: e es)
;;     mot
;;     base
;;     step)
;; is the same (mot (add1 n) (vec:: e es)) as
;;   (step n e es
;;     (ind-Vec n es
;;       mot
;;       base
;;       step)).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 251:23
(claim mot-vec-append
  (Pi ((E U)
       (j Nat)
       (k Nat))
    (-> (Vec E k)
      U)))
(define mot-vec-append
  (lambda (E j k)
    (lambda (es)
      (Vec E (+ k j)))))

; 252:26
(claim step-vec-append
  (Pi ((E U)
       (j Nat)
       (k Nat)
       (e E)
       (es (Vec E k)))
    (-> (mot-vec-append E j k es)
      (mot-vec-append E j (add1 k) (vec:: e es)))))
(define step-vec-append
  (lambda (E j k e es)
    (lambda (vec-append_es)
      (vec:: e vec-append_es))))

; 252:27
(claim vec-append
  (Pi ((E U)
       (l Nat)
       (j Nat))
    (-> (Vec E l) (Vec E j)
        (Vec E (+ l j)))))
(define vec-append
  (lambda (E l j)
    (lambda (es end)
      (ind-Vec l es
        (mot-vec-append E j)
        end
        (step-vec-append E j)))))

; 253:28
#;(claim fika
  (Vec Atom 5))
#;(define fika
  (vec-append Atom 3 2
    treats
    (list->vec Atom)))

; 254:31
(claim mot-vec->list
  (Pi ((E U)
       (l Nat))
    (-> (Vec E l)
      U)))
(define mot-vec->list
  (lambda (E l)
    (lambda (es)
      (List E))))

; 254:31
(claim step-vec->list
  (Pi ((E U)
       (l-1 Nat)
       (e E)
       (es (Vec E l-1)))
    (-> (mot-vec->list E l-1 es)
      (mot-vec->list E (add1 l-1) (vec:: e es)))))
(define step-vec->list
  (lambda (E l-1 e es)
    (lambda (vec->list_es)
      (:: e vec->list_es))))

; 254:32
(claim vec->list
  (Pi ((E U)
       (l Nat))
    (-> (Vec E l)
      (List E))))
(define vec->list
  (lambda (E l)
    (lambda (es)
      (ind-Vec l es
        (mot-vec->list E)
        nil
        (step-vec->list E)))))

; unused in the text
(claim base-list->vec->list=
  (Pi ((E U))
    #;(= (List E)
      nil
      nil)
    (= (List E)
      nil
      (vec->list E 0 (list->vec E nil)))))
(define base-list->vec->list=
  (lambda (E)
    (same nil)))

; 256:39
(claim mot-list->vec->list=
  (Pi ((E U))
    (-> (List E)
      U)))
(define mot-list->vec->list=
  (lambda (E)
    (lambda (es)
      (= (List E)
        es
        (vec->list E (length E es) (list->vec E es))))))

; 258:45
(claim Treat-Statement
  U)
(define Treat-Statement
  (Pi ((some-treats (List Atom))
       (more-treats (List Atom)))
    (-> (= (List Atom)
          some-treats
          more-treats)
        (= (List Atom)
          (:: 'plattar some-treats)
          (:: 'plattar more-treats)))))

; 258:46
(claim ::-plattar
  (-> (List Atom)
    (List Atom)))
(define ::-plattar
  (lambda (treats)
    (:: 'plattar treats)))

; 258:46
(claim treat-proof
  Treat-Statement)
(define treat-proof
  (lambda (some more)
    (lambda (treats=)
      (cong treats= ::-plattar))))

; 259:48
(claim length-treats=
  (Pi ((some-treats (List Atom))
       (more-treats (List Atom)))
    (-> (= (List Atom)
        some-treats
        more-treats)
      (= Nat
        (length Atom some-treats)
	(length Atom more-treats)))))
(define length-treats=
  (lambda (some-treats more-treats)
    (lambda (treats=)
      (cong treats= (length Atom)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; When in Doubt, Evaluate
;;
;; Gain insight by finding the values of expressions in types working out
;; examples in "same-as" charts.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(claim ::-func
  (Pi ((E U))
    (-> E (List E)
      (List E))))
(define ::-func
  (lambda (E)
    (lambda (e es)
      (:: e es))))

; 256:40
(claim step-list->vec->list=
  (Pi ((E U)
       (e E)
       (es (List E)))
    (-> (mot-list->vec->list= E es)
      (mot-list->vec->list= E (:: e es)))))
(define step-list->vec->list=
  (lambda (E e es)
    (lambda (list->vec->list=_es)
      (cong list->vec->list=_es (::-func E e)))))

; 261:55
(claim list->vec->list=
  (Pi ((E U)
       (es (List E)))
    (= (List E)
      es
      (vec->list E (length E es) (list->vec E es)))))
(define list->vec->list=
  (lambda (E es)
    (ind-List es
      (mot-list->vec->list= E)
      #;(same nil) ; would work to replace base-list->vec->list=
      (base-list->vec->list= E)
      (step-list->vec->list= E))))

