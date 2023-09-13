#lang pie

; 320:21
(claim =consequence
  (→ Nat Nat
    U))
(define =consequence
  (λ (n j)
    (which-Nat n
      (which-Nat j
        Trivial
        (λ (j-1)
          Absurd))
      (λ (n-1)
        (which-Nat j
          Absurd
          (λ (j-1)
            (= Nat n-1 j-1)))))))

; 321:27
(claim =consequence-same
  (Π ((n Nat))
    (=consequence n n)))
(define =consequence-same
  (λ (n)
    (ind-Nat n
      (λ (k)
        (=consequence k k))
      sole
      (λ (n-1 =consequence_n-1)
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
  (Π ((n Nat)
       (j Nat))
    (→ (= Nat n j)
      (=consequence n j))))
(define use-Nat=
  (λ (n j)
    (λ (n=j)
      (replace n=j
        (λ (k)
          (=consequence n k))
        (=consequence-same n)))))

; 326:47
(claim zero-not-add1
  (Π ((n Nat))
    (→ (= Nat 0 (add1 n))
      Absurd)))
(define zero-not-add1
  (λ (n)
    (use-Nat= 0 (add1 n))))

; 327:48
(claim donut-absurdity
  (→ (= Nat 0 6)
    (= Atom 'powdered 'glazed)))
(define donut-absurdity
  (λ (zero=six)
    (ind-Absurd (zero-not-add1 5 zero=six)
      (= Atom 'powdered 'glazed))))

; 327:50
(claim sub1=
  (Π ((n Nat)
       (j Nat))
    (→ (= Nat (add1 n) (add1 j))
      (= Nat n j))))
(define sub1=
  (λ (n j)
    (use-Nat= (add1 n) (add1 j))))

; 328:53
(claim one-not-six
  (→ (= Nat 1 6)
    Absurd))
(define one-not-six
  (λ (one=six)
    (zero-not-add1 4
      (sub1= 0 5 one=six))))

; 330:60
(claim mot-front
  (Π ((E U)
       (k Nat))
    (→ (Vec E k)
      U)))
(define mot-front
  (λ (E k)
    (λ (es)
      (Π ((j Nat))
        (→ (= Nat k (add1 j))
          E)))))

; 332:69
(claim step-front
  (Π ((E U)
       (l Nat)
       (e E)
       (es (Vec E l)))
    (→ (mot-front E l es)
      (mot-front E (add1 l) (vec:: e es)))))
(define step-front
  (λ (E l e es)
    (λ (front_es)
      (λ (j)
        (λ (eq)
          e)))))

; 333:74
(claim front
  (Π ((E U)
       (l Nat))
    (→ (Vec E (add1 l))
      E)))
#;(define front
  (λ (E l)
    (λ (es)
      (ind-Vec (add1 l) es
        (λ (k xs)
          E)
        TODO ; this box cannot be filled; redefine the motive to encode this
        (λ (k h tl front_ys)
          h)))))
(define front
  (λ (E l)
    (λ (es)
      ((ind-Vec (add1 l) es
         (mot-front E)
         (λ (j eq)
           (ind-Absurd (zero-not-add1 j eq)
             E))
         (step-front E))
        l (same (add1 l))))))

; 335:83
#;(claim pem
  (Π ((X U))
    (Either X
      (→ X
        Absurd)))) ; cannot be defined

; 339:103
(claim pem-not-false
  (Π ((X U))
    (→ (→ (Either X
              (→ X
                Absurd))
          Absurd)
      Absurd)))
(define pem-not-false
  (λ (X)
    (λ (pem-false)
      (pem-false
        (right
          (λ (x)
            (pem-false
              (left x))))))))

; 340:107
(claim Dec
  (→ U
    U))
(define Dec
  (λ (X)
    (Either X
      (→ X
        Absurd))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enjoy your donuts                                                            ;;
;;                                                                              ;;
;; you'll need your energy for tomorrow's decisions.                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

