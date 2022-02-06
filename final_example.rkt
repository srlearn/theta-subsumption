; Copyright © 2021-2022 Alexander L. Hayes

; The final "tic-tac-toe" style example from Plotkin's paper.

#lang racket

(require "generalize.rkt")

(define W₁₁
  '(Literal "¬Occ" (
      (Function "1" ())
      (Function "X" ())
      (Function "p₁" ())
    )))

(define W₁₂
  '(Literal "¬Occ" (
      (Function "2" ())
      (Function "O" ())
      (Function "p₁" ())
    )))

(define W₂₁
  '(Literal "¬Occ" (
      (Function "1" ())
      (Function "X" ())
      (Function "p₂" ())
    )))

(define W₂₂
  '(Literal "¬Occ" (
      (Function "2" ())
      (Function "X" ())
      (Function "p₂" ())
    )))

(print-word
  (antiunify W₁₁ W₂₁))
(print-word
  (antiunify W₁₁ W₂₂))
(print-word
  (antiunify W₁₂ W₂₁))
(print-word
  (antiunify W₁₂ W₂₂))
