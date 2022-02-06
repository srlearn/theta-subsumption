; Copyright © 2021-2022 Alexander L. Hayes

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
