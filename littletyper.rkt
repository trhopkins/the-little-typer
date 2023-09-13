#lang pie

(claim Pear
  U)
(define Pear
  (Pair Nat Nat))

(claim Pear-maker
  U)
(define Pear-maker
  (-> Nat Nat
    Pear))

(claim elim-Pear
  (-> Pear Pear-maker
    Pear))
(define elim-Pear
  (lambda (pear maker)
    (maker (car pear) (cdr pear))))

(claim +
  (-> Nat Nat
    Nat))
(define +
  (lambda (lhs rhs)
    (iter-Nat lhs
      rhs
      (lambda (n)
        (add1 n)))))

(claim pearwise-+
  (-> Pear Pear
    Pear))
(define pearwise-+
  (lambda (lhs rhs)
    (elim-Pear lhs
      (lambda (la ld)
        (elim-Pear rhs
          (lambda (ra rd)
            (cons
              (+ la ra)
              (+ ld rd))))))))

(claim gauss
  (-> Nat
    Nat))
(define gauss
  (lambda (n)
    (rec-Nat n
      0
      (lambda (n-1 gauss_n-1)
        (+ (add1 n-1) gauss_n-1)))))

(claim step-zerop
  (-> Nat Atom
    Atom))
(define step-zerop
  (lambda (n-1 zerop_n-1)
    'nil))

(claim zerop
  (-> Nat
    Atom))
(define zerop
  (lambda (n)
    (rec-Nat n
      't
      step-zerop)))

(claim make-step-*
  (-> Nat
    (-> Nat Nat
      Nat)))
(define make-step-*
  (lambda (n)
    (lambda (n-1 *_n-1)
      (+ n *_n-1))))

(claim step-*
  (-> Nat Nat Nat
    Nat))
(define step-*
  (lambda (n n-1 *_n-1)
    (+ n *_n-1)))

(claim *
  (-> Nat Nat
    Nat))
(define *
  (lambda (lhs rhs)
    (rec-Nat lhs
      0
      ; (make-step-* rhs)
      (step-* rhs))))

(claim elim-Pair_1 ; no hoisting
  (Pi ((A U)
       (D U)
       (X U))
    (-> (Pair A D)
        (-> A D
          X)
      X)))
(define elim-Pair_1
  (lambda (A D X)
    (lambda (p f)
      (f (car p) (cdr p)))))

(claim kar_1
  (-> (Pair Nat Nat)
    Nat))
(define kar_1
  (lambda (p)
    (elim-Pair_1
      Nat Nat
      Nat
      p
      (lambda (a d)
        a))))

(claim kdr_1
  (-> (Pair Nat Nat)
    Nat))
(define kdr_1
  (lambda (p)
    (elim-Pair_1
      Nat Nat
      Nat
      p
      (lambda (a d)
        d))))

(claim swap
  (-> (Pair Nat Atom)
    (Pair Atom Nat)))
(define swap
  (lambda (p)
    (elim-Pair_1
      Nat Atom
      (Pair Atom Nat)
      p
      (lambda (a d)
        (cons d a)))))

#;(claim elim-Pair_1
  (-> A D X (Pair A D) (-> A D
                         X)
    X))

(claim flip
  (Pi ((A U)
       (D U))
    (-> (Pair A D)
      (Pair D A))))
(define flip
  (lambda (A D)
    (lambda (p)
      (cons (cdr p) (car p)))))

(claim elim-Pair
  (Pi ((A U)
       (D U)
       (X U))
    (-> (Pair A D) (-> (Pair A D)
                     X)
      X)))

(claim twin-Pair
  (Pi ((T U))
    (-> T
      (Pair T T))))
(define twin-Pair
  (lambda (T)
    (lambda (v)
      (cons v v))))

(claim twin-Atom
  (-> Atom
    (Pair Atom Atom)))
(define twin-Atom
  (twin-Pair Atom))

(claim step-length
  (Pi ((E U))
    (-> E (List E) Nat
      Nat)))
(define step-length
  (lambda (E)
    (lambda (e es length_es)
      (add1 length_es))))

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

(claim length-Atom
  (-> (List Atom)
    Nat))
(define length-Atom
  (length Atom))

(claim step-append
  (Pi ((E U))
    (-> E (List E) (List E)
      (List E))))
(define step-append
  (lambda (E)
    (lambda  (e es step-append_es)
      (:: e step-append_es))))

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

(claim step-reverse
  (Pi ((E U))
    (-> E (List E) (List E)
      (List E))))
(define step-reverse
  (lambda (E)
    (lambda (e es step-reverse_es)
      (snoc E step-reverse_es e))))

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

(claim first-of-one
  (Pi ((E U))
    (-> (Vec E 1)
      E)))
(define first-of-one
  (lambda (E)
    (lambda (es)
      (head es))))

(claim first-of-two
  (Pi ((E U))
    (-> (Vec E 2)
      E)))
(define first-of-two
  (lambda (E)
    (lambda (es)
      (head es))))

(claim first
  (Pi ((E U)
       (l Nat))
    (-> (Vec E (add1 l))
      E)))
(define first
  (lambda (E l)
    (lambda (es)
      (head es))))

(claim first-1
  (Pi ((E U))
    (Pi ((l Nat))
        (Pi ((es (Vec E (add1 l))))
            E))))
(define first-1
  (lambda (E)
    (lambda (l)
      (lambda (es)
        (head es)))))

(claim first-2
  (Pi ((E U)
       (l Nat)
       (es (Vec E (add1 l))))
    E))
(define first-2
  (lambda (E l es)
    (head es)))

(claim rest
  (Pi ((E U)
       (l Nat))
    (-> (Vec E (add1 l))
      (Vec E l))))
(define rest
  (lambda (E l)
    (lambda (es)
      (tail es))))

(claim mot-peas
  (-> Nat
    U))
(define mot-peas
  (lambda (k)
    (Vec Atom k)))

(claim step-peas
  (Pi ((l-1 Nat))
    (-> (mot-peas l-1)
      (mot-peas (add1 l-1)))))
(define step-peas
  (lambda (l-1)
    (lambda (peas_l-1)
      (vec:: 'pea peas_l-1))))

(claim peas
  (Pi ((l Nat))
    (Vec Atom l)))
(define peas
  (lambda (l)
    (ind-Nat l
      mot-peas
      vecnil
      step-peas)))

(claim almost-rec-Nat
  (Pi ((T U))
    (-> Nat
        T
        (-> Nat T
          T)
      T)))
(define almost-rec-Nat
  (lambda (T)
    (lambda (target base step)
      (ind-Nat target
        (lambda (k)
          T)
        base
        step))))

(claim base-last
  (Pi ((E U))
    (-> (Vec E 1)
      E)))
(define base-last
  (lambda (E)
    (lambda (es)
      (head es))))

(claim mot-last
  (-> U Nat
    U))
(define mot-last
  (lambda (E k)
    (-> (Vec E (add1 k))
      E)))

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

(claim base-drop-last
  (Pi ((E U))
    (-> (Vec E 1)
      (Vec E 0))))
(define base-drop-last
  (lambda (E)
    (lambda (es)
      vecnil)))

(claim mot-drop-last
  (-> U Nat
    U))
(define mot-drop-last
  (lambda (E l)
    (-> (Vec E (add1 l))
      (Vec E l))))

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

(claim incr-1
  (-> Nat
    Nat))
(define incr-1
  (lambda (n)
    (iter-Nat n
      1
      (+ 1))))

(claim incr
  (-> Nat
    Nat))
(define incr
  (lambda (n)
    (rec-Nat n
      1
      (lambda (n-1)
        (+ 1)))))

(claim +1=add1
  (Pi ((n Nat))
    (= Nat (+ 1 n) (add1 n))))
(define +1=add1
  (lambda (n)
    (same (add1 n))))

(claim base-incr=add1
  (= Nat (incr 0) (add1 0)))
(define base-incr=add1
  (same (add1 0)))

(claim mot-incr=add1
  (-> Nat
    U))
(define mot-incr=add1
  (lambda (n)
    (= Nat (incr n) (add1 n))))

#;(claim step-incr=add1
  (Pi ((n-1 Nat))
    (-> (mot-incr=add1 n-1)
      (mot-incr=add1 (add1 n-1)))))
#;(claim step-incr=add1
  (Pi ((n-1 Nat))
    (-> (= Nat
          (incr n-1)
          (add1 n-1))
      (= Nat
        (incr (add1 n-1))
        (add1 (add1 n-1))))))
(claim step-incr=add1
  (Pi ((n-1 Nat))
    (-> (= Nat
          (incr n-1)
          (add1 n-1))
      (= Nat
        (add1 (incr n-1))
        (add1 (add1 n-1)))))) ; swap incr/add1
(define step-incr=add1
  (lambda (n)
    (lambda (step-incr=add1_n-1)
      (cong step-incr=add1_n-1 (+ 1)))))

(claim incr=add1
  (Pi ((n Nat))
    (= Nat (incr n) (add1 n))))
#;(define incr=add1 ; incr evaluates to a neutral expression
  (lambda (n)
    (same (add1 n))))
(define incr=add1
  (lambda (n)
    (ind-Nat n
      mot-incr=add1
      base-incr=add1
      step-incr=add1)))

;; 9:21
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

;; 9:22
(claim twice
  (-> Nat
    Nat))
(define twice
  (lambda (n)
    (+ n n)))

(claim mot-add1+=+add1
  (-> Nat Nat
    U))
(define mot-add1+=+add1
  (lambda (j k)
    (= Nat
      (add1 (+ k j))
      (+ k (add1 j)))))

(claim step-add1+=+add1
  (Pi ((j Nat)
       (n-1 Nat))
    (-> (mot-add1+=+add1 j n-1)
        (mot-add1+=+add1 j (add1 n-1)))))
(define step-add1+=+add1
  (lambda (j n-1)
    (lambda (add1+=+add1_n-1)
      (cong add1+=+add1_n-1 (+ 1)))))

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

(claim mot-twice=double
  (-> Nat
    U))
(define mot-twice=double
  (lambda (n)
    (= Nat
       (twice n)
       (double n))))

(claim mot-step-twice=double
  (-> Nat Nat
    U))
(define mot-step-twice=double
  (lambda (n-1 k)
    (= Nat
      (add1 k)
      (add1 (add1 (double n-1))))))

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

(claim twice=double-of-17
  (= Nat
    (twice 17)
    (double 17)))
(define twice=double-of-17
  (same 34))

(claim twice=double-of-17-1
  (= Nat
    (twice 17)
    (double 17)))
(define twice=double-of-17-1
  (twice=double 17))

(claim mot-double-Vec
  (-> U Nat
    U))
(define mot-double-Vec
  (lambda (E k)
    (-> (Vec E k)
      (Vec E (double k)))))

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

(claim there-is-a-bagel
  (Sigma ((bread Atom))
    (= Atom bread 'bagel)))
(define there-is-a-bagel
  (cons 'bagel (same 'bagel)))

(claim sample-existential-1
  (Sigma ((A U))
    A))
(define sample-existential-1
  (cons Nat 5))

(claim sample-existential-2
  (Sigma ((A U))
    A))
(define sample-existential-2
  (cons Atom 'pear))

(claim sample-existential-3
  (Sigma ((A U))
    A))
(define sample-existential-3
  (cons (-> Nat Nat)
    (+ 7)))

(claim toasty
  (Sigma ((food Atom))
    (= (List Atom)
       (:: food nil)
       (:: 'toast nil))))
(define toasty
  (cons 'toast (same (:: 'toast nil))))

(claim step-list->vec-1
  (Pi ((E U))
    (-> E (List E) (Sigma ((l Nat))
                      (Vec E l))
      (Sigma ((l Nat))
        (Vec E l)))))
(define step-list->vec-1
  (lambda (E)
    (lambda (e es list->vec-1_es)
      (cons (add1 (car list->vec-1_es))
        (vec:: e (cdr list->vec-1_es))))))

(claim list->vec-1
  (Pi ((E U))
    (-> (List E)
      (Sigma ((l Nat))
        (Vec E l)))))
#;(define list->vec-1
  (lambda (E)
    (lambda (es)
      (rec-List es
        (cons 0 (the (Vec E 0) vecnil)) ; cannot determine a type for some reason? dashed border
        (step-list->vec-1 E)))))

(claim mot-replicate
  (-> U Nat
    U))
(define mot-replicate
  (lambda (E k)
    (Vec E k)))

(claim step-replicate
  (Pi ((E U)
       (e E)
       (l-1 Nat))
    (-> (mot-replicate E l-1)
      (mot-replicate E (add1 l-1)))))
(define step-replicate
  (lambda (E e l-1)
    (lambda (replicate_l-1)
      (vec:: e replicate_l-1))))

(claim replicate
  (Pi ((E U)
       (l Nat))
    (-> E
      (Vec E l))))
(define replicate
  (lambda (E l)
    (lambda (e)
      (ind-Nat l
        (mot-replicate E)
        vecnil
        (step-replicate E e)))))

(claim mot-list->vec-2
  (Pi ((E U))
    (-> (List E)
      U)))
(define mot-list->vec-2
  (lambda (E)
    (lambda (es)
      (Vec E (length E es)))))

(claim step-list->vec-2
  (Pi ((E U)
       (e E)
       (es (List E)))
    (-> (mot-list->vec-2 E es)
      (mot-list->vec-2 E (:: e es)))))
(define step-list->vec-2
  (lambda (E e es)
    (lambda (list->vec_es)
      (vec:: e list->vec_es))))

(claim list->vec-2
  (Pi ((E U)
       (es (List E)))
    (Vec E (length E es))))
(define list->vec-2
  (lambda (E es)
    (ind-List es
      (mot-list->vec-2 E)
      vecnil
      (step-list->vec-2 E))))

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

(claim mot-vec->list
  (Pi ((E U)
       (l Nat))
    (-> (Vec E l)
      U)))
(define mot-vec->list
  (lambda (E l)
    (lambda (es)
      (List E))))

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

(claim ::-plattar
  (-> (List Atom)
    (List Atom)))
(define ::-plattar
  (lambda (treats)
    (:: 'plattar treats)))

(claim treat-proof
  Treat-Statement)
(define treat-proof
  (lambda (some more)
    (lambda (treats=)
      (cong treats= ::-plattar))))

(claim Length-Statement
  U)
(define Length-Statement
  (Pi ((some (List Atom))
       (more (List Atom)))
    (-> (= (List Atom)
          some
          more)
      (= Nat
        (length Atom some)
        (length Atom more)))))

(claim length-proof
  Length-Statement)
(define length-proof
  (lambda (some more)
    (lambda (treats=)
      (cong treats=
        (length Atom)
        #;(lambda (es) (length Atom es)) #|why does this fail?|#))))

(claim base-list->vec->list=
  (Pi ((E U))
    #;(= (List E)
      nil
      nil)
    (= (List E)
      nil
      (vec->list E 0 (list->vec-2 E nil)))))
(define base-list->vec->list=
  (lambda (E)
    (same nil)))

(claim mot-list->vec->list=
  (Pi ((E U))
    (-> (List E)
      U)))
(define mot-list->vec->list=
  (lambda (E)
    (lambda (es)
      (= (List E)
        es
        (vec->list E (length E es) (list->vec-2 E es))))))

(claim ::-func
  (Pi ((E U))
    (-> E (List E)
      (List E))))
(define ::-func
  (lambda (E)
    (lambda (e es)
      (:: e es))))

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

(claim list->vec->list=
  (Pi ((E U)
       (es (List E)))
    (= (List E)
      es
      (vec->list E (length E es) (list->vec-2 E es)))))
(define list->vec->list=
  (lambda (E es)
    (ind-List es
      (mot-list->vec->list= E)
      (base-list->vec->list= E)
      (step-list->vec->list= E))))

(claim Even
  (-> Nat
    U))
(define Even
  (lambda (n)
    (Sigma ((half Nat))
      (= Nat
        n
        (double half)))))

(claim zero-is-even
  (Even zero))
(define zero-is-even
  (cons zero (same zero)))

(claim +-two-even
  (Pi ((n Nat))
    (-> (Even n)
      (Even (+ 2 n)))))
(define +-two-even
  (lambda (n)
    (lambda (even_n)
      (cons (add1 (car even_n))
        (cong (cdr even_n) (+ 2))))))

(claim Two-Is-Even-Statement
  U)
(define Two-Is-Even-Statement
  (Even 2))

(claim two-is-even-proof
  Two-Is-Even-Statement)
(define two-is-even-proof
  (+-two-even 0 zero-is-even))

(claim Odd
  (-> Nat
    U))
(define Odd
  (lambda (n)
    (Sigma ((haf Nat))
      (= Nat
        n
        (add1 (double haf))))))

(claim one-is-odd
  (Odd 1))
(define one-is-odd
  (cons 0 (same 1)))

(claim 13-is-odd
  (Odd 13))
(define 13-is-odd
  (cons 6 (same 13)))

(claim add1-even->odd
  (Pi ((n Nat))
    (-> (Even n)
      (Odd (add1 n)))))
(define add1-even->odd
  (lambda (n)
    (lambda (even_n)
      (cons (car even_n)
        (cong (cdr even_n) (+ 1))))))

(claim add1-odd->even
  (Pi ((n Nat))
    (-> (Odd n)
      (Even (add1 n)))))
(define add1-odd->even
  (lambda (n)
    (lambda (odd_n)
      (cons (add1 (car odd_n))
        (cong (cdr odd_n) (+ 1))))))

(claim repeat
  (-> (-> Nat
        Nat)
      Nat
    Nat))
(define repeat
  (lambda (f n)
    (iter-Nat n
      (f 1)
      (lambda (iter_n-1)
        (f iter_n-1)))))

(claim ackermann
  (-> Nat Nat
    Nat))
(define ackermann
  (lambda (n)
    (iter-Nat n
      (+ 1)
      (lambda (ackermann_n-1)
        (repeat ackermann_n-1)))))

(claim mot-even-or-odd
  (-> Nat
    U))
(define mot-even-or-odd
  (lambda (n)
    (Either (Even n) (Odd n))))

(claim base-even-or-odd
  (mot-even-or-odd 0))
(define base-even-or-odd
  (left (cons 0 (same (double 0)))))

(claim mot-step-even-or-odd
  (Pi ((n-1 Nat)
       (even-or-odd_n-1 (mot-even-or-odd n-1)))
    U))
(define mot-step-even-or-odd
  (lambda (n-1 even-or-odd_n-1)
    (mot-even-or-odd (add1 n-1))))

(claim step-even-or-odd
  (Pi ((n Nat))
    (-> (mot-even-or-odd n)
        (mot-even-or-odd (add1 n)))))
(define step-even-or-odd
  (lambda (n-1)
    (lambda (even-or-odd_n-1)
      (ind-Either even-or-odd_n-1
        #;(lambda (even-or-odd)
          (mot-even-or-odd (add1 n-1)))
        (mot-step-even-or-odd n-1)
        (lambda (even_n-1)
          (right (add1-even->odd n-1 even_n-1)))
        (lambda (odd_n-1)
          (left (add1-odd->even n-1 odd_n-1)))))))

(claim even-or-odd
  (Pi ((n Nat))
    (Either (Even n) (Odd n))))
(define even-or-odd
  (lambda (n)
    (ind-Nat n
      mot-even-or-odd
      (left zero-is-even)
      step-even-or-odd)))

(claim Maybe
  (-> U
    U))
(define Maybe
  (lambda (X)
    (Either X Trivial)))

(claim nothing
  (Pi ((E U))
    (Maybe E)))
(define nothing
  (lambda (E)
    (right sole)))

(claim just
  (Pi ((E U))
    (-> E
      (Maybe E))))
(define just
  (lambda (E)
    (lambda (e)
      (left e))))

(claim maybe-head
  (Pi ((E U))
    (-> (List E)
      (Maybe E))))
(define maybe-head
  (lambda (E)
    (lambda (es)
      (rec-List es
        (nothing E)
        (lambda (e es maybe-head_es)
          (just E e))))))

(claim maybe-tail
  (Pi ((E U))
    (-> (List E)
      (Maybe (List E)))))
(define maybe-tail
  (lambda (E)
    (lambda (es)
      (rec-List es
        (nothing (List E))
        (lambda (e es maybe-tail_es)
            (just (List E) es))))))

(claim step-list-ref
  (Pi ((E U))
    (-> Nat (-> (List E)
              (Maybe E))
      (-> (List E)
        (Maybe E)))))
(define step-list-ref
  (lambda (E)
    (lambda (n-1 list-ref_n-1)
      (lambda (es)
        (ind-Either (maybe-tail E es)
          (lambda (maybe_tl)
            (Maybe E))
          (lambda (tl)
            (list-ref_n-1 tl))
          (lambda (none)
            (nothing E)))))))

(claim list-ref
  (Pi ((E U))
    (-> Nat (List E)
      (Maybe E))))
(define list-ref
  (lambda (E)
    (lambda (n)
      (rec-Nat n
        (maybe-head E)
        (step-list-ref E)))))

(claim sandwich
  (-> Atom
    Atom))
(define sandwich
  (lambda (which)
    'delicious))

(claim menu
  (Vec Atom 4))
(define menu
  (vec:: 'ratatouille
    (vec:: 'kartoffelmad
      (vec:: (sandwich 'hero)
        (vec:: 'prinsesstarta vecnil)))))

(claim similarly-absurd
  (-> Absurd
    Absurd))
(define similarly-absurd
  (lambda (x)
    x)) ; I dare you to run this function!

(claim Fin
  (-> Nat
    U))
(define Fin
  (lambda (n)
    (iter-Nat n
      Absurd
      Maybe)))

(claim fzero
  (Pi ((n Nat))
    #;(Fin (add1 n))
    (Maybe (Fin n))))
(define fzero
  (lambda (n)
    (nothing (Fin n))))

(claim fadd1
  (Pi ((n Nat))
    (-> (Fin n)
      (Fin (add1 n)))))
(define fadd1
  (lambda (n)
    (lambda (i-1)
      (just (Fin n) i-1))))

(claim base-vec-ref
  (Pi ((E U))
    (-> (Fin 0) (Vec E 0)
      E)))
(define base-vec-ref
  (lambda (E)
    (lambda (no-value-ever es)
      (ind-Absurd no-value-ever
        E))))

(claim step-vec-ref
  (Pi ((E U)
       (l-1 Nat))
    (-> (-> (Fin l-1) (Vec E l-1)
          E)
      (-> (Fin (add1 l-1)) (Vec E (add1 l-1))
        E))))
(define step-vec-ref
  (lambda (E l-1)
    (lambda (vec-ref_l-1)
      (lambda (i es)
        (ind-Either i
          (lambda (maybe_i)
            E)
          (lambda (i-1)
            (vec-ref_l-1 i-1 (tail es)))
          (lambda (triv)
            (head es)))))))

(claim vec-ref
  (Pi ((E U)
       (l Nat))
    (-> (Fin l) (Vec E l)
      E)))
(define vec-ref
  (lambda (E l)
    (ind-Nat l
      (lambda (k)
        (-> (Fin k) (Vec E k)
          E))
      (base-vec-ref E)
      (step-vec-ref E))))

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

(claim zero-not-add1
  (Pi ((n Nat))
    (-> (= Nat 0 (add1 n))
      Absurd)))
(define zero-not-add1
  (lambda (n)
    (use-Nat= 0 (add1 n))))

(claim donut-absurdity
  (-> (= Nat 0 6)
    (= Atom 'powdered 'glazed)))
(define donut-absurdity
  (lambda (zero=six)
    (ind-Absurd (zero-not-add1 5 zero=six)
      (= Atom 'powdered 'glazed))))

(claim sub1=
  (Pi ((n Nat)
       (j Nat))
    (-> (= Nat (add1 n) (add1 j))
      (= Nat n j))))
(define sub1=
  (lambda (n j)
    (use-Nat= (add1 n) (add1 j))))

(claim one-not-six
  (-> (= Nat 1 6)
    Absurd))
(define one-not-six
  (lambda (one=six)
    (zero-not-add1 4
      (sub1= 0 5 one=six))))

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

#;(claim pem ; cannot be defined
  (Pi ((X U))
    (Either X
      (-> X
        Absurd))))

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

(claim Dec
  (-> U
    U))
(define Dec
  (lambda (X)
    (Either X
      (-> X
        Absurd))))

#;(claim pem ; equivalent pem
  (Pi ((X U))
    (Dec X)))

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

(claim mot-nat=?
  (-> Nat
    U))
(define mot-nat=?
  (lambda (k)
    (Pi ((j Nat))
      (Dec (= Nat k j)))))

(claim add1-not-zero
  (Pi ((n Nat))
    (-> (= Nat (add1 n) 0)
      Absurd)))
(define add1-not-zero
  (lambda (n)
    (use-Nat= (add1 n) 0)))

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
