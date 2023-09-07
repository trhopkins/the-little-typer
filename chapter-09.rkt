#lang pie

(claim +
  (-> Nat Nat
    Nat))
(define +
  (lambda (lhs rhs)
    (iter-Nat lhs
      rhs
      (lambda (n)
        (add1 n)))))

(claim incr
  (-> Nat
    Nat))
(define incr
  (lambda (n)
    (rec-Nat n
      1
      (lambda (n-1)
        (+ 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of replace
;;
;; If target is an
;;   (= X from to),
;; mot is an
;;   (-> X
;;     U),
;; and base is a
;;   (mot from)
;; then
;;   (replace target
;;     mot
;;     base)
;; is a
;;   (mot to).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(claim mot-step-incr=add1
  (-> Nat Nat
    U))
(define mot-step-incr=add1
  (lambda (n-1 k)
    (= Nat
      (add1
        (incr n-1))
      (add1
        k))))

; 203:21
(claim double
  (-> Nat
    Nat))
(define double
  (lambda (n)
    (iter-Nat n
      0
      #;(lambda (x)
        (add1 (add1 x)))
      (+ 2))))

; 203:22
(claim twice
  (-> Nat
    Nat))
(define twice
  (lambda (n)
    (+ n n)))

; 205:31
(claim mot-add1+=+add1
  (-> Nat Nat
    U))
(define mot-add1+=+add1
  (lambda (j k)
    (= Nat
      (add1 (+ k j))
      (+ k (add1 j)))))

; 206:33
(claim step-add1+=+add1
  (Pi ((j Nat)
       (n-1 Nat))
    (-> (mot-add1+=+add1 j n-1)
        (mot-add1+=+add1 j (add1 n-1)))))
(define step-add1+=+add1
  (lambda (j n-1)
    (lambda (add1+=+add1_n-1)
      (cong add1+=+add1_n-1 (+ 1)))))

; 207:35
(claim add1+=+add1
  (Pi ((n Nat)
       (m Nat))
    (= Nat
       (add1 (+ n m))
       (+ n (add1 m)))))
(define add1+=+add1
  (lambda (n j)
    (ind-Nat n
      (mot-add1+=+add1 j)
      (same (add1 j))
      (step-add1+=+add1 j))))

; 208:39
(claim mot-twice=double
  (-> Nat
    U))
(define mot-twice=double
  (lambda (n)
    (= Nat
       (twice n)
       (double n))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Observation about +
;;
;; No matter which Nats j and k are,
;;   (+ (add1 j) k)
;; is the same Nat as
;;   (add1
;;     (+ j k)).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 211:48
(claim mot-step-twice=double
  (-> Nat Nat
    U))
(define mot-step-twice=double
  (lambda (n-1 k)
    (= Nat
      (add1 k)
      (add1 (add1 (double n-1))))))

; 212:51
(claim step-twice=double
  (Pi ((n-1 Nat))
    (-> (mot-twice=double n-1)
      (mot-twice=double (add1 n-1)))))
(define step-twice=double
  (lambda (n-1)
    (lambda (twice=double_n-1)
      (replace (add1+=+add1 n-1 n-1)
        (mot-step-twice=double n-1)
        (cong twice=double_n-1 (+ 2))))))

; 212:52
(claim twice=double
  (Pi ((n Nat))
    (= Nat
       (twice n)
       (double n))))
(define twice=double
  (lambda (n)
    (ind-Nat n
      mot-twice=double
      (same 0)
      step-twice=double)))

; 212:53
(claim twice=double-of-17
  (= Nat (twice 17) (double 17)))
(define twice=double-of-17
  (twice=double 17))

; 212:53
(claim twice=double-of-17-again
  (= Nat (twice 17) (double 17)))
(define twice=double-of-17-again
  (same 34))

; 214:59
(claim base-double-Vec
  (Pi ((E U))
    (-> (Vec E zero)
      (Vec E (double zero)))))
(define base-double-Vec
  (lambda (E)
    (lambda (es)
      vecnil)))

; 214:60
(claim mot-double-Vec
  (-> U Nat
    U))
(define mot-double-Vec
  (lambda (E k)
    (-> (Vec E k)
      (Vec E (double k)))))

; 215:61
(claim step-double-Vec
  (Pi ((E U)
       (l-1 Nat))
    (-> (-> (Vec E l-1)
          (Vec E (double l-1)))
        (-> (Vec E (add1 l-1))
          (Vec E (double (add1 l-1)))))))
(define step-double-Vec
  (lambda (E l-1)
    (lambda (double-Vec_l-1)
      (lambda (es)
        (vec:: (head es)
          (vec:: (head es)
            (double-Vec_l-1 (tail es))))))))

; 215:62
(claim double-Vec
  (Pi ((E U)
       (l Nat))
    (-> (Vec E l)
      (Vec E (double l)))))
(define double-Vec
  (lambda (E l)
    (ind-Nat l
        (mot-double-Vec E)
        (lambda (es_l=0)
          vecnil)
        (step-double-Vec E))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Solve Easy Problems First
;;
;; If two functions produce equal results, then use the
;; asier one when defining a dependent function, and
;; then use replace to give it the desired type.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 217:67
(claim twice-Vec
  (Pi ((E U)
       (l Nat))
    (-> (Vec E l)
      (Vec E (twice l)))))
(define twice-Vec
  (lambda (E l)
    (lambda (es)
      (replace (symm (twice=double l))
        (lambda (k)
          (Vec E k))
        (double-Vec E l es)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of symm
;;
;; If e is an
;;   (= X from to),
;; then
;;   (symm e)
;; is an
;;   (= X to from).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Commandment of symm
;;
;; If x is an X, then
;;   (symm (same x))
;; is the same
;;   (= X x x)
;; as
;;   (same x).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
