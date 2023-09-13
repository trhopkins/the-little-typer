#lang pie

;; PREREQUISITES
(claim + (→ Nat Nat Nat))
(define + (λ (lhs rhs) (iter-Nat lhs rhs (λ (n) (add1 n)))))
(claim Dec (→ U U))
(define Dec (λ (X) (Either X (→ X Absurd))))
(claim =consequence (→ Nat Nat U))
(define =consequence (λ (n j) (which-Nat n (which-Nat j Trivial (λ (j-1) Absurd)) (λ (n-1) (which-Nat j Absurd (λ (j-1) (= Nat n-1 j-1)))))))
(claim =consequence-same (Π ((n Nat)) (=consequence n n)))
(define =consequence-same (λ (n) (ind-Nat n (λ (k) (=consequence k k)) sole (λ (n-1 =consequence_n-1) (same n-1)))))
(claim use-Nat= (Π ((n Nat) (j Nat)) (→ (= Nat n j) (=consequence n j))))
(define use-Nat= (λ (n j) (λ (n=j) (replace n=j (λ (k) (=consequence n k)) (=consequence-same n)))))
(claim sub1= (Π ((n Nat) (j Nat)) (→ (= Nat (add1 n) (add1 j)) (= Nat n j))))
(define sub1= (λ (n j) (use-Nat= (add1 n) (add1 j))))
(claim zero-not-add1 (Π ((n Nat)) (→ (= Nat 0 (add1 n)) Absurd)))
(define zero-not-add1 (λ (n) (use-Nat= 0 (add1 n))))

; 345:16
(claim zero?
  (Π ((n Nat))
    (Dec (= Nat 0 n))))
(define zero?
  (λ (j)
    (ind-Nat j
      (λ (k)
        (Dec (= Nat 0 k)))
      (left (same 0))
      (λ (j-1 zero?_j-1)
        (right (zero-not-add1 j-1))))))

; 347:22
(claim mot-nat=?
  (→ Nat
    U))
(define mot-nat=?
  (λ (k)
    (Π ((j Nat))
      (Dec (= Nat k j)))))

; 350:35
(claim add1-not-zero
  (Π ((n Nat))
    (→ (= Nat (add1 n) 0)
      Absurd)))
(define add1-not-zero
  (λ (n)
    (use-Nat= (add1 n) 0)))

; 354:50
(claim dec-add1=
  (Π ((n-1 Nat)
       (j-1 Nat))
    (→ (Dec (= Nat n-1 j-1))
        (Dec (= Nat (add1 n-1) (add1 j-1))))))
(define dec-add1=
  (λ (n-1 j-1 eq-or-not)
    (ind-Either eq-or-not
      (λ (target)
        (Dec (= Nat (add1 n-1) (add1 j-1))))
      (λ (yes)
        (left
          (cong yes (+ 1))))
      (λ (no)
        (right
          (λ (n=j)
            (no
              (sub1= n-1 j-1
                n=j))))))))

; 354:51
(claim step-nat=?
  (Π ((n-1 Nat))
    (→ (mot-nat=? n-1)
      (mot-nat=? (add1 n-1)))))
(define step-nat=?
  (λ (n-1)
    (λ (nat=?_n-1)
      (λ (j)
        (ind-Nat j
          (λ (k)
            (Dec (= Nat (add1 n-1) k)))
          (right (add1-not-zero n-1))
          (λ (j-1 step-nat=?)
            (dec-add1= n-1 j-1
              (nat=?_n-1 j-1))))))))

; 355:52
(claim nat=?
  (Π ((n Nat)
       (j Nat))
    (Dec (= Nat n j))))
(define nat=?
  (λ (n j)
    ((ind-Nat n
       mot-nat=?
       zero?
       step-nat=?)
      j)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Go enjoy a banquet                                                           ;;
;;                                                                              ;;
;; you've earned it!                                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

