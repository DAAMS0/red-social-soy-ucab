CREATE OR REPLACE FUNCTION fn_validar_colision_evento() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Evento
        WHERE lugar = NEW.lugar AND nombre_evento <> NEW.nombre_evento 
        AND (NEW.fecha_inicio, NEW.fecha_fin) OVERLAPS (fecha_inicio, fecha_fin)
    ) THEN
        RAISE EXCEPTION 'Conflicto de agenda: Lugar ocupado en ese horario.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_validar_colision BEFORE INSERT OR UPDATE ON Evento FOR EACH ROW EXECUTE FUNCTION fn_validar_colision_evento();

-- 3.2 Trigger: Asignar Puntos por Asistencia
CREATE OR REPLACE FUNCTION fn_asignar_puntos_evento() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fue_presente = TRUE AND (OLD.fue_presente = FALSE OR OLD.fue_presente IS NULL) THEN
        INSERT INTO Transaccion_Puntos_UCAB (correo_persona, fecha_hora_transaccion, tipo_actividad, puntos_otorgados, descripcion_actividad) 
        VALUES (NEW.correo_electronico, NOW(), 'ASISTENCIA_EVENTO', 10, 'Asistencia a: ' || NEW.nombre_evento);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_asignar_puntos AFTER UPDATE ON Asistencia_Evento FOR EACH ROW EXECUTE FUNCTION fn_asignar_puntos_evento();

-- 3.3 Trigger: Validación Completa de Postulación (FALTABA: Validar ROL de usuario)
CREATE OR REPLACE FUNCTION fn_validar_postulacion() RETURNS TRIGGER AS $$
BEGIN
    -- 1. Validar que la oferta esté activa
    IF EXISTS (SELECT 1 FROM Oferta WHERE titulo_oferta = NEW.titulo_oferta AND razon_social_organizacion = NEW.razon_social_organizacion AND fecha_cierre < CURRENT_DATE) THEN
         RAISE EXCEPTION 'La oferta ha cerrado.';
    END IF;
    -- 2. Validar que sea Estudiante o Egresado (NUEVO)
    IF NOT EXISTS (SELECT 1 FROM Estudiante WHERE correo_electronico = NEW.correo_electronico) 
       AND NOT EXISTS (SELECT 1 FROM Egresado WHERE correo_electronico = NEW.correo_electronico) THEN
        RAISE EXCEPTION 'Solo estudiantes o egresados pueden postularse.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_validar_postulacion BEFORE INSERT ON Postulacion_Oferta FOR EACH ROW EXECUTE FUNCTION fn_validar_postulacion();

-- 3.4 Trigger: Encuesta Anónima (FALTABA)
CREATE OR REPLACE FUNCTION fn_validar_encuesta_anonima() RETURNS TRIGGER AS $$
DECLARE v_anonima BOOLEAN;
BEGIN
    SELECT es_anonima INTO v_anonima FROM Encuesta_Institucional 
    WHERE titulo_encuesta = NEW.titulo_encuesta AND fecha_creacion = NEW.fecha_creacion_encuesta;
    
    IF v_anonima = TRUE AND NEW.correo_electronico IS NOT NULL THEN
        RAISE EXCEPTION 'Encuesta anónima no debe tener correo electrónico.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_validar_encuesta_anonima BEFORE INSERT ON Respuesta_Encuesta FOR EACH ROW EXECUTE FUNCTION fn_validar_encuesta_anonima();

-- 3.5 Trigger: No Auto-Recomendación (FALTABA)
CREATE OR REPLACE FUNCTION fn_validar_recomendacion() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.correo_recomendador = NEW.correo_recomendado THEN
        RAISE EXCEPTION 'No se permite la auto-recomendación de habilidades.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_validar_recomendacion BEFORE INSERT OR UPDATE ON Recomendacion_Habilidad FOR EACH ROW EXECUTE FUNCTION fn_validar_recomendacion();

-- 3.6 Trigger: No Auto-Tutoría (FALTABA)
CREATE OR REPLACE FUNCTION fn_validar_tutoria() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.correo_tutor = NEW.correo_tutorado THEN
        RAISE EXCEPTION 'Una persona no puede ser tutor de sí misma.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER trg_validar_tutoria BEFORE INSERT OR UPDATE ON Tutoria FOR EACH ROW EXECUTE FUNCTION fn_validar_tutoria();

