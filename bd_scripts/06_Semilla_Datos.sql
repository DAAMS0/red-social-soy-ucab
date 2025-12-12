===================================================================

-- MAESTRAS
INSERT INTO Dependencia VALUES ('Gryffindor', 'Académica', 'Casa', 'mcgonagall@hogwarts.edu');
INSERT INTO Dependencia VALUES ('Mantenimiento', 'Administrativa', 'Castillo', 'filch@hogwarts.edu');
INSERT INTO Organizacion_Asociada VALUES ('Ministerio de Magia', 'M-001', 'Gobierno', 'UK', 'Londres');
INSERT INTO Organizacion_Asociada VALUES ('Gringotts', 'G-001', 'Banca', 'UK', 'Diagon');
INSERT INTO Habilidad VALUES ('Defensa', 'Técnica', 'Combate'), ('Quidditch', 'Deporte', 'Vuelo');
INSERT INTO Evento VALUES ('Baile Navidad', '2025-12-25 20:00:00', '2025-12-26 02:00:00', 'Fiesta', 'P', 'Gala', 'Gran Comedor', 500, 'publicado');
INSERT INTO Encuesta_Institucional VALUES ('Evaluacion Profes', CURRENT_DATE, TRUE, 'activa');
INSERT INTO Certificacion_Digital VALUES ('TIMO Pociones', 'Hogwarts', 'Examen', '2024-06-01', '2099-01-01', 'activo');
INSERT INTO Mapa_Egresados VALUES ('Europa', 1500);

-- PERSONAS
INSERT INTO Persona VALUES ('harry@hogwarts.edu', 'V', 'H001', 'Harry', 'Potter', '1980-07-31', 'UK', 'Surrey', '1991-09-01');
INSERT INTO Persona VALUES ('snape@hogwarts.edu', 'V', 'S001', 'Severus', 'Snape', '1960-01-09', 'UK', 'Cokeworth', '1980-09-01');
INSERT INTO Persona VALUES ('lucius@malfoy.com', 'V', 'M001', 'Lucius', 'Malfoy', '1954-01-01', 'UK', 'Wiltshire', '1970-09-01');
INSERT INTO Persona VALUES ('filch@hogwarts.edu', 'V', 'F001', 'Argus', 'Filch', '1950-01-01', 'UK', 'Castillo', '1975-01-01');

-- ROLES
INSERT INTO Estudiante VALUES ('harry@hogwarts.edu', '1991-09-01', 'Gryffindor', 'Auror');
INSERT INTO Profesor VALUES ('snape@hogwarts.edu', 'Jefe Casa', 'Gryffindor');
INSERT INTO Egresado VALUES ('lucius@malfoy.com', 'Mortífago', 'Gryffindor', 1970);
INSERT INTO Personal_Administrativo VALUES ('filch@hogwarts.edu', 'Celador', 'Mantenimiento');

-- DEPENDIENTES
INSERT INTO Grupo VALUES ('Ejercito Dumbledore', 'Defensa', 'Estudiantil', CURRENT_DATE, 'harry@hogwarts.edu');
INSERT INTO Capitulo_Regional VALUES ('Alumni Mortifagos', 'Wiltshire', '1980-01-01', 'activo', 'Gryffindor');
INSERT INTO Proyecto_Colaborativo VALUES ('Horrocruxes', 'harry@hogwarts.edu', 'Destruir Voldemort', 'Salvar mundo', 'en curso', CURRENT_DATE, 0, 'privado');
INSERT INTO Oferta VALUES ('Caza-Recompensas', 'Ministerio de Magia', 'Empleo', CURRENT_DATE, CURRENT_DATE + 30);
INSERT INTO Configuracion_Privacidad VALUES ('harry@hogwarts.edu', 'Ubicación', 'solo_yo');
INSERT INTO Transaccion_Puntos_UCAB (correo_persona, fecha_hora_transaccion, tipo_actividad, puntos_otorgados, descripcion_actividad) VALUES ('harry@hogwarts.edu', NOW(), 'Hazaña', 50, 'Basilisco');
INSERT INTO Respuesta_Encuesta VALUES (DEFAULT, 'Evaluacion Profes', CURRENT_DATE, NULL, '{"Nota": 0}'); -- NULL porque es anónima

-- INTERRELACIONES
INSERT INTO Membresia_Grupo VALUES ('harry@hogwarts.edu', 'Ejercito Dumbledore', 'Líder', CURRENT_DATE, NULL, 'activo');
INSERT INTO Membresia_Capitulo VALUES ('lucius@malfoy.com', 'Alumni Mortifagos', '2000-01-01', 'Líder', 'activo');
INSERT INTO Asistencia_Evento VALUES ('harry@hogwarts.edu', 'Baile Navidad', '2025-12-25 20:00:00', NOW(), FALSE);
INSERT INTO Tutoria VALUES ('snape@hogwarts.edu', 'harry@hogwarts.edu', 'Defensa', CURRENT_DATE, 'activa', NULL);
INSERT INTO Habilidad_Persona VALUES ('harry@hogwarts.edu', 'Quidditch', 'Buscador');
INSERT INTO Recomendacion_Habilidad VALUES ('snape@hogwarts.edu', 'harry@hogwarts.edu', 'Quidditch', 'Bueno', 'Visto', CURRENT_DATE, 'publico');
INSERT INTO Postulacion_Oferta VALUES ('harry@hogwarts.edu', 'Caza-Recompensas', 'Ministerio de Magia', CURRENT_DATE, 'Soy el elegido');
INSERT INTO Participante_Proyecto VALUES ('harry@hogwarts.edu', 'Horrocruxes', 'harry@hogwarts.edu', 'Líder', CURRENT_DATE, 'activo');
