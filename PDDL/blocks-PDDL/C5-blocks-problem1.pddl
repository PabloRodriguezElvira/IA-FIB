(define (problem blocksproblem1) (:domain blocksworld)
(:objects
	A B C D E F
)
(:init
  (clear D)
  (clear F)
  (ontable C)
  (ontable B)
  (on D A)
  (on A C)
  (on F E)
  (on E B)
  (handempty)
)
(:goal (and
    (on C B)
    (on B A)
    (on A E)
    (on E F)
    (on F D)
	)
))
