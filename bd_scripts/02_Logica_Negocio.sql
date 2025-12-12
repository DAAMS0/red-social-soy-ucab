-- Procedimiento Registrar Postulación (Kelly)
CREATE OR REPLACE PROCEDURE registrar_postulacion(p_correo VARCHAR, p_id_oferta INTEGER)
LANGUAGE plpgsql AS $$
DECLARE v_estado VARCHAR;
BEGIN
    SELECT estado INTO v_estado FROM OFERTA WHERE clave_oferta = p_id_oferta;
    IF v_estado <> 'Activa' THEN RAISE EXCEPTION 'Oferta no activa'; END IF;
    INSERT INTO POSTULACION_OFERTA (fk_oferta, correo_postulante) VALUES (p_id_oferta, p_correo);
END; $$;

-- Función Miembro Grupo (Kelly)
CREATE OR REPLACE FUNCTION es_miembro_grupo(p_correo VARCHAR, p_id_grupo INTEGER)
RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
    RETURN EXISTS (SELECT 1 FROM MEMBRESIA_GRUPO WHERE correo_miembro = p_correo AND fk_grupo = p_id_grupo);
END; $$;

-- Función Promedio Tutor (Edwin)
CREATE OR REPLACE FUNCTION calcular_promedio_valoracion_tutor(p_correo VARCHAR)
RETURNS DECIMAL LANGUAGE plpgsql AS $$
DECLARE v_prom DECIMAL;
BEGIN
    SELECT AVG(valoracion_tutor) INTO v_prom FROM TUTORIA WHERE correo_tutor = p_correo;
    RETURN COALESCE(v_prom, 0);
END; $$;