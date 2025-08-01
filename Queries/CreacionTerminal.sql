-- Creacion de terminal
-- Usar la base
create database Terminal COLLATE Modern_Spanish_CI_AS;
USE Terminal 
GO

-- Crear tabla TERMINAL
CREATE TABLE TERMINAL (
    cod_terminal INT PRIMARY KEY,
    ciudad_terminal VARCHAR(100),
    nombre_terminal VARCHAR(100),
    direccion_terminal VARCHAR(150)
);
GO

-- Crear tabla VEHICULO
CREATE TABLE VEHICULO (
    cod_vehiculo INT PRIMARY KEY,
    cod_terminal INT,
    placa_vehiculo VARCHAR(10),
    capacidad_vehiculo INT,
    compañia_vehiculo VARCHAR(100),
    FOREIGN KEY (cod_terminal) REFERENCES TERMINAL(cod_terminal)
);
GO

-- Crear tabla CONDUCTOR
CREATE TABLE CONDUCTOR (
    cod_conductor INT PRIMARY KEY,
    nombre_conductor VARCHAR(100),
    apellido_conductor VARCHAR(100),
    licencia_conductor VARCHAR(20)
);
GO

-- Crear tabla VIAJE
CREATE TABLE VIAJE (
    cod_viaje INT PRIMARY KEY,
    cod_conductor INT,
    cod_vehiculo INT,
    cod_terminal INT,
    fecha_viaje DATE,
    hora_viaje TIME,
    ciudad_destino VARCHAR(100),
    precio_viaje DECIMAL(10,2),
    FOREIGN KEY (cod_conductor) REFERENCES CONDUCTOR(cod_conductor),
    FOREIGN KEY (cod_vehiculo) REFERENCES VEHICULO(cod_vehiculo),
    FOREIGN KEY (cod_terminal) REFERENCES TERMINAL(cod_terminal)
);
GO

-- Crear tabla PASAJEROS
CREATE TABLE PASAJEROS (
    cod_pasajero INT PRIMARY KEY,
    cod_viaje INT,
    nombre_pasajero VARCHAR(100),
    apellido_pasajero VARCHAR(100),
    telefono_pasajero VARCHAR(20),
    cedula_pasajero VARCHAR(20),
    correo_pasajero VARCHAR(100),
    FOREIGN KEY (cod_viaje) REFERENCES VIAJE(cod_viaje)
);
GO












-- INSERT TERMINAL
INSERT INTO TERMINAL (cod_terminal, ciudad_terminal, nombre_terminal, direccion_terminal) VALUES
(1, 'Quito', 'Terminal Quitumbe', 'Av. Maldonado y Morán Valverde'),
(2, 'Ibarra', 'Terminal Ibarra Norte', 'Av. Teodoro Gómez y Bolívar');

-- INSERT VEHICULO
INSERT INTO VEHICULO (cod_vehiculo, cod_terminal, placa_vehiculo, capacidad_vehiculo, compañia_vehiculo) VALUES
(1, 1, 'PCQ1234', 40, 'Coop. Quiteña'),
(2, 1, 'QWE5678', 45, 'Coop. Transportes Andes'),
(3, 1, 'UIO9876', 50, 'Coop. Express Norte'),
(4, 2, 'IBR5432', 35, 'Coop. IbarraBus'),
(5, 2, 'ZXA4567', 40, 'Coop. Imbabura'),
(6, 2, 'MNB8765', 42, 'Coop. OtavaloExpress');

-- INSERT CONDUCTOR
INSERT INTO CONDUCTOR (cod_conductor, nombre_conductor, apellido_conductor, licencia_conductor) VALUES
(1, 'Juan', 'Pérez', 'LIC-001'),
(2, 'María', 'López', 'LIC-002'),
(3, 'Carlos', 'Andrade', 'LIC-003'),
(4, 'Ana', 'Reyes', 'LIC-004'),
(5, 'Luis', 'Cabrera', 'LIC-005'),
(6, 'Tatiana', 'Salas', 'LIC-006'),
(7, 'Pedro', 'Mora', 'LIC-007'),
(8, 'Diana', 'Jaramillo', 'LIC-008'),
(9, 'Andrés', 'Vega', 'LIC-009'),
(10, 'Sofía', 'Cornejo', 'LIC-010');

-- INSERT VIAJE
INSERT INTO VIAJE (cod_viaje, cod_conductor, cod_vehiculo, cod_terminal, fecha_viaje, hora_viaje, ciudad_destino, precio_viaje) VALUES
(1, 1, 1, 1, '2025-07-06', '08:00', 'Guayaquil', 20.00),
(2, 2, 2, 1, '2025-07-06', '10:30', 'Ambato', 8.00),
(3, 3, 3, 1, '2025-07-06', '12:00', 'Cuenca', 18.50),
(4, 4, 4, 2, '2025-07-06', '09:00', 'Tulcán', 12.00),
(5, 5, 5, 2, '2025-07-06', '11:30', 'Quito', 10.00),
(6, 6, 6, 2, '2025-07-06', '13:00', 'Esmeraldas', 14.50),
(7, 7, 1, 1, '2025-07-07', '08:00', 'Loja', 22.00),
(8, 8, 2, 1, '2025-07-07', '10:30', 'Manta', 19.00),
(9, 9, 4, 2, '2025-07-07', '09:00', 'Tena', 11.00);


-- INSERT CONDUCTOR 
INSERT INTO PASAJEROS (cod_pasajero, cod_viaje, nombre_pasajero, apellido_pasajero, telefono_pasajero, cedula_pasajero, correo_pasajero) VALUES
(1, 1, 'Erick', 'Vélez', '0991112233', '1712345678', 'erickvelez@email.com'),
(2, 2, 'Marcela', 'García', '0987654321', '1723456789', 'marcega@email.com'),
(3, 3, 'Manuel', 'Lopez', '0987657890', '1723456780', 'manuel@email.com'),
(4, 4, 'Joel', 'Tinitana', '0987616491', '1723454599', 'joel@email.com'),
(5, 5, 'Sebas', 'Chicaiza', '0900354321', '1761056789', 'sebas@email.com'),
(6, 6, 'Francis', 'Bravo', '0939914321', '1724476789', 'francis@email.com');


-- consultas 
SELECT * FROM PASAJEROS;
SELECT * FROM VIAJE;
SELECT * FROM CONDUCTOR;

SELECT * FROM VEHICULO
select * from terminal