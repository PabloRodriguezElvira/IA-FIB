(define (problem aircargo2cg1av2ae) (:domain aircargo)
(:objects
	A1 C1 C2 JFK SFO
)
(:init
  (Avion A1)
  (Carga C1)
  (Carga C2)
  (Aeropuerto JFK)
  (Aeropuerto SFO)
  (En C1 SFO)
  (En C2 JFK)
  (En A1 SFO)
)
(:goal (and
    (En C1 JFK)
    (En C2 SFO)
	)
))
