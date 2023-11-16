---BASE DE DATOS PARA PROYECTO DE DS I

DROP TABLE IF EXISTS Empleado cascade;
CREATE TABLE Empleado (
	id_empleado CHAR(10) NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	correo VARCHAR(50) NOT NULL,
	fecha_inicio DATE,
	
	CONSTRAINT Empleado_pk PRIMARY KEY (id_empleado)
);

DROP TABLE IF EXISTS asesorComercial cascade;
CREATE TABLE asesorComercial(
	
	id_asesor CHAR(10) NOT NULL,
	salario VARCHAR(10) NOT NULL,
	
	CONSTRAINT asesorComercial_pk PRIMARY KEY (id_asesor),
	CONSTRAINT asesorComercial_fk FOREIGN KEY (id_asesor)
		REFERENCES Empleado (id_empleado)
);

DROP TABLE IF EXISTS Cliente cascade;
CREATE TABLE Cliente (
	nombre VARCHAR(200) NOT NULL,
	telefono CHAR(10) NOT NULL,
	correo VARCHAR(250) NOT NULL,
	direccion VARCHAR(200) NOT NULL,
	id_cliente VARCHAR(20) NOT NULL,
	
	CONSTRAINT Cliente_pk PRIMARY KEY (id_cliente)
	
);

DROP TABLE IF EXISTS vehiculoCliente cascade;
CREATE TABLE vehiculoCliente(
	modelo CHAR(4) NOT NULL,
	color VARCHAR(15) NOT NULL,
	placa CHAR(6) NOT NULL,
	VIN CHAR(12) NOT NULL,
	id_cliente VARCHAR(20) NOT NULL,
	
	CONSTRAINT vehiculoCliente_pk PRIMARY KEY (placa),
	CONSTRAINT vehiculoCliente_fk FOREIGN KEY (id_cliente)
		REFERENCES Cliente (id_cliente)
	
);

DROP TABLE IF EXISTS Sucursal cascade;
CREATE TABLE Sucursal(
	
	cod_sucursal CHAR(2) NOT NULL,
	nombre VARCHAR(100) NOT NULL,
	direccion VARCHAR(30) NOT NULL,
	ciudad VARCHAR(20) NOT NULL,
	
	CONSTRAINT cod_sucursal_pk PRIMARY KEY (cod_sucursal)
	
);

DROP TABLE IF EXISTS jefeTaller cascade;
CREATE TABLE jefeTaller(
	
	nombre VARCHAR(40) NOT NULL,
	correo VARCHAR(40) NOT NULL,
	telefono CHAR(10) NOT NULL,
	id_jefetaller CHAR(10) NOT NULL,
	cod_sucursal VARCHAR(10) NOT NULL,
	
	CONSTRAINT jefeTaller_pk PRIMARY KEY(id_jefetaller),
	CONSTRAINT jefeTaller_fk1 FOREIGN KEY (cod_sucursal)
		REFERENCES Sucursal (cod_sucursal),
	CONSTRAINT jefeTaller_fk2 FOREIGN KEY (id_jefetaller)
		REFERENCES Empleado (id_empleado)

);

DROP TABLE IF EXISTS ordenReparacion cascade;
CREATE TABLE ordenReparacion(
	numero_orden VARCHAR(10) NOT NULL,
	id_cliente VARCHAR(20) NOT NULL,
	placa CHAR(6) NOT NULL,
	trabajos VARCHAR(700) NOT NULL,
	id_jefetaller CHAR(10) NOT NULL,
	
	CONSTRAINT ordenReparacion_pk PRIMARY KEY(numero_orden,id_cliente,placa,id_jefetaller),
	CONSTRAINT ordenReparacion_fk1 FOREIGN KEY (id_cliente)
		REFERENCES Cliente (id_cliente),
	CONSTRAINT ordenReparacion_fk2 FOREIGN KEY (placa)
		REFERENCES vehiculoCliente (placa),
	CONSTRAINT ordenReparacion_fk3 FOREIGN KEY (id_jefetaller)
		REFERENCES jefeTaller (id_jefetaller)
	
);

DROP TABLE IF EXISTS Gerente cascade;
CREATE TABLE Gerente(
	
	id_gerente CHAR(10) NOT NULL,
	nombre VARCHAR(200) NOT NULL,
	apellidos VARCHAR(200) NOT NULL,
	correo VARCHAR(100) NOT NULL,
	telefono CHAR(10) NOT NULL,
	
	CONSTRAINT Gerente_pk PRIMARY KEY (id_gerente)
);

DROP TABLE IF EXISTS Repuestos cascade;
CREATE TABLE Repuestos (
	
	referencia_repuesto VARCHAR(12) NOT NULL,
	cantidad VARCHAR(8) NOT NULL,
	precioUnitario VARCHAR(8) NOT NULL,
	precioTtotal VARCHAR(100) NOT NULL,
	descripcion VARCHAR(100) NOT NULL,
	cod_sucursal CHAR(2) NOT NULL,
	
	CONSTRAINT Repuestos_pk PRIMARY KEY (referencia_repuesto),
	CONSTRAINT Repuestos_fk FOREIGN KEY (cod_sucursal)
		REFERENCES Sucursal (cod_sucursal)
	
);

DROP TABLE IF EXISTS vehiculoNuevo cascade;
CREATE TABLE vehiculoNuevo (
	
	VIN CHAR(10) NOT NULL,
	color VARCHAR(15) NOT NULL,
	modelo CHAR(4) NOT NULL,
	linea VARCHAR(15) NOT NULL,
	cod_sucursal CHAR(2) NOT NULL,
	
	CONSTRAINT vehiculoNuevo_pk PRIMARY KEY (VIN),
	CONSTRAINT vehiculoNuevo_fk FOREIGN KEY (cod_sucursal)
		REFERENCES Sucursal (cod_sucursal)

);

---CREATE SEQUENCE numero_cotizacion;

DROP TABLE IF EXISTS Cotizacion cascade;
CREATE TABLE Cotizacion (
	
	id_cotizacion SERIAL PRIMARY KEY,
	fecha_cotizacion DATE,
	id_cliente VARCHAR(20) NOT NULL,
	referencia_repuesto VARCHAR(12),
	VIN CHAR(12) NOT NULL,
	cod_sucursal CHAR(2) NOT NULL,
	numero_cotizacion INT,
	descripcion VARCHAR(300) NOT NULL,
	
	CONSTRAINT Cotizacion_fk1 FOREIGN KEY (id_cliente)
		REFERENCES Cliente (id_cliente),
	CONSTRAINT Cotizacion_fk2 FOREIGN KEY (referencia_repuesto)
		REFERENCES Repuestos (referencia_repuesto),
	CONSTRAINT Cotizacion_fk3 FOREIGN KEY (VIN)
		REFERENCES vehiculoNuevo (VIN),
	CONSTRAINT Cotizacion_fk4 FOREIGN KEY (cod_sucursal)
		REFERENCES Sucursal (cod_sucursal)
	
);





