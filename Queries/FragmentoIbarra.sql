create database Terminal_Ibarra COLLATE Modern_Spanish_CI_AS;

USE Terminal_Ibarra;
GO

-- 🟨 Fragmentación vertical: ViajeInformación_Ibarra
CREATE TABLE ViajeInformacion_Ibarra (
    cod_viaje      INT IDENTITY(1,1) NOT NULL,
    cod_conductor  INT         NOT NULL,
    cod_vehiculo   INT         NOT NULL,
    cod_terminal   INT         NOT NULL,
    ciudad_destino VARCHAR(100) NOT NULL,
    precio_viaje   DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_ViajeInformacion_Ibarra PRIMARY KEY (cod_viaje, cod_terminal)
);
GO

SET IDENTITY_INSERT ViajeInformacion_Ibarra ON;

INSERT INTO ViajeInformacion_Ibarra (cod_viaje, cod_conductor, cod_vehiculo, cod_terminal, ciudad_destino, precio_viaje)
SELECT v.cod_viaje, v.cod_conductor, v.cod_vehiculo, v.cod_terminal, v.ciudad_destino, v.precio_viaje
FROM [VLADIMIRJON].[Terminal].[dbo].[VIAJE] v
JOIN TERMINAL t ON v.cod_terminal = t.cod_terminal
WHERE t.ciudad_terminal = 'Ibarra';

SET IDENTITY_INSERT ViajeInformacion_Ibarra OFF;

select * from ViajeInformacion_Ibarra


-- 🟧 Fragmentación vertical: PasajerosInformacion_Ibarra
CREATE TABLE PasajerosInformacion_Ibarra (
    cod_pasajero      INT IDENTITY(1,1) NOT NULL,
    cod_viaje         INT         NOT NULL,
    nombre_pasajero   VARCHAR(100) NOT NULL,
    apellido_pasajero VARCHAR(100) NOT NULL,
    cedula_pasajero   VARCHAR(20)  NOT NULL,
    CONSTRAINT PK_Pasajeros_Ibarra PRIMARY KEY (cod_pasajero),
    CONSTRAINT FK_Pasajeros_Viaje_Ibarra FOREIGN KEY (cod_viaje)
        REFERENCES ViajeInformacion_Ibarra(cod_viaje)
);
GO

SET IDENTITY_INSERT PasajerosInformacion_Ibarra ON;

INSERT INTO PasajerosInformacion_Ibarra (cod_pasajero, cod_viaje, nombre_pasajero, apellido_pasajero, cedula_pasajero)
SELECT p.cod_pasajero, p.cod_viaje, p.nombre_pasajero, p.apellido_pasajero, p.cedula_pasajero
FROM [VLADIMIRJON].[Terminal].[dbo].[PASAJEROS] p
JOIN [VLADIMIRJON].[Terminal].[dbo].[VIAJE] v ON p.cod_viaje = v.cod_viaje
WHERE v.cod_terminal = 2;

SET IDENTITY_INSERT PasajerosInformacion_Ibarra OFF;



-- 🟥 Fragmentación horizontal derivada: Vehiculo_Ibarra
CREATE TABLE Vehiculo_Ibarra (
    cod_vehiculo       INT,
    cod_terminal       INT,
    placa_vehiculo     VARCHAR(10),
    capacidad_vehiculo INT,
    compañia_vehiculo  VARCHAR(100),
    CONSTRAINT PK_Vehiculo_Ibarra PRIMARY KEY (cod_vehiculo, cod_terminal)
);
GO

INSERT INTO Vehiculo_Ibarra
SELECT v.cod_vehiculo, v.cod_terminal, v.placa_vehiculo, v.capacidad_vehiculo, v.compañia_vehiculo
FROM [VLADIMIRJON].[Terminal].[dbo].[VEHICULO] v
WHERE v.cod_terminal = 2;
GO


-- 🟪 Fragmentación horizontal derivada: Conductor_Ibarra
CREATE TABLE Conductor_Ibarra (
    cod_conductor      INT,
    cod_terminal       INT,
    nombre_conductor   VARCHAR(100),
    apellido_conductor VARCHAR(100),
    licencia_conductor VARCHAR(20),
    CONSTRAINT PK_Conductor_Ibarra PRIMARY KEY (cod_conductor, cod_terminal)
);
GO

INSERT INTO Conductor_Ibarra
SELECT DISTINCT 
    c.cod_conductor,
    v.cod_terminal,
    c.nombre_conductor,
    c.apellido_conductor,
    c.licencia_conductor
FROM [VLADIMIRJON].[Terminal].[dbo].[CONDUCTOR] c
JOIN [VLADIMIRJON].[Terminal].[dbo].[VIAJE] v ON c.cod_conductor = v.cod_conductor
WHERE v.cod_terminal = 2;
GO

-- 🧾 Consultas para verificar los resultados
SELECT * FROM ViajeInformacion_Ibarra;
SELECT * FROM PasajerosInformacion_Ibarra;
SELECT * FROM Vehiculo_Ibarra;
SELECT * FROM Conductor_Ibarra;


create view Viaje_Ibarra_vista as
select 
    vi.cod_viaje,
    vi.cod_conductor,
    vi.cod_vehiculo,
    vi.cod_terminal,
    vt.fecha_viaje,
    vt.hora_viaje,
    vi.ciudad_destino,
    vi.precio_viaje
FROM [ASUS-8KR2UI2].Terminal_Ibarra.dbo.ViajeInformacion_Ibarra  vi
JOIN [VLADIMIRJON].Terminal_Quito.dbo.ViajeTiempo vt ON vi.cod_viaje = vt.cod_viaje;


create view Pasajero_Ibarra_vista as
select 
    pai.cod_pasajero,
    pai.cod_viaje,
    pai.nombre_pasajero,
    pai.apellido_pasajero,
    pac.telefono_pasajero,
    pai.cedula_pasajero,
    pac.correo_pasajero
from [VLADIMIRJON].Terminal_Quito.dbo.PasajerosContacto pac
JOIN [ASUS-8KR2UI2].Terminal_Ibarra.dbo.PasajerosInformacion_Ibarra pai on pac.cod_pasajero = pai.cod_pasajero

select * from Pasajero_Ibarra_vista
select * from PasajerosInformacion_Ibarra
select * from [VLADIMIRJON].Terminal_Quito.dbo.PasajerosContacto
select * from [VLADIMIRJON].Terminal.dbo.viaje

FROM ViajeInformacion_Quito vi
JOIN ViajeTiempo vt ON vi.cod_viaje = vt.cod_viaje;


-- VIAJE VEHICULO
create view Vehiculo_Ibarra_vista
as select * from Vehiculo_Ibarra

select * from Terminal
select * from Conductor_Ibarra
select * from PasajerosInformacion_Ibarra
select * from Vehiculo_Ibarra
select * from ViajeInformacion_Ibarra