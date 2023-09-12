#lang pie

;; PREREQUISITES
(claim + (-> Nat Nat Nat))
(define + (lambda (lhs rhs) (iter-Nat lhs rhs (lambda (n) (add1 n)))))
(claim Dec (-> U U))
(define Dec (lambda (X) (Either X (-> X Absurd))))
(claim =consequence (-> Nat Nat U))
(define =consequence (lambda (n j) (which-Nat n (which-Nat j Trivial (lambda (j-1) Absurd)) (lambda (n-1) (which-Nat j Absurd (lambda (j-1) (= Nat n-1 j-1)))))))
(claim =consequence-same (Pi ((n Nat)) (=consequence n n)))
(define =consequence-same (lambda (n) (ind-Nat n (lambda (k) (=consequence k k)) sole (lambda (n-1 =consequence_n-1) (same n-1)))))
(claim use-Nat= (Pi ((n Nat) (j Nat)) (-> (= Nat n j) (=consequence n j))))
(define use-Nat= (lambda (n j) (lambda (n=j) (replace n=j (lambda (k) (=consequence n k)) (=consequence-same n)))))
(claim sub1= (Pi ((n Nat) (j Nat)) (-> (= Nat (add1 n) (add1 j)) (= Nat n j))))
(define sub1= (lambda (n j) (use-Nat= (add1 n) (add1 j))))
(claim zero-not-add1 (Pi ((n Nat)) (-> (= Nat 0 (add1 n)) Absurd)))
(define zero-not-add1 (lambda (n) (use-Nat= 0 (add1 n))))

; 345:16
(claim zero?
  (Pi ((n Nat))
    (Dec (= Nat 0 n))))
(define zero?
  (lambda (j)
    (ind-Nat j
      (lambda (k)
        (Dec (= Nat 0 k)))
      (left (same 0))
      (lambda (j-1 zero?_j-1)
        (right (zero-not-add1 j-1))))))

; 347:22
(claim mot-nat=?
  (-> Nat
    U))
(define mot-nat=?
  (lambda (k)
    (Pi ((j Nat))
      (Dec (= Nat k j)))))

; 350:35
(claim add1-not-zero
  (Pi ((n Nat))
    (-> (= Nat (add1 n) 0)
      Absurd)))
(define add1-not-zero
  (lambda (n)
    (use-Nat= (add1 n) 0)))

; 354:50
(claim dec-add1=
  (Pi ((n-1 Nat)
       (j-1 Nat))
    (-> (Dec (= Nat n-1 j-1))
        (Dec (= Nat (add1 n-1) (add1 j-1))))))
(define dec-add1=
  (lambda (n-1 j-1 eq-or-not)
    (ind-Either eq-or-not
      (lambda (target)
        (Dec (= Nat (add1 n-1) (add1 j-1))))
      (lambda (yes)
        (left
          (cong yes (+ 1))))
      (lambda (no)
        (right
          (lambda (n=j)
            (no
              (sub1= n-1 j-1
                n=j))))))))

; 354:51
(claim step-nat=?
  (Pi ((n-1 Nat))
    (-> (mot-nat=? n-1)
      (mot-nat=? (add1 n-1)))))
(define step-nat=?
  (lambda (n-1)
    (lambda (nat=?_n-1)
      (lambda (j)
        (ind-Nat j
          (lambda (k)
            (Dec (= Nat (add1 n-1) k)))
          (right (add1-not-zero n-1))
          (lambda (j-1 step-nat=?)
            (dec-add1= n-1 j-1
              (nat=?_n-1 j-1))))))))

; 355:52
(claim nat=?
  (Pi ((n Nat)
       (j Nat))
    (Dec (= Nat n j))))
(define nat=?
  (lambda (n j)
    ((ind-Nat n
       mot-nat=?
       zero?
       step-nat=?)
      j)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Go enjoy a banquet
;;
;; you've earned it!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

