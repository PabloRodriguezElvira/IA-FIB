(define (domain SmartBusFluents)
  (:requirements :adl :typing :fluents)

  (:types persona parada SBus - object
          pasajeroNormal pasajeroMreducida - persona
  )           

  (:predicates
   (estacionado ?bus - SBus ?l - parada)
   (dentro ?p - persona ?bus - SBus)
   (destino ?p - persona ?g - parada)
   (en ?p - persona ?l - parada)
   (pendiente ?p - persona)
   (servido ?p - persona)
  )

  (:functions
    (butacasLibres)
    (plazasMrLibres)
  )

  (:action montar_en_SBus
    :parameters (?p - pasajeroNormal ?bus - SBus ?l - parada)
    :precondition (and (pendiente ?p) (en ?p ?l) 
                       (estacionado ?bus ?l)
                       (> (butacasLibres) 0)
                   )    
    :effect (and (decrease (butacasLibres) 1) (dentro ?p ?bus)
                 (not (en ?p ?l)) (not (pendiente ?p))
            )
  )

  (:action montar_en_SBus_Mreducida
    :parameters (?p - pasajeroMreducida ?bus - SBus ?l - parada)
    :precondition (and (pendiente ?p) (en ?p ?l) 
                       (estacionado ?bus ?l)
                       (> (plazasMrLibres) 0)
                   )    
    :effect (and (decrease (plazasMrLibres) 1) (dentro ?p ?bus)
                 (not (en ?p ?l)) (not (pendiente ?p))
            )
  )
  
  (:action bajar_de_SBus
    :parameters (?p - pasajeroNormal ?bus - SBus ?l - parada)
    :precondition (and (dentro ?p ?bus) 
                       (estacionado ?bus ?l)
                       (destino ?p ?l) 
                  )
    :effect (and (en ?p ?l) (servido ?p) 
                  (not (dentro ?p ?bus))
                  (increase (butacasLibres) 1)
            )
  )

  (:action bajar_de_SBus_Mreducida
    :parameters (?p - pasajeroMreducida ?bus - SBus ?l - parada)
    :precondition (and (dentro ?p ?bus) 
                       (estacionado ?bus ?l)
                       (destino ?p ?l) 
                  )
    :effect (and (en ?p ?l) (servido ?p) 
                  (not (dentro ?p ?bus))
                  (increase (plazasMrLibres) 1)
            )
  )

  (:action mover_SBus
    :parameters (?bus - SBus ?ori - parada ?des - parada)
    :precondition (estacionado ?bus ?ori)
    :effect (and (estacionado ?bus ?des) (not (estacionado ?bus ?ori))
            )
  )
)