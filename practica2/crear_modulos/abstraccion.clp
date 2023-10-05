; Templates
(deftemplate prioridad-tipo-ejercicio
    (slot nombre 
        (type SYMBOL) (allowed-symbols aerobico resistencia flexibilidad equilibrio))
    (slot prioridad 
        (type SYMBOL) (allowed-symbols baja media alta) (default baja))
)

;
; Funciones auxiliares
;
(deffunction calcular-imc (?peso ?altura)
    (bind ?altura_metros (/ ?altura 100))
    (/ ?peso (* ?altura_metros ?altura_metros))
)

(deffunction incrementar-prioridad-aerobico ()
    (bind ?p (nth$ 1 (find-fact ((?p2 prioridad-tipo-ejercicio)) (eq ?p2:nombre aerobico))))

    ; Prioridad media => alta
    (if (eq (fact-slot-value ?p prioridad) media)
    then
        (modify ?p (prioridad alta))
        (return)
    )    

    ; Prioridad baja => media 
    (if (eq (fact-slot-value ?p prioridad) baja)
    then
        (modify ?p (prioridad media))
    )
)

(deffunction incrementar-prioridad-resistencia ()
    (bind ?p (nth$ 1 (find-fact ((?p2 prioridad-tipo-ejercicio)) (eq ?p2:nombre resistencia))))

    ; Prioridad media => alta
    (if (eq (fact-slot-value ?p prioridad) media)
    then
        (modify ?p (prioridad alta))
        (return)
    )

    ; Prioridad baja => media
    (if (eq (fact-slot-value ?p prioridad) baja)
    then
        (modify ?p (prioridad media))
    )
)

(deffunction incrementar-prioridad-equilibrio ()
    (bind ?p (nth$ 1 (find-fact ((?p2 prioridad-tipo-ejercicio)) (eq ?p2:nombre equilibrio))))

    ; Prioridad media => alta
    (if (eq (fact-slot-value ?p prioridad) media)
    then
        (modify ?p (prioridad alta))
        (return)
    )

    ; Prioridad baja => media
    (if (eq (fact-slot-value ?p prioridad) baja)
    then
        (modify ?p (prioridad media))
    )
)

(deffunction incrementar-prioridad-flexibilidad ()
    (bind ?p (nth$ 1 (find-fact ((?p2 prioridad-tipo-ejercicio)) (eq ?p2:nombre flexibilidad))))

    ; Prioridad media => alta
    (if (eq (fact-slot-value ?p prioridad) media)
    then
        (modify ?p (prioridad alta))
        (return)
    )

    ; Prioridad baja => media
    (if (eq (fact-slot-value ?p prioridad) media)
    then
        (modify ?p (prioridad media))
    )
)

;
; Reglas
;
(defrule crear-prioridad-ejercicios
    (final-preguntas)
    => 
    (assert (prioridad-tipo-ejercicio (nombre aerobico)))
    (assert (prioridad-tipo-ejercicio (nombre resistencia)))
    (assert (prioridad-tipo-ejercicio (nombre flexibilidad)))
    (assert (prioridad-tipo-ejercicio (nombre equilibrio)))

    (assert (inicio-abstraccion))
)

;
; IMC
;
(defrule tiene-obesidad
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (peso ?peso) (altura ?altura))
    (test (> (calcular-imc ?peso ?altura) 30.0))
    =>
    (assert (obesidad))
)

(defrule tiene-peso-superior-normal
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (peso ?peso) (altura ?altura))
    (test (and (< (calcular-imc ?peso ?altura) 30.0) (> (calcular-imc ?peso ?altura) 25.0)))
    =>
    (assert (peso-superior-normal))
)

;
; Frecuencia cardiovascular
;
(defrule tiene-frecuencia-cardiovascular-alta
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (frecuencia_cardiovascular ?freq))
    (test (> ?freq 100))
    =>    
    (assert (frecuencia-cardiovascular-alta))
)

; https://www.goredforwomen.org/es/healthy-living/fitness/fitness-basics/target-heart-rates
; https://www.valida.es/blog/post/pulsaciones-normales-en-ancianos-como-bajarlas-o-subirlas/
(defrule tiene-frecuencia-cardiovascular-baja
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (frecuencia_cardiovascular ?freq))
    (test (< ?freq 50))
    =>    
    (assert (frecuencia-cardiovascular-baja))
)

;
; Ejercicio previo y nivel de dependencia
;
(defrule es-persona-muy-dependiente
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (dependencia ?depen))
    (test (eq ?depen "Muy dependiente"))
    =>
    (assert (intensidad-baja))
)

(defrule es-persona-dependiente-escala-alta
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (dependencia ?depen) (nivel_actividad_fisica ?borg))
    (test (and
        (eq ?depen "Dependiente")
        (>= ?borg 4)
    ))
    => 
    (assert (intensidad-baja))
)

(defrule es-persona-dependiente-escala-baja
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (dependencia ?depen) (nivel_actividad_fisica ?borg))
    (test (and
        (eq ?depen "Dependiente")
        (< ?borg 4)
    ))
    => 
    (assert (intensidad-media))
)

(defrule es-persona-independiente-escala-baja
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (dependencia ?depen) (nivel_actividad_fisica ?borg))
    (test (and
        (eq ?depen "Independiente")
        (< ?borg 4)
    ))
    => 
    (assert (intensidad-alta))
)

(defrule es-persona-independiente-escala-media
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (dependencia ?depen) (nivel_actividad_fisica ?borg))
    (test (and
        (eq ?depen "Independiente")
        (>= ?borg 4)
        (< ?borg 8)
    ))
    => 
    (assert (intensidad-media))
)

(defrule es-persona-independiente-escala-alta
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (dependencia ?depen) (nivel_actividad_fisica ?borg))
    (test (and
        (eq ?depen "Independiente")
        (>= ?borg 8)
    ))
    => 
    (assert (intensidad-baja))
)

;
; Condiciones físicas 
;
(defrule tiene-no-disponibilidad-brazos
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (condicion_fisica $?cond))
    (test (member [disfuncion_brazos] ?cond))
    =>
    (assert (no-disponibilidad-brazos))
)

(defrule tiene-no-disponibilidad-piernas
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (condicion_fisica $?cond))
    (test (member [silla_de_ruedas] ?cond))
    =>
    (assert (no-disponibilidad-piernas))
)

(defrule tiene-caidas-frecuentes
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (condicion_fisica $?cond))
    (test (member [caidas_frecuentes] ?cond))
    =>
    (incrementar-prioridad-equilibrio)
    (assert (reforzar-zona-inferior))
)

(defrule tiene-depresion
    (inicio-abstraccion)
    ?p <- (object (is-a Persona) (condicion_fisica $?cond))
    (test (member [depresion] ?cond))
    =>
    ; Incrementar mucho los ejercicios aeróbicos
    (incrementar-prioridad-aerobico)
    (incrementar-prioridad-aerobico)
)

;
; Enfermedades
;
(defrule tiene-insuficiencia-cardiaca
    (inicio-abstraccion)
    ?persona <- (object (is-a Persona) (enfermedades $?enfermedades))
    (test (member [cardiaca] ?enfermedades))
    =>
    (incrementar-prioridad-aerobico)
    (incrementar-prioridad-resistencia)
)

(defrule tiene-insuficiencia-diabetes
    (inicio-abstraccion)
    ?persona <- (object (is-a Persona) (enfermedades $?enfermedades))
    (test (member [diabetes] ?enfermedades))
    =>
    (incrementar-prioridad-aerobico)
    (incrementar-prioridad-resistencia)

    (assert (reforzar-grandes-grupos-musculares))
)

(defrule tiene-artrosis
    (inicio-abstraccion)
    ?persona <- (object (is-a Persona) (enfermedades $?enfermedades))
    (test (member [artrosis] ?enfermedades))
    =>
    (incrementar-prioridad-resistencia)
    (assert (reforzar-articulaciones))
    ; FIXME: También pone evitar obesidad, o no lo ponemos o intentamos codificarlo de alguna manera
)

(defrule tiene-insuficiencia-renal
    (inicio-abstraccion)
    ?persona <- (object (is-a Persona) (enfermedades $?enfermedades))
    (test (member [insuficiencia_renal_cronica] ?enfermedades))
    =>
    (incrementar-prioridad-resistencia)
    (assert (reforzar-grandes-grupos-musculares))
    (assert (reforzar-zona-inferior))
)

(defrule tiene-osteoporosis
    (inicio-abstraccion)
    ?persona <- (object (is-a Persona) (enfermedades $?enfermedades))
    (test (member [osteoporosis] ?enfermedades))
    =>
    (incrementar-prioridad-resistencia)
    (assert (reforzar-grandes-grupos-musculares))
    (assert (reforzar-zona-superior))
    (assert (evitar-ejercicios-abdomen))
)

(defrule tiene-incontinencia-urinaria 
    (inicio-abstraccion)
    ?persona <- (object (is-a Persona) (enfermedades $?enfermedades))
    (test (member [incontinencia_urinaria] ?enfermedades))
    =>
    (incrementar-prioridad-resistencia)
    (assert (evitar-ejercicios-abdomen))
    (assert (reforzar-zona-inferior))
)
