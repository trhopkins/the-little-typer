#lang pie

; PREREQUISITE
(claim + (-> Nat Nat Nat))
(define + (λ (lhs rhs) (iter-Nat lhs rhs (λ (n) (add1 n)))))

; 171:5
(claim incr
  (-> Nat
    Nat))
(define incr
  (λ (n)
    (rec-Nat n
      1
      (λ (n-1)
        (+ 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of =                                                                 ;;
;;                                                                              ;;
;; An expression                                                                ;;
;;   (= X from to)                                                              ;;
;; is a type if X is a type, from is an X, and to is an X.                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reading FROM and TO as Nouns                                                 ;;
;;                                                                              ;;
;; Because from and to are convenient names, the corresponding parts of an      ;;
;; =-expression are referred to as the FROM and the TO.                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of same                                                              ;;
;;                                                                              ;;
;; The expression (same e) is an (= X e e) if e is an X.                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 180:41
(claim +1=add1
  (Π ((n Nat))
    (= Nat (+ 1 n) (add1 n))))
(define +1=add1
  (λ (n)
    (same (add1 n))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Neutral Expressions                                                          ;;
;;                                                                              ;;
;; Variables that are not defined are neutral. If the target of an eliminator   ;;
;; expression is neutral, then the eliminator expression is neutral. Thus,      ;;
;; values are not neutral.                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 185:59
(claim base-incr=add1
  (= Nat (incr 0) (add1 0)))
(define base-incr=add1
  (same (add1 0)))

; 185:60
(claim mot-incr=add1
  (-> Nat
    U))
(define mot-incr=add1
  (λ (n)
    (= Nat (incr n) (add1 n))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; "If" and "Then" as Types                                                     ;;
;;                                                                              ;;
;; The expression                                                               ;;
;;   (-> X                                                                      ;;
;;     Y)                                                                       ;;
;; can be read as the statement,                                                ;;
;;   "if X then Y."                                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Observation about incr                                                       ;;
;;                                                                              ;;
;; No matter which Nat n is,                                                    ;;
;;   (incr (add1 n))                                                            ;;
;; is the same Nat as                                                           ;;
;;   (add1 (incr n)).                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of cong                                                              ;;
;;                                                                              ;;
;; If f is an                                                                   ;;
;;   (-> X                                                                      ;;
;;     Y)                                                                       ;;
;; and target is an (= X from to),                                              ;;
;; then (cong target f) is an (= Y (f from) (f to)).                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 191:80
(claim step-incr=add1
  (Π ((n-1 Nat))
    (-> (= Nat
          (incr n-1)
          (add1 n-1))
      (= Nat
        (add1 (incr n-1))
        (add1 (add1 n-1)))))) ; swap incr/add1
(define step-incr=add1
  (λ (n)
    (λ (step-incr=add1_n-1)
      (cong step-incr=add1_n-1 (+ 1)))))

; 192:81
(claim incr=add1
  (Π ((n Nat))
    (= Nat (incr n) (add1 n))))
(define incr=add1
  (λ (n)
    (ind-Nat n
      mot-incr=add1
      base-incr=add1
      step-incr=add1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Commandment of cong                                                      ;;
;;                                                                              ;;
;; If x is an X, and f is an                                                    ;;
;;   (-> X                                                                      ;;
;;     Y),                                                                      ;;
;; then (cong (same x) f) is the same                                           ;;
;;   (= Y (f x) (f x))                                                          ;;
;; as                                                                           ;;
;;   (same (f x)).                                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 195:90
(claim sandwich
  (-> Atom
    Atom))
(define sandwich
  (λ (which-sandwich)
    'delicious))

