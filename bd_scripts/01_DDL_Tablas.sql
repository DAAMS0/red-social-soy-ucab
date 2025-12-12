DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-- 1. ACTORES
CREATE TABLE MIEMBRO (
    correo_principal VARCHAR(255) PRIMARY KEY,
    contrasena_hash VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fotografia_url VARCHAR(255),
    tipo_usuario VARCHAR(50) NOT NULL 
);

CREATE TABLE PERSONA (
    correo_principal VARCHAR(255) PRIMARY KEY REFERENCES MIEMBRO(correo_principal),
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cedula VARCHAR(20) UNIQUE,
    fecha_nacimiento DATE,
    ubicacion_ciudad VARCHAR(100),
    ubicacion_pais VARCHAR(100)
);

CREATE TABLE ENTIDAD (
    correo_principal VARCHAR(255) PRIMARY KEY REFERENCES MIEMBRO(correo_principal),
    nombre_oficial VARCHAR(255) NOT NULL,
    tipo_entidad VARCHAR(50) CHECK (tipo_entidad IN ('Dependencia UCAB', 'Organizacion Asociada'))
);

-- 2. GRUPOS
CREATE TABLE GRUPO (
    clave_grupo SERIAL PRIMARY KEY,
    nombre_grupo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    visibilidad VARCHAR(20) CHECK (visibilidad IN ('Público', 'Privado', 'Secreto')),
    correo_creador VARCHAR(255) REFERENCES MIEMBRO(correo_principal)
);

CREATE TABLE MEMBRESIA_GRUPO (
    clave_membresia SERIAL PRIMARY KEY,
    fk_grupo INTEGER REFERENCES GRUPO(clave_grupo),
    correo_miembro VARCHAR(255) REFERENCES PERSONA(correo_principal),
    rol_en_grupo VARCHAR(20) DEFAULT 'Miembro'
);

-- 3. EVENTOS
CREATE TABLE EVENTO (
    clave_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    fecha_inicio TIMESTAMP NOT NULL,
    fecha_fin TIMESTAMP NOT NULL,
    lugar VARCHAR(255) NOT NULL,
    organizador VARCHAR(255) REFERENCES MIEMBRO(correo_principal),
    CONSTRAINT check_fechas_evento CHECK (fecha_fin >= fecha_inicio)
);

CREATE TABLE ASISTENCIA_EVENTO (
    fk_evento INTEGER REFERENCES EVENTO(clave_evento),
    correo_asistente VARCHAR(255) REFERENCES PERSONA(correo_principal),
    asistio_realmente BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (fk_evento, correo_asistente)
);

-- 4. TUTORÍAS (Edwin)
CREATE TABLE TUTORIA (
    clave_tutoria SERIAL PRIMARY KEY,
    correo_tutor VARCHAR(255) REFERENCES PERSONA(correo_principal),
    correo_tutorado VARCHAR(255) REFERENCES PERSONA(correo_principal),
    area_conocimiento VARCHAR(100) NOT NULL,
    valoracion_tutor INTEGER CHECK (valoracion_tutor BETWEEN 1 AND 5),
    CONSTRAINT check_tutoria_consistente CHECK (correo_tutor <> correo_tutorado)
);

-- 5. OFERTAS Y POSTULACIONES
CREATE TABLE OFERTA (
    clave_oferta SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activa',
    correo_publicador VARCHAR(255) REFERENCES ENTIDAD(correo_principal)
);

CREATE TABLE POSTULACION_OFERTA (
    clave_postulacion SERIAL PRIMARY KEY,
    fk_oferta INTEGER REFERENCES OFERTA(clave_oferta),
    correo_postulante VARCHAR(255) REFERENCES PERSONA(correo_principal),
    fecha_postulacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. PUNTOS (Edwin)
CREATE TABLE TRANSACCION_PUNTOS_UCAB (
    clave_transaccion SERIAL PRIMARY KEY,
    correo_usuario VARCHAR(255) REFERENCES PERSONA(correo_principal),
    puntos_otorgados INTEGER NOT NULL CHECK (puntos_otorgados >= 0),
    concepto VARCHAR(255),
    fecha_transaccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);