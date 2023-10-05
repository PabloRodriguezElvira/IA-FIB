(define (problem vector1) (:domain vectorV3)
(:objects
	fantasma1 a b c fantasma2
)
(:init
  (izquierda fantasma1 a)
  (izquierda a b)
  (izquierda b c)
  (izquierda c fantasma2)
)
(:goal (and
  (izquierda c a)
  (izquierda a b)
	)
))

