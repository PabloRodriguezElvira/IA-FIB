(define (problem Problema0_Extension1)
    (:domain VidaEnMarte_Extension1)
    (:objects
        rover1 rover2 - rover
        personal1 personal2 personal3 personal4 personal5 - personal
        suministro1 suministro2 suministro3 suministro4 suministro5 suministro6 - suministro
        asentamiento1 asentamiento2 asentamiento3 - asentamiento
        almacen1 - almacen
        id1 id2 id3 id4 id5 id6 - peticion 
    )
    
    (:init
        (= (recursosDisponibles) 11)

        (= (personalEnRover rover1) 0)
        (= (personalEnRover rover2) 0)
        (= (suministrosEnRover rover1) 0)
        (= (suministrosEnRover rover2) 0)
        (= (combustibleEnRover rover1) 10)
        (= (combustibleEnRover rover2) 10)
        (= (combusibleTotal) 10)

        (= (prioridadTotal) 0)

        (= (prioridad id1) 1)
        (= (prioridad id2) 1)
        (= (prioridad id3) 2)
        (= (prioridad id4) 3)
        (= (prioridad id5) 1)
        (= (prioridad id6) 3)

        (Conecta asentamiento1 asentamiento2)
        (Conecta asentamiento2 asentamiento1)

        (Conecta asentamiento1 asentamiento3)
        (Conecta asentamiento3 asentamiento1)

        (Conecta asentamiento2 asentamiento3)
        (Conecta asentamiento3 asentamiento2)

        (Conecta asentamiento3 almacen1)
        (Conecta almacen1 asentamiento3)

        (Estacionado rover1 asentamiento3)
        (Estacionado rover2 asentamiento1)

        (En personal1 asentamiento1)
        (En personal2 asentamiento2)
        (En personal3 asentamiento2)
        (En personal4 asentamiento3)
        (En personal5 asentamiento1)

        (En suministro1 almacen1)
        (En suministro2 almacen1)
        (En suministro3 almacen1)
        (En suministro4 almacen1)
        (En suministro5 almacen1)
        (En suministro6 almacen1)

        (ContenidoPeticion id1 suministro1)
        (DestinoPeticion id1 asentamiento3)

        (ContenidoPeticion id2 suministro2)
        (DestinoPeticion id2 asentamiento2)

        (ContenidoPeticion id3 personal1)
        (DestinoPeticion id3 asentamiento3)

        (ContenidoPeticion id4 suministro3)
        (DestinoPeticion id4 asentamiento1)

        (ContenidoPeticion id5 personal4)
        (DestinoPeticion id5 asentamiento2)

        (ContenidoPeticion id6 suministro4)
        (DestinoPeticion id6 asentamiento1)
    )
    
    (:goal (or (forall (?p - peticion) (Servida ?p)) (= (recursosDisponibles) 0)))

    (:metric maximize (+ (* (prioridadTotal) 5) (* (combusibleTotal) 2)))
)