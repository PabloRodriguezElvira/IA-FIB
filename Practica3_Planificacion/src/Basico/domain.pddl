(define (domain VidaEnMarte)

    (:requirements :strips :typing :fluents)

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
        (Dentro ?x - movil ?y - rover)
        (ContenidoPeticion ?x - peticion ?y - movil)
        (DestinoPeticion ?x - peticion ?y - asentamiento)
        (Servida ?x - peticion)
    )

    (:action moverRover
        :parameters (?rover - rover ?origen - base ?destino - base)
        :precondition (and (Estacionado ?rover ?origen) (Conecta ?origen ?destino))
        :effect (and (Estacionado ?rover ?destino) (not (Estacionado ?rover ?origen)))
    )

    (:action cargar
        :parameters (?mvl - movil ?base - base ?rover - rover)
        :precondition (and (En ?mvl ?base) (Estacionado ?rover ?base))
        :effect (and (not (En ?mvl ?base)) (Dentro ?mvl ?rover))
    )

    (:action descargar
        :parameters (?mvl - movil ?asentamiento - asentamiento ?rover - rover ?peticion - peticion)
        :precondition (and (Estacionado ?rover ?asentamiento) (Dentro ?mvl ?rover) (ContenidoPeticion ?peticion ?mvl) (DestinoPeticion ?peticion ?asentamiento))
        :effect (and (not (Dentro ?mvl ?rover)) (Servida ?peticion))
    )
)