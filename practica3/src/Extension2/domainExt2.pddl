(define (domain VidaEnMarte_Extension1)

    (:requirements :strips :typing :fluents :adl)

    (:types 
        base cargamento rover peticion - object
        asentamiento almacen - base
        personal suministro - cargamento 
    )

    (:functions 
        (personalEnRover ?x - rover)
        (suministrosEnRover ?x - rover)
        (combustibleEnRover ?x - rover)
        (combusibleTotal)
        (recursosDisponibles)
    )

    (:predicates 
        (En ?x - cargamento ?y - base)
        (Conecta ?x - base  ?y - base)
        (Estacionado ?x - rover ?y - base)
        (Dentro ?x - peticion ?y - rover)
        (ContenidoPeticion ?x - peticion ?y - cargamento)
        (DestinoPeticion ?x - peticion ?y - asentamiento)
        (PeticionCargada ?x - peticion)
        (Servida ?x - peticion)
    )

    (:action mover_rover
        :parameters (?rover - rover ?origen - base ?destino - base)
        :precondition (and (Estacionado ?rover ?origen) (Conecta ?origen ?destino) (> (combustibleEnRover ?rover) 0))
        :effect (and (not (Estacionado ?rover ?origen)) (Estacionado ?rover ?destino) (decrease (combustibleEnRover ?rover) 1) (decrease (combusibleTotal) 1))
    )

    (:action cargar_Personal
        :parameters (?personal - personal ?asentamiento - asentamiento ?rover - rover ?peticion - peticion)
        :precondition (and (En ?personal ?asentamiento) (not (Dentro ?peticion ?rover)) (Estacionado ?rover ?asentamiento) 
                    (not (PeticionCargada ?peticion)) (ContenidoPeticion ?peticion ?personal) (= (suministrosEnRover ?rover) 0) (< (personalEnRover ?rover) 2))
        :effect (and (Dentro ?peticion ?rover) (not (En ?personal ?asentamiento)) (PeticionCargada ?peticion) (increase (personalEnRover ?rover) 1))
    )
    
    (:action cargar_Suministros 
        :parameters (?suministro - suministro ?almacen - almacen ?rover - rover ?peticion - peticion)
        :precondition (and (En ?suministro ?almacen) (not (Dentro ?peticion ?rover)) (Estacionado ?rover ?almacen) (not (PeticionCargada ?peticion)) 
                    (ContenidoPeticion ?peticion ?suministro) (= (personalEnRover ?rover) 0) (= (suministrosEnRover ?rover) 0))
        :effect (and (Dentro ?peticion ?rover) (not (En ?suministro ?almacen)) (PeticionCargada ?peticion) (increase (suministrosEnRover ?rover) 1))
    )

    (:action descargar_Personal
        :parameters (?personal - personal ?asentamiento - asentamiento ?rover - rover ?peticion - peticion)
        :precondition (and (Dentro ?peticion ?rover) (not (Servida ?peticion)) (Estacionado ?rover ?asentamiento) (ContenidoPeticion ?peticion ?personal) 
                    (DestinoPeticion ?peticion ?asentamiento))
        :effect (and (Servida ?peticion) (not (Dentro ?peticion ?rover)) (decrease (personalEnRover ?rover) 1) (decrease (recursosDisponibles) 1))
    )

    (:action descargar_Suministros 
        :parameters (?suministro - suministro ?asentamiento - asentamiento ?rover - rover ?peticion - peticion)
        :precondition (and (Dentro ?peticion ?rover) (not (Servida ?peticion)) (Estacionado ?rover ?asentamiento) (ContenidoPeticion ?peticion ?suministro) 
                    (DestinoPeticion ?peticion ?asentamiento))
        :effect (and (Servida ?peticion) (not (Dentro ?peticion ?rover)) (decrease (suministrosEnRover ?rover) 1) (decrease (recursosDisponibles) 1))
    )
)