(define (problem vector1) (:domain vectorTyped2)
(:objects
	p1 p2 p3 - pos
	a b c - valor
)
(:init
  (next p1 p2)
  (next p2 p3)
  (val p1 a)
  (val p2 b)
  (val p3 c)
  (target p1 c)
  (target p2 a)
  (target p3 b)	 
)

(:goal (and
  (val p1 c)
  (val p2 a)
  (val p3 b)
	)
)
)

