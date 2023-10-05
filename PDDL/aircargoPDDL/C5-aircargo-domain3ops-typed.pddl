  (define (domain aircargoTyped)
  (:requirements :strips :typing)
  (:types aeropuerto movil - object
          avion carga - movil )
          
(:predicates (En ?x - movil   ?y - aeropuerto)
             (Dentro ?x - carga ?y - avion))

(:action volar
  :parameters (?av - avion ?orig - aeropuerto ?dest - aeropuerto)
  :precondition (En ?av ?orig)
  :effect (and (En ?av ?dest)  
               (not (En ?av ?orig))))

(:action carga
  :parameters  (?c - carga ?av - avion ?aerop - aeropuerto)
  :precondition (and (En ?c ?aerop) (En ?av ?aerop))
  :effect (and (Dentro ?c ?av) 
               (not (En ?c ?aerop))))

(:action descarga
  :parameters  (?c - carga ?av - avion ?aerop - aeropuerto)
  :precondition (and (Dentro ?c ?av) (En ?av ?aerop))
  :effect (and (En ?c ?aerop) 
               (not (Dentro ?c ?av)))
)
)
