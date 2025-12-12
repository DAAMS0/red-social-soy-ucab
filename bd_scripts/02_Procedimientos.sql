CREATE OR REPLACE PROCEDURE sp_inscribir_evento(p_correo VARCHAR, p_evento VARCHAR, p_fecha TIMESTAMP) LANGUAGE plpgsql AS $$ 
DECLARE v_cupo INT; v_ins INT; 
BEGIN 
    SELECT cupo_maximo INTO v_cupo FROM Evento WHERE nombre_evento = p_evento AND fecha_inicio = p_fecha; 
    SELECT COUNT(*) INTO v_ins FROM Asistencia_Evento WHERE nombre_evento = p_evento AND fecha_inicio = p_fecha; 
    IF v_ins >= v_cupo THEN RAISE EXCEPTION 'Cupo lleno'; END IF; 
    INSERT INTO Asistencia_Evento (correo_electronico, nombre_evento, fecha_inicio, fue_presente) VALUES (p_correo, p_evento, p_fecha, FALSE); 
END; 
$$;


CREATE OR REPLACE PROCEDURE sp_registrar_postulacion(p_correo VARCHAR, p_oferta VARCHAR, p_org VARCHAR, p_msj VARCHAR) LANGUAGE plpgsql AS $$ 
BEGIN 
    INSERT INTO Postulacion_Oferta (correo_electronico, titulo_oferta, razon_social_organizacion, fecha_postulacion, mensaje_motivacion) 
    VALUES (p_correo, p_oferta, p_org, CURRENT_DATE, p_msj); 
END; 
$$;

CREATE OR REPLACE PROCEDURE sp_registrar_tutoria(p_tutor VARCHAR, p_tutorado VARCHAR, p_area VARCHAR, p_mod VARCHAR) LANGUAGE plpgsql AS $$ 
BEGIN 
    INSERT INTO Tutoria (correo_tutor, correo_tutorado, area_conocimiento, fecha_inicio, estado_tutoria) 
    VALUES (p_tutor, p_tutorado, p_area, CURRENT_DATE, 'activa'); 
END; 
$$;

CREATE OR REPLACE PROCEDURE sp_registrar_puntos(p_correo VARCHAR, p_actividad VARCHAR, p_puntos INT) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Transaccion_Puntos_UCAB (correo_persona, fecha_hora_transaccion, tipo_actividad, puntos_otorgados, descripcion_actividad)
    VALUES (p_correo, NOW(), p_actividad, p_puntos, 'Asignación manual de administrador');
END;
$$;