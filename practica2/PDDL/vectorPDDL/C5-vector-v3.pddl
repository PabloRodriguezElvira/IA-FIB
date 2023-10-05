(define (domain vectorV3)
  (:requirements :strips)
  
  (:predicates (izquierda ?vx ?vy)
  )



  (:action swap
    :parameters (?izq ?vx ?vy ?der)
    :precondition (and (izquierda ?vx ?vy) (izquierda ?izq ?vx)
                       (izquierda ?vy ?der))
    :effect (and (not (izquierda ?vx ?vy)) (not (izquierda ?izq ?vx))
                 (not (izquierda ?vy ?der))
                 (izquierda ?vy ?vx) (izquierda ?izq ?vy)
                 (izquierda ?vx ?der)
            )
  )
)