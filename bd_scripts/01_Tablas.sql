
CREATE TABLE Persona (
    correo_electronico VARCHAR(100) PRIMARY KEY,
    tipo_documento VARCHAR(10),
    numero_documento VARCHAR(20),
    nombres VARCHAR(80),
    apellidos VARCHAR(80),
    fecha_nacimiento DATE,
    pais_residencia VARCHAR(60),
    ciudad_residencia VARCHAR(60),
    fecha_registro DATE DEFAULT CURRENT_DATE,
    url_foto_perfil VARCHAR(255),
    resumen_perfil VARCHAR(500)
);

CREATE TABLE Dependencia (
    nombre_dependencia VARCHAR(100) PRIMARY KEY,
    tipo_dependencia VARCHAR(30),
    descripcion VARCHAR(400),
    correo_contacto VARCHAR(100)
);

CREATE TABLE Organizacion_Asociada (
    razon_social VARCHAR(150) PRIMARY KEY,
    rif VARCHAR(15),
    sector_economico VARCHAR(60),
    pais VARCHAR(60),
    ciudad VARCHAR(60)
);

CREATE TABLE Habilidad (
    nombre_habilidad VARCHAR(80) PRIMARY KEY,
    categoria_habilidad VARCHAR(60),
    descripcion_habilidad VARCHAR(400)
);

CREATE TABLE Evento (
    nombre_evento VARCHAR(150),
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    tipo_evento VARCHAR(40),
    modalidad VARCHAR(15),
    descripcion VARCHAR(600),
    lugar VARCHAR(200),
    cupo_maximo INTEGER,
    estado_evento VARCHAR(20) CHECK (estado_evento IN ('borrador', 'publicado', 'en curso', 'finalizado', 'archivado')),
    PRIMARY KEY (nombre_evento, fecha_inicio),
    CHECK (fecha_fin >= fecha_inicio) -- Constraint explícito del PDF
);

CREATE TABLE Encuesta_Institucional (
    titulo_encuesta VARCHAR(200),
    fecha_creacion DATE,
    es_anonima BOOLEAN,
    estado_encuesta VARCHAR(20),
    PRIMARY KEY (titulo_encuesta, fecha_creacion)
);

CREATE TABLE Certificacion_Digital (
    nombre_certificacion VARCHAR(150),
    entidad_emisora VARCHAR(150),
    tipo_certificacion VARCHAR(40),
    fecha_emision DATE,
    fecha_expiracion DATE,
    estado_certificacion VARCHAR(20),
    PRIMARY KEY (nombre_certificacion, entidad_emisora)
);

CREATE TABLE Mapa_Egresados (region_pais VARCHAR(100), cantidad INTEGER);

-- 2.2 Roles
CREATE TABLE Estudiante (
    correo_electronico VARCHAR(100) PRIMARY KEY REFERENCES Persona(correo_electronico),
    cohorte_ingreso DATE,
    escuela VARCHAR(100),
    carrera VARCHAR(100)
);

CREATE TABLE Egresado (
    correo_electronico VARCHAR(100) PRIMARY KEY REFERENCES Persona(correo_electronico),
    titulo_obtenido VARCHAR(150),
    escuela_egreso VARCHAR(100),
    anio_ingreso INTEGER
);

CREATE TABLE Profesor (
    correo_electronico VARCHAR(100) PRIMARY KEY REFERENCES Persona(correo_electronico),
    categoria VARCHAR(40),
    dependencia_adscrita VARCHAR(100) REFERENCES Dependencia(nombre_dependencia)
);

CREATE TABLE Personal_Administrativo (
    correo_electronico VARCHAR(100) PRIMARY KEY REFERENCES Persona(correo_electronico),
    cargo VARCHAR(100),
    dependencia_trabajo VARCHAR(100) REFERENCES Dependencia(nombre_dependencia)
);

-- 2.3 Tablas Dependientes
CREATE TABLE Grupo (
    nombre_grupo VARCHAR(120) PRIMARY KEY,
    descripcion VARCHAR(200),
    tipo_grupo VARCHAR(15),
    fecha_creacion DATE,
    correo_creador VARCHAR(100) REFERENCES Persona(correo_electronico)
);

CREATE TABLE Oferta (
    titulo_oferta VARCHAR(200),
    razon_social_organizacion VARCHAR(150) REFERENCES Organizacion_Asociada(razon_social),
    tipo_oferta VARCHAR(30),
    fecha_publicacion DATE,
    fecha_cierre DATE,
    PRIMARY KEY (titulo_oferta, razon_social_organizacion)
);

CREATE TABLE Transaccion_Puntos_UCAB (
    id_transaccion SERIAL PRIMARY KEY,
    correo_persona VARCHAR(100) REFERENCES Persona(correo_electronico),
    fecha_hora_transaccion TIMESTAMP,
    tipo_actividad VARCHAR(60),
    puntos_otorgados INTEGER CHECK (puntos_otorgados >= 0),
    descripcion_actividad VARCHAR(400)
);

CREATE TABLE Respuesta_Encuesta (
    id_respuesta SERIAL PRIMARY KEY,
    titulo_encuesta VARCHAR(200),
    fecha_creacion_encuesta DATE,
    correo_electronico VARCHAR(100) REFERENCES Persona(correo_electronico), -- Puede ser NULL por regla de negocio
    respuestas_json TEXT, 
    FOREIGN KEY (titulo_encuesta, fecha_creacion_encuesta) 
        REFERENCES Encuesta_Institucional(titulo_encuesta, fecha_creacion)
);

CREATE TABLE Configuracion_Privacidad (
    correo_electronico VARCHAR(100) REFERENCES Persona(correo_electronico),
    seccion_perfil VARCHAR(60),
    nivel_visibilidad VARCHAR(20) CHECK (nivel_visibilidad IN ('solo_yo', 'contactos', 'comunidad_ucab', 'publico')),
    PRIMARY KEY (correo_electronico, seccion_perfil)
);

-- 2.4 Interrelaciones
CREATE TABLE Membresia_Grupo (
    correo_electronico VARCHAR(100) REFERENCES Persona(correo_electronico),
    nombre_grupo VARCHAR(120) REFERENCES Grupo(nombre_grupo),
    rol_en_grupo VARCHAR(40),
    fecha_union DATE,
    fecha_salida DATE,
    estado_membresia VARCHAR(20),
    PRIMARY KEY (correo_electronico, nombre_grupo)
);

CREATE TABLE Capitulo_Regional (
    nombre_capitulo VARCHAR(120) PRIMARY KEY,
    territorio VARCHAR(120),
    fecha_fundacion DATE,
    estatus VARCHAR(20),
    dependencia_responsable VARCHAR(100) REFERENCES Dependencia(nombre_dependencia)
);

CREATE TABLE Membresia_Capitulo (
    correo_electronico VARCHAR(100) REFERENCES Persona(correo_electronico),
    nombre_capitulo VARCHAR(120) REFERENCES Capitulo_Regional(nombre_capitulo),
    fecha_afiliacion DATE,
    rol_en_capitulo VARCHAR(40),
    estado_membresia VARCHAR(20),
    PRIMARY KEY (correo_electronico, nombre_capitulo)
);

CREATE TABLE Asistencia_Evento (
    correo_electronico VARCHAR(100) REFERENCES Persona(correo_electronico),
    nombre_evento VARCHAR(150),
    fecha_inicio TIMESTAMP,
    fecha_registro TIMESTAMP,
    fue_presente BOOLEAN,
    PRIMARY KEY (correo_electronico, nombre_evento, fecha_inicio),
    FOREIGN KEY (nombre_evento, fecha_inicio) REFERENCES Evento(nombre_evento, fecha_inicio)
);

CREATE TABLE Tutoria (
    correo_tutor VARCHAR(100) REFERENCES Persona(correo_electronico),
    correo_tutorado VARCHAR(100) REFERENCES Persona(correo_electronico),
    area_conocimiento VARCHAR(80),
    fecha_inicio DATE,
    estado_tutoria VARCHAR(20),
    calificacion_tutor INTEGER CHECK (calificacion_tutor BETWEEN 1 AND 5),
    PRIMARY KEY (correo_tutor, correo_tutorado, area_conocimiento)
);

CREATE TABLE Habilidad_Persona (
    correo_electronico VARCHAR(100) REFERENCES Persona(correo_electronico),
    nombre_habilidad VARCHAR(80) REFERENCES Habilidad(nombre_habilidad),
    nivel_autodeclarado VARCHAR(40),
    PRIMARY KEY (correo_electronico, nombre_habilidad)
);

CREATE TABLE Recomendacion_Habilidad (
    correo_recomendador VARCHAR(100) REFERENCES Persona(correo_electronico),
    correo_recomendado VARCHAR(100) REFERENCES Persona(correo_electronico),
    nombre_habilidad VARCHAR(80) REFERENCES Habilidad(nombre_habilidad),
    nivel_recomendado VARCHAR(40),
    contexto_observacion VARCHAR(400),
    fecha_recomendacion DATE,
    visibilidad VARCHAR(20),
    PRIMARY KEY (correo_recomendador, correo_recomendado, nombre_habilidad)
);

CREATE TABLE Postulacion_Oferta (
    correo_electronico VARCHAR(100) REFERENCES Persona(correo_electronico),
    titulo_oferta VARCHAR(200),
    razon_social_organizacion VARCHAR(150),
    fecha_postulacion DATE,
    mensaje_motivacion TEXT,
    PRIMARY KEY (correo_electronico, titulo_oferta, razon_social_organizacion),
    FOREIGN KEY (titulo_oferta, razon_social_organizacion) REFERENCES Oferta(titulo_oferta, razon_social_organizacion)
);

CREATE TABLE Proyecto_Colaborativo (
    titulo_proyecto VARCHAR(200),
    correo_creador VARCHAR(100) REFERENCES Persona(correo_electronico),
    descripcion VARCHAR(800),
    objetivo_principal VARCHAR(600),
    estado_proyecto VARCHAR(20),
    fecha_inicio DATE,
    presupuesto_estimado NUMERIC(12,2),
    visibilidad VARCHAR(15),
    PRIMARY KEY (titulo_proyecto, correo_creador)
);

CREATE TABLE Participante_Proyecto (
    correo_electronico VARCHAR(100) REFERENCES Persona(correo_electronico),
    titulo_proyecto VARCHAR(200),
    correo_creador VARCHAR(100),
    rol_en_proyecto VARCHAR(60),
    fecha_ingreso DATE,
    estado_participacion VARCHAR(20),
    FOREIGN KEY (titulo_proyecto, correo_creador) REFERENCES Proyecto_Colaborativo(titulo_proyecto, correo_creador)
);