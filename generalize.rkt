; Copyright © 2021-2022 Alexander L. Hayes
; MIT License

#|
Overview
--------

The algorithm described in Plotkin's "Theorem 1" is described in
an imperative style. This rewrites some of Plotkin's explanation
in a Lispy style.

Foundations
'''''''''''

Suppose we can show that a property holds for variables and constants,
and that whenever it holds for t₁, ..., tₙ then it holds for
ϕ(t₁, ..., tₙ).

Then the property holds for all words.

We will write W₁ ∼ W₂ when W₁ ≤ W₂ and W₂ ≤ W₁. It is known that
W₁ ∼ W₂ are alphabetic variants.

Two words are *compatible* ⇔ they are both terms or have the same
predicate sign or letter.

If K is a set of words, then W is a *least generalization* of K ⇔

1. For every V in K, W ≤ V.
2. If for every V in K, W₁ ≤ V, then W₁ ≤ W.

It follows from (2) that if W₁,W₂ are any two least generalizations
of K, then W₁ ∼ W₂.

Theorem 1
'''''''''

Every non-empty, finite set of words has a least generalization
⇔ any two words in the set are compatible.

Let W₁, W₂ be any two compatible words.

1. Set Vᵢ to Wᵢ(i=1,2).
   Set εᵢ to ε (i=1,2).
   ε is the empty substitution.

2. Try to find terms t₁, t₂ which have the same place in V₁, V₂
   respectively and such that t₁ ≠ t₂ and either t₁ and t₂ begin
   with different function letters or else at least one of them
   is a variable.

3. If there are no such t₁, t₂ then halt. V₁ is a least
   generalization of {W₁, W₂} and V₁ = V₂, Vᵢεᵢ = Wᵢ(i=1,2).

4. Choose a variable `x` distinct from any in V₁ or V₂ and
   wherever t₁ and t₂ occur in the same place in V₁ and V₂,
   replace each by `x`.

5. Change εᵢ to {tᵢ|x} εᵢ(i=1,2).

6. Go to 2.

Bibliography
------------

1. G. Plotkin. "A Note on Inductive Generalization."
   In *Machine Intelligence*, volume 5, pages 153-163.
   Edinburgh University Press, 1970.
2. Luc De Raedt, Peter Idestam-Almquist, Gunther Sablon.
   "Θ-subsumption for Structural Matching."
   European Conference on Machine Learning (ECML),
   pages 73-84. Lecture Notes in Computer Science, 1997.
|#

#lang racket

(provide word->string
         print-word
         antiunify
         )

; TODO(hayesall): `compatible?` function that checks two words
;   The definition of `compatible` is fairly important in some of the Lemmas
;   e.g. see Lemma 1.1 on page 157.
; TODO(hayesall): Handle negations ¬P
;   If you wrap a ¬ around the P, does that make P a term?
;     V₁ = P(f(a))
;     V₂ = ¬P(f(a))
;

(define (print-word w)
  (printf "~a\n" (word->string w)))

(define (word->string W)
  (match W
    [`(Literal ,n ,args) (string-append n "(" (word->string args) ")")]
    [`(Function ,n ,args)
      (if (string? n)
          (string-append n "(" (word->string args) ")")
          (string-append "_" (number->string n) "(" (word->string args) ")"))]
    [`(Variable ,n)
      (if (string? n)
          n
          (string-append "_" (number->string n)))]
    [(cons a d)
     (if (null? d)
         (word->string a)
         (string-append (word->string a) ", " (word->string d)))]
    ['() ""]))

(define (substitute V₁ V₂ ε ℕ)
  (match V₁
    [`(Literal ,n ,args)
     `(Literal ,n ,(substitute args (caddr V₂) ε ℕ))]
    [`(Function ,n ,args)
      (cond
        [(and (equal? V₁ ε)
              (not (equal? V₁ V₂)))
        `(Variable ,ℕ)]
        [else `(Function ,n ,(substitute args (caddr V₂) ε ℕ))])]
    [`(Variable ,n)
      (cond
        [(and (equal? V₁ ε)
              (not (equal? V₁ V₂)))
              `(Variable ,ℕ)]
        [else V₁])]
    [(cons a b)
      (cons (substitute a (car V₂) ε ℕ) (substitute b (cdr V₂) ε ℕ))]
    ['() '()]))

(define (find-terms W₁ W₂)
  (match W₁
    [`(Literal  ,n ,args) (find-terms args (caddr W₂))]
    [`(Function ,n ,args)
      (if [and (not (equal? n (cadr W₂))) (equal? args (caddr W₂))]
          `(((Function ,n ,args) (Function ,(cadr W₂) ,(caddr W₂))))
          (find-terms args (caddr W₂)))]
    [`(Variable ,n)
      (if [not (equal? n (cadr W₂))]
        `(((Variable ,n) (Variable ,(cadr W₂))))
        '())]
    [(cons a d)
      (append (find-terms a (car W₂)) (find-terms d (cdr W₂)))]
    ['() '()]))

(define (antiunify-helper V₁ V₂ ℕ)
  (cond
    [(equal? V₁ V₂) V₁]
    [else
      (let ((subst  (find-terms V₁ V₂)))
      (let ((subst₁ (caar subst)))
      (let ((subst₂ (cadar subst)))

      (antiunify-helper
        (substitute V₁ V₂ subst₁ ℕ)
        (substitute V₂ V₁ subst₂ ℕ)
        (add1 ℕ)))))]))

(define (antiunify W₁ W₂)
  (antiunify-helper W₁ W₂ 0))
