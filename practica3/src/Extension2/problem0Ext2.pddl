(define (problem Problema0_Extension1)
    (:domain VidaEnMarte_Extension1)
    (:objects
        buga1 buga2 buga3 - rover
        Pepe Fernando David Carlos - personal
        Risketos Doritos Canelones Macarrones - suministro
        asentamiento1 asentamiento2 asentamiento3 - asentamiento
        almacen1 almacen2 - almacen
        id0 id1 id2 id3 id4 id5 - peticion 
    )
    
    (:init
        (= (recursosDisponibles) 8)

        (= (personalEnRover buga1) 0)
        (= (personalEnRover buga2) 0)
        (= (personalEnRover buga3) 0)

        (= (suministrosEnRover buga1) 0)
        (= (suministrosEnRover buga2) 0)
        (= (suministrosEnRover buga3) 0)

        (= (combustibleEnRover buga1) 10)
        (= (combustibleEnRover buga2) 10)
        (= (combustibleEnRover buga3) 10)

        (= (combusibleTotal) 30)
 
        (Conecta asentamiento1 almacen1)
        (Conecta almacen1 asentamiento1)
        (Conecta asentamiento2 almacen1)
        (Conecta almacen1 asentamiento2)
        (Conecta asentamiento2 almacen2)
        (Conecta almacen2 asentamiento2)
        (Conecta asentamiento3 almacen2)
        (Conecta almacen2 asentamiento3)

        (Estacionado buga1 almacen1)
        (Estacionado buga2 asentamiento1)
        (Estacionado buga3 asentamiento3)

        (En Pepe asentamiento1)
        (En Fernando asentamiento2)
        (En David asentamiento3)
        (En Carlos asentamiento2)
        (En Risketos almacen1)
        (En Doritos almacen2)
        (En Canelones almacen2)
        (En Macarrones almacen1)

        (ContenidoPeticion id0 Pepe)
        (DestinoPeticion id0 asentamiento2)

        (ContenidoPeticion id1 Fernando)
        (DestinoPeticion id1 asentamiento2)

        (ContenidoPeticion id2 David) 
        (DestinoPeticion id2 asentamiento1)
        
        (ContenidoPeticion id3 Risketos) 
        (DestinoPeticion id3 asentamiento2)

        (ContenidoPeticion id4 Doritos) 
        (DestinoPeticion id4 asentamiento1)

        (ContenidoPeticion id5 Macarrones) 
        (DestinoPeticion id5 asentamiento3)
    )
    
    (:goal (or (forall (?p - peticion) (Servida ?p)) (= (recursosDisponibles) 0)))

    (:metric maximize (combusibleTotal))
)