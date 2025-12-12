-- PROCEDURE: public.sp_inscribir_evento(character varying, character varying, date)

-- DROP PROCEDURE IF EXISTS public.sp_inscribir_evento(character varying, character varying, date);

CREATE OR REPLACE PROCEDURE public.sp_inscribir_evento(
	IN p_correo character varying,
	IN p_nombre_evento character varying,
	IN p_fecha_inicio date)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    v_cupo_max INTEGER;
    v_inscritos INTEGER;
BEGIN
    SELECT cupo_maximo INTO v_cupo_max FROM Evento 
    WHERE nombre_evento = p_nombre_evento AND fecha_inicio = p_fecha_inicio;
    
    SELECT COUNT(*) INTO v_inscritos FROM Asistencia_Evento 
    WHERE nombre_evento = p_nombre_evento AND fecha_inicio = p_fecha_inicio;

    IF v_inscritos >= v_cupo_max THEN
        RAISE EXCEPTION 'El evento ha alcanzado su cupo máximo.';
    END IF;

    INSERT INTO Asistencia_Evento (
        correo_electronico, nombre_evento, fecha_inicio, fecha_registro, tipo_participacion, fue_presente
    ) VALUES (
        p_correo, p_nombre_evento, p_fecha_inicio, NOW(), 'ASISTENTE', FALSE
    );
END;
$BODY$;
ALTER PROCEDURE public.sp_inscribir_evento(character varying, character varying, date)
    OWNER TO postgres;
-- PROCEDURE: public.sp_registrar_postulacion(character varying, character varying, character varying, character varying)

-- DROP PROCEDURE IF EXISTS public.sp_registrar_postulacion(character varying, character varying, character varying, character varying);

CREATE OR REPLACE PROCEDURE public.sp_registrar_postulacion(
	IN p_correo character varying,
	IN p_titulo_oferta character varying,
	IN p_razon_social character varying,
	IN p_mensaje_motivacion character varying)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Oferta 
        WHERE titulo_oferta = p_titulo_oferta 
        AND razon_social_organizacion = p_razon_social
        AND fecha_cierre >= CURRENT_DATE
    ) THEN
        RAISE EXCEPTION 'La oferta no existe o ya ha cerrado.';
    END IF;

    INSERT INTO Postulacion_Oferta (
        correo_electronico, titulo_oferta, razon_social_organizacion, 
        fecha_postulacion, estado_postulacion, mensaje_motivacion
    ) VALUES (
        p_correo, p_titulo_oferta, p_razon_social, 
        CURRENT_DATE, 'enviada', p_mensaje_motivacion
    );
END;
$BODY$;
ALTER PROCEDURE public.sp_registrar_postulacion(character varying, character varying, character varying, character varying)
    OWNER TO postgres;
-- PROCEDURE: public.sp_registrar_puntos(character varying, character varying, integer, character varying, character varying)

-- DROP PROCEDURE IF EXISTS public.sp_registrar_puntos(character varying, character varying, integer, character varying, character varying);

CREATE OR REPLACE PROCEDURE public.sp_registrar_puntos(
	IN p_correo character varying,
	IN p_tipo_actividad character varying,
	IN p_puntos integer,
	IN p_descripcion character varying,
	IN p_fuente character varying)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Persona WHERE correo_electronico = p_correo) THEN
        RAISE EXCEPTION 'El usuario % no existe.', p_correo;
    END IF;
    IF p_puntos < 0 THEN
        RAISE EXCEPTION 'No se pueden otorgar puntos negativos.';
    END IF;
    INSERT INTO Transaccion_Puntos_UCAB (
        correo_persona, fecha_hora_transaccion, tipo_actividad, 
        puntos_otorgados, descripcion_actividad, fuente_origen, es_ajuste
    ) VALUES (
        p_correo, NOW(), p_tipo_actividad, 
        p_puntos, p_descripcion, p_fuente, FALSE
    );
END;
$BODY$;
ALTER PROCEDURE public.sp_registrar_puntos(character varying, character varying, integer, character varying, character varying)
    OWNER TO postgres;
-- PROCEDURE: public.sp_registrar_tutoria(character varying, character varying, character varying, character varying)

-- DROP PROCEDURE IF EXISTS public.sp_registrar_tutoria(character varying, character varying, character varying, character varying);

CREATE OR REPLACE PROCEDURE public.sp_registrar_tutoria(
	IN p_tutor character varying,
	IN p_tutorado character varying,
	IN p_area character varying,
	IN p_modalidad character varying)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Tutoria 
        WHERE correo_tutor = p_tutor AND correo_tutorado = p_tutorado 
        AND area_conocimiento = p_area AND estado_tutoria = 'activa'
    ) THEN
        RAISE EXCEPTION 'Ya existe una tutoría activa entre estas personas para esa área.';
    END IF;

    INSERT INTO Tutoria (
        correo_tutor, correo_tutorado, area_conocimiento, 
        fecha_inicio, modalidad, estado_tutoria
    ) VALUES (
        p_tutor, p_tutorado, p_area, 
        CURRENT_DATE, p_modalidad, 'activa'
    );
END;
$BODY$;
ALTER PROCEDURE public.sp_registrar_tutoria(character varying, character varying, character varying, character varying)
    OWNER TO postgres;
