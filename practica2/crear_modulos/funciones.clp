(deffunction eliminar-ejercicios-tipo (?tipo $?ejercicios)
    (bind ?i 1)
    (while (<= ?i (length$ ?ejercicios)) do 
        (bind ?ej (nth$ ?i ?ejercicios))
        (bind ?pertenece (member ?tipo (send ?ej get-tipo)))

        (if (not (eq ?pertenece FALSE)) 
        then
            (bind ?ejercicios (delete-member$ $?ejercicios ?ej))
        else 
            (bind ?i (+ ?i 1))
        )
    )
    ?ejercicios
)

(deffunction eliminar-ejercicios-parte (?parte $?ejercicios)
    (bind ?i 1)
    (while (<= ?i (length$ ?ejercicios)) do 
        (bind ?ej (nth$ ?i ?ejercicios))
        (bind ?pertenece (member ?parte (send ?ej get-parte_cuerpo)))

        (if (not (eq ?pertenece FALSE)) 
        then
            (bind ?ejercicios (delete-member$ $?ejercicios ?ej))
        else 
            (bind ?i (+ ?i 1))
        )
    )
    ?ejercicios
)

(deffunction persona-tiene-enfermedad (?persona ?enfermedad)
    (member ?enfermedad (send ?persona get-enfermedades))
)

(deffunction persona-tiene-condicion-fisica (?persona ?condicion)
    (member ?condicion (send ?persona get-condicion_fisica))
)

(deffunction persona-tiene-material (?persona ?material)
    (member ?material (send ?persona get-material))
)

(deffunction modificar-prioridad-ejercicio (?ej ?mod)
    (bind ?actual (send ?ej get-prioridad))
    (send ?ej put-prioridad (+ ?actual ?mod))
)

(deffunction valorar-ejercicios-tipo (?tipo ?mod $?ejercicios)
    (progn$ (?ej ?ejercicios)
        (bind ?pertenece (member ?tipo (send ?ej get-tipo)))

        (if (not (eq ?pertenece FALSE)) ; if pertenece
        then
            (modificar-prioridad-ejercicio ?ej ?mod)
        )
    )
)

(deffunction valorar-ejercicios-parte-cuerpo (?parte ?mod $?ejercicios)
    (progn$ (?ej ?ejercicios)
        (bind ?pertenece (member ?parte (send ?ej get-parte_cuerpo)))

        (if (not (eq ?pertenece FALSE)) ; if pertenece
        then
            (modificar-prioridad-ejercicio ?ej ?mod)
        )
    )
)

(deffunction valorar-ejercicios-tipo-parte (?tipo ?parte ?mod $?ejercicios)
    (progn$ (?ej ?ejercicios)
        (bind ?p_tipo (member ?tipo (send ?ej get-tipo)))
        (bind ?p_parte (member ?parte (send ?ej get-parte_cuerpo)))

        (if (and (not (eq ?p_tipo FALSE)) (not (eq ?p_parte FALSE))) ; if ejercicio es de tipo y necesita parte del cuerpo
        then
            (modificar-prioridad-ejercicio ?ej ?mod)
        )
    )
)

(deffunction valorar-ejercicios-material (?material ?mod $?ejercicios)
    (progn$ (?ej ?ejercicios)
        (bind ?pertenece (member ?material (send ?ej get-material)))

        (if (not (eq ?pertenece FALSE)) ; if ejercicio necesita el material
        then
            (modificar-prioridad-ejercicio ?ej ?mod)
        )
    )
)

(deffunction sort-prioridad (?ej1 ?ej2)
   (< (send ?ej1 get-prioridad) (send ?ej2 get-prioridad))
)
 