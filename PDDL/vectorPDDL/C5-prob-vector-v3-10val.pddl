(define (problem vector10) (:domain vectorV3)
(:objects
	fantasma1 a b c d e f g h i j fantasma2
)
(:init
  (izquierda fantasma1 a)
  (izquierda a b)
  (izquierda b c)
  (izquierda c d)
  (izquierda d e)
  (izquierda e f)
  (izquierda f g)
  (izquierda g h)
  (izquierda h i)
  (izquierda i j)
  (izquierda j fantasma2)
)
(:goal (and
  (izquierda fantasma1 e)
  (izquierda e d)
  (izquierda d f)
  (izquierda f h)
  (izquierda h c)
  (izquierda c j)
  (izquierda j b)
  (izquierda b g)
  (izquierda g a)
  (izquierda a i)
  (izquierda i fantasma2)
	)
))

