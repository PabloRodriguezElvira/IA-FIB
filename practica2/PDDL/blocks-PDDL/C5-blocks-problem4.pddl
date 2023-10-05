(define (problem blocksproblemslides) (:domain blocksworld)
(:objects
	A B C D
)
(:init
  (clear A)
  (clear B)
  (clear C)
  (clear D)
  (ontable A)
  (ontable C)
  (ontable B)
  (ontable D)
  (handempty)
)
(:goal (and
    (on C B)
    (on B A)
    (on D C)
	)
))
