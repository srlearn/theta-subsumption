# θ-Subsumption and Inductive Generalization

A Racket implementation of θ-subsumption, originally described in
Gordon D. Plotkin's "*A Note on Inductive Generalization*," then adapted
to structural matching by Luc De Raedt, Peter Idestam-Almquist, and
Gunther Sablon in "*θ-subsumption for Structural Matching*."

```racket
#lang racket
(require "generalize.rkt")

(define W₁
  '(Literal "P" ((Variable "m") (Function "f" ((Variable "x"))))))
(define W₂
  '(Literal "P" ((Variable "n") (Function "g" ((Variable "y"))))))

(print-word W₁)
(print-word W₂)

(print-word
  (antiunify W₁ W₂))
```

**Output**:

```console
P(m, f(x))
P(n, g(y))
P(_0, _2)
```

## Reproduce Plotkin's Example 1

Plotkin provides a derivation of how his Theorem-1/Algorithm finds the least
generalization of `{P(f(a(), g(y)), x, g(y)), P(h(a(), g(x)), x, g(x))}`.
His derivation halts with `P(y, x, g(z))`, ours halts with
`P(_1, x, g(_0))`—our implementation uses integers instead of characters,
but the representations are α-equivalent.

```racket
#lang racket
(require "generalize.rkt")

(define W₁
  '(Literal "P" (
    (Function "f" ((Function "a" ()) (Function "g" ((Variable "y")))))
    (Variable "x")
    (Function "g" ((Variable "y"))))))
(define W₂
  '(Literal "P" (
    (Function "h" ((Function "a" ()) (Function "g" ((Variable "x")))))
     (Variable "x")
     (Function "g" ((Variable "x"))))))

(print-word W₁)
(print-word W₂)

(print-word
  (antiunify W₁ W₂))
```

**Output**:

```console
P(f(a(), g(y)), x, g(y))
P(h(a(), g(x)), x, g(x))
P(_1, x, g(_0))
```
