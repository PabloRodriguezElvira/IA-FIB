(define (problem ProblemaBasico)
    (:domain VidaEnMarte)
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
        
        (Conecta asentamiento1 almacen1)
        (Conecta almacen1 asentamiento1)
        (Conecta asentamiento2 almacen1)
        (Conecta almacen1 asentamiento2)
        (Conecta asentamiento2 almacen2)
        (Conecta almacen2 asentamiento2)
        (Conecta asentamiento3 almacen2)
        (Conecta almacen2 asentamiento3)

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
    )
)