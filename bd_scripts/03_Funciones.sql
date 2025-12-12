-- FUNCTION: public.fn_es_miembro_grupo(character varying, character varying)

-- DROP FUNCTION IF EXISTS public.fn_es_miembro_grupo(character varying, character varying);

CREATE OR REPLACE FUNCTION public.fn_es_miembro_grupo(
	p_correo character varying,
	p_nombre_grupo character varying)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Membresia_Grupo
        WHERE correo_electronico = p_correo 
        AND nombre_grupo = p_nombre_grupo
        AND estado_membresia = 'activo'
        AND (fecha_salida IS NULL OR fecha_salida > CURRENT_DATE)
    ) THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
$BODY$;

ALTER FUNCTION public.fn_es_miembro_grupo(character varying, character varying)
    OWNER TO postgres;

-- FUNCTION: public.fn_calcular_promedio_valoracion_tutor(character varying)

-- DROP FUNCTION IF EXISTS public.fn_calcular_promedio_valoracion_tutor(character varying);

CREATE OR REPLACE FUNCTION public.fn_calcular_promedio_valoracion_tutor(
	p_correo_tutor character varying)
    RETURNS numeric
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    v_promedio NUMERIC(3,2);
BEGIN
    SELECT AVG(calificacion_tutor) INTO v_promedio
    FROM Tutoria
    WHERE correo_tutor = p_correo_tutor
    AND estado_tutoria = 'finalizada';
    
    RETURN COALESCE(v_promedio, 0.00);
END;
$BODY$;

ALTER FUNCTION public.fn_calcular_promedio_valoracion_tutor(character varying)
    OWNER TO postgres;

