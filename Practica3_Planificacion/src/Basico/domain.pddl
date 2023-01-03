(define (domain VidaEnMarte)

    (:requirements :strips :typing :fluents :adl)

    (:types 
        base cargamento rover peticion - object
        asentamiento almacen - base
        personal suministro - cargamento 
    )

    (:functions 
        (recursosDisponibles)
    )

    (:predicates 
        (En ?x - cargamento ?y - base)
        (Estacionado ?x - rover ?y - base)
        (Conecta ?x - base  ?y - base)
        (Dentro ?x - peticion ?y - rover)
        (ContenidoPeticion ?x - peticion ?y - cargamento)
        (DestinoPeticion ?x - peticion ?y - asentamiento)
        (PeticionCargada ?x - peticion)
        (Servida ?x - peticion)
    )

    (:action mover_rover
        :parameters (?rover - rover ?origen - base ?destino - base)
        :precondition (and (Estacionado ?rover ?origen) (Conecta ?origen ?destino))
        :effect (and (not (Estacionado ?rover ?origen)) (Estacionado ?rover ?destino))
    )

    (:action cargar
        :parameters (?carga - cargamento ?base - base ?rover - rover ?peticion - peticion)
        :precondition (and (En ?carga ?base) (Estacionado ?rover ?base) (not (PeticionCargada ?peticion)) (ContenidoPeticion ?peticion ?carga))
        :effect (and (not (En ?carga ?base)) (Dentro ?peticion ?rover) (PeticionCargada ?peticion))
    )

    (:action descargar
        :parameters (?carga - cargamento ?asentamiento - asentamiento ?rover - rover ?peticion - peticion)
        :precondition (and (Estacionado ?rover ?asentamiento) (Dentro ?peticion ?rover) (ContenidoPeticion ?peticion ?carga) (DestinoPeticion ?peticion ?asentamiento))
        :effect (and (not (Dentro ?peticion ?rover)) (Servida ?peticion) (decrease (recursosDisponibles) 1))
    )
)