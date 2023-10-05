(define (domain SmartBus)
  (:requirements :adl :typing)

  (:types persona lugar SBus - object
          asiento parada - lugar
	  butaca plazaMreducida - asiento
	  pasajeroNormal pasajeroMreducida - persona
	)           

  (:predicates
   (estacionado ?bus - SBus ?l - parada)
   (dentro ?a - asiento ?bus - SBus)
   (libre ?a - asiento)
   (destino ?p - persona ?g - parada)
   (en ?p - persona ?l - lugar)
   (pendiente ?p - persona)
   (servido ?p - persona)
  )

  (:action montar_en_SBus
    :parameters (?p - pasajeroNormal ?bus - SBus ?a - butaca ?l - parada)
    :precondition (and (pendiente ?p) (en ?p ?l) 
                       (estacionado ?bus ?l)
                       (dentro ?a ?bus) (libre ?a)
                   )    
    :effect (and (en ?p ?a) 
                 (not (en ?p ?l)) (not (libre ?a)) (not (pendiente ?p))
            )
  )
   
	(:action montar_en_SBus_Mreducida
    :parameters (?p - pasajeroMreducida ?bus - SBus ?a - plazaMreducida 
		             ?l - parada)
    :precondition (and (pendiente ?p) (en ?p ?l) 
                       (estacionado ?bus ?l)
                       (dentro ?a ?bus) (libre ?a)
                   )    
    :effect (and (en ?p ?a) 
                 (not (en ?p ?l)) (not (libre ?a)) (not (pendiente ?p))
            )
  )
  
	(:action bajar_de_SBus
    :parameters (?p - persona ?bus - SBus ?a - asiento ?l - parada)
    :precondition (and (en ?p ?a) (dentro ?a ?bus)
                       (estacionado ?bus ?l)
                       (destino ?p ?l) 
                  )
    :effect (and (en ?p ?l) (libre ?a) (servido ?p) 
                  (not (en ?p ?a))
            )
  )

  (:action mover_SBus
    :parameters (?bus - SBus ?ori - parada ?des - parada)
    :precondition (estacionado ?bus ?ori)
    :effect (and (estacionado ?bus ?des) (not (estacionado ?bus ?ori))
            )
  )
)