INSERT INTO MIEMBRO VALUES ('kelly@ucab.edu.ve', '123', NOW(), NULL, 'Persona');
INSERT INTO MIEMBRO VALUES ('edwin@ucab.edu.ve', '123', NOW(), NULL, 'Persona');
INSERT INTO MIEMBRO VALUES ('polar@empresas.com', '123', NOW(), NULL, 'Organizacion Asociada');

INSERT INTO PERSONA VALUES ('kelly@ucab.edu.ve', 'Kelly', 'Apolinar', 'V-12345', '2000-01-01', 'Caracas', 'Venezuela');
INSERT INTO PERSONA VALUES ('edwin@ucab.edu.ve', 'Edwin', 'Li', 'V-67890', '2000-01-01', 'Valencia', 'Venezuela');

INSERT INTO ENTIDAD VALUES ('polar@empresas.com', 'Empresas Polar', 'Organizacion Asociada');

INSERT INTO TUTORIA (correo_tutor, correo_tutorado, area_conocimiento, valoracion_tutor) 
VALUES ('edwin@ucab.edu.ve', 'kelly@ucab.edu.ve', 'Programacion', 5);

INSERT INTO OFERTA (titulo, correo_publicador) VALUES ('Desarrollador Junior', 'polar@empresas.com');
INSERT INTO POSTULACION_OFERTA (fk_oferta, correo_postulante) VALUES (1, 'kelly@ucab.edu.ve');

INSERT INTO EVENTO (titulo, fecha_inicio, fecha_fin, lugar) 
VALUES ('Feria UCAB', NOW(), NOW(), 'Aula Magna');