(define (problem aircargo2cg2av2ae)
        (:domain aircargo)

 (:objects
	A1 A2 C1 C2 JFK SFO
 )

 (:init
   (Avion A2)
   (Avion A1)
   (Carga C1)
   (Carga C2)
   (Aeropuerto JFK)
   (Aeropuerto SFO)
   (En C1 SFO)
   (En C2 JFK)
   (En A1 SFO)
   (En A2 JFK)
 )

 (:goal (and (En C1 JFK)
             (En C2 SFO)
	    )
 )
)
