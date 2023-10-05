; Templates
(deftemplate ejercicios-potenciales
    (multislot ejercicios (type INSTANCE))
    (slot intensidad (type INTEGER) (default 0))
    (slot tiempo-sesion (type INTEGER))
    (multislot dias (type STRING))
)

(defrule crear-ejercicios-potenciales
    (inicio-abstraccion)
    (not (ejercicios-potenciales))
    => 
    (bind $?e (find-all-instances ((?e2 Ejercicio)) TRUE))
    (bind ?potenciales (assert (ejercicios-potenciales (ejercicios ?e))))

    (assert (ejercicios-potenciales-creados))
)

; Globales
(defglobal
    ?*mod_reforzar_parte* = 2

    ?*mod_frecuencia_baja* = 2

    ?*mod_obesidad* = 2
    ?*mod_peso_superior* = 1

    ?*mod_prioridad_alta* = 5
    ?*mod_prioridad_media* = 3

    ?*mod_material* = 1

    ?*mod_dolor_principal* = -3
    ?*mod_dolor_secundario* = -1
)

;
; Imposibilidad de ejercicios
;
(defrule brazos-disfuncionales
    (ejercicios-potenciales-creados)
    ?r <- (no-disponibilidad-brazos)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    => 
    (bind ?actualizado (eliminar-ejercicios-parte "brazos" ?ejercicios))
    (modify ?potenciales
        (ejercicios ?actualizado))
    (retract ?r)
)

(defrule piernas-disfuncionales
    (ejercicios-potenciales-creados)
    ?r <- (no-disponibilidad-piernas)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    => 
    (bind ?actualizado (eliminar-ejercicios-parte "piernas" ?ejercicios))
    (modify ?potenciales
        (ejercicios ?actualizado))
    (retract ?r)
)

(defrule no-abdomen 
    (ejercicios-potenciales-creados)
    ?r <- (evitar-ejercicios-abdomen)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    => 
    (bind ?actualizado (eliminar-ejercicios-parte "abdominales" ?ejercicios))
    (modify ?potenciales (ejercicios ?actualizado))
    (retract ?r)
)

;
; Condiciones persona
;
(defrule regla-obesidad
    (ejercicios-potenciales-creados)
    ?r <- (obesidad)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    =>
    (valorar-ejercicios-tipo [Aerobico] ?*mod_obesidad* ?ejercicios)
    (retract ?r)
)

(defrule regla-peso-superior
    (ejercicios-potenciales-creados)
    ?r <- (peso-superior-normal)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    =>
    (valorar-ejercicios-tipo [Aerobico] ?*mod_peso_superior* ?ejercicios)
    (retract ?r)
)

(defrule frecuencia-alta-intensidad-alta
    (ejercicios-potenciales-creados)
    ?r <- (frecuencia-cardiovascular-alta)
    ?i <- (intensidad-alta)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    =>
    (retract ?i)
    (assert (intensidad-media))

    (retract ?r)
)

(defrule frecuecnia-alta-intensidad-media
    (ejercicios-potenciales-creados)
    ?r <- (frecuencia-cardiovascular-alta)
    ?i <- (intensidad-alta)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    =>
    (retract ?i)
    (assert (intensidad-baja))

    (retract ?r)
)

(defrule frecuencia-baja
    (ejercicios-potenciales-creados)
    ?r <- (frecuencia-cardiovascular-baja)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    =>
    (valorar-ejercicios-tipo [Aerobico] ?*mod_frecuencia_baja* ?ejercicios)
    (assert (reforzar-grandes-grupos-musculares))
    (retract ?r)
)

;
; Reforzar partes
;
(defrule reforzar-articulaciones-regla
    (ejercicios-potenciales-creados)
    ?r <- (reforzar-articulaciones)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    =>
    (valorar-ejercicios-parte-cuerpo "brazos" ?*mod_reforzar_parte* ?ejercicios)
    (valorar-ejercicios-parte-cuerpo "piernas" ?*mod_reforzar_parte* ?ejercicios)
    (retract ?r)
)

(defrule reforzar-grandes-grupos-musculares-regla
    (ejercicios-potenciales-creados)
    ?r <- (reforzar-grandes-grupos-musculares)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    =>
    (valorar-ejercicios-parte-cuerpo "espalda" ?*mod_reforzar_parte* ?ejercicios)
    (valorar-ejercicios-parte-cuerpo "abdominales" ?*mod_reforzar_parte* ?ejercicios)
    (retract ?r)
)

(defrule reforzar-zona-inferior-regla
    (ejercicios-potenciales-creados)
    ?r <- (reforzar-zona-inferior)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    =>
    (valorar-ejercicios-parte-cuerpo "piernas" ?*mod_reforzar_parte* ?ejercicios)
    (valorar-ejercicios-parte-cuerpo "cintura" ?*mod_reforzar_parte* ?ejercicios)
    (retract ?r)
)

(defrule reforzar-zona-superior-regla
    (ejercicios-potenciales-creados)
    ?r <- (reforzar-zona-superior)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))
    =>
    (valorar-ejercicios-parte-cuerpo "brazos" ?*mod_reforzar_parte* ?ejercicios)
    (valorar-ejercicios-parte-cuerpo "espalda" ?*mod_reforzar_parte* ?ejercicios)
    (retract ?r)
)

;
; Prioridad tipo ejercicios
;
(defrule aerobico-media
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))

    ?r <- (prioridad-tipo-ejercicio (nombre ?nombre) (prioridad ?prioridad))
    (test (and (eq ?nombre aerobico) (eq ?prioridad media)))
    =>
    (valorar-ejercicios-tipo [Aerobico] ?*mod_prioridad_media* ?ejercicios)
    (retract ?r)
)

(defrule aerobico-alta
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))

    ?r <- (prioridad-tipo-ejercicio (nombre ?nombre) (prioridad ?prioridad))
    (test (and (eq ?nombre aerobico) (eq ?prioridad alta)))
    =>
    (valorar-ejercicios-tipo [Aerobico] ?*mod_prioridad_alta* ?ejercicios)
    (retract ?r)
)

(defrule resistencia-media
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))

    ?r <- (prioridad-tipo-ejercicio (nombre ?nombre) (prioridad ?prioridad))
    (test (and (eq ?nombre resistencia) (eq ?prioridad media)))
    =>
    (valorar-ejercicios-tipo [Musculacion] ?*mod_prioridad_media* ?ejercicios)
    (retract ?r)
)

(defrule resistencia-alta
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))

    ?r <- (prioridad-tipo-ejercicio (nombre ?nombre) (prioridad ?prioridad))
    (test (and (eq ?nombre resistencia) (eq ?prioridad alta)))
    =>
    (valorar-ejercicios-tipo [Musculacion] ?*mod_prioridad_alta* ?ejercicios)
    (retract ?r)
)

(defrule equilibrio-media
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))

    ?r <- (prioridad-tipo-ejercicio (nombre ?nombre) (prioridad ?prioridad))
    (test (and (eq ?nombre equilibrio) (eq ?prioridad media)))
    =>
    (valorar-ejercicios-tipo [Equilibrio] ?*mod_prioridad_media* ?ejercicios)
    (retract ?r)
)

(defrule equilibrio-alta
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))

    ?r <- (prioridad-tipo-ejercicio (nombre ?nombre) (prioridad ?prioridad))
    (test (and (eq ?nombre equilibrio) (eq ?prioridad alta)))
    =>
    (valorar-ejercicios-tipo [Equilibrio] ?*mod_prioridad_alta* ?ejercicios)
    (retract ?r)
)

(defrule flexibilidad-media
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))

    ?r <- (prioridad-tipo-ejercicio (nombre ?nombre) (prioridad ?prioridad))
    (test (and (eq ?nombre flexibilidad) (eq ?prioridad media)))
    =>
    (valorar-ejercicios-tipo [Flexibilidad] ?*mod_prioridad_media* ?ejercicios)
    (retract ?r)
)

(defrule flexibilidad-alta
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (ejercicios $?ejercicios))

    ?r <- (prioridad-tipo-ejercicio (nombre ?nombre) (prioridad ?prioridad))
    (test (and (eq ?nombre flexibilidad) (eq ?prioridad alta)))
    =>
    (valorar-ejercicios-tipo [Flexibilidad] ?*mod_prioridad_alta* ?ejercicios)
    (retract ?r)
)

;
; Intensidad 
;
(defrule puede-intensidad-baja
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (intensidad ?intensidad))
    ?r <- (intensidad-baja)
    =>
    (modify ?potenciales (intensidad 1))
    (retract ?r)
)

(defrule puede-intensidad-media
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (intensidad ?intensidad))
    ?r <- (intensidad-media)
    =>
    (modify ?potenciales (intensidad 2))
    (retract ?r)
)

(defrule puede-intensidad-alta
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales (intensidad ?intensidad))
    ?r <- (intensidad-alta)
    =>
    (modify ?potenciales (intensidad 3))
    (retract ?r)
)

;
; Refinar dolores
;
(defrule tiene-dolor-abdominales
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-condicion-fisica ?persona [dolor_abdominales]))
    =>
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-parte-cuerpo "abdominales" ?*mod_dolor_principal* ?ejercicios)
)

(defrule tiene-dolor-brazos
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-condicion-fisica ?persona [dolor_brazos]))
    =>
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-parte-cuerpo "brazos" ?*mod_dolor_principal* ?ejercicios)
)

(defrule tiene-dolor-cadera
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-condicion-fisica ?persona [dolor_cadera]))
    =>
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-parte-cuerpo "cadera" ?*mod_dolor_principal* ?ejercicios)

    (assert (dolor-cadera-comprobado))
)

(defrule tiene-dolor-cuello
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-condicion-fisica ?persona [dolor_cuello]))
    =>
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-parte-cuerpo "cuello" ?*mod_dolor_principal* ?ejercicios)
)

(defrule tiene-dolor-espalda
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-condicion-fisica ?persona [dolor_espalda]))
    =>
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-parte-cuerpo "espalda" ?*mod_dolor_principal* ?ejercicios)
)

(defrule tiene-dolor-hombros
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-condicion-fisica ?persona [dolor_hombros]))
    =>
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-parte-cuerpo "brazos" ?*mod_dolor_secundario* ?ejercicios)
    (valorar-ejercicios-parte-cuerpo "espalda" ?*mod_dolor_secundario* ?ejercicios)
)

(defrule tiene-dolor-piernas
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-condicion-fisica ?persona [dolor_piernas]))
    =>
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-parte-cuerpo "piernas" ?*mod_dolor_principal* ?ejercicios)
)

;
; Refinar materiales
;
(defrule tiene-mancuernas
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-material ?persona Mancuernas))
    => 
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-material "mancuernas" ?*mod_material* ?ejercicios)

    (assert (mancuernas-comprobado))
)

(defrule tiene-colchoneta
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-material ?persona Colchoneta))
    => 
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-material "colchoneta" ?*mod_material* ?ejercicios)

    (assert (colchoneta-comprobada))
)

(defrule tiene-piscina
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-material ?persona Piscina))
    => 
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-material "piscina" ?*mod_material* ?ejercicios)

    (assert (piscina-comprobada))
)

(defrule tiene-bicicleta-estatica
    (ejercicios-potenciales-creados)
    ?persona <- (object (is-a Persona))
    (test (persona-tiene-material ?persona Bicicleta_estatica))
    => 
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))
    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))

    (valorar-ejercicios-material "bicicleta_estatica" ?*mod_material* ?ejercicios)

    (assert (piscina-comprobada))
)

;
; Generación de la solución
;

(defrule tiene-3-dias
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales)
    ?r <- (3-dias-disponibles)
    =>
    (modify ?potenciales (dias (create$ "Lunes" "Miercoles" "Viernes")))
    (assert (dias-seleccionados))
    (retract ?r)
)

(defrule tiene-4-dias
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales)
    ?r <- (4-dias-disponibles)
    =>
    (modify ?potenciales (dias (create$ "Lunes" "Miercoles" "Viernes" "Domingo")))
    (assert (dias-seleccionados))
    (retract ?r)
)

(defrule tiene-5-dias
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales)
    ?r <- (5-dias-disponibles)
    =>
    (modify ?potenciales (dias (create$ "Lunes" "Martes" "Miercoles" "Jueves" "Sabado")))
    (assert (dias-seleccionados))
    (retract ?r)
)

(defrule tiene-tiempo-30-45
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales)
    ?r <- (tiempo-30-45)
    =>
    (modify ?potenciales (tiempo-sesion 30))
    (retract ?r)
)

(defrule tiene-tiempo-45-60
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales)
    ?r <- (tiempo-45-60)
    =>
    (modify ?potenciales (tiempo-sesion 40))
    (retract ?r)
)

(defrule tiene-tiempo-60-90
    (ejercicios-potenciales-creados)
    ?potenciales <- (ejercicios-potenciales)
    ?r <- (tiempo-60-90)
    =>
    (modify ?potenciales (tiempo-sesion 70))
    (retract ?r)
)

(deffunction get-duracion-base-ejercicio (?intensidad)
    (if (eq ?intensidad 1)
    then
        (return 5)
    )
    (if (eq ?intensidad 2)
    then
        (return 12)
    )
    (if (eq ?intensidad 3)
    then
        (return 20)
    )
)

;
; Generación solucion
;
(deffunction print-ejercicio (?ej) 
    (bind ?prefix-material "")
    (bind ?material "")
    (if (not (eq (length$ (send ?ej get-material)) 0))
    then
        (bind ?prefix-material "Material:")
        (bind ?material (implode$ (send ?ej get-material)))
    )

    (printout t 
        "    ["
        (send ?ej get-nombre)
        "] con una duracion de "
        (send ?ej get-duracion)
        " minutos"
    crlf)
)

(defrule generacion-solucion
    (declare (salience -1000))
    (ejercicios-potenciales-creados)
    (dias-seleccionados)
    =>
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))

    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))
    (bind ?intensidad (fact-slot-value ?potenciales intensidad))
    (bind ?duracion_sesion_global (fact-slot-value ?potenciales tiempo-sesion))
    (bind ?dias (fact-slot-value ?potenciales dias))

    (bind ?ordenados (sort sort-prioridad ?ejercicios))
    (bind ?ejercicios_calentamiento_reposo ?ordenados)

    ; Crear sesiones y popularlas
    (bind ?sesiones (create$))
    (loop-for-count (?i 1 (length$ dias))
        (bind ?sesion (make-instance of Sesion))
        (bind ?duracion_sesion ?duracion_sesion_global)

        ; idx = i % 2, pero como clips empieza en 1, pasamos a -1 (para que 1 == 0), hacemos el módulo y despues lo retormanos a 1 sumando
        (bind ?idx (+ (mod (- ?i 1) 2) 1))
        (while (> ?duracion_sesion 0)
            (bind ?ej (nth$ ?idx ?ordenados))

            (bind ?duracion_base (get-duracion-base-ejercicio ?intensidad))
            (if (member [Aerobico] (send ?ej get-tipo)) 
            then
                (send ?ej put-duracion (+ ?duracion_base 5))
            else
                (send ?ej put-duracion ?duracion_base)
            )

            (bind ?ejercicios_calentamiento_reposo (delete-member$ ?ejercicios_calentamiento_reposo ?ej))

            (send ?sesion put-compuesto_por (insert$ (send ?sesion get-compuesto_por) 1 ?ej))

            (bind ?duracion_sesion (- ?duracion_sesion (send ?ej get-duracion)))
            (bind ?idx (+ ?idx 2))
        )

        ; TODO: Guardar duracion sesión total
        (bind ?sesiones (insert$ ?sesiones 1 ?sesion))
    )

    ; Crear calentamiento y reposo
    (bind ?calentamiento (make-instance of Calentamiento))
    (bind ?reposo (make-instance of Reposo))

    (bind ?sin_aerobico (create$)) 
    (progn$ (?ej ?ejercicios_calentamiento_reposo)
        (if (not (member [Aerobico] (send ?ej get-tipo))) 
        then 
            (bind ?sin_aerobico (insert$ ?sin_aerobico 1 ?ej))
        )
    )

    ; Calentamiento
    (bind ?pos 1)
    (loop-for-count (?i 1 2)
        (bind ?ej (nth$ ?pos ?sin_aerobico))
        (send ?ej put-duracion 5)
        (send ?calentamiento put-compuesto_por (insert$ (send ?calentamiento get-compuesto_por) 1 ?ej))
        (bind ?pos (+ ?pos 1))
    )

    ; Reposo
    (loop-for-count (?i 1 2)
        (bind ?ej (nth$ ?pos ?sin_aerobico))
        (send ?ej put-duracion 5)
        (send ?reposo put-compuesto_por (insert$ (send ?reposo get-compuesto_por) 1 ?ej))
        (bind ?pos (+ ?pos 1))
    )

    ; 
    ; Imprmir resultados
    ;
    (printout t "Mostrando resultados:" crlf)
    (printout t "=====================" crlf)
    (printout t "" crlf)

    (printout t "Calentamiento:" crlf)
    (progn$ (?ej (send ?calentamiento get-compuesto_por))
        (print-ejercicio ?ej)
    )

    (printout t "Reposo:" crlf)
    (progn$ (?ej (send ?reposo get-compuesto_por))
        (print-ejercicio ?ej)
    )

    (printout t "Mostrando las sesiones por dia" crlf)
    (printout t "==============================" crlf)

    (loop-for-count (?i 1 (length$ ?dias))
        (printout t "Sesion dia " (nth$ ?i ?dias) crlf)
        (progn$ (?ej (send (nth$ ?i ?sesiones) get-compuesto_por))
            (print-ejercicio ?ej)
        )
    )
)

