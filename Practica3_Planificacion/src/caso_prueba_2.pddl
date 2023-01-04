(define (problem Problema0_Extension1)
    (:domain VidaEnMarte_Extension1)
    (:objects
        rover1 - rover
        personal1 personal2 personal3 personal4 personal5 personal6 - personal
        suministro1 suministro2 suministro3 suministro4 - suministro
        asentamiento1 asentamiento2 - asentamiento
        almacen1 almacen2 - almacen
        id1 id2 id3 id4 id5 id6 id7 id8 id9 id10 - peticion 
    )
    
    (:init
        (= (recursosDisponibles) 11)

        (= (personalEnRover rover1) 0)
        (= (suministrosEnRover rover1) 0)
        (= (combustibleEnRover rover1) 200)
        (= (combusibleTotal) 200)

        (= (prioridadTotal) 0)

        (= (prioridad id1) 1)
        (= (prioridad id2) 1)
        (= (prioridad id3) 2)
        (= (prioridad id4) 3)
        (= (prioridad id5) 1)
        (= (prioridad id6) 3)
        (= (prioridad id7) 1)
        (= (prioridad id8) 1)
        (= (prioridad id9) 2)
        (= (prioridad id10) 2)

        (Conecta almacen1 asentamiento1)
        (Conecta asentamiento1 almacen1)

        (Conecta asentamiento1 asentamiento2)
        (Conecta asentamiento2 asentamiento1)

        (Conecta asentamiento2 almacen2)
        (Conecta almacen2 asentamiento1)

        (Estacionado rover1 asentamiento1)

        (En personal1 asentamiento1)
        (En personal2 asentamiento1)
        (En personal3 asentamiento1)
        (En personal4 asentamiento2)
        (En personal5 asentamiento2)
        (En personal6 asentamiento2)

        (En suministro1 almacen1)
        (En suministro2 almacen1)
        (En suministro3 almacen2)
        (En suministro4 almacen2)

        (ContenidoPeticion id1 suministro1)
        (DestinoPeticion id1 asentamiento2)

        (ContenidoPeticion id2 suministro2)
        (DestinoPeticion id2 asentamiento2)

        (ContenidoPeticion id3 suministro3)
        (DestinoPeticion id3 asentamiento1)

        (ContenidoPeticion id4 suministro4)
        (DestinoPeticion id4 asentamiento1)

        (ContenidoPeticion id5 personal1)
        (DestinoPeticion id5 asentamiento2)

        (ContenidoPeticion id6 personal2)
        (DestinoPeticion id6 asentamiento2)

        (ContenidoPeticion id7 personal3)
        (DestinoPeticion id7 asentamiento2)

        (ContenidoPeticion id8 personal4)
        (DestinoPeticion id8 asentamiento1)

        (ContenidoPeticion id9 personal5)
        (DestinoPeticion id9 asentamiento1)

        (ContenidoPeticion id10 personal6)
        (DestinoPeticion id10 asentamiento1)
    )
    
    (:goal (or (forall (?p - peticion) (Servida ?p)) (= (recursosDisponibles) 0)))

    (:metric maximize (+ (* (prioridadTotal) 5) (* (combusibleTotal) 2)))
)