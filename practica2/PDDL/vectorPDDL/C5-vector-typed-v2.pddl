(define (domain vectorTyped2)
  (:requirements :strips :typing :adl)
  (:types pos valor - object)

  (:predicates (val ?x - pos ?vx - valor)
               (next ?x - pos ?y -pos)
  			   (target ?x - pos ?vx - valor)
	)

  (:action swap
    :parameters (?x - pos ?y - pos ?vx - valor ?vy - valor)
    :precondition (and (val ?x ?vx) (val ?y ?vy) (target ?x ?vy))
    :effect (and (val ?y ?vx) (val ?x ?vy) (not (val ?x ?vx)) (not (val ?y ?vy))
            )
  )
)