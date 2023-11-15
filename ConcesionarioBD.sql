---BASE DE DATOS PARA CONCESIONARIO

DROP TYPE IF EXISTS cargo_type;
CREATE TYPE cargo_type AS ENUM ('GERENTE', 'JEFE DE TALLER', 'ASESOR COMERCIAL');

DROP TABLE IF EXISTS Empleado cascade;
CREATE TABLE Empleado (
    id_empleado INT NOT NULL,
    nombre VARCHAR NOT NULL,
    apellido VARCHAR NOT NULL,
    direccion VARCHAR NOT NULL,
    fecha_inicio DATE,
    salario DECIMAL(12, 2),
    cargo cargo_type NOT NULL,
    
    CONSTRAINT Empleado_pk PRIMARY KEY (id_empleado)
);

DROP TABLE IF EXISTS Sucursal cascade;
CREATE TABLE Sucursal(
	
	cod_sucursal INT NOT NULL,
	nombre VARCHAR NOT NULL,
	direccion VARCHAR NOT NULL,
	ciudad VARCHAR NOT NULL,
	
	CONSTRAINT cod_sucursal_pk PRIMARY KEY (cod_sucursal)
	
);

DROP TABLE IF EXISTS Usuario cascade;
CREATE TABLE Usuario (
	
	id_usuario VARCHAR NOT NULL,
	id_empleado INT NOT NULL,
	contrasena VARCHAR(255) NOT NULL,
	
	CONSTRAINT Usuario_pk PRIMARY KEY (id_usuario),
    CONSTRAINT Usuario_fk_empleado FOREIGN KEY (id_empleado) REFERENCES Empleado (id_empleado)
	
);

DROP TABLE IF EXISTS asesorComercial cascade;
CREATE TABLE asesorComercial(
	
	id_asesor INT NOT NULL,
	correo VARCHAR NOT NULL,
	telefono VARCHAR NOT NULL,
	cod_sucursal INT NOT NULL,
	id_usuario VARCHAR NOT NULL,
	CONSTRAINT asesorComercial_pk PRIMARY KEY (id_asesor),
	CONSTRAINT asesorComercial_fk FOREIGN KEY (id_asesor) REFERENCES Empleado (id_empleado),
	CONSTRAINT asesorComercial_fk2 FOREIGN KEY (cod_sucursal) REFERENCES Sucursal (cod_sucursal),
	CONSTRAINT asesorComercial_fk3 FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario)
);

DROP TABLE IF EXISTS Cliente cascade;
CREATE TABLE Cliente (
	nombre VARCHAR NOT NULL,
	apellido VARCHAR NOT NULL,
	telefono VARCHAR NOT NULL,
	correo VARCHAR NOT NULL,
	direccion VARCHAR NOT NULL,
	id_cliente INT NOT NULL,
	
	CONSTRAINT Cliente_pk PRIMARY KEY (id_cliente)
); 

DROP TABLE IF EXISTS vehiculoCliente cascade;
CREATE TABLE vehiculoCliente(
	marca VARCHAR NOT NULL,
	modelo VARCHAR NOT NULL,
	anio INT NOT NULL,
	color VARCHAR NOT NULL,
	placa VARCHAR NOT NULL,
	VIN VARCHAR NOT NULL,
	tipo_combustible VARCHAR NOT NULL,
	id_cliente INT NOT NULL,
	
	CONSTRAINT vehiculoCliente_pk PRIMARY KEY (placa),
	CONSTRAINT vehiculoCliente_fk FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente)
	
);

DROP TABLE IF EXISTS jefeTaller cascade;
CREATE TABLE jefeTaller(

	id_jefetaller INT NOT NULL,
	correo VARCHAR NOT NULL,
	telefono VARCHAR NOT NULL,
	cod_sucursal INT NOT NULL,
	id_usuario VARCHAR NOT NULL,
	
	CONSTRAINT jefeTaller_pk PRIMARY KEY(id_jefetaller),
	CONSTRAINT jefeTaller_fk1 FOREIGN KEY (cod_sucursal) REFERENCES Sucursal (cod_sucursal),
	CONSTRAINT jefeTaller_fk2 FOREIGN KEY (id_jefetaller) REFERENCES Empleado (id_empleado),
	CONSTRAINT jefeTaller_fk3 FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario)

);

DROP TABLE IF EXISTS ordenReparacion cascade;
CREATE TABLE ordenReparacion(
	numero_orden INT NOT NULL,
	id_cliente INT NOT NULL,
	placa VARCHAR NOT NULL,
	descripcion VARCHAR NOT NULL,
	id_jefetaller INT NOT NULL,
	precio DECIMAL(12, 2) NOT NULL,
	fecha_inicio DATE NOT NULL,
	fecha_entrega DATE,
	
	CONSTRAINT ordenReparacion_pk PRIMARY KEY(numero_orden, id_cliente, placa, id_jefetaller),
	CONSTRAINT ordenReparacion_fk1 FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente),
	CONSTRAINT ordenReparacion_fk2 FOREIGN KEY (placa) REFERENCES vehiculoCliente (placa),
	CONSTRAINT ordenReparacion_fk3 FOREIGN KEY (id_jefetaller) REFERENCES jefeTaller (id_jefetaller)
	
);

DROP TABLE IF EXISTS Gerente cascade;
CREATE TABLE Gerente(
	
	id_gerente INT NOT NULL,
	correo VARCHAR NOT NULL,
	telefono VARCHAR NOT NULL,
	cod_sucursal INT NOT NULL,
	id_usuario VARCHAR NOT NULL,
	
	CONSTRAINT Gerente_pk PRIMARY KEY (id_gerente),
	CONSTRAINT Gerente_fk FOREIGN KEY (id_gerente) REFERENCES Empleado (id_empleado),
	CONSTRAINT Gerente_fk2 FOREIGN KEY (cod_sucursal) REFERENCES Sucursal (cod_sucursal),
	CONSTRAINT Gerente_fk3 FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario)
);

DROP TABLE IF EXISTS Repuestos cascade;
CREATE TABLE Repuestos (
	
	referencia_repuesto VARCHAR NOT NULL,
	cantidad INT NOT NULL,
	precioUnitario DECIMAL(12, 2) NOT NULL,
	descripcion VARCHAR NOT NULL,
	cod_sucursal INT NOT NULL,
	
	CONSTRAINT Repuestos_pk PRIMARY KEY (referencia_repuesto),
	CONSTRAINT Repuestos_fk FOREIGN KEY (cod_sucursal) REFERENCES Sucursal (cod_sucursal)
	
); 

DROP TABLE IF EXISTS vehiculoNuevo cascade;
CREATE TABLE vehiculoNuevo (
	
	VIN VARCHAR NOT NULL,
	color VARCHAR NOT NULL,
	marca VARCHAR NOT NULL,
	modelo VARCHAR NOT NULL,
	anio INT NOT NULL,
	linea VARCHAR NOT NULL,
	precio DECIMAL(12, 2)  NOT NULL,
	descuento INT NOT NULL,
	cod_sucursal INT NOT NULL,
	
	CONSTRAINT vehiculoNuevo_pk PRIMARY KEY (VIN),
	CONSTRAINT vehiculoNuevo_fk FOREIGN KEY (cod_sucursal) REFERENCES Sucursal (cod_sucursal)

);

---CREATE SEQUENCE numero_cotizacion;

DROP TABLE IF EXISTS Cotizacion cascade;
CREATE TABLE Cotizacion (
	
	id_cotizacion SERIAL PRIMARY KEY,
	fecha_cotizacion DATE,
	id_cliente INT NOT NULL,
	referencia_repuesto VARCHAR,
	VIN VARCHAR,
	cod_sucursal INT NOT NULL,
	descripcion VARCHAR NOT NULL,
	
	CONSTRAINT Cotizacion_fk1 FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente),
	CONSTRAINT Cotizacion_fk2 FOREIGN KEY (referencia_repuesto) REFERENCES Repuestos (referencia_repuesto),
	CONSTRAINT Cotizacion_fk3 FOREIGN KEY (VIN) REFERENCES vehiculoNuevo (VIN),
	CONSTRAINT Cotizacion_fk4 FOREIGN KEY (cod_sucursal) REFERENCES Sucursal (cod_sucursal)
	
);

DROP TABLE IF EXISTS Accesorios cascade;
CREATE TABLE Accesorios (
    id_accesorio INT NOT NULL,
    nombre VARCHAR NOT NULL,
    descripcion VARCHAR,

    CONSTRAINT Accesorios_pk PRIMARY KEY (id_accesorio)
);

DROP TABLE IF EXISTS Cotizacion_Accesorios cascade;
CREATE TABLE Cotizacion_Accesorios (
    id_cotizacion INT NOT NULL,
    id_accesorio INT NOT NULL,

    CONSTRAINT Cotizacion_Accesorios_pk PRIMARY KEY (id_cotizacion, id_accesorio),
    CONSTRAINT Cotizacion_Accesorios_fk1 FOREIGN KEY (id_cotizacion) REFERENCES Cotizacion (id_cotizacion),
    CONSTRAINT Cotizacion_Accesorios_fk2 FOREIGN KEY (id_accesorio) REFERENCES Accesorios (id_accesorio)
);


--------- INSERTANDO DATOS ---------

INSERT INTO Empleado (id_empleado, nombre, apellido, direccion, fecha_inicio, salario, cargo) 
VALUES (1, 'Juan', 'Perez', 'Calle 1', '2020-01-01', 1500000, 'JEFE DE TALLER'), 
       (2, 'Maria', 'Garcia', 'Calle 2', '2020-02-01', 1500000, 'JEFE DE TALLER'),
	   (3, 'Carlos', 'Rodriguez', 'Calle 3', '2020-03-01', 1500000, 'JEFE DE TALLER'),
	   (4, 'Carlos', 'Rodriguez', 'Calle 4', '2020-04-01', 1500000, 'JEFE DE TALLER'), 
	   (5, 'Ana', 'Lopez', 'Calle 5', '2020-05-01', 1500000, 'JEFE DE TALLER'), 
	   (6, 'Fernando', 'Morales', 'Calle 6', '2020-06-01', 1500000, 'JEFE DE TALLER'), 
	   (7, 'Patricia', 'Rojas', 'Calle 7', '2020-07-01', 1500000, 'JEFE DE TALLER'), 
	   (8, 'Ricardo', 'Alvarez', 'Calle 8', '2020-08-01', 1500000, 'JEFE DE TALLER'), 
	   (9, 'Carmen', 'Ramirez', 'Calle 9', '2020-09-01', 1500000, 'JEFE DE TALLER'), 
	   (10, 'Manuel', 'Torres', 'Calle 10', '2020-10-01', 1500000, 'JEFE DE TALLER'), 
       (11, 'Teresa', 'Castro', 'Calle 11', '2020-11-01', 1500000, 'JEFE DE TALLER'), 
	   (12, 'Jorge', 'Gutierrez', 'Calle 12', '2020-12-01', 1500000, 'JEFE DE TALLER'), 
	   (13, 'Sara', 'Romero', 'Calle 13', '2021-01-01', 1500000, 'JEFE DE TALLER'), 
	   (14, 'Eduardo', 'Navarro', 'Calle 14', '2021-02-01', 1500000, 'JEFE DE TALLER'), 
	   (15, 'Pedro', 'Gomez', 'Calle 15', '2020-01-15', 1500000, 'JEFE DE TALLER'), 
	   (16, 'Laura', 'Martinez', 'Calle 16', '2020-02-15', 900000, 'ASESOR COMERCIAL'), 
	   (17, 'Daniel', 'Torres', 'Calle 17', '2020-03-15', 900000, 'ASESOR COMERCIAL'), 
	   (18, 'Sofia', 'Castro', 'Calle 18', '2020-04-15', 900000, 'ASESOR COMERCIAL'), 
	   (19, 'Luis', 'Gutierrez', 'Calle 19', '2020-05-15', 900000, 'ASESOR COMERCIAL'), 
       (20, 'Andrea', 'Navarro', 'Calle 20', '2020-06-15', 900000, 'ASESOR COMERCIAL'), 
       (21, 'David', 'Rojas', 'Calle 21', '2020-07-15', 900000, 'ASESOR COMERCIAL'), 
       (22, 'Patricia', 'Alvarez', 'Calle 22', '2020-08-15', 900000, 'ASESOR COMERCIAL'), 
       (23, 'Ricardo', 'Morales', 'Calle 23', '2020-09-15', 900000, 'ASESOR COMERCIAL'), 
       (24, 'Carmen', 'Ramirez', 'Calle 24', '2020-10-15', 900000, 'ASESOR COMERCIAL'), 
       (25, 'Manuel', 'Ortiz', 'Calle 25', '2020-11-15', 900000, 'ASESOR COMERCIAL'), 
       (26, 'Teresa', 'Perez', 'Calle 26', '2020-12-15', 900000, 'ASESOR COMERCIAL'), 
       (27, 'Jorge', 'Garcia', 'Calle 27', '2021-01-15', 900000, 'ASESOR COMERCIAL'), 
       (28, 'Sara', 'Rodriguez', 'Calle 28', '2021-02-15', 900000, 'ASESOR COMERCIAL'), 
       (29, 'Eduardo', 'Lopez', 'Calle 29', '2021-03-15', 900000, 'ASESOR COMERCIAL'), 
	   (30, 'Camila', 'Sanchez', 'Calle 30', '2020-01-30', 900000, 'ASESOR COMERCIAL'), 
	   (31, 'Andres', 'Lopez', 'Calle 31', '2020-01-01', 10000000, 'GERENTE'), 
	   (32, 'Sofia', 'Gutierrez', 'Calle 32', '2020-02-01', 10000000, 'GERENTE'), 
	   (33, 'Miguel', 'Torres', 'Calle 33', '2020-03-01', 10000000, 'GERENTE');

INSERT INTO Usuario (id_usuario, id_empleado, contrasena) 
VALUES ('usuario1', 1, '123abc'), 
	   ('usuario2', 2, '123abc'), 
	   ('usuario3', 3, '123abc'), 
	   ('usuario4', 4, '123abc'), 
	   ('usuario5', 5, '123abc'), 
	   ('usuario6', 6, '123abc'), 
	   ('usuario7', 7, '123abc'), 
	   ('usuario8', 8, '123abc'), 
	   ('usuario9', 9, '123abc'), 
	   ('usuario10', 10, '123abc'), 
	   ('usuario11', 11, '123abc'), 
	   ('usuario12', 12, '123abc'), 
	   ('usuario13', 13, '123abc'), 
	   ('usuario14', 14, '123abc'), 
	   ('usuario15', 15, '123abc'), 
	   ('usuario16', 16, '123abc'), 
	   ('usuario17', 17, '123abc'), 
	   ('usuario18', 18, '123abc'), 
	   ('usuario19', 19, '123abc'), 
	   ('usuario20', 20, '123abc'), 
	   ('usuario21', 21, '123abc'), 
	   ('usuario22', 22, '123abc'), 
	   ('usuario23', 23, '123abc'), 
	   ('usuario24', 24, '123abc'), 
	   ('usuario25', 25, '123abc'), 
	   ('usuario26', 26, '123abc'), 
	   ('usuario27', 27, '123abc'), 
	   ('usuario28', 28, '123abc'), 
	   ('usuario29', 29, '123abc'), 
	   ('usuario30', 30, '123abc'), 
	   ('usuario31', 31, '123abc'), 
	   ('usuario32', 32, '123abc'), 
	   ('usuario33', 33, '123abc');

INSERT INTO Sucursal (cod_sucursal, nombre, direccion, ciudad) 
VALUES (1, 'Sucursal Cali', 'Calle 10', 'Cali'), 
       (2, 'Sucursal Bogota', 'Calle 15', 'Bogota'), 
	   (3, 'Sucursal Medellin', 'Calle 20', 'Medellin');

INSERT INTO jefeTaller (id_jefetaller, correo, telefono, cod_sucursal, id_usuario) 
VALUES (1, 'jefeTaller01@gmail.com', '3123365', 1, 'usuario1'),
	   (2, 'jefeTaller02@gmail.com', '3123366', 2, 'usuario2'), 
	   (3, 'jefeTaller03@gmail.com', '3123367', 3, 'usuario3'), 
	   (4, 'jefeTaller04@gmail.com', '3123368', 1, 'usuario4'), 
	   (5, 'jefeTaller05@gmail.com', '3123369', 2, 'usuario5'), 
	   (6, 'jefeTaller06@gmail.com', '3123370', 3, 'usuario6'), 
	   (7, 'jefeTaller07@gmail.com', '3123371', 1, 'usuario7'), 
	   (8, 'jefeTaller08@gmail.com', '3123372', 2, 'usuario8'), 
       (9, 'jefeTaller09@gmail.com', '3123373', 3, 'usuario9'), 
	   (10, 'jefeTaller10@gmail.com', '3123374', 1, 'usuario10'), 
	   (11, 'jefeTaller11@gmail.com', '3123375', 2, 'usuario11'), 
	   (12, 'jefeTaller12@gmail.com', '3123376', 3, 'usuario12'), 
	   (13, 'jefeTaller13@gmail.com', '3123377', 1, 'usuario13'), 
	   (14, 'jefeTaller14@gmail.com', '3123378', 2, 'usuario14'), 
	   (15, 'jefeTaller15@gmail.com', '8812328', 3, 'usuario15');

INSERT INTO asesorComercial (id_asesor, correo, telefono, cod_sucursal, id_usuario) 
VALUES (16, 'asesor01@gmail.com', '31245671',1, 'usuario16'),
	   (17, 'asesor02@gmail.com', '31245672', 2, 'usuario17'), 
	   (18, 'asesor03@gmail.com', '31245673', 3, 'usuario18'), 
	   (19, 'asesor04@gmail.com', '31245674', 1, 'usuario19'), 
	   (20, 'asesor05@gmail.com', '31245675', 2, 'usuario20'), 
	   (21, 'asesor06@gmail.com', '31245676', 3, 'usuario21'), 
	   (22, 'asesor07@gmail.com', '31245677', 1, 'usuario22'), 
	   (23, 'asesor08@gmail.com', '31245678', 2, 'usuario23'), 
	   (24, 'asesor09@gmail.com', '31245679', 3, 'usuario24'), 
	   (25, 'asesor10@gmail.com', '31245680', 1, 'usuario25'), 
	   (26, 'asesor11@gmail.com', '31245681', 2, 'usuario26'), 
	   (27, 'asesor12@gmail.com', '31245682', 3, 'usuario27'), 
	   (28, 'asesor13@gmail.com', '31245683', 1, 'usuario28'), 
	   (29, 'asesor14@gmail.com', '31245684', 2, 'usuario29'), 
	   (30, 'asesor15@gmail.com', '8812408', 3, 'usuario30');

INSERT INTO Gerente (id_gerente, correo, telefono, cod_sucursal, id_usuario) 
VALUES (31, 'gerente01@gmail.com', '3123456', 1, 'usuario31'),
	   (32, 'gerente02@gmail.com', '3123457', 2, 'usuario32'), 
	   (33, 'gerente03@gmail.com', '3123458', 3, 'usuario33'); 
INSERT INTO Cliente (nombre, apellido, telefono, correo, direccion, id_cliente) 
VALUES ('Cliente 1', 'Apellido 1', '3001111111', 'cliente1@mail.com', 'Direccion 1', 1), 
	   ('Cliente 2', 'Apellido 2', '3001111112', 'cliente2@mail.com', 'Direccion 2', 2), 
       ('Cliente 3', 'Apellido 3', '3001111113', 'cliente3@mail.com', 'Direccion 3', 3), 
       ('Cliente 4', 'Apellido 4', '3001111114', 'cliente4@mail.com', 'Direccion 4', 4), 
       ('Cliente 5', 'Apellido 5', '3001111115', 'cliente5@mail.com', 'Direccion 5', 5), 
       ('Cliente 6', 'Apellido 6', '3001111116', 'cliente6@mail.com', 'Direccion 6', 6), 
       ('Cliente 7', 'Apellido 7', '3001111117', 'cliente7@mail.com', 'Direccion 7', 7), 
       ('Cliente 8', 'Apellido 8', '3001111118', 'cliente8@mail.com', 'Direccion 8', 8), 
       ('Cliente 9', 'Apellido 9', '3001111119', 'cliente9@mail.com', 'Direccion 9', 9), 
       ('Cliente 10', 'Apellido 10', '3001111120', 'cliente10@mail.com', 'Direccion 10', 10), 
       ('Cliente 11', 'Apellido 11', '3001111121', 'cliente11@mail.com', 'Direccion 11', 11), 
       ('Cliente 12', 'Apellido 12', '3001111122', 'cliente12@mail.com', 'Direccion 12', 12), 
       ('Cliente 13', 'Apellido 13', '3001111123', 'cliente13@mail.com', 'Direccion 13', 13), 
       ('Cliente 14', 'Apellido 14', '3001111124', 'cliente14@mail.com', 'Direccion 14', 14), 
       ('Cliente 15', 'Apellido 15', '3001111125', 'cliente15@mail.com', 'Direccion 15', 15), 
       ('Cliente 16', 'Apellido 16', '3001111126', 'cliente16@mail.com', 'Direccion 16', 16), 
       ('Cliente 17', 'Apellido 17', '3001111127', 'cliente17@mail.com', 'Direccion 17', 17), 
       ('Cliente 18', 'Apellido 18', '3001111128', 'cliente18@mail.com', 'Direccion 18', 18), 
       ('Cliente 19', 'Apellido 19', '3001111129', 'cliente19@mail.com', 'Direccion 19', 19), 
	   ('Cliente 20', 'Apellido 20', '3001120000', 'cliente20@mail.com', 'Direccion 20', 20);

INSERT INTO vehiculoCliente (marca, modelo, anio, color, placa, VIN, tipo_combustible, id_cliente) 
VALUES ('Mercedes-Benz', 'Clase C', 2020, 'Blanco', 'AAA111', 'WDD111111000000000', 'Gasolina', 1), 
       ('Mercedes-Benz', 'Clase E', 2022, 'Negro', 'BBB222', 'WDD222222000000000', 'Diesel', 2),
       ('Mercedes-Benz', 'Clase A', 2021, 'Rojo', 'CCC333', 'WDD333333000000001', 'Gasolina', 3), 
       ('Mercedes-Benz', 'Clase B', 2020, 'Azul', 'DDD444', 'WDD444444000000002', 'Diesel', 4), 
       ('Mercedes-Benz', 'Clase C', 2021, 'Verde', 'EEE555', 'WDD555555000000003', 'Gasolina', 5), 
       ('Mercedes-Benz', 'Clase E', 2022, 'Negro', 'FFF666', 'WDD666666000000004', 'Diesel', 6), 
       ('Mercedes-Benz', 'Clase S', 2021, 'Gris', 'GGG777', 'WDD777777000000005', 'Hibrido', 7), 
       ('Mercedes-Benz', 'GLA', 2020, 'Blanco', 'HHH888', 'WDD888888000000006', 'Gasolina', 8), 
       ('Mercedes-Benz', 'GLB', 2022, 'Negro', 'III999', 'WDD999999000000007', 'Diesel', 9), 
       ('Mercedes-Benz', 'GLC', 2021, 'Gris', 'JJJ1010', 'WDD101010100000008', 'Hibrido', 10), 
       ('Mercedes-Benz', 'GLE', 2020, 'Blanco', 'KKK1111', 'WDD111111100000009', 'Gas', 11),
	   ('Mercedes-Benz', 'GLS', 2022, 'Negro', 'LLL1212', 'WDD121212120000010', 'Diesel', 12), 
       ('Mercedes-Benz', 'Clase A', 2021, 'Rojo', 'MMM1313', 'WDD131313130000011', 'Gasolina', 13), 
       ('Mercedes-Benz', 'Clase B', 2020, 'Azul', 'NNN1414', 'WDD141414140000012', 'Diesel', 14), 
       ('Mercedes-Benz', 'Clase C', 2021, 'Verde', 'OOO1515', 'WDD151515150000013', 'Gasolina', 15), 
       ('Mercedes-Benz', 'Clase E', 2022, 'Negro', 'PPP1616', 'WDD161616160000014', 'Diesel', 16), 
       ('Mercedes-Benz', 'Clase S', 2021, 'Gris', 'QQQ1717', 'WDD171717170000015', 'Hibrido', 17), 
       ('Mercedes-Benz', 'GLA', 2020, 'Blanco', 'RRR1818', 'WDD181818180000016', 'Gasolina', 18), 
       ('Mercedes-Benz', 'GLB', 2022, 'Negro', 'SSS1919', 'WDD191919190000017', 'Diesel', 19), 
	   ('Mercedes-Benz', 'Clase S', 2021, 'Gris', 'BBB333', 'WDD333333330000000', 'Hibrido', 20);

INSERT INTO ordenReparacion (numero_orden, id_cliente, placa, descripcion, id_jefetaller, precio, fecha_inicio, fecha_entrega) 
VALUES (1, 1, 'AAA111', 'Cambio de aceite', 1, 150000, '2023-01-01', NULL), 
       (2, 5, 'EEE555', 'Reparación de motor', 3, 500000, '2023-01-10', NULL),
       (3, 6, 'FFF666', 'Cambio de frenos', 2, 200000, '2023-01-15', '2023-01-20'), 
       (4, 7, 'GGG777', 'Revisión general', 4, 100000, '2023-01-20', NULL), 
       (5, 8, 'HHH888', 'Cambio de aceite', 1, 150000, '2023-01-25', NULL), 
       (6, 9, 'III999', 'Reparación de motor', 3, 500000, '2023-01-30', '2023-02-28'), 
       (7, 10, 'MMM1313', 'Cambio de frenos', 2, 200000, '2023-02-01', NULL), 
       (8, 11, 'KKK1111', 'Revisión general', 4, 100000, '2023-04-02', '2023-04-07'),
	   (9, 12, 'LLL1212', 'Cambio de aceite', 1, 150000, '2023-02-05', NULL), 
       (10, 13, 'MMM1313', 'Reparación de motor', 3, 500000, '2023-02-10', NULL),
	   (15, 10, 'RRR1818', 'Cambio de llantas', 7, 300000, '2023-02-12', '2023-02-15');

INSERT INTO Repuestos (referencia_repuesto, cantidad, precioUnitario, descripcion, cod_sucursal) 
VALUES ('REP001', 10, 50000, 'Bujias', 1), 
       ('REP002', 5, 200000, 'Amortiguadores', 1),
       ('REP003', 7, 100000, 'Frenos', 2), 
	   ('REP004', 8, 150000, 'Aceite', 3), 
	   ('REP005', 10, 50000, 'Filtros', 1), 
	   ('REP006', 6, 300000, 'Batería', 2), 
	   ('REP007', 4, 250000, 'Luces', 3), 
	   ('REP008', 9, 40000, 'Escobillas', 1), 
	   ('REP009', 3, 60000, 'Radiador', 2), 
	   ('REP010', 2, 70000, 'Alternador', 3), 
	   ('REP011', 5, 80000, 'Bomba de agua', 1), 
	   ('REP012', 7, 90000, 'Correa', 2), 
	   ('REP013', 6, 100000, 'Embrague', 3), 
	   ('REP014', 4, 110000, 'Inyectores', 1), 
	   ('REP015', 3, 120000, 'Radiador', 2),
	   ('REP016', 8, 130000, 'Catalizador', 3), 
       ('REP017', 7, 140000, 'Turbo', 1), 
	   ('REP018', 6, 150000, 'Distribuidor', 2), 
	   ('REP019', 5, 160000, 'Bomba de gasolina', 3), 
	   ('REP020', 4, 170000, 'Sensor de oxígeno', 1),
	   ('REP021', 4, 400000, 'Motor 600 hp', 1),
	   ('REP022', 12, 800000, 'Llantas', 1);

INSERT INTO vehiculoNuevo (VIN, color, marca, modelo, anio, linea, precio, descuento, cod_sucursal)
VALUES ('WDD111111111111111', 'Blanco', 'Mercedes-Benz', 'Clase A', 2022, 'Compacto', 400000000, 5, 1), 
       ('WDD222222222222222', 'Negro', 'Mercedes-Benz', 'Clase B', 2022, 'Compacto', 600000000, 5, 1),  
	   ('WDD333333333333333', 'Rojo', 'Mercedes-Benz', 'Clase C', 2022, 'Sedán', 700000000, 7, 2), 
 	   ('WDD444444444444444', 'Azul', 'Mercedes-Benz', 'Clase E', 2022, 'Sedán', 800000000, 8, 3), 
	   ('WDD555555555555555', 'Verde', 'Mercedes-Benz', 'Clase S', 2022, 'Sedán', 900000000, 9, 1), 
	   ('WDD666666666666666', 'Amarillo', 'Mercedes-Benz', 'GLB', 2022, 'SUV', 1000000000, 10, 2), 
	   ('WDD777777777777777', 'Negro', 'Mercedes-Benz', 'GLC', 2022, 'SUV', 1100000000, 11, 3), 
	   ('WDD888888888888888', 'Blanco', 'Mercedes-Benz', 'GLE', 2022, 'SUV', 1200000000, 12, 1), 
	   ('WDD999999999999999', 'Gris', 'Mercedes-Benz', 'GLS', 2022, 'SUV', 1300000000, 13, 2), 
	   ('WDD000000000000000', 'Rojo', 'Mercedes-Benz', 'Clase A', 2023, 'Compacto', 1400000000, 14, 3), 
	   ('WDD111111111111112', 'Azul', 'Mercedes-Benz', 'Clase B', 2023, 'Compacto', 1500000000, 15, 1), 
	   ('WDD222222222222223', 'Verde', 'Mercedes-Benz', 'GLA', 2023, 'SUV', 1600000000, 16, 2),
	   ('WDD101010101010101', 'Gris', 'Mercedes-Benz', 'GLA', 2022, 'SUV', 800000000, 10, 3);

INSERT INTO Accesorios (id_accesorio, nombre, descripcion) 
VALUES (1, 'Sistema de navegación GPS', 'Sistema de navegación por satélite integrado en el tablero'),
       (2, 'Sistema de sonido premium', 'Sistema de audio surround Bose o Harman Kardon'), 
	   (3, 'Techo solar', 'Techo de cristal corredizo eléctrico'), 
	   (4, 'Ruedas de aleación', 'Juego de ruedas de aleación deportivas'), 
	   (5, 'Paquete de seguridad avanzada', 'Incluye control de crucero adaptativo, alerta de colisión frontal, etc'), 
	   (6, 'Paquete de asistencia al conductor', 'Incluye alerta de cambio de carril, asistente de estacionamiento, etc');

INSERT INTO Cotizacion (id_cotizacion, fecha_cotizacion, id_cliente, referencia_repuesto, VIN, cod_sucursal, descripcion) 
VALUES (1, '2023-02-01', 1, NULL, 'WDD333333333333333', 1, 'Cotización para vehículo nuevo Clase C'), 
       (2, '2023-02-02', 5, 'REP021', NULL, 2, 'Cotización para cambio de motor'), 
	   (3, '2023-02-02', 5, 'REP021', NULL, 2, 'Cotización para cambio de motor'), 
	   (4, '2023-02-03', 8, 'REP008', NULL, 3, 'Cotización para compra de Escobillas'), 
	   (5, '2023-02-04', 2, NULL, 'WDD444444444444444', 1, 'Cotización para vehículo nuevo Clase E'), 
	   (6, '2023-02-05', 6, 'REP003', NULL, 2, 'Cotización para cambio de frenos'), 
	   (7, '2023-02-06', 9, 'REP006', NULL, 3, 'Cotización para compra de batería'), 
	   (8, '2023-02-07', 3, NULL, 'WDD555555555555555', 1, 'Cotización para vehículo nuevo Clase S'), 
	   (9, '2023-02-08', 7, 'REP004', NULL, 2, 'Cotización para cambio de aceite'), 
	   (10, '2023-02-09', 4, 'REP007', NULL, 3, 'Cotización para compra de luces'), 
	   (11, '2023-02-10', 1, NULL, 'WDD222222222222223', 1, 'Cotización para vehículo nuevo GLA'),
	   (12, '2023-02-03', 8, 'REP008', NULL, 3, 'Cotización para compra de Escobillas'), 
	   (13, '2023-02-15', 10, 'REP022', NULL, 1, 'Cotización para compra de llantas');

INSERT INTO Cotizacion_Accesorios (id_cotizacion, id_accesorio) 
VALUES (1, 1), 
       (5, 4), 
	   (8, 5),
	   (11, 2);


