(define (domain TraeMeLo)
    (:requirements :strips :typing)
    (:types vehiculo repartidor pedido direccion- object
            scooter bici - vehiculo
    )
    (:predicates (En ?x - pedido ?y - vehiculo)
                (Tiene ?x - repartidor ?y - pedido)
                (Esta_en ?x - repartidor ?y - vehiculo) 
                (Pedido_listo ?x - pedido)             
    )

    (:action pedidoListo
        :parameters (?pedido - pedido)
        :precondition (not (Pedido_listo ?pedido)
        :effect (Pedido_listo ?pedido)     
    )


    (:action mover
        :parameters (?pedido - pedido ?origen - comercio ?destino - vivienda)
        :precondition (and (En ?pedido ?origen) (Pedido_listo ?pedido))        
    )
)
