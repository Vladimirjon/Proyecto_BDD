use Terminal_Quito

SET XACT_ABORT ON;
GO
-- VISTA TERMINAL
create view Terminal_Quito_vista 
as select cod_terminal,ciudad_terminal,nombre_terminal,direccion_terminal from TERMINAL

select * from Terminal_Quito_vista

-- VISTA CONDUCTOR 
create view Conductor_Quito_vista
as select * from Conductor_Quito

select * from Conductor_Quito_vista

-- VISTA VIAJE 
CREATE VIEW Viaje_Quito_vista AS
SELECT 
    vi.cod_viaje,
    vi.cod_conductor,
    vi.cod_vehiculo,
    vi.cod_terminal, 
    vt.fecha_viaje,
    vt.hora_viaje,
    vi.ciudad_destino,
    vi.precio_viaje   
    
FROM ViajeInformacion_Quito vi
JOIN ViajeTiempo vt ON vi.cod_viaje = vt.cod_viaje;

select * from Viaje_Quito_vista

-- VISTA PASAJERO
create view Pasajero_Quito_vista as
select 
    pai.cod_pasajero,
    pai.cod_viaje,
    pai.nombre_pasajero,
    pai.apellido_pasajero,
    pac.telefono_pasajero,
    pai.cedula_pasajero,
    pac.correo_pasajero
from PasajerosContacto pac
JOIN PasajerosInformacion_Quito pai on pac.cod_pasajero = pai.cod_pasajero

select * from Pasajero_Quito_vista
select * from PasajerosContacto
select * from PasajerosInformacion_Quito

-- VIAJE VEHICULO
create view Vehiculo_Quito_vista
as select * from Vehiculo_Quito

select * from Vehiculo_Quito_vista
select * from Pasajero_Quito_vista
select * from Viaje_Quito_vista
select * from Terminal_Quito_vista
select * from Conductor_Quito_vista