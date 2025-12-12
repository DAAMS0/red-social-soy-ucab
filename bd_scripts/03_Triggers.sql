-- Trigger Validación Eventos (Kelly)
CREATE OR REPLACE FUNCTION fn_check_evento() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM EVENTO WHERE lugar = NEW.lugar AND fecha_inicio = NEW.fecha_inicio) THEN
        RAISE EXCEPTION 'Lugar ocupado en esa fecha';
    END IF;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_evento_lugar BEFORE INSERT ON EVENTO
FOR EACH ROW EXECUTE FUNCTION fn_check_evento();

-- Trigger Puntos por Asistencia (Edwin)
CREATE OR REPLACE FUNCTION fn_puntos_asistencia() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.asistio_realmente = TRUE AND OLD.asistio_realmente = FALSE THEN
        INSERT INTO TRANSACCION_PUNTOS_UCAB (correo_usuario, puntos_otorgados, concepto)
        VALUES (NEW.correo_asistente, 50, 'Asistencia Evento');
    END IF;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_asistencia_puntos AFTER UPDATE ON ASISTENCIA_EVENTO
FOR EACH ROW EXECUTE FUNCTION fn_puntos_asistencia();