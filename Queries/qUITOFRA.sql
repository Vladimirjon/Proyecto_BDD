create database Terminal_Quito COLLATE Modern_Spanish_CI_AS;

use Terminal_Quito



CREATE TABLE ViajeInformacion_Quito (
    cod_viaje      INT IDENTITY(1,1) NOT NULL,
    cod_conductor  INT,
    cod_vehiculo   INT,
    cod_terminal   INT,
    
    ciudad_destino VARCHAR(100),
    precio_viaje   DECIMAL(10,2),
    CONSTRAINT PK_ViajeInformacion_Quito PRIMARY KEY (cod_viaje, cod_terminal)
);

SET IDENTITY_INSERT ViajeInformacion_Quito ON;

INSERT INTO ViajeInformacion_Quito (cod_viaje, cod_conductor, cod_vehiculo, cod_terminal, ciudad_destino, precio_viaje)
SELECT v.cod_viaje, v.cod_conductor, v.cod_vehiculo, v.cod_terminal, v.ciudad_destino, v.precio_viaje
FROM Terminal.dbo.VIAJE v
JOIN TERMINAL t ON v.cod_terminal = t.cod_terminal
WHERE t.ciudad_terminal = 'Quito';

SET IDENTITY_INSERT ViajeInformacion_Quito OFF;



select * from ViajeInformacion_Quito


CREATE TABLE ViajeTiempo (
    cod_viaje   INT    PRIMARY KEY,
    hora_viaje  TIME,
    fecha_viaje DATE
);

INSERT INTO ViajeTiempo
SELECT v.cod_viaje, v.hora_viaje, v.fecha_viaje
FROM Terminal.dbo.VIAJE v
JOIN TERMINAL t ON v.cod_terminal = t.cod_terminal

select * from ViajeTiempo


CREATE TABLE PasajerosInformacion_Quito (
    cod_pasajero      INT IDENTITY(1,1) PRIMARY KEY,
    cod_viaje         INT,
    nombre_pasajero   VARCHAR(100),
    apellido_pasajero VARCHAR(100),
    cedula_pasajero   VARCHAR(20)
);


SET IDENTITY_INSERT PasajerosInformacion_Quito ON;

INSERT INTO PasajerosInformacion_Quito (cod_pasajero, cod_viaje, nombre_pasajero, apellido_pasajero, cedula_pasajero)
SELECT p.cod_pasajero, p.cod_viaje, p.nombre_pasajero, p.apellido_pasajero, p.cedula_pasajero
FROM Terminal.dbo.PASAJEROS p
JOIN Terminal.dbo.VIAJE v ON p.cod_viaje = v.cod_viaje
WHERE v.cod_terminal = 1;

SET IDENTITY_INSERT PasajerosInformacion_Quito OFF;


select * from PasajerosInformacion_Quito


-- 2.4 PasajerosContacto_Quito
CREATE TABLE PasajerosContacto (
    cod_pasajero       INT    PRIMARY KEY,
    telefono_pasajero  VARCHAR(20),
    correo_pasajero    VARCHAR(100)
);

INSERT INTO dbo.PasajerosContacto (cod_pasajero, telefono_pasajero, correo_pasajero)
SELECT 
    p.cod_pasajero,
    p.telefono_pasajero,
    p.correo_pasajero
FROM Terminal.dbo.PASAJEROS AS p
JOIN Terminal.dbo.VIAJE      AS v 
  ON p.cod_viaje = v.cod_viaje
WHERE v.cod_terminal IN (1, 2);
GO

select * from PasajerosContacto


CREATE TABLE Vehiculo_Quito (
    cod_vehiculo       INT,
    cod_terminal       INT,
    placa_vehiculo     VARCHAR(10),
    capacidad_vehiculo INT,
    compañia_vehiculo  VARCHAR(100),
    CONSTRAINT PK_Vehiculo_Quito PRIMARY KEY (cod_vehiculo, cod_terminal)
);

INSERT INTO Vehiculo_Quito
SELECT v.cod_vehiculo, v.cod_terminal, v.placa_vehiculo, v.capacidad_vehiculo, v.compañia_vehiculo
FROM Terminal.dbo.VEHICULO v
JOIN TERMINAL t ON v.cod_terminal = t.cod_terminal
WHERE t.ciudad_terminal = 'Quito';

select * from Vehiculo_Quito

CREATE TABLE Conductor_Quito (
    cod_conductor      INT,
    cod_terminal       INT,
    nombre_conductor   VARCHAR(100),
    apellido_conductor VARCHAR(100),
    licencia_conductor VARCHAR(20),
    CONSTRAINT PK_Conductor_Quito PRIMARY KEY (cod_conductor, cod_terminal)
);

INSERT INTO Conductor_Quito
SELECT DISTINCT c.cod_conductor, v.cod_terminal, c.nombre_conductor, c.apellido_conductor, c.licencia_conductor
FROM Terminal.dbo.CONDUCTOR c
JOIN Terminal.dbo.VIAJE v ON c.cod_conductor = v.cod_conductor
JOIN TERMINAL t  ON v.cod_terminal = t.cod_terminal
WHERE t.ciudad_terminal = 'Quito';

select * from Conductor_Quito


use Terminal
select * from VIAJE


