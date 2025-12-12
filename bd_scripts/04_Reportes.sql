-- Reporte Crecimiento (Kelly)
CREATE OR REPLACE VIEW V_REPORTE_CRECIMIENTO AS
SELECT TO_CHAR(fecha_registro, 'YYYY-MM') as mes, tipo_usuario, COUNT(*) as total 
FROM MIEMBRO GROUP BY 1, 2;

-- Reporte Tutorías (Edwin)
CREATE OR REPLACE VIEW V_REPORTE_TUTORIAS AS
SELECT p.nombres, t.area_conocimiento, COUNT(*) as cantidad, AVG(t.valoracion_tutor) as calificacion
FROM TUTORIA t JOIN PERSONA p ON t.correo_tutor = p.correo_principal GROUP BY 1, 2;

-- Reporte Ofertas (Edwin)
CREATE OR REPLACE VIEW V_REPORTE_OPORTUNIDADES AS
SELECT o.titulo, e.nombre_oficial, COUNT(p.clave_postulacion) as postulantes
FROM OFERTA o JOIN ENTIDAD e ON o.correo_publicador = e.correo_principal 
LEFT JOIN POSTULACION_OFERTA p ON o.clave_oferta = p.fk_oferta GROUP BY 1, 2;

-- Reporte Eventos (Kelly)
CREATE OR REPLACE VIEW V_REPORTE_EVENTOS AS
SELECT e.titulo, e.fecha_inicio, COUNT(ae.correo_asistente) as inscritos
FROM EVENTO e LEFT JOIN ASISTENCIA_EVENTO ae ON e.clave_evento = ae.fk_evento GROUP BY 1, 2;

-- Reporte Puntos (Edwin)
CREATE OR REPLACE VIEW V_REPORTE_PUNTOS AS
SELECT p.nombres, SUM(tr.puntos_otorgados) as total_puntos
FROM TRANSACCION_PUNTOS_UCAB tr JOIN PERSONA p ON tr.correo_usuario = p.correo_principal GROUP BY 1;