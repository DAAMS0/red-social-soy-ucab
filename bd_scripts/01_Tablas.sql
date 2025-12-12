-- Table: public.asistencia_evento

-- DROP TABLE IF EXISTS public.asistencia_evento;

CREATE TABLE IF NOT EXISTS public.asistencia_evento
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    nombre_evento character varying(150) COLLATE pg_catalog."default" NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_registro timestamp without time zone,
    tipo_participacion character varying(40) COLLATE pg_catalog."default",
    fue_presente boolean,
    CONSTRAINT asistencia_evento_pkey PRIMARY KEY (correo_electronico, nombre_evento, fecha_inicio),
    CONSTRAINT asistencia_evento_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT asistencia_evento_nombre_evento_fecha_inicio_fkey FOREIGN KEY (nombre_evento, fecha_inicio)
        REFERENCES public.evento (nombre_evento, fecha_inicio) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.asistencia_evento
    OWNER to postgres;

-- Trigger: trg_asignar_puntos_asistencia

-- DROP TRIGGER IF EXISTS trg_asignar_puntos_asistencia ON public.asistencia_evento;

CREATE OR REPLACE TRIGGER trg_asignar_puntos_asistencia
    AFTER UPDATE 
    ON public.asistencia_evento
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_asignar_puntos_evento();

    -- Table: public.capitulo_regional

-- DROP TABLE IF EXISTS public.capitulo_regional;

CREATE TABLE IF NOT EXISTS public.capitulo_regional
(
    nombre_capitulo character varying(120) COLLATE pg_catalog."default" NOT NULL,
    territorio character varying(120) COLLATE pg_catalog."default",
    fecha_fundacion date,
    estatus character varying(20) COLLATE pg_catalog."default",
    enlaces_redes character varying(500) COLLATE pg_catalog."default",
    dependencia_responsable character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT capitulo_regional_pkey PRIMARY KEY (nombre_capitulo),
    CONSTRAINT capitulo_regional_dependencia_responsable_fkey FOREIGN KEY (dependencia_responsable)
        REFERENCES public.dependencia (nombre_dependencia) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.capitulo_regional
    OWNER to postgres;

-- Table: public.certificacion_digital

-- DROP TABLE IF EXISTS public.certificacion_digital;

CREATE TABLE IF NOT EXISTS public.certificacion_digital
(
    nombre_certificacion character varying(150) COLLATE pg_catalog."default" NOT NULL,
    entidad_emisora character varying(150) COLLATE pg_catalog."default" NOT NULL,
    tipo_certificacion character varying(40) COLLATE pg_catalog."default",
    nivel_competencia character varying(40) COLLATE pg_catalog."default",
    fecha_emision date,
    fecha_expiracion date,
    url_verificacion character varying(255) COLLATE pg_catalog."default",
    estado_certificacion character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT certificacion_digital_pkey PRIMARY KEY (nombre_certificacion, entidad_emisora)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.certificacion_digital
    OWNER to postgres;

-- Table: public.configuracion_privacidad

-- DROP TABLE IF EXISTS public.configuracion_privacidad;

CREATE TABLE IF NOT EXISTS public.configuracion_privacidad
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    seccion_perfil character varying(60) COLLATE pg_catalog."default" NOT NULL,
    nivel_visibilidad character varying(20) COLLATE pg_catalog."default",
    fecha_ultima_actualizacion timestamp without time zone,
    CONSTRAINT configuracion_privacidad_pkey PRIMARY KEY (correo_electronico, seccion_perfil),
    CONSTRAINT configuracion_privacidad_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT chk_nivel_visibilidad CHECK (nivel_visibilidad::text = ANY (ARRAY['solo_yo'::character varying, 'contactos'::character varying, 'comunidad_ucab'::character varying, 'publico'::character varying]::text[]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.configuracion_privacidad
    OWNER to postgres;

-- Table: public.dependencia

-- DROP TABLE IF EXISTS public.dependencia;

CREATE TABLE IF NOT EXISTS public.dependencia
(
    nombre_dependencia character varying(100) COLLATE pg_catalog."default" NOT NULL,
    tipo_dependencia character varying(30) COLLATE pg_catalog."default",
    descripcion character varying(400) COLLATE pg_catalog."default",
    correo_contacto character varying(100) COLLATE pg_catalog."default",
    telefono_contacto character varying(20) COLLATE pg_catalog."default",
    campus character varying(60) COLLATE pg_catalog."default",
    sitio_web character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT dependencia_pkey PRIMARY KEY (nombre_dependencia)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.dependencia
    OWNER to postgres;

-- Table: public.egresado

-- DROP TABLE IF EXISTS public.egresado;

CREATE TABLE IF NOT EXISTS public.egresado
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    codigo_tai character varying(20) COLLATE pg_catalog."default",
    titulo_obtenido character varying(150) COLLATE pg_catalog."default",
    escuela_egreso character varying(100) COLLATE pg_catalog."default",
    anio_ingreso integer,
    fecha_acto_grado date,
    menciones_honorificas character varying(500) COLLATE pg_catalog."default",
    CONSTRAINT egresado_pkey PRIMARY KEY (correo_electronico),
    CONSTRAINT egresado_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.egresado
    OWNER to postgres;

-- Table: public.encuesta_institucional

-- DROP TABLE IF EXISTS public.encuesta_institucional;

CREATE TABLE IF NOT EXISTS public.encuesta_institucional
(
    titulo_encuesta character varying(200) COLLATE pg_catalog."default" NOT NULL,
    fecha_creacion date NOT NULL,
    descripcion character varying(500) COLLATE pg_catalog."default",
    objetivo_investigativo character varying(600) COLLATE pg_catalog."default",
    publico_objetivo character varying(200) COLLATE pg_catalog."default",
    fecha_inicio_vigencia date,
    fecha_fin_vigencia date,
    limite_respuestas integer,
    es_anonima boolean,
    estado_encuesta character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT encuesta_institucional_pkey PRIMARY KEY (titulo_encuesta, fecha_creacion)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.encuesta_institucional
    OWNER to postgres;

-- Table: public.estudiante

-- DROP TABLE IF EXISTS public.estudiante;

CREATE TABLE IF NOT EXISTS public.estudiante
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    cohorte_ingreso date,
    escuela character varying(100) COLLATE pg_catalog."default",
    carrera character varying(100) COLLATE pg_catalog."default",
    estado_academico character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT estudiante_pkey PRIMARY KEY (correo_electronico),
    CONSTRAINT estudiante_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.estudiante
    OWNER to postgres;

-- Table: public.evento

-- DROP TABLE IF EXISTS public.evento;

CREATE TABLE IF NOT EXISTS public.evento
(
    nombre_evento character varying(150) COLLATE pg_catalog."default" NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date,
    tipo_evento character varying(40) COLLATE pg_catalog."default",
    modalidad character varying(15) COLLATE pg_catalog."default",
    descripcion character varying(600) COLLATE pg_catalog."default",
    lugar character varying(200) COLLATE pg_catalog."default",
    cupo_maximo integer,
    estado_evento character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT evento_pkey PRIMARY KEY (nombre_evento, fecha_inicio),
    CONSTRAINT chk_fechas_evento CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT chk_estado_evento CHECK (estado_evento::text = ANY (ARRAY['borrador'::character varying, 'publicado'::character varying, 'en curso'::character varying, 'finalizado'::character varying, 'archivado'::character varying]::text[]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.evento
    OWNER to postgres;

-- Trigger: trg_validar_colision_evento

-- DROP TRIGGER IF EXISTS trg_validar_colision_evento ON public.evento;

CREATE OR REPLACE TRIGGER trg_validar_colision_evento
    BEFORE INSERT OR UPDATE 
    ON public.evento
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_validar_colision_evento();

-- Table: public.grupo

-- DROP TABLE IF EXISTS public.grupo;

CREATE TABLE IF NOT EXISTS public.grupo
(
    nombre_grupo character varying(120) COLLATE pg_catalog."default" NOT NULL,
    descripcion character varying(500) COLLATE pg_catalog."default",
    tipo_grupo character varying(15) COLLATE pg_catalog."default",
    fecha_creacion date,
    correo_creador character varying(100) COLLATE pg_catalog."default",
    imagen_grupo character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT grupo_pkey PRIMARY KEY (nombre_grupo),
    CONSTRAINT grupo_correo_creador_fkey FOREIGN KEY (correo_creador)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.grupo
    OWNER to postgres;

-- Table: public.habilidad

-- DROP TABLE IF EXISTS public.habilidad;

CREATE TABLE IF NOT EXISTS public.habilidad
(
    nombre_habilidad character varying(80) COLLATE pg_catalog."default" NOT NULL,
    categoria_habilidad character varying(60) COLLATE pg_catalog."default",
    descripcion_habilidad character varying(400) COLLATE pg_catalog."default",
    nivel_referencia character varying(30) COLLATE pg_catalog."default",
    CONSTRAINT habilidad_pkey PRIMARY KEY (nombre_habilidad)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.habilidad
    OWNER to postgres;

-- Table: public.habilidad_persona

-- DROP TABLE IF EXISTS public.habilidad_persona;

CREATE TABLE IF NOT EXISTS public.habilidad_persona
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    nombre_habilidad character varying(80) COLLATE pg_catalog."default" NOT NULL,
    nivel_autodeclarado character varying(40) COLLATE pg_catalog."default",
    anios_experiencia integer,
    fuente_validacion character varying(80) COLLATE pg_catalog."default",
    CONSTRAINT habilidad_persona_pkey PRIMARY KEY (correo_electronico, nombre_habilidad),
    CONSTRAINT habilidad_persona_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT habilidad_persona_nombre_habilidad_fkey FOREIGN KEY (nombre_habilidad)
        REFERENCES public.habilidad (nombre_habilidad) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.habilidad_persona
    OWNER to postgres;

-- Table: public.mapa_egresados

-- DROP TABLE IF EXISTS public.mapa_egresados;

CREATE TABLE IF NOT EXISTS public.mapa_egresados
(
    region_pais character varying(100) COLLATE pg_catalog."default" NOT NULL,
    numero_egresados integer,
    enlace_mapa character varying(255) COLLATE pg_catalog."default",
    comentarios_region character varying(400) COLLATE pg_catalog."default",
    CONSTRAINT mapa_egresados_pkey PRIMARY KEY (region_pais)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.mapa_egresados
    OWNER to postgres;

-- Table: public.membresia_capitulo

-- DROP TABLE IF EXISTS public.membresia_capitulo;

CREATE TABLE IF NOT EXISTS public.membresia_capitulo
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    nombre_capitulo character varying(120) COLLATE pg_catalog."default" NOT NULL,
    fecha_afiliacion date,
    rol_en_capitulo character varying(40) COLLATE pg_catalog."default",
    estado_membresia character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT membresia_capitulo_pkey PRIMARY KEY (correo_electronico, nombre_capitulo),
    CONSTRAINT membresia_capitulo_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT membresia_capitulo_nombre_capitulo_fkey FOREIGN KEY (nombre_capitulo)
        REFERENCES public.capitulo_regional (nombre_capitulo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.membresia_capitulo
    OWNER to postgres;

-- Trigger: trg_validar_miembro_capitulo

-- DROP TRIGGER IF EXISTS trg_validar_miembro_capitulo ON public.membresia_capitulo;

CREATE OR REPLACE TRIGGER trg_validar_miembro_capitulo
    BEFORE INSERT OR UPDATE 
    ON public.membresia_capitulo
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_validar_miembro_capitulo();

-- Table: public.membresia_grupo

-- DROP TABLE IF EXISTS public.membresia_grupo;

CREATE TABLE IF NOT EXISTS public.membresia_grupo
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    nombre_grupo character varying(120) COLLATE pg_catalog."default" NOT NULL,
    rol_en_grupo character varying(40) COLLATE pg_catalog."default",
    fecha_union date,
    fecha_salida date,
    estado_membresia character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT membresia_grupo_pkey PRIMARY KEY (correo_electronico, nombre_grupo),
    CONSTRAINT membresia_grupo_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT membresia_grupo_nombre_grupo_fkey FOREIGN KEY (nombre_grupo)
        REFERENCES public.grupo (nombre_grupo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.membresia_grupo
    OWNER to postgres;

-- Table: public.oferta

-- DROP TABLE IF EXISTS public.oferta;

CREATE TABLE IF NOT EXISTS public.oferta
(
    titulo_oferta character varying(200) COLLATE pg_catalog."default" NOT NULL,
    razon_social_organizacion character varying(150) COLLATE pg_catalog."default" NOT NULL,
    tipo_oferta character varying(30) COLLATE pg_catalog."default",
    descripcion character varying(800) COLLATE pg_catalog."default",
    ubicacion character varying(200) COLLATE pg_catalog."default",
    modalidad_trabajo character varying(20) COLLATE pg_catalog."default",
    fecha_publicacion date,
    fecha_cierre date,
    salario_referencial character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT oferta_pkey PRIMARY KEY (titulo_oferta, razon_social_organizacion),
    CONSTRAINT oferta_razon_social_organizacion_fkey FOREIGN KEY (razon_social_organizacion)
        REFERENCES public.organizacion_asociada (razon_social) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.oferta
    OWNER to postgres;

-- Table: public.organizacion_asociada

-- DROP TABLE IF EXISTS public.organizacion_asociada;

CREATE TABLE IF NOT EXISTS public.organizacion_asociada
(
    razon_social character varying(150) COLLATE pg_catalog."default" NOT NULL,
    rif character varying(15) COLLATE pg_catalog."default",
    sector_economico character varying(60) COLLATE pg_catalog."default",
    pais character varying(60) COLLATE pg_catalog."default",
    ciudad character varying(60) COLLATE pg_catalog."default",
    correo_contacto character varying(100) COLLATE pg_catalog."default",
    telefono_contacto character varying(20) COLLATE pg_catalog."default",
    sitio_web character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT organizacion_asociada_pkey PRIMARY KEY (razon_social)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.organizacion_asociada
    OWNER to postgres;

-- Table: public.participante_proyecto

-- DROP TABLE IF EXISTS public.participante_proyecto;

CREATE TABLE IF NOT EXISTS public.participante_proyecto
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    titulo_proyecto character varying(200) COLLATE pg_catalog."default" NOT NULL,
    correo_creador character varying(100) COLLATE pg_catalog."default" NOT NULL,
    rol_en_proyecto character varying(60) COLLATE pg_catalog."default",
    fecha_ingreso date,
    estado_participacion character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT participante_proyecto_pkey PRIMARY KEY (correo_electronico, titulo_proyecto, correo_creador),
    CONSTRAINT participante_proyecto_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT participante_proyecto_titulo_proyecto_correo_creador_fkey FOREIGN KEY (titulo_proyecto, correo_creador)
        REFERENCES public.proyecto_colaborativo (titulo_proyecto, correo_creador) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.participante_proyecto
    OWNER to postgres;

-- Table: public.persona

-- DROP TABLE IF EXISTS public.persona;

CREATE TABLE IF NOT EXISTS public.persona
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    tipo_documento character varying(10) COLLATE pg_catalog."default",
    numero_documento character varying(20) COLLATE pg_catalog."default",
    nombres character varying(80) COLLATE pg_catalog."default",
    apellidos character varying(80) COLLATE pg_catalog."default",
    fecha_nacimiento date,
    pais_residencia character varying(60) COLLATE pg_catalog."default",
    ciudad_residencia character varying(60) COLLATE pg_catalog."default",
    telefono_principal character varying(20) COLLATE pg_catalog."default",
    url_foto_perfil character varying(255) COLLATE pg_catalog."default",
    resumen_perfil character varying(500) COLLATE pg_catalog."default",
    fecha_registro date DEFAULT CURRENT_DATE,
    CONSTRAINT persona_pkey PRIMARY KEY (correo_electronico)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.persona
    OWNER to postgres;

-- Table: public.personal_administrativo

-- DROP TABLE IF EXISTS public.personal_administrativo;

CREATE TABLE IF NOT EXISTS public.personal_administrativo
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    cargo character varying(100) COLLATE pg_catalog."default",
    dependencia_trabajo character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT personal_administrativo_pkey PRIMARY KEY (correo_electronico),
    CONSTRAINT personal_administrativo_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT personal_administrativo_dependencia_trabajo_fkey FOREIGN KEY (dependencia_trabajo)
        REFERENCES public.dependencia (nombre_dependencia) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.personal_administrativo
    OWNER to postgres;

-- Table: public.postulacion_oferta

-- DROP TABLE IF EXISTS public.postulacion_oferta;

CREATE TABLE IF NOT EXISTS public.postulacion_oferta
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    titulo_oferta character varying(200) COLLATE pg_catalog."default" NOT NULL,
    razon_social_organizacion character varying(150) COLLATE pg_catalog."default" NOT NULL,
    fecha_postulacion date,
    estado_postulacion character varying(20) COLLATE pg_catalog."default",
    mensaje_motivacion text COLLATE pg_catalog."default",
    CONSTRAINT postulacion_oferta_pkey PRIMARY KEY (correo_electronico, titulo_oferta, razon_social_organizacion),
    CONSTRAINT postulacion_oferta_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT postulacion_oferta_titulo_oferta_razon_social_organizacion_fkey FOREIGN KEY (titulo_oferta, razon_social_organizacion)
        REFERENCES public.oferta (titulo_oferta, razon_social_organizacion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.postulacion_oferta
    OWNER to postgres;

-- Trigger: trg_validar_postulacion

-- DROP TRIGGER IF EXISTS trg_validar_postulacion ON public.postulacion_oferta;

CREATE OR REPLACE TRIGGER trg_validar_postulacion
    BEFORE INSERT OR UPDATE 
    ON public.postulacion_oferta
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_validar_postulante_oferta();

-- Table: public.profesor

-- DROP TABLE IF EXISTS public.profesor;

CREATE TABLE IF NOT EXISTS public.profesor
(
    correo_electronico character varying(100) COLLATE pg_catalog."default" NOT NULL,
    categoria character varying(40) COLLATE pg_catalog."default",
    dedicacion character varying(40) COLLATE pg_catalog."default",
    dependencia_adscrita character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT profesor_pkey PRIMARY KEY (correo_electronico),
    CONSTRAINT profesor_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT profesor_dependencia_adscrita_fkey FOREIGN KEY (dependencia_adscrita)
        REFERENCES public.dependencia (nombre_dependencia) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.profesor
    OWNER to postgres;

-- Table: public.proyecto_colaborativo

-- DROP TABLE IF EXISTS public.proyecto_colaborativo;

CREATE TABLE IF NOT EXISTS public.proyecto_colaborativo
(
    titulo_proyecto character varying(200) COLLATE pg_catalog."default" NOT NULL,
    correo_creador character varying(100) COLLATE pg_catalog."default" NOT NULL,
    descripcion character varying(800) COLLATE pg_catalog."default",
    objetivo_principal character varying(600) COLLATE pg_catalog."default",
    estado_proyecto character varying(20) COLLATE pg_catalog."default",
    fecha_inicio date,
    fecha_cierre_prevista date,
    presupuesto_estimado numeric(12,2),
    visibilidad character varying(15) COLLATE pg_catalog."default",
    CONSTRAINT proyecto_colaborativo_pkey PRIMARY KEY (titulo_proyecto, correo_creador),
    CONSTRAINT proyecto_colaborativo_correo_creador_fkey FOREIGN KEY (correo_creador)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT chk_estado_proyecto CHECK (estado_proyecto::text = ANY (ARRAY['idea'::character varying, 'en curso'::character varying, 'pausado'::character varying, 'finalizado'::character varying]::text[]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.proyecto_colaborativo
    OWNER to postgres;

-- Table: public.recomendacion_habilidad

-- DROP TABLE IF EXISTS public.recomendacion_habilidad;

CREATE TABLE IF NOT EXISTS public.recomendacion_habilidad
(
    correo_recomendador character varying(100) COLLATE pg_catalog."default" NOT NULL,
    correo_recomendado character varying(100) COLLATE pg_catalog."default" NOT NULL,
    nombre_habilidad character varying(80) COLLATE pg_catalog."default" NOT NULL,
    nivel_recomendado character varying(40) COLLATE pg_catalog."default",
    contexto_observacion character varying(400) COLLATE pg_catalog."default",
    fecha_recomendacion date,
    visibilidad character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT recomendacion_habilidad_pkey PRIMARY KEY (correo_recomendador, correo_recomendado, nombre_habilidad),
    CONSTRAINT recomendacion_habilidad_correo_recomendado_fkey FOREIGN KEY (correo_recomendado)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT recomendacion_habilidad_correo_recomendador_fkey FOREIGN KEY (correo_recomendador)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT recomendacion_habilidad_nombre_habilidad_fkey FOREIGN KEY (nombre_habilidad)
        REFERENCES public.habilidad (nombre_habilidad) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.recomendacion_habilidad
    OWNER to postgres;

-- Trigger: trg_validar_recomendacion

-- DROP TRIGGER IF EXISTS trg_validar_recomendacion ON public.recomendacion_habilidad;

CREATE OR REPLACE TRIGGER trg_validar_recomendacion
    BEFORE INSERT OR UPDATE 
    ON public.recomendacion_habilidad
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_validar_recomendacion();

-- Table: public.respuesta_encuesta

-- DROP TABLE IF EXISTS public.respuesta_encuesta;

CREATE TABLE IF NOT EXISTS public.respuesta_encuesta
(
    id_respuesta integer NOT NULL DEFAULT nextval('respuesta_encuesta_id_respuesta_seq'::regclass),
    titulo_encuesta character varying(200) COLLATE pg_catalog."default",
    fecha_creacion_encuesta date,
    correo_electronico character varying(100) COLLATE pg_catalog."default",
    fecha_respuesta date,
    respuestas_json text COLLATE pg_catalog."default",
    CONSTRAINT respuesta_encuesta_pkey PRIMARY KEY (id_respuesta),
    CONSTRAINT respuesta_encuesta_correo_electronico_fkey FOREIGN KEY (correo_electronico)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT respuesta_encuesta_titulo_encuesta_fecha_creacion_encuesta_fkey FOREIGN KEY (titulo_encuesta, fecha_creacion_encuesta)
        REFERENCES public.encuesta_institucional (titulo_encuesta, fecha_creacion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.respuesta_encuesta
    OWNER to postgres;

-- Trigger: trg_validar_encuesta_anonima

-- DROP TRIGGER IF EXISTS trg_validar_encuesta_anonima ON public.respuesta_encuesta;

CREATE OR REPLACE TRIGGER trg_validar_encuesta_anonima
    BEFORE INSERT
    ON public.respuesta_encuesta
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_validar_encuesta_anonima();

-- Table: public.transaccion_puntos_ucab

-- DROP TABLE IF EXISTS public.transaccion_puntos_ucab;

CREATE TABLE IF NOT EXISTS public.transaccion_puntos_ucab
(
    correo_persona character varying(100) COLLATE pg_catalog."default" NOT NULL,
    fecha_hora_transaccion timestamp without time zone NOT NULL,
    tipo_actividad character varying(60) COLLATE pg_catalog."default",
    puntos_otorgados integer,
    descripcion_actividad character varying(400) COLLATE pg_catalog."default",
    fuente_origen character varying(150) COLLATE pg_catalog."default",
    es_ajuste boolean,
    CONSTRAINT transaccion_puntos_ucab_pkey PRIMARY KEY (correo_persona, fecha_hora_transaccion),
    CONSTRAINT transaccion_puntos_ucab_correo_persona_fkey FOREIGN KEY (correo_persona)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT chk_puntos_no_negativos CHECK (puntos_otorgados >= 0)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.transaccion_puntos_ucab
    OWNER to postgres;

-- Table: public.tutoria

-- DROP TABLE IF EXISTS public.tutoria;

CREATE TABLE IF NOT EXISTS public.tutoria
(
    correo_tutor character varying(100) COLLATE pg_catalog."default" NOT NULL,
    correo_tutorado character varying(100) COLLATE pg_catalog."default" NOT NULL,
    area_conocimiento character varying(80) COLLATE pg_catalog."default" NOT NULL,
    fecha_inicio date,
    fecha_fin date,
    modalidad character varying(20) COLLATE pg_catalog."default",
    estado_tutoria character varying(20) COLLATE pg_catalog."default",
    calificacion_tutor integer,
    CONSTRAINT tutoria_pkey PRIMARY KEY (correo_tutor, correo_tutorado, area_conocimiento),
    CONSTRAINT tutoria_correo_tutor_fkey FOREIGN KEY (correo_tutor)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tutoria_correo_tutorado_fkey FOREIGN KEY (correo_tutorado)
        REFERENCES public.persona (correo_electronico) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tutoria_calificacion_tutor_check CHECK (calificacion_tutor >= 1 AND calificacion_tutor <= 5)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tutoria
    OWNER to postgres;

-- Trigger: trg_validar_tutoria

-- DROP TRIGGER IF EXISTS trg_validar_tutoria ON public.tutoria;

CREATE OR REPLACE TRIGGER trg_validar_tutoria
    BEFORE INSERT OR UPDATE 
    ON public.tutoria
    FOR EACH ROW
    EXECUTE FUNCTION public.fn_validar_tutor_no_es_tutorado();