CREATE OR REPLACE FUNCTION fn_es_miembro_grupo(p_correo VARCHAR, p_grupo VARCHAR) RETURNS INTEGER AS $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM Membresia_Grupo WHERE correo_electronico = p_correo AND nombre_grupo = p_grupo AND estado_membresia = 'activo') THEN RETURN 1; ELSE RETURN 0; END IF; 
END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_calcular_promedio_valoracion_tutor(p_correo VARCHAR) RETURNS NUMERIC AS $$ 
DECLARE v_promedio NUMERIC; 
BEGIN 
    SELECT AVG(calificacion_tutor) INTO v_promedio FROM Tutoria WHERE correo_tutor = p_correo AND estado_tutoria = 'finalizada'; 
    RETURN COALESCE(v_promedio, 0.0); 
END; 
$$ LANGUAGE plpgsql;

-- 3.8 PROCEDIMIENTOS ALMACENADOS
CREATE OR REPLACE PROCEDURE sp_inscribir_evento(p_correo VARCHAR, p_evento VARCHAR, p_fecha TIMESTAMP) LANGUAGE plpgsql AS $$ 
DECLARE v_cupo INT; v_ins INT; 
BEGIN 
    SELECT cupo_maximo INTO v_cupo FROM Evento WHERE nombre_evento = p_evento AND fecha_inicio = p_fecha; 
    SELECT COUNT(*) INTO v_ins FROM Asistencia_Evento WHERE nombre_evento = p_evento AND fecha_inicio = p_fecha; 
    IF v_ins >= v_cupo THEN RAISE EXCEPTION 'Cupo lleno'; END IF; 
    INSERT INTO Asistencia_Evento (correo_electronico, nombre_evento, fecha_inicio, fue_presente) VALUES (p_correo, p_evento, p_fecha, FALSE); 
END; 
$$;
