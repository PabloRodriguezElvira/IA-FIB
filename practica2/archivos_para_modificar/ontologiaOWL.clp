;;; ---------------------------------------------------------
;;; ontologiaOWL.clp
;;; Translated by owl2clips
;;; Translated to CLIPS from ontology ontologiaOWL.owl
;;; :Date 14/12/2022 18:56:24

(defclass Sintoma
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot afecta
        (type INSTANCE)
        (create-accessor read-write))
    (slot nombre
        (type STRING)
        (create-accessor read-write))
)

(defclass CondicionFisica
    (is-a Sintoma)
    (role concrete)
    (pattern-match reactive)
)

(defclass Enfermedad
    (is-a Sintoma)
    (role concrete)
    (pattern-match reactive)
)

(defclass Fase
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot compuesto_por
        (type INSTANCE)
        (create-accessor read-write))
    (slot duracion
        (type INTEGER)
        (create-accessor read-write))
)

(defclass Calentamiento
    (is-a Fase)
    (role concrete)
    (pattern-match reactive)
)

(defclass Reposo
    (is-a Fase)
    (role concrete)
    (pattern-match reactive)
)

(defclass Sesion
    (is-a Fase)
    (role concrete)
    (pattern-match reactive)
)

(defclass Ejercicio
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot tipo
        (type INSTANCE)
        (create-accessor read-write))
    (slot duracion
        (type INTEGER)
        (create-accessor read-write))
    (multislot material
        (type STRING)
        (create-accessor read-write))
    (slot nombre
        (type STRING)
        (create-accessor read-write))
    (multislot parte_cuerpo
        (type STRING)
        (create-accessor read-write))
    (multislot prioridad
        (type INTEGER)
        (create-accessor read-write))
)

(defclass Persona
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
    (multislot enfermedades
        (type INSTANCE)
        (create-accessor read-write))
    (slot realiza
        (type INSTANCE)
        (create-accessor read-write))
    (slot altura
        (type INTEGER)
        (create-accessor read-write))
    (multislot condicion_fisica
        (type STRING)
        (create-accessor read-write))
    (slot dependencia
        (type INTEGER)
        (create-accessor read-write))
    (slot edad
        (type INTEGER)
        (create-accessor read-write))
    (slot frecuencia_cardiovascular
        (type INTEGER)
        (create-accessor read-write))
    (multislot material
        (type STRING)
        (create-accessor read-write))
    (slot nivel_actividad_fisica
        (type INTEGER)
        (create-accessor read-write))
    (slot nombre
        (type STRING)
        (create-accessor read-write))
    (slot peso
        (type INTEGER)
        (create-accessor read-write))
    (slot sexo
        (type STRING)
        (create-accessor read-write))
)

(defclass Programa
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(defclass TipoEjercicio
    (is-a USER)
    (role concrete)
    (pattern-match reactive)
)

(definstances instances
    ([Aerobico] of TipoEjercicio
    )

    ([Equilibrio] of TipoEjercicio
    )

    ([Flexibilidad] of TipoEjercicio
    )

    ([Resistencia] of TipoEjercicio
    )

    ([abdominales] of Ejercicio
         (tipo  [Resistencia])
         (material  "colchoneta")
         (nombre  "Abdominales")
         (parte_cuerpo  "abdominales")
    )

    ([andar] of Ejercicio
         (tipo  [Aerobico])
         (nombre  "Andar")
         (parte_cuerpo  "piernas")
    )

    ([andar_levantando_rodillas] of Ejercicio
         (tipo  [Equilibrio])
         (nombre  "Andar levantando las rodillas")
         (parte_cuerpo  "piernas")
    )

    ([artrosis] of Enfermedad
         (nombre  "Artrosis")
    )

    ([baile] of Ejercicio
         (tipo  [Aerobico])
         (nombre  "Baile")
         (parte_cuerpo  "brazos" "cadera" "piernas")
    )

    ([biceps] of Ejercicio
         (tipo  [Resistencia])
         (material  "mancuernas")
         (nombre  "Biceps")
         (parte_cuerpo  "brazos")
    )

    ([bicicleta] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Bicicleta abdominal")
         (parte_cuerpo  "abdominales")
    )

    ([caidas_frecuentes] of CondicionFisica
         (nombre  "Problemas de caidas")
    )

    ([cardiaca] of Enfermedad
         (nombre  "Enfermedad cardiaca")
    )

    ([ciclismo] of Ejercicio
         (tipo  [Aerobico])
         (nombre  "Ciclismo")
         (parte_cuerpo  "piernas")
    )

    ([curl_biceps] of Ejercicio
         (tipo  [Resistencia])
         (nombre  "Curl de biceps")
         (parte_cuerpo  "brazos")
    )

    ([deltoides] of Ejercicio
         (tipo  [Resistencia])
         (material  "mancuernas")
         (nombre  "Deltoides")
         (parte_cuerpo  "brazos")
    )

    ([depresion] of Enfermedad
         (nombre  "Depresion")
    )

    ([diabetes] of Enfermedad
         (nombre  "Diabetes")
    )

    ([diagonal_cuello] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Diagonal de cuello")
         (parte_cuerpo  "cuello")
    )

    ([disfuncion_brazos] of CondicionFisica
    )

    ([dolor_abdominales] of CondicionFisica
    )

    ([dolor_brazos] of CondicionFisica
    )

    ([dolor_cadera] of CondicionFisica
    )

    ([dolor_cuello] of CondicionFisica
    )

    ([dolor_espalda] of CondicionFisica
    )

    ([dolor_hombros] of CondicionFisica
    )

    ([dolor_piernas] of CondicionFisica
    )

    ([elevacion_piernas] of Ejercicio
         (tipo  [Resistencia])
         (material  "colchoneta")
         (nombre  "Elevacion de piernas")
         (parte_cuerpo  "piernas")
    )

    ([elevacion_piernas_lateral] of Ejercicio
         (tipo  [Equilibrio] [Resistencia])
         (nombre  "Elevacion de piernas lateralmente")
         (parte_cuerpo  "piernas")
    )

    ([elongacion_lateral] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Elongacion lateral")
         (parte_cuerpo  "brazos")
    )

    ([estiramiento_brazos] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de brazos")
         (parte_cuerpo  "brazos")
    )

    ([estiramiento_cuadriceps] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de cuadriceps")
         (parte_cuerpo  "piernas")
    )

    ([estiramiento_espalda] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de espalda")
         (parte_cuerpo  "espalda")
    )

    ([estiramiento_gemelos] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de los gemelos")
         (parte_cuerpo  "piernas")
    )

    ([estiramiento_isquiotibiales] of Ejercicio
         (tipo  [Flexibilidad] [Resistencia])
         (material  "colchoneta")
         (nombre  "Estiramiento de isquiotibiales")
         (parte_cuerpo  "piernas")
    )

    ([estiramiento_miembros_inferiores] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de los miembros inferiores")
         (parte_cuerpo  "piernas")
    )

    ([estiramiento_miembros_superiores] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de los miembros superiores")
         (parte_cuerpo  "brazos")
    )

    ([estiramiento_muneca] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de muneca")
         (parte_cuerpo  "manos")
    )

    ([estiramiento_pantorrillas] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de pantorrillas")
         (parte_cuerpo  "piernas")
    )

    ([estiramiento_pectorales] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de pectorales")
         (parte_cuerpo  "pecho")
    )

    ([estiramiento_tendones_muslo] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de los tendones del muslo")
         (parte_cuerpo  "piernas")
    )

    ([estiramiento_tobillos] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de tobillos")
         (parte_cuerpo  "pies")
    )

    ([estiramiento_triceps] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Estiramiento de triceps")
         (parte_cuerpo  "brazos")
    )

    ([extension_cadera] of Ejercicio
         (tipo  [Equilibrio] [Resistencia])
         (nombre  "Extension de cadera")
         (parte_cuerpo  "cadera")
    )

    ([extension_hombros] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Extension de hombros")
         (parte_cuerpo  "brazos")
    )

    ([extension_rodilla] of Ejercicio
         (tipo  [Resistencia])
         (nombre  "Extension de rodilla")
         (parte_cuerpo  "piernas")
    )

    ([extension_triceps] of Ejercicio
         (tipo  [Resistencia])
         (nombre  "Extension de triceps")
         (parte_cuerpo  "brazos")
    )

    ([flexion_cadera] of Ejercicio
         (tipo  [Equilibrio] [Resistencia])
         (nombre  "Flexion de caderas")
         (parte_cuerpo  "cadera")
    )

    ([flexion_extension_de_tobillos] of Ejercicio
         (tipo  [Resistencia])
         (material  "colchoneta")
         (nombre  "Flexion y extension de tobillos")
         (parte_cuerpo  "pies")
    )

    ([flexion_hombros] of Ejercicio
         (tipo  [Flexibilidad] [Resistencia])
         (nombre  "Flexion de hombros")
         (parte_cuerpo  "brazos")
    )

    ([flexion_plantar] of Ejercicio
         (tipo  [Equilibrio] [Resistencia])
         (nombre  "Flexion plantar")
         (parte_cuerpo  "pies")
    )

    ([flexion_rodilla] of Ejercicio
         (tipo  [Equilibrio] [Resistencia])
         (nombre  "Flexion de rodilla")
         (parte_cuerpo  "piernas")
    )

    ([flexionar_piernas_alternativamente] of Ejercicio
         (tipo  [Resistencia])
         (material  "colchoneta")
         (nombre  "Flexionar piernas alternativamente")
         (parte_cuerpo  "piernas")
    )

    ([giros_cintura] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Giros de cintura")
         (parte_cuerpo  "cintura")
    )

    ([incontinencia_urinaria] of Enfermedad
         (nombre  "Incontinencia urinaria")
    )

    ([insuficiencia_renal_cronica] of Enfermedad
         (nombre  "Insuficiencia renal cronica")
    )

    ([isometrico_lateral] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Isometrico lateral")
         (parte_cuerpo  "brazos")
    )

    ([lateralizacion_cuello] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Lateralizacion de cuello")
         (parte_cuerpo  "cuello")
    )

    ([lateralizacion_tronco] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Lateralizacion del tronco")
         (parte_cuerpo  "torso")
    )

    ([levantar_brazos_frontal] of Ejercicio
         (tipo  [Resistencia])
         (nombre  "Levantar brazos frontalmente")
         (parte_cuerpo  "brazos")
    )

    ([levantar_brazos_lateral] of Ejercicio
         (tipo  [Resistencia])
         (nombre  "Levantar brazos lateralmente")
         (parte_cuerpo  "brazos")
    )

    ([levantarse_de_una_silla] of Ejercicio
         (tipo  [Resistencia])
         (nombre  "Levantarse de una silla")
         (parte_cuerpo  "piernas")
    )

    ([marcha] of Ejercicio
         (tipo  [Aerobico])
         (nombre  "Marcha")
         (parte_cuerpo  "piernas")
    )

    ([nadar] of Ejercicio
         (tipo  [Aerobico])
         (nombre  "Nadar")
         (parte_cuerpo  "brazos
piernas")
    )

    ([osteoporosis] of Enfermedad
         (nombre  "Osteoporosis")
    )

    ([press] of Ejercicio
         (tipo  [Resistencia])
         (material  "mancuernas")
         (nombre  "Press")
         (parte_cuerpo  "brazos")
    )

    ([puente] of Ejercicio
         (tipo  [Resistencia])
         (material  "colchoneta")
         (nombre  "Puente")
         (parte_cuerpo  "piernas
espalda")
    )

    ([pullover] of Ejercicio
         (tipo  [Resistencia])
         (material  "mancuernas")
         (nombre  "Pullover")
         (parte_cuerpo  "brazos")
    )

    ([remo] of Ejercicio
         (tipo  [Resistencia])
         (material  "mancuernas")
         (nombre  "Remo")
         (parte_cuerpo  "brazos")
    )

    ([rotacion_doble_cadera] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Rotacion doble de cadera")
         (parte_cuerpo  "cadera")
    )

    ([rotacion_hombros] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Rotacion de hombros")
         (parte_cuerpo  "brazos")
    )

    ([rotacion_simple_cadera] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Rotacion simple de cadera")
         (parte_cuerpo  "cadera")
    )

    ([rotadores_hombro] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Rotadores de hombros")
         (parte_cuerpo  "brazos")
    )

    ([sentadilla] of Ejercicio
         (tipo  [Flexibilidad] [Resistencia])
         (nombre  "Sentadillas")
         (parte_cuerpo  "piernas")
    )

    ([silla_de_ruedas] of CondicionFisica
    )

    ([subir_escaleras] of Ejercicio
         (tipo  [Flexibilidad])
         (nombre  "Subir escaleras")
         (parte_cuerpo  "piernas")
    )

    ([tijeras_abdominales] of Ejercicio
         (tipo  [Resistencia])
         (material  "colchoneta")
         (nombre  "Tijeras abdominales")
         (parte_cuerpo  "abdominales")
    )

    ([tocar_tobillo_con_mano] of Ejercicio
         (tipo  [Resistencia])
         (material  "colchoneta")
         (nombre  "Tocar el tobillo con la mano")
         (parte_cuerpo  "abdominales")
    )

    ([trapecios] of Ejercicio
         (tipo  [Resistencia])
         (material  "mancuernas")
         (nombre  "Trapecios")
         (parte_cuerpo  "espalda")
    )

    ([triceps] of Ejercicio
         (tipo  [Resistencia])
         (material  "mancuernas")
         (nombre  "Triceps")
         (parte_cuerpo  "brazos")
    )

    ([yoga] of Ejercicio
         (tipo  [Aerobico])
         (nombre  "Yoga")
         (parte_cuerpo  "brazos
piernas
abdominales")
    )

)
