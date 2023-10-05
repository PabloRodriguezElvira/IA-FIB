(define (domain blocksworld)
  (:requirements :strips)
(:predicates (clear ?x)
             (ontable ?x)
             (handempty)
             (holding ?x)
             (on ?x ?y))


(:action colocar
  :parameters  (?ob ?underob)
  :precondition (and (ontable ?ob) (clear ?underob) (clear ?ob) (handempty))
  :effect (and (on ?ob ?underob)
               (not (clear ?underob)) (not (ontable ?ob))
           )
 )

(:action despejar
  :parameters  (?ob ?underob)
  :precondition (and (on ?ob ?underob) (clear ?ob) (handempty))
  :effect (and (ontable ?ob) (clear ?underob)
               (not (on ?ob ?underob)) 
          )
)
)
