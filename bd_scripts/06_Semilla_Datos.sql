
-- TABLA: Dependencia
INSERT INTO Dependencia VALUES ('Gryffindor', 'Académica', 'Casa de los valientes', 'mcgonagall@hogwarts.edu');
INSERT INTO Dependencia VALUES ('Mantenimiento', 'Administrativa', 'Cuidado del castillo', 'filch@hogwarts.edu');

-- TABLA: Organizacion_Asociada
INSERT INTO Organizacion_Asociada VALUES ('Ministerio de Magia', 'M-0001', 'Gobierno', 'UK', 'Londres');
INSERT INTO Organizacion_Asociada VALUES ('Gringotts', 'G-0002', 'Banca', 'UK', 'Callejon Diagon');

-- TABLA: Habilidad
INSERT INTO Habilidad VALUES ('Defensa Contra Artes Oscuras', 'Técnica', 'Combate mágico');
INSERT INTO Habilidad VALUES ('Quidditch', 'Deportiva', 'Vuelo en escoba');

-- TABLA: Evento
INSERT INTO Evento VALUES ('Baile de Navidad', '2025-12-25 20:00:00', '2025-12-26 02:00:00', 'Fiesta', 'Presencial', 'Gala anual', 'Gran Comedor', 500, 'publicado');

-- TABLA: Encuesta_Institucional
INSERT INTO Encuesta_Institucional VALUES ('Evaluación Profesores', CURRENT_DATE, TRUE, 'activa');

-- TABLA: Certificacion_Digital
INSERT INTO Certificacion_Digital VALUES ('TIMO en Pociones', 'Hogwarts', 'Examen', '2024-06-01', '2099-01-01', 'activo');

-- TABLA: Mapa_Egresados (Datos para el mapa de calor)
INSERT INTO Mapa_Egresados VALUES ('Europa Mágica', 1500);

-- TABLA: Persona (Creamos 4 actores principales)
INSERT INTO Persona VALUES ('harry@hogwarts.edu', 'V', 'H001', 'Harry', 'Potter', '1980-07-31', 'UK', 'Surrey', '1991-09-01');
INSERT INTO Persona VALUES ('snape@hogwarts.edu', 'V', 'S001', 'Severus', 'Snape', '1960-01-09', 'UK', 'Cokeworth', '1980-09-01');
INSERT INTO Persona VALUES ('lucius@malfoy.com', 'V', 'M001', 'Lucius', 'Malfoy', '1954-01-01', 'UK', 'Wiltshire', '1970-09-01');
INSERT INTO Persona VALUES ('filch@hogwarts.edu', 'V', 'F001', 'Argus', 'Filch', '1950-01-01', 'UK', 'Castillo', '1975-01-01');

-- TABLA: Estudiante (Harry)
INSERT INTO Estudiante VALUES ('harry@hogwarts.edu', '1991-09-01', 'Gryffindor', 'Auror');

-- TABLA: Profesor (Snape)
INSERT INTO Profesor VALUES ('snape@hogwarts.edu', 'Jefe de Casa', 'Gryffindor'); -- (Aunque es Slytherin, asignamos a dependencia existente)

-- TABLA: Egresado (Lucius)
INSERT INTO Egresado VALUES ('lucius@malfoy.com', 'Mortífago', 'Gryffindor', 1970);

-- TABLA: Personal_Administrativo (Filch)
INSERT INTO Personal_Administrativo VALUES ('filch@hogwarts.edu', 'Celador', 'Mantenimiento');

-- TABLA: Grupo
INSERT INTO Grupo VALUES ('Ejército de Dumbledore', 'Defensa práctica', 'Estudiantil', CURRENT_DATE, 'harry@hogwarts.edu');

-- TABLA: Capitulo_Regional
INSERT INTO Capitulo_Regional VALUES ('Alumni Mortífagos', 'Wiltshire', '1980-01-01', 'activo', 'Gryffindor');

-- TABLA: Proyecto_Colaborativo
INSERT INTO Proyecto_Colaborativo VALUES ('Búsqueda Horrocruxes', 'harry@hogwarts.edu', 'Destruir a Voldemort', 'Salvar mundo', 'en curso', CURRENT_DATE, 0.00, 'privado');

-- TABLA: Oferta
INSERT INTO Oferta VALUES ('Caza-Recompensas', 'Ministerio de Magia', 'Empleo', CURRENT_DATE, CURRENT_DATE + 30);

-- TABLA: Configuracion_Privacidad
INSERT INTO Configuracion_Privacidad VALUES ('harry@hogwarts.edu', 'Ubicación', 'solo_yo');

-- TABLA: Transaccion_Puntos_UCAB (Puntos para Gryffindor)
INSERT INTO Transaccion_Puntos_UCAB (correo_persona, fecha_hora_transaccion, tipo_actividad, puntos_otorgados, descripcion_actividad)
VALUES ('harry@hogwarts.edu', NOW(), 'Hazaña', 50, 'Vencer al Basilisco');

-- TABLA: Respuesta_Encuesta
INSERT INTO Respuesta_Encuesta (titulo_encuesta, fecha_creacion_encuesta, correo_electronico, respuestas_json) 
VALUES ('Evaluación Profesores', CURRENT_DATE, NULL, '{"Snape": "Malo"}'); -- Es anónima, correo NULL

-- TABLA: Membresia_Grupo (Harry se une al ED)
INSERT INTO Membresia_Grupo VALUES ('harry@hogwarts.edu', 'Ejército de Dumbledore', 'Líder', CURRENT_DATE, NULL, 'activo');

-- TABLA: Membresia_Capitulo (Lucius se une al capítulo)
INSERT INTO Membresia_Capitulo VALUES ('lucius@malfoy.com', 'Alumni Mortífagos', '2000-01-01', 'Líder', 'activo');

-- TABLA: Asistencia_Evento (Harry va al baile)
INSERT INTO Asistencia_Evento VALUES ('harry@hogwarts.edu', 'Baile de Navidad', '2025-12-25 20:00:00', NOW(), FALSE);

-- TABLA: Tutoria (Snape enseña a Harry)
INSERT INTO Tutoria VALUES ('snape@hogwarts.edu', 'harry@hogwarts.edu', 'Defensa Contra Artes Oscuras', CURRENT_DATE, 'activa', NULL);

-- TABLA: Habilidad_Persona (Harry sabe Quidditch)
INSERT INTO Habilidad_Persona VALUES ('harry@hogwarts.edu', 'Quidditch', 'Buscador');

-- TABLA: Recomendacion_Habilidad (Snape valida a Harry - raro pero sirve de prueba)
INSERT INTO Recomendacion_Habilidad VALUES ('snape@hogwarts.edu', 'harry@hogwarts.edu', 'Quidditch', 'Bueno', 'Lo vi volar', CURRENT_DATE, 'publico');

-- TABLA: Postulacion_Oferta (Harry busca trabajo)
INSERT INTO Postulacion_Oferta VALUES ('harry@hogwarts.edu', 'Caza-Recompensas', 'Ministerio de Magia', CURRENT_DATE, 'Soy el elegido');

-- TABLA: Participante_Proyecto (Harry en su propio proyecto)
INSERT INTO Participante_Proyecto VALUES ('harry@hogwarts.edu', 'Búsqueda Horrocruxes', 'harry@hogwarts.edu', 'Líder', CURRENT_DATE, 'activo');

