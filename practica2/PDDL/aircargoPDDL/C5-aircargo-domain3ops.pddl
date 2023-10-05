(define (domain aircargo)
  (:requirements :strips)

  (:predicates (Avion ?x)
               (Aeropuerto ?y)
               (Carga ?x)
               (En ?x ?y)
               (Dentro ?x ?y)
  )

  (:action volar
    :parameters (?av ?orig ?dest)
    :precondition (and (En ?av ?orig) (Avion ?av)
	                   (Aeropuerto ?orig) (Aeropuerto ?dest)
	              )
    :effect (and (En ?av ?dest)
                 (not (En ?av ?orig))
			)
  )

  (:action carga
    :parameters (?c ?av ?aerop)
    :precondition (and (En ?c ?aerop) (En ?av ?aerop)
	                   (Carga ?c) (Avion ?av) (Aeropuerto ?aerop)
				  )
    :effect (and (Dentro ?c ?av)
                 (not (En ?c ?aerop))
			)
  )

  (:action descarga
    :parameters (?c ?av ?aerop)
    :precondition (and (Dentro ?c ?av) (En ?av ?aerop)
                       (Carga ?c) (Avion ?av) (Aeropuerto ?aerop)
                  )
    :effect (and (En ?c ?aerop)
                 (not (En ?c ?av)))
            )
  )
