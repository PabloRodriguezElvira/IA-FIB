
(defclass TipoEjercicio
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass Ejercicio
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (slot duracion
        (type INTEGER)
        (create-accessor read-write))
    (multislot material
        (type STRING)
        (create-accessor read-write))
    (slot nombre
        (type STRING)
        (create-accessor read-write))
    (multislot tipo
        (type INSTANCE)
        (allowed-classes TipoEjercicio)
        (create-accessor read-write))
)

(definstances instances
    ([Equilibrio] of TipoEjercicio)
    ([Resistencia] of TipoEjercicio)

    (Levantamiento of Ejercicio
        (duracion 5)
        (material poronga)
        (nombre levantamiento)
        (tipo 
            [Resistencia] 
            [Equilibrio]))
    (Mantenerse of Ejercicio
        (duracion 3)
        (material poronga)
        (nombre mantenerse)
        (tipo 
            [Equilibrio]))
    (Ir-al-baño of Ejercicio
        (duracion 120)
        (material poronga)
        (nombre ir-al-baño)
        (tipo 
            [Resistencia]))
)

(deftemplate ejercicio-prioridad
    (slot ejercicio (type INSTANCE) (allowed-classes Ejercicio))
    (slot prioridad (type INTEGER))
)

(deftemplate ejercicios-potenciales
    (multislot ejercicios (type INSTANCE))
)

(defrule inicializar-ejercicios-potenciales 
    (not (ejercicios-potenciales))
    =>
    (bind ?lista (assert (ejercicios-potenciales)))
    (bind ?ejercicios (find-all-instances ((?ej Ejercicio)) TRUE))
    (modify ?lista (ejercicios $?ejercicios))
)

(deffunction borrar-ejercicios (?tipo $?ejercicios) 
   (bind ?i 1)
       (while (<= ?i (length$ ?ejercicios))
       do
       (bind ?ej (nth$ ?i ?ejercicios)) 
       (bind ?esTipo (member ?tipo (send ?ej get-tipo)))
       (if (eq ?esTipo TRUE) then (delete-member$ ?ejercicios ?ej))
       (bind ?i (+ ?i 1)))
    (assert (ejercicios-potenciales) (ejercicios ?ejercicios))
)


(defrule borrar-ejercicios-resistencia
    ?ejercicios <- (ejercicios-potenciales (ejercicios $?listaEjs))
    =>
   (printout t "La lista contiene estos ejercicios:" crlf (borrar-ejercicios [Resistencia] ?listaEjs))
)
