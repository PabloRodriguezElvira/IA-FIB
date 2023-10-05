(define (problem vector10) (:domain vectorV3)
(:objects
	fantasma1 a b c d e fantasma2
)
(:init
  (izquierda fantasma1 a)
  (izquierda a b)
  (izquierda b c)
  (izquierda c d)
  (izquierda d e)
  (izquierda e fantasma2)
)
(:goal (and
  (izquierda fantasma1 e)
  (izquierda e d)
  (izquierda d a)
  (izquierda a c)
  (izquierda c b)
  (izquierda b fantasma2)
	)
))

