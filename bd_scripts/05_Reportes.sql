-- View: public.v_reporte_certificaciones

-- DROP VIEW public.v_reporte_certificaciones;

CREATE OR REPLACE VIEW public.v_reporte_certificaciones
 AS
 SELECT entidad_emisora,
    tipo_certificacion,
    count(*) AS total_emitidas,
    sum(
        CASE
            WHEN fecha_expiracion < CURRENT_DATE THEN 1
            ELSE 0
        END) AS expiradas,
    sum(
        CASE
            WHEN fecha_expiracion >= CURRENT_DATE THEN 1
            ELSE 0
        END) AS vigentes
   FROM certificacion_digital
  GROUP BY entidad_emisora, tipo_certificacion;

ALTER TABLE public.v_reporte_certificaciones
    OWNER TO postgres;

-- View: public.v_reporte_crecimiento

-- DROP VIEW public.v_reporte_crecimiento;

CREATE OR REPLACE VIEW public.v_reporte_crecimiento
 AS
 SELECT to_char(p.fecha_registro::timestamp with time zone, 'YYYY-MM'::text) AS periodo,
    p.pais_residencia,
        CASE
            WHEN e.correo_electronico IS NOT NULL THEN 'Estudiante'::text
            WHEN g.correo_electronico IS NOT NULL THEN 'Egresado'::text
            WHEN f.correo_electronico IS NOT NULL THEN 'Profesor'::text
            ELSE 'Otro'::text
        END AS tipo_usuario,
    count(*) AS nuevos_registros
   FROM persona p
     LEFT JOIN estudiante e ON p.correo_electronico::text = e.correo_electronico::text
     LEFT JOIN egresado g ON p.correo_electronico::text = g.correo_electronico::text
     LEFT JOIN profesor f ON p.correo_electronico::text = f.correo_electronico::text
  GROUP BY (to_char(p.fecha_registro::timestamp with time zone, 'YYYY-MM'::text)), p.pais_residencia, (
        CASE
            WHEN e.correo_electronico IS NOT NULL THEN 'Estudiante'::text
            WHEN g.correo_electronico IS NOT NULL THEN 'Egresado'::text
            WHEN f.correo_electronico IS NOT NULL THEN 'Profesor'::text
            ELSE 'Otro'::text
        END)
  ORDER BY (to_char(p.fecha_registro::timestamp with time zone, 'YYYY-MM'::text)) DESC;

ALTER TABLE public.v_reporte_crecimiento
    OWNER TO postgres;

-- View: public.v_reporte_distribucion_egresados

-- DROP VIEW public.v_reporte_distribucion_egresados;

CREATE OR REPLACE VIEW public.v_reporte_distribucion_egresados
 AS
 SELECT p.pais_residencia,
    p.ciudad_residencia,
    e.escuela_egreso,
    count(e.correo_electronico) AS total_egresados
   FROM egresado e
     JOIN persona p ON e.correo_electronico::text = p.correo_electronico::text
  GROUP BY p.pais_residencia, p.ciudad_residencia, e.escuela_egreso;

ALTER TABLE public.v_reporte_distribucion_egresados
    OWNER TO postgres;

-- View: public.v_reporte_egresados

-- DROP VIEW public.v_reporte_egresados;

CREATE OR REPLACE VIEW public.v_reporte_egresados
 AS
 SELECT p.pais_residencia,
    p.ciudad_residencia,
    e.escuela_egreso,
    count(*) AS total_egresados
   FROM egresado e
     JOIN persona p ON e.correo_electronico::text = p.correo_electronico::text
  GROUP BY p.pais_residencia, p.ciudad_residencia, e.escuela_egreso;

ALTER TABLE public.v_reporte_egresados
    OWNER TO postgres;

-- View: public.v_reporte_eventos

-- DROP VIEW public.v_reporte_eventos;

CREATE OR REPLACE VIEW public.v_reporte_eventos
 AS
 SELECT e.nombre_evento,
    e.tipo_evento,
    e.cupo_maximo,
    count(ae.correo_electronico) AS inscritos,
    round(count(ae.correo_electronico)::numeric / NULLIF(e.cupo_maximo, 0)::numeric * 100::numeric, 2) AS porcentaje_ocupacion,
    e.estado_evento
   FROM evento e
     LEFT JOIN asistencia_evento ae ON e.nombre_evento::text = ae.nombre_evento::text AND e.fecha_inicio = ae.fecha_inicio
  GROUP BY e.nombre_evento, e.tipo_evento, e.cupo_maximo, e.estado_evento
  ORDER BY (count(ae.correo_electronico)) DESC;

ALTER TABLE public.v_reporte_eventos
    OWNER TO postgres;

-- View: public.v_reporte_grupos

-- DROP VIEW public.v_reporte_grupos;

CREATE OR REPLACE VIEW public.v_reporte_grupos
 AS
 SELECT g.nombre_grupo,
    g.tipo_grupo,
    count(m.correo_electronico) AS cantidad_miembros,
    g.fecha_creacion,
        CASE
            WHEN count(m.correo_electronico) > 5 THEN 'Muy Activo'::text
            WHEN count(m.correo_electronico) >= 1 AND count(m.correo_electronico) <= 5 THEN 'Activo'::text
            ELSE 'Inactivo'::text
        END AS estado_actividad
   FROM grupo g
     LEFT JOIN membresia_grupo m ON g.nombre_grupo::text = m.nombre_grupo::text
  GROUP BY g.nombre_grupo, g.tipo_grupo, g.fecha_creacion
  ORDER BY (count(m.correo_electronico)) DESC;

ALTER TABLE public.v_reporte_grupos
    OWNER TO postgres;

-- View: public.v_reporte_habilidades

-- DROP VIEW public.v_reporte_habilidades;

CREATE OR REPLACE VIEW public.v_reporte_habilidades
 AS
 SELECT h.nombre_habilidad,
    h.categoria_habilidad,
    count(hp.correo_electronico) AS usuarios_con_habilidad,
    ( SELECT count(*) AS count
           FROM recomendacion_habilidad rh
          WHERE rh.nombre_habilidad::text = h.nombre_habilidad::text) AS total_validaciones
   FROM habilidad h
     LEFT JOIN habilidad_persona hp ON h.nombre_habilidad::text = hp.nombre_habilidad::text
  GROUP BY h.nombre_habilidad, h.categoria_habilidad
  ORDER BY (( SELECT count(*) AS count
           FROM recomendacion_habilidad rh
          WHERE rh.nombre_habilidad::text = h.nombre_habilidad::text)) DESC, (count(hp.correo_electronico)) DESC;

ALTER TABLE public.v_reporte_habilidades
    OWNER TO postgres;

-- View: public.v_reporte_interaccion

-- DROP VIEW public.v_reporte_interaccion;

CREATE OR REPLACE VIEW public.v_reporte_interaccion
 AS
 SELECT nombres,
    apellidos,
    ( SELECT count(*) AS count
           FROM membresia_grupo mg
          WHERE mg.correo_electronico::text = p.correo_electronico::text) AS grupos_unidos,
    ( SELECT count(*) AS count
           FROM asistencia_evento ae
          WHERE ae.correo_electronico::text = p.correo_electronico::text) AS eventos_asistidos,
    ( SELECT count(*) AS count
           FROM participante_proyecto pp
          WHERE pp.correo_electronico::text = p.correo_electronico::text) AS proyectos_participados,
    (( SELECT count(*) AS count
           FROM membresia_grupo mg
          WHERE mg.correo_electronico::text = p.correo_electronico::text)) + (( SELECT count(*) AS count
           FROM asistencia_evento ae
          WHERE ae.correo_electronico::text = p.correo_electronico::text)) + (( SELECT count(*) AS count
           FROM participante_proyecto pp
          WHERE pp.correo_electronico::text = p.correo_electronico::text)) AS nivel_participacion_total
   FROM persona p
  ORDER BY ((( SELECT count(*) AS count
           FROM membresia_grupo mg
          WHERE mg.correo_electronico::text = p.correo_electronico::text)) + (( SELECT count(*) AS count
           FROM asistencia_evento ae
          WHERE ae.correo_electronico::text = p.correo_electronico::text)) + (( SELECT count(*) AS count
           FROM participante_proyecto pp
          WHERE pp.correo_electronico::text = p.correo_electronico::text))) DESC;

ALTER TABLE public.v_reporte_interaccion
    OWNER TO postgres;

-- View: public.v_reporte_oportunidades

-- DROP VIEW public.v_reporte_oportunidades;

CREATE OR REPLACE VIEW public.v_reporte_oportunidades
 AS
 SELECT o.titulo_oferta,
    o.razon_social_organizacion,
    o.tipo_oferta,
    count(po.correo_electronico) AS cantidad_postulaciones,
        CASE
            WHEN o.fecha_cierre < CURRENT_DATE THEN 'Cerrada'::text
            ELSE 'Abierta'::text
        END AS estatus
   FROM oferta o
     LEFT JOIN postulacion_oferta po ON o.titulo_oferta::text = po.titulo_oferta::text AND o.razon_social_organizacion::text = po.razon_social_organizacion::text
  GROUP BY o.titulo_oferta, o.razon_social_organizacion, o.tipo_oferta, o.fecha_cierre
  ORDER BY (count(po.correo_electronico)) DESC;

ALTER TABLE public.v_reporte_oportunidades
    OWNER TO postgres;

-- View: public.v_reporte_puntos

-- DROP VIEW public.v_reporte_puntos;

CREATE OR REPLACE VIEW public.v_reporte_puntos
 AS
 SELECT p.nombres,
    p.apellidos,
    COALESCE(sum(t.puntos_otorgados), 0::bigint) AS total_puntos,
        CASE
            WHEN COALESCE(sum(t.puntos_otorgados), 0::bigint) > 1000 THEN 'Diamante'::text
            WHEN COALESCE(sum(t.puntos_otorgados), 0::bigint) >= 500 AND COALESCE(sum(t.puntos_otorgados), 0::bigint) <= 1000 THEN 'Oro'::text
            WHEN COALESCE(sum(t.puntos_otorgados), 0::bigint) >= 100 AND COALESCE(sum(t.puntos_otorgados), 0::bigint) <= 499 THEN 'Plata'::text
            ELSE 'Bronce'::text
        END AS nivel_alcanzado,
    rank() OVER (ORDER BY (COALESCE(sum(t.puntos_otorgados), 0::bigint)) DESC) AS ranking_global
   FROM persona p
     LEFT JOIN transaccion_puntos_ucab t ON t.correo_persona::text = p.correo_electronico::text
  GROUP BY p.correo_electronico, p.nombres, p.apellidos;

ALTER TABLE public.v_reporte_puntos
    OWNER TO postgres;

-- View: public.v_reporte_ranking_puntos

-- DROP VIEW public.v_reporte_ranking_puntos;

CREATE OR REPLACE VIEW public.v_reporte_ranking_puntos
 AS
 SELECT p.nombres,
    p.apellidos,
    sum(t.puntos_otorgados) AS total_puntos,
    rank() OVER (ORDER BY (sum(t.puntos_otorgados)) DESC) AS ranking
   FROM transaccion_puntos_ucab t
     JOIN persona p ON t.correo_persona::text = p.correo_electronico::text
  GROUP BY p.correo_electronico, p.nombres, p.apellidos;

ALTER TABLE public.v_reporte_ranking_puntos
    OWNER TO postgres;

-- View: public.v_reporte_tutorias

-- DROP VIEW public.v_reporte_tutorias;

CREATE OR REPLACE VIEW public.v_reporte_tutorias
 AS
 SELECT (p.nombres::text || ' '::text) || p.apellidos::text AS nombre_tutor,
    t.area_conocimiento,
    count(*) AS total_tutorias_impartidas,
    sum(
        CASE
            WHEN t.estado_tutoria::text = 'finalizada'::text THEN 1
            ELSE 0
        END) AS completadas,
    avg(COALESCE(t.calificacion_tutor, 0)) AS calificacion_promedio
   FROM tutoria t
     JOIN persona p ON t.correo_tutor::text = p.correo_electronico::text
  GROUP BY p.nombres, p.apellidos, t.area_conocimiento
  ORDER BY (avg(COALESCE(t.calificacion_tutor, 0))) DESC;

ALTER TABLE public.v_reporte_tutorias
    OWNER TO postgres;

