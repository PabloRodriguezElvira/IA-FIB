;************************************ MÓDULO MAIN  *******************************

(defmodule MAIN "Este es el módulo donde se da la bienvenida a nuestro programa."
    (export ?ALL)
)

(defrule saludar-inicio-programa
    (initial-fact)
    =>
    (printout t crlf crlf)
    (printout t "*************************************************************************************************************" crlf)
    (printout t "                               PLANIFICADOR DE RUTINAS DE EJERCICIOS                                         " crlf crlf)
    (printout t "Bienvenido a nuestro sistema planificador de ejercicios para personas mayores." crlf crlf)
    (printout t "A continuación vamos a hacerle una serie de preguntas para construirle el mejor plan de ejercicios posible." crlf)
    (printout t "*************************************************************************************************************" crlf crlf)
    (assert (crear-instancia-persona))
)

; Creación de la instancia de persona
(defrule crear-persona
    (crear-instancia-persona)
    (not (persona))
    =>
    (make-instance of Persona)
    (assert (persona-creada))
    (focus PREGUNTAS)
)


;************************** MÓDULO FUNCIONES ************************

(defmodule FUNCIONES "Este es el módulo donde se definen todas las funciones auxiliares y templates para nuestro programa."
    (import MAIN ?ALL)
    (export ?ALL)
)

; Template para definir ejercicios potenciales.
(deftemplate ejercicios-potenciales
    (multislot ejercicios (type INSTANCE))
    (slot intensidad (type INTEGER) (default 0))
    (slot tiempo-sesion (type INTEGER))
    (multislot dias (type STRING))
)

; Template que relaciona el ejercicio con su prioridad.
(deftemplate prioridad-tipo-ejercicio
    (slot nombre 
        (type SYMBOL) (allowed-symbols aerobico resistencia flexibilidad equilibrio))
    (slot prioridad 
        (type SYMBOL) (allowed-symbols baja media alta) (default baja))
)

;
; Funciones auxiliares para las preguntas.
;
(deffunction pregunta (?pregunta $?valores_permitidos)
    (format t "%s (%s): " ?pregunta (implode$ ?valores_permitidos))
    (bind ?respuesta (read))
    (while (not (member (lowcase ?respuesta) ?valores_permitidos)) do
        (format t "%s (%s): " ?pregunta (implode$ ?valores_permitidos))
        (bind ?respuesta (read))
    )
    ?respuesta
)

(deffunction pregunta-numerica (?pregunta ?rangini ?rangfi)
    (format t "%s [%d, %d]: " ?pregunta ?rangini ?rangfi)
    (bind ?respuesta (read))
    (while (not(and(>= ?respuesta ?rangini)(<= ?respuesta ?rangfi))) do
        (format t "%s [%d, %d]: " ?pregunta ?rangini ?rangfi)
        (bind ?respuesta (read))
    )
    ?respuesta
)

(deffunction pregunta-si-o-no (?pregunta)
    (bind ?respuesta (pregunta ?pregunta si no))
    (if (eq (lowcase ?respuesta) si)
        then TRUE
        else FALSE
    )
)

(deffunction preguntar-lista (?prefix $?opciones)
    (bind ?elegidas (create$))
    (progn$ (?op ?opciones)
        (printout t "    " ?prefix)
        (bind ?res (pregunta-si-o-no ?op))
        (if (not (eq ?res FALSE))
        then 
            (bind ?elegidas (insert$ ?elegidas 1 ?op))
        )
    )
    ?elegidas
)

(deffunction pregunta-opciones (?pregunta $?opciones)
    (printout t ?pregunta " ( ")
    (bind ?i 1)
    (progn$ (?op ?opciones)
        (printout t ?i "-" ?op " ")
        (bind ?i (+ ?i 1))
    )
    (printout t ")" crlf)
    (bind ?valor (pregunta-numerica "  Inserte el valor" 1 (length$ ?opciones)))

    (nth$ ?valor ?opciones)
)


;
; Funciones útiles para el resto del programa.
;
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
 

;******************** MÓDULO PREGUNTAS ********************

(defmodule PREGUNTAS "Este es el módulo donde se hacen las preguntas al usuario."
    (import MAIN ?ALL)
    (import FUNCIONES ?ALL)
    (export ?ALL)
)

; ==================================
; Inicio de preguntas
; ==================================

(defrule preguntar-nombre
    (persona-creada)
    ?persona <- (object (is-a Persona))
    =>
    (printout t "¿Cual es su nombre?: ")
    (bind ?nombre (read))
    (send ?persona put-nombre ?nombre)

    (assert (nombre-preguntado))
)

(defrule preguntar-edad
    (nombre-preguntado)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?edad (pregunta-numerica "¿Cual es su edad?: " 60 100))
    (send ?persona put-edad ?edad)

    (assert (edad-preguntada))
)

(defrule preguntar-sexo
    (edad-preguntada)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?sexo (pregunta-opciones "¿Cual es su sexo?" (create$ "hombre" "mujer" "ns")))
    (send ?persona put-sexo ?sexo)

    (assert (sexo-preguntado))
)

(defrule preguntar-altura
    (sexo-preguntado)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?altura (pregunta-numerica "¿Cual es su altura (en cm)?" 120 220))
    (send ?persona put-altura ?altura)

    (assert (altura-preguntada))
)

(defrule preguntar-peso
    (sexo-preguntado)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?peso (pregunta-numerica "¿Cual es su peso (en kg)?" 40 220))
    (send ?persona put-peso ?peso)

    (assert (peso-preguntado))
)

(defrule preguntar-si-tiene-enfermedad
    (peso-preguntado)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?res (pregunta-si-o-no "Tiene alguna enfermedad que pueda afectar a la realización de ejercicio"))
    (if (not (eq ?res FALSE)) 
    then
        (assert (preguntar-enfermedades))
    else
        (assert (enfermedades-preguntadas))
    )
)

(defrule preguntar-enfermedades-regla
    (preguntar-enfermedades)
    ?persona <- (object (is-a Persona))
    =>
    (bind $?enfermedades (find-all-instances ((?e Enfermedad)) TRUE))

    (bind $?respuesta (preguntar-lista "Tiene: " ?enfermedades))
    (send ?persona put-enfermedades ?respuesta)

    (assert (enfermedades-preguntadas))
)

(defrule preguntar-si-tiene-condicion-fisica
    (enfermedades-preguntadas)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?res (pregunta-si-o-no "Tiene alguna condicion física que pueda afectar a la realización de ejercicio"))
    (if (not (eq ?res FALSE)) 
    then
        (assert (preguntar-condiciones-fisicas))
    else
        (assert (condiciones-fisicas-preguntadas))
    )
)

(defrule preguntar-condiciones-fisicas-regla
    (preguntar-condiciones-fisicas)
    ?persona <- (object (is-a Persona))
    =>
    (bind $?condiciones (find-all-instances ((?e CondicionFisica)) (not (eq (type ?e) Dolor))))

    (bind $?respuesta (preguntar-lista "Tiene: " ?condiciones))
    (send ?persona put-condicion_fisica ?respuesta) 

    (assert (condiciones-fisicas-preguntadas))
)

(defrule preguntar-si-tiene-dolor
    (condiciones-fisicas-preguntadas)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?res (pregunta-si-o-no "Tiene alguna algun dolor que pueda afectar a la realización de ejercicio"))
    (if (not (eq ?res FALSE)) 
    then
        (assert (preguntar-dolores))
    else
        (assert (dolores-preguntados))
    )
)

(defrule preguntar-dolores-regla
    (preguntar-dolores)
    ?persona <- (object (is-a Persona))
    =>
    (bind $?dolores (find-all-instances ((?e Dolor)) TRUE))

    (bind $?respuesta (preguntar-lista "Tiene: " ?dolores))

    ; Añadimos a la lista de condiciones físicas actual de la persona los dolores
    (bind ?condiciones (send ?persona get-condicion_fisica))
    (progn$ (?dolor ?respuesta)
        (bind ?condiciones (insert$ ?condiciones 1 ?dolor))
    )

    (send ?persona put-condicion_fisica ?condiciones) 

    (assert (dolores-preguntados))
)

(defrule preguntar-frecuencia-cardiovascular
    (dolores-preguntados)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?frec (pregunta-numerica "Cual es su frecuencia cardiovascular" 30 250))
    (send ?persona put-frecuencia_cardiovascular ?frec)

    (assert (frecuencia-cardiovascular-preguntada))
)

(defrule preguntar-numero-dias-disponible
    (frecuencia-cardiovascular-preguntada)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?dias (pregunta-numerica "Cuantos días a la semana tienes disponible hacer ejercicio" 3 5))

    (if (eq ?dias 3) then
        (assert (3-dias-disponibles))
    )
    (if (eq ?dias 4) then
        (assert (4-dias-disponibles))
    )
    (if (eq ?dias 5) then
        (assert (5-dias-disponibles))
    )

    (assert (numero-dias-preguntado))
)

(defrule preguntar-tiempo-disponible
    (numero-dias-preguntado)
    ?persona <- (object (is-a Persona))
    =>
    ; (bind ?tiempo (pregunta-numerica "Cuanto tiempo tiene disponible para dedicarle al dia (en minutos)" 30 90))
    (bind ?tiempo (pregunta-opciones "Cuanto tiempo tiene disponible al dia para dedicarlo a hacer deporte" 
        (create$ "Entre 30 y 45 minutos" "Entre 45 y 60 minutos" "Entre 60 y 90 minutos")))

    (if (eq ?tiempo "Entre 30 y 45 minutos") then
        (assert (tiempo-30-45))
    )
    (if (eq ?tiempo "Entre 45 y 60 minutos") then
        (assert (tiempo-45-60))
    )
    (if (eq ?tiempo "Entre 60 y 90 minutos") then
        (assert (tiempo-60-90))
    )


    (assert (duracion-ejercicios-preguntado))
)

(defrule preguntar-nivel-dependencia
    (duracion-ejercicios-preguntado)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?dependencia (pregunta-opciones "Cual es su nivel de dependencia" (create$ "Independiente" "Dependiente" "Muy dependiente")))
    (send ?persona put-dependencia ?dependencia)

    (assert (nivel-dependencia-preguntada))
)

(defrule preguntar-escala-borg
    (nivel-dependencia-preguntada)
    ?persona <- (object (is-a Persona))
    =>
    (bind ?actividad (pregunta-numerica "Del 0 al 10, cuánto esfuerzo considera que hace al realizar ejercicio" 0 10))
    (send ?persona put-nivel_actividad_fisica ?actividad)

    (assert (escala-borg-preguntada))
)

(defrule preguntar-material
    (escala-borg-preguntada)
    ?persona <- (object (is-a Persona))
    =>
    (printout t "¿Tiene (o tiene acceso a) alguno de los siguientes materiales?:" crlf)
    (bind ?materiales (preguntar-lista "Tiene: " Mancuernas Colchoneta Piscina Bicicleta_estatica))
    (send ?persona put-material ?materiales) 

    (assert (final-preguntas))
    (focus GENERACION_SOLUCION)
)

;******************************** MÓDULO DE GENERACIÓN DE LA SOLUCIÓN ***********************************

(defmodule GENERACION_SOLUCION "Este es el módulo donde se realizan los pasos de abstracción de datos, asociación heurística, refinamiento y se genera la solución."
    (import MAIN ?ALL)
    (import FUNCIONES ?ALL)
    (import PREGUNTAS ?ALL)
    (export ?ALL)
)

;************************** PARTE DE ABSTRACCIÓN DE DATOS Y ASOCIACIÓN HEURÍSTICA ************************

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

;************************** PARTE DE REFINAMIENTO ******************************

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

;************************************ GENERACIÓN DE LA SOLUCIÓN ****************************************

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

(defrule generacion-solucion
    (declare (salience -1000))
    (ejercicios-potenciales-creados)
    (dias-seleccionados)
    =>
    (bind ?potenciales (nth$ 1 (find-fact ((?potenciales ejercicios-potenciales)) TRUE)))

    (bind ?ejercicios (fact-slot-value ?potenciales ejercicios))
    (bind ?intensidad (fact-slot-value ?potenciales intensidad))
    (bind ?duracion_sesion_global (fact-slot-value ?potenciales tiempo-sesion))

    (bind ?ordenados (sort sort-prioridad ?ejercicios))
    (bind ?ejercicios_calentamiento_reposo ?ordenados)

    ; Crear sesiones y popularlas
    (bind ?sesiones (create$))
    (loop-for-count (?i 1 (length$ dias))
        (bind ?sesion (make-instance of Sesion))
        (bind ?duracion_sesion ?duracion_sesion_global)

        ; idx = i % 2, pero como clips empieza en 1, pasamos a -1 (para que 1 == 0), hacemos el módulo y despues lo retormanos a 1 sumando
        (bind ?idx (+ (mod (- ?i 1) 2) 1))
        (while (and (> ?duracion_sesion 0) (<= ?idx (length$ ordenados)))
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

    ; Imprimir la solución.

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

    (bind ?dias (fact-slot-value ?potenciales dias))

    (loop-for-count (?i 1 (length$ ?dias))
        (printout t "Sesion dia " (nth$ ?i ?dias) crlf)
        (progn$ (?ej (send (nth$ ?i ?sesiones) get-compuesto_por))
            (print-ejercicio ?ej)
        )
    )
)



