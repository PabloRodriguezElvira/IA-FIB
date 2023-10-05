(define (problem SmartBus-1bus-14paradas-21usuarios)
   (:domain SmartBusFluents)
   (:objects Sbus027 - SBus
             p2701 p2702 p2703 p2704 p2705 p2706 p2707 
	     p2708 p2709 p2710 p2711 p2712 p2713 p2714 - parada
	     Esteban Cristina Daniel Luis Lorena Jesus Raul Maria Estela 
	         Martina Noelia Pau Jordi Susana Beatriz Ruth - pasajeroNormal
	     Sebas Xavier Alba Kilian Fabiola - pasajeroMreducida
    )

  (:init
    (= (butacasLibres) 12)
    (= (plazasMrLibres) 2)
    (en Esteban p2701) (destino Esteban p2703) (pendiente Esteban)
    (en Cristina p2707) (destino Cristina p2712) (pendiente Cristina)
    (en Daniel p2714) (destino Daniel p2710) (pendiente Daniel)
    (en Luis p2711) (destino Luis p2705) (pendiente Luis)
    (en Lorena p2703) (destino Lorena p2707) (pendiente Lorena)
    (en Jesus p2703) (destino Jesus p2708) (pendiente Jesus)
    (en Raul p2701) (destino Raul p2705) (pendiente Raul)
    (en Maria p2713) (destino Maria p2708) (pendiente Maria)
    (en Estela p2706) (destino Estela p2711) (pendiente Estela)
    (en Sebas p2712) (destino Sebas p2710) (pendiente Sebas)
    (en Martina p2701) (destino Martina p2711) (pendiente Martina)
    (en Noelia p2707) (destino Noelia p2705) (pendiente Noelia)
    (en Pau p2704) (destino Pau p2710) (pendiente Pau)
    (en Xavier p2703) (destino Xavier p2705) (pendiente Xavier)
    (en Alba p2703) (destino Alba p2707) (pendiente Alba)
    (en Beatriz p2703) (destino Beatriz p2708) (pendiente Beatriz)
    (en Jordi p2706) (destino Jordi p2705) (pendiente Jordi)
    (en Kilian p2713) (destino Kilian p2708) (pendiente Kilian)
    (en Fabiola p2706) (destino Fabiola p2710) (pendiente Fabiola)
    (en Susana p2714) (destino Susana p2710) (pendiente Susana)
    (en Ruth p2706) (destino Ruth p2710) (pendiente Ruth)
    (estacionado Sbus027 p2701)
  )

  (:goal (forall (?p - persona) (servido ?p)))
)


