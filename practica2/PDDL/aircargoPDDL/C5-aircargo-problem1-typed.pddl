(define (problem aircargo2cg2av2ae) (:domain aircargoTyped)
(:objects
	A1 A2 - avion
	C1 C2 - carga 
	JFK SFO - aeropuerto
)
(:init
  (En C1 SFO)
  (En C2 JFK)
  (En A1 SFO)
  (En A2 JFK)
)
(:goal (and
    (En C1 JFK)
    (En C2 SFO)
	)
))
