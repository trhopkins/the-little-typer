#lang pie

; 219:2
(claim more-expectations
  (Vec Atom 3))
(define more-expectations
  (vec:: 'need-induction
    (vec:: 'understood-induction
      (vec:: 'built-function vecnil))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of Σ                                                             ;;
;;                                                                              ;;
;; The expression                                                               ;;
;;   (Σ ((x A))                                                             ;;
;;     D)                                                                       ;;
;; is a type when A is a type, and D is a type if x is an A.                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Commandment of cons                                                      ;;
;;                                                                              ;;
;; If p is a                                                                    ;;
;;   (Σ ((x A))                                                             ;;
;;     D),                                                                      ;;
;; then p is the same as                                                        ;;
;;   (cons (car p) (cdr p)).                                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Use a Specific Type for Correctness                                          ;;
;;                                                                              ;;
;; Specific types can rule out foolish definitions.                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 233:47
(claim mot-replicate
  (-> U Nat
    U))
(define mot-replicate
  (λ (E k)
    (Vec E k)))

; 233:49
(claim step-replicate
  (Π ((E U)
       (e E)
       (l-1 Nat))
    (-> (mot-replicate E l-1)
      (mot-replicate E (add1 l-1)))))
(define step-replicate
  (λ (E e l-1)
    (λ (replicate_l-1)
      (vec:: e replicate_l-1))))

; 233:50
(claim replicate
  (Π ((E U)
       (l Nat))
    (-> E
      (Vec E l))))
(define replicate
  (λ (E l)
    (λ (e)
      (ind-Nat l
        (mot-replicate E)
        vecnil
        (step-replicate E e)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Law of ind-List                                                          ;;
;;                                                                              ;;
;; If target is a (List E),                                                     ;;
;; mot is an                                                                    ;;
;;   (-> (List E)                                                               ;;
;;     U),                                                                      ;;
;; base is a (mot nil), and step is a                                           ;;
;;   (Π ((e E)                                                                 ;;
;;        (es (List E)))                                                        ;;
;;     (-> (mot es)                                                             ;;
;;       (mot (:: e es))))                                                      ;;
;; then                                                                         ;;
;;   (ind-List target                                                           ;;
;;     mot                                                                      ;;
;;     base                                                                     ;;
;;     step)                                                                    ;;
;; is a (mot target).                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The First Commandment of ind-List                                            ;;
;;                                                                              ;;
;; The ind-List-expression                                                      ;;
;;   (ind-List nil                                                              ;;
;;     mot                                                                      ;;
;;     base                                                                     ;;
;;     step)                                                                    ;;
;; is the same (mot nil) as base.                                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Second Commandment of ind-List                                           ;;
;;                                                                              ;;
;; The ind-List-expression                                                      ;;
;;   (ind-List (:: e es)                                                        ;;
;;     mot                                                                      ;;
;;     base                                                                     ;;
;;     step)                                                                    ;;
;; is the same (mot (:: e es)) as                                               ;;
;;   (step e es                                                                 ;;
;;     (ind-List es                                                             ;;
;;       mot                                                                    ;;
;;       base                                                                   ;;
;;       step)).                                                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 240:70
(claim mot-list->vec
  (Π ((E U))
    (-> (List E)
      U)))
(define mot-list->vec
  (λ (E)
    (λ (es)
      (Vec E (length E es)))))

; 240:72
(claim step-list->vec
  (Π ((E U)
       (e E)
       (es (List E)))
    (-> (mot-list->vec E es)
      (mot-list->vec E (:: e es)))))
(define step-list->vec
  (λ (E e es)
    (λ (list->vec_es)
      (vec:: e list->vec_es))))

; 242:77
(claim list->vec
  (Π ((E U)
       (es (List E)))
    (Vec E (length E es))))
(define list->vec
  (λ (E es)
    (ind-List es
      (mot-list->vec E)
      vecnil
      (step-list->vec E))))

