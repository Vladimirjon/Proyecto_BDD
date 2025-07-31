USE [Terminal_Ibarra]
GO

/****** Object:  View [dbo].[Conductor_Ibarra_vista]    Script Date: 31/7/2025 9:57:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Conductor_Ibarra_vista]
as select * from Conductor_Ibarra
GO


USE [Terminal_Ibarra]
GO

/****** Object:  View [dbo].[Pasajero_Ibarra_PorViaje]    Script Date: 31/7/2025 9:58:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[Pasajero_Ibarra_PorViaje] AS
SELECT
    cod_pasajero,
    cod_viaje,
    nombre_pasajero,
    apellido_pasajero,
    telefono_pasajero,
	correo_pasajero
FROM Pasajero_Ibarra_vista;
GO

USE [Terminal_Ibarra]
GO

/****** Object:  View [dbo].[Pasajero_Ibarra_vista]    Script Date: 31/7/2025 9:58:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Pasajero_Ibarra_vista] as
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
GO

USE [Terminal_Ibarra]
GO

/****** Object:  View [dbo].[Terminal_Ibarra_vista]    Script Date: 31/7/2025 9:58:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Terminal_Ibarra_vista]
AS
SELECT 
    cod_terminal,
    ciudad_terminal,
    nombre_terminal,
    direccion_terminal
FROM 
    TERMINAL


GO

USE [Terminal_Ibarra]
GO

/****** Object:  View [dbo].[Vehiculo_Ibarra_vista]    Script Date: 31/7/2025 9:58:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[Vehiculo_Ibarra_vista]
as select * from Vehiculo_Ibarra
GO

USE [Terminal_Ibarra]
GO

/****** Object:  View [dbo].[Viaje_Ibarra_vista]    Script Date: 31/7/2025 9:59:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[Viaje_Ibarra_vista] as
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
GO

