
CREATE VIEW V_Reporte_Crecimiento AS 
SELECT TO_CHAR(fecha_registro, 'YYYY-MM') as periodo, COUNT(*) as nuevos FROM Persona GROUP BY 1;

CREATE VIEW V_Reporte_Interaccion AS 
SELECT nombres, (SELECT COUNT(*) FROM Membresia_Grupo WHERE correo_electronico = p.correo_electronico) + (SELECT COUNT(*) FROM Asistencia_Evento WHERE correo_electronico = p.correo_electronico) as total FROM Persona p;

CREATE VIEW V_Reporte_Grupos AS 
SELECT nombre_grupo, (SELECT COUNT(*) FROM Membresia_Grupo m WHERE m.nombre_grupo = g.nombre_grupo) as miembros FROM Grupo g;

CREATE VIEW V_Reporte_Eventos AS 
SELECT nombre_evento, cupo_maximo, (SELECT COUNT(*) FROM Asistencia_Evento a WHERE a.nombre_evento = e.nombre_evento) as inscritos FROM Evento e;

CREATE VIEW V_Reporte_Egresados AS 
SELECT p.pais_residencia, p.ciudad_residencia, e.escuela_egreso, COUNT(*) as cantidad 
FROM Egresado e JOIN Persona p ON e.correo_electronico = p.correo_electronico 
GROUP BY p.pais_residencia, p.ciudad_residencia, e.escuela_egreso;

CREATE VIEW V_Reporte_Oportunidades AS 
SELECT titulo_oferta, CASE WHEN fecha_cierre < CURRENT_DATE THEN 'Cerrada' ELSE 'Abierta' END as estado, (SELECT COUNT(*) FROM Postulacion_Oferta po WHERE po.titulo_oferta = o.titulo_oferta) as postulaciones FROM Oferta o;

CREATE VIEW V_Reporte_Tutorias AS 
SELECT correo_tutor, AVG(calificacion_tutor) as promedio, COUNT(*) as total FROM Tutoria GROUP BY 1;

CREATE VIEW V_Reporte_Certificaciones AS 
SELECT tipo_certificacion, entidad_emisora, COUNT(*) as total, SUM(CASE WHEN fecha_expiracion < CURRENT_DATE THEN 1 ELSE 0 END) as expiradas FROM Certificacion_Digital GROUP BY 1, 2;

CREATE VIEW V_Reporte_Habilidades AS 
SELECT nombre_habilidad, COUNT(*) as usuarios FROM Habilidad_Persona GROUP BY 1;

CREATE VIEW V_Reporte_Puntos AS 
SELECT correo_persona, SUM(puntos_otorgados) as total FROM Transaccion_Puntos_UCAB GROUP BY 1;