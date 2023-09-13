#lang pie

; 320:21
(claim =consequence
  (-> Nat Nat
    U))
(define =consequence
  (lambda (n j)
    (which-Nat n
      (which-Nat j
        Trivial
        (lambda (j-1)
          Absurd))
      (lambda (n-1)
        (which-Nat j
          Absurd
          (lambda (j-1)
            (= Nat n-1 j-1)))))))

; 321:27
(claim =consequence-same
  (Pi ((n Nat))
    (=consequence n n)))
(define =consequence-same
  (lambda (n)
    (ind-Nat n
      (lambda (k)
        (=consequence k k))
      sole
      (lambda (n-1 =consequence_n-1)
        (same n-1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Imagine That...                                                              ;;
;;                                                                              ;;
;; Using types, it is possible to assume things that may or may not be true, an ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sameness versus Equality                                                     ;;
;;                                                                              ;;
;; Either two expressions are the same, or they are not. It is impossible to pr ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 325:42
(claim use-Nat=
  (Pi ((n Nat)
       (j Nat))
    (-> (= Nat n j)
      (=consequence n j))))
(define use-Nat=
  (lambda (n j)
    (lambda (n=j)
      (replace n=j
        (lambda (k)
          (=consequence n k))
        (=consequence-same n)))))

; 326:47
(claim zero-not-add1
  (Pi ((n Nat))
    (-> (= Nat 0 (add1 n))
      Absurd)))
(define zero-not-add1
  (lambda (n)
    (use-Nat= 0 (add1 n))))

; 327:48
(claim donut-absurdity
  (-> (= Nat 0 6)
    (= Atom 'powdered 'glazed)))
(define donut-absurdity
  (lambda (zero=six)
    (ind-Absurd (zero-not-add1 5 zero=six)
      (= Atom 'powdered 'glazed))))

; 327:50
(claim sub1=
  (Pi ((n Nat)
       (j Nat))
    (-> (= Nat (add1 n) (add1 j))
      (= Nat n j))))
(define sub1=
  (lambda (n j)
    (use-Nat= (add1 n) (add1 j))))

; 328:53
(claim one-not-six
  (-> (= Nat 1 6)
    Absurd))
(define one-not-six
  (lambda (one=six)
    (zero-not-add1 4
      (sub1= 0 5 one=six))))

; 330:60
(claim mot-front
  (Pi ((E U)
       (k Nat))
    (-> (Vec E k)
      U)))
(define mot-front
  (lambda (E k)
    (lambda (es)
      (Pi ((j Nat))
        (-> (= Nat k (add1 j))
          E)))))

; 332:69
(claim step-front
  (Pi ((E U)
       (l Nat)
       (e E)
       (es (Vec E l)))
    (-> (mot-front E l es)
      (mot-front E (add1 l) (vec:: e es)))))
(define step-front
  (lambda (E l e es)
    (lambda (front_es)
      (lambda (j)
        (lambda (eq)
          e)))))

; 333:74
(claim front
  (Pi ((E U)
       (l Nat))
    (-> (Vec E (add1 l))
      E)))
#;(define front
  (lambda (E l)
    (lambda (es)
      (ind-Vec (add1 l) es
        (lambda (k xs)
          E)
        TODO ; this box cannot be filled; redefine the motive to encode this
        (lambda (k h tl front_ys)
          h)))))
(define front
  (lambda (E l)
    (lambda (es)
      ((ind-Vec (add1 l) es
         (mot-front E)
         (lambda (j eq)
           (ind-Absurd (zero-not-add1 j eq)
             E))
         (step-front E))
        l (same (add1 l))))))

; 335:83
#;(claim pem
  (Pi ((X U))
    (Either X
      (-> X
        Absurd)))) ; cannot be defined

; 339:103
(claim pem-not-false
  (Pi ((X U))
    (-> (-> (Either X
              (-> X
                Absurd))
          Absurd)
      Absurd)))
(define pem-not-false
  (lambda (X)
    (lambda (pem-false)
      (pem-false
        (right
          (lambda (x)
            (pem-false
              (left x))))))))

; 340:107
(claim Dec
  (-> U
    U))
(define Dec
  (lambda (X)
    (Either X
      (-> X
        Absurd))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enjoy your donuts                                                            ;;
;;                                                                              ;;
;; you'll need your energy for tomorrow's decisions.                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

