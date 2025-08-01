USE [Terminal_Quito]
GO

/****** Object:  StoredProcedure [dbo].[ActualizarPasajeroCompleto]    Script Date: 31/7/2025 10:06:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[ActualizarPasajeroCompleto]
    @codPasajero       INT,
    @codViaje          INT,
    @nombrePasajero    NVARCHAR(100),
    @apellidoPasajero  NVARCHAR(100),
    @cedulaPasajero    NVARCHAR(20),
    @telefonoPasajero  NVARCHAR(20),
    @correoPasajero    NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY


        -- 1) Actualiza la fragmentación de información general (tabla Quito)
        UPDATE PasajerosInformacion_Quito
        SET 
            cod_viaje        = @codViaje,
            nombre_pasajero  = @nombrePasajero,
            apellido_pasajero= @apellidoPasajero,
            cedula_pasajero  = @cedulaPasajero
        WHERE cod_pasajero = @codPasajero;

        -- 2) Actualiza la fragmentación de contacto (tabla remota)
        UPDATE PasajerosContacto
        SET 
            telefono_pasajero = @telefonoPasajero,
            correo_pasajero   = @correoPasajero
        WHERE cod_pasajero = @codPasajero;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

USE [Terminal_Quito]
GO

/****** Object:  StoredProcedure [dbo].[ActualizarViajeCompleto]    Script Date: 31/7/2025 10:06:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[ActualizarViajeCompleto]
    @codViaje       INT,
    @codVehiculo    INT,
    @codConductor   INT,
    @codTerminal    INT,
    @ciudadDestino  NVARCHAR(100),
    @precioViaje    DECIMAL(10,2),
    @fechaViaje     DATE,
    @horaViaje      TIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY


        -- 1) Actualiza la parte informativa
        UPDATE dbo.ViajeInformacion_Quito
        SET 
            cod_vehiculo    = @codVehiculo,
            cod_conductor   = @codConductor,
            cod_terminal    = @codTerminal,
            ciudad_destino  = @ciudadDestino,
            precio_viaje    = @precioViaje
        WHERE cod_viaje = @codViaje;

        -- 2) Actualiza la parte de fecha y hora
        UPDATE [VLADIMIRJON].[Terminal_Quito].[dbo].[ViajeTiempo]
        SET 
            fecha_viaje = @fechaViaje,
            hora_viaje  = @horaViaje
        WHERE cod_viaje = @codViaje;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
        THROW;  -- relanza el error
    END CATCH
END
GO

USE [Terminal_Quito]
GO

/****** Object:  StoredProcedure [dbo].[EliminarPasajeroCompleto]    Script Date: 31/7/2025 10:06:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[EliminarPasajeroCompleto]
    @codPasajero INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1) Eliminar primero de la fragmentación de contacto
        DELETE FROM PasajerosContacto
        WHERE cod_pasajero = @codPasajero;

        -- 2) Luego eliminar de la tabla de información general
        DELETE FROM PasajerosInformacion_Quito
        WHERE cod_pasajero = @codPasajero;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;  -- Reenviar error a la aplicación
    END CATCH
END
GO

USE [Terminal_Quito]
GO

/****** Object:  StoredProcedure [dbo].[EliminarViajeCompleto]    Script Date: 31/7/2025 10:06:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[EliminarViajeCompleto]
    @codViaje INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- 1) Eliminar pasajeros contacto primero
        DELETE FROM [VLADIMIRJON].[Terminal_Quito].[dbo].[PasajerosContacto]
        WHERE cod_pasajero IN (
            SELECT cod_pasajero FROM PasajerosInformacion_Quito
            WHERE cod_viaje = @codViaje
        );

        -- 2) Eliminar información de pasajeros
        DELETE FROM PasajerosInformacion_Quito
        WHERE cod_viaje = @codViaje;

        -- 3) Eliminar tiempo del viaje
        DELETE FROM [VLADIMIRJON].[Terminal_Quito].[dbo].[ViajeTiempo]
        WHERE cod_viaje = @codViaje;

        -- 4) Eliminar viaje principal
        DELETE FROM ViajeInformacion_Quito
        WHERE cod_viaje = @codViaje;

    END TRY
    BEGIN CATCH
        THROW;  -- Manda el error al código Java si algo falla
    END CATCH
END
GO

USE [Terminal_Quito]
GO

/****** Object:  StoredProcedure [dbo].[InsertarConductorCompleto]    Script Date: 31/7/2025 10:07:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[InsertarConductorCompleto]
    @codTerminal       INT,
    @nombreConductor   NVARCHAR(100),
    @apellidoConductor NVARCHAR(100),
    @licenciaConductor NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Conductor_Quito
            (cod_terminal, nombre_conductor, apellido_conductor, licencia_conductor)
        VALUES
            (@codTerminal, @nombreConductor, @apellidoConductor, @licenciaConductor);


        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

USE [Terminal_Quito]
GO

/****** Object:  StoredProcedure [dbo].[InsertarPasajeroCompleto]    Script Date: 31/7/2025 10:07:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[InsertarPasajeroCompleto]
    @codViaje           INT,
    @nombrePasajero     NVARCHAR(100),
    @apellidoPasajero   NVARCHAR(100),
    @cedulaPasajero     NVARCHAR(20),
    @telefonoPasajero   NVARCHAR(20),
    @correoPasajero     NVARCHAR(100),
    @nuevoCodPasajero   INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1) Inserta en la fragmentación de información general (Ibarra)
        INSERT INTO PasajerosInformacion_Quito
            (cod_viaje, nombre_pasajero, apellido_pasajero, cedula_pasajero)
        VALUES
            (@codViaje, @nombrePasajero, @apellidoPasajero, @cedulaPasajero);

        -- 2) Captura el nuevo ID generado
			SET @nuevoCodPasajero = SCOPE_IDENTITY();
		COMMIT TRANSACTION;

        -- 3) Inserta en la fragmentación de contacto (VladimirJon)
        -- Debes ejecutar este INSERT usando un **linked server** si la tabla está en otro servidor.
        INSERT INTO PasajerosContacto
            (cod_pasajero, telefono_pasajero, correo_pasajero)
        VALUES
            (@nuevoCodPasajero, @telefonoPasajero, @correoPasajero);

        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;  -- relanza el error al caller
    END CATCH
END
GO

USE [Terminal_Quito]
GO

/****** Object:  StoredProcedure [dbo].[InsertarViajeCompleto]    Script Date: 31/7/2025 10:07:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[InsertarViajeCompleto]
    @codVehiculo    INT,
    @codConductor   INT,
    @codTerminal    INT,
    @ciudadDestino  NVARCHAR(100),
    @precioViaje    DECIMAL(10,2),
    @horaViaje      TIME,
    @fechaViaje     DATE,
    @nuevoCodViaje  INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
            -- 1) Inserción en el fragmento de información (Quito)
            INSERT INTO dbo.ViajeInformacion_Quito
                (cod_vehiculo, cod_conductor, cod_terminal, ciudad_destino, precio_viaje)
            VALUES
                (@codVehiculo, @codConductor, @codTerminal, @ciudadDestino, @precioViaje);

            -- Capturamos el nuevo ID generado
            SET @nuevoCodViaje = SCOPE_IDENTITY();

            -- 2) Inserción en el fragmento de fecha/hora (también en Quito)
            INSERT INTO dbo.ViajeTiempo
                (cod_viaje, hora_viaje, fecha_viaje)
            VALUES
                (@nuevoCodViaje, @horaViaje, @fechaViaje);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

GO

