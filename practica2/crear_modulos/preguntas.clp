;
; Funciones
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

; ==================================
; Inicio de preguntas
; ==================================
(defrule crear-persona
    (initial-fact)
    (not (persona))
    =>
    (make-instance of Persona)
    (assert (persona-creada))
)

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
)

; Para pruebas adquirir instancia persona: (bind ?p (nth$ 1 (find-all-instances ((?p Persona)) TRUE)))