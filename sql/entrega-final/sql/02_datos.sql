/* =========================================================
   Archivo: Entrega2_Massironi_Datos.sql
   Proyecto: Feria del Automóvil - Entrega 2
   Función: Inserción de datos de prueba
   Motor: MySQL 8+ (MySQL Workbench)

   Tablas cubiertas:
   - dim_marca, dim_modelo, dim_combustible, dim_transmision
   - dim_color, dim_carroceria, dim_ubicacion, dim_estado
   - dim_origen, dim_fecha
   - dim_cliente, dim_vendedor, dim_financiacion
   - fact_auto
   - trans_venta, trans_pago
   ========================================================= */

USE feria_massironi;

/* =========================================================
   LIMPIEZA PREVIA
   ========================================================= */
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;

DELETE FROM trans_pago;
DELETE FROM trans_venta;
DELETE FROM fact_auto;
DELETE FROM dim_fecha;
DELETE FROM dim_origen;
DELETE FROM dim_estado;
DELETE FROM dim_ubicacion;
DELETE FROM dim_carroceria;
DELETE FROM dim_color;
DELETE FROM dim_transmision;
DELETE FROM dim_combustible;
DELETE FROM dim_modelo;
DELETE FROM dim_marca;
DELETE FROM dim_cliente;
DELETE FROM dim_vendedor;
DELETE FROM dim_financiacion;

SET SQL_SAFE_UPDATES = 1;
SET FOREIGN_KEY_CHECKS = 1;

/* =========================================================
   TABLAS DIMENSIÓN BASE
   ========================================================= */

/* dim_marca */
INSERT INTO dim_marca (id_marca, marca) VALUES
(1, 'Toyota'),
(2, 'Ford'),
(3, 'Chevrolet'),
(4, 'Volkswagen'),
(5, 'Peugeot'),
(6, 'Renault');

/* dim_modelo */
INSERT INTO dim_modelo (id_modelo, id_marca, modelo, image_url) VALUES
(1,  1, 'Corolla', 'https://example.com/corolla.jpg'),
(2,  1, 'Hilux',   'https://example.com/hilux.jpg'),
(3,  2, 'Fiesta',  'https://example.com/fiesta.jpg'),
(4,  2, 'Ranger',  'https://example.com/ranger.jpg'),
(5,  3, 'Cruze',   'https://example.com/cruze.jpg'),
(6,  3, 'Onix',    'https://example.com/onix.jpg'),
(7,  4, 'Gol',     'https://example.com/gol.jpg'),
(8,  4, 'Amarok',  'https://example.com/amarok.jpg'),
(9,  5, '208',     'https://example.com/208.jpg'),
(10, 5, '3008',    'https://example.com/3008.jpg'),
(11, 6, 'Kwid',    'https://example.com/kwid.jpg'),
(12, 6, 'Duster',  'https://example.com/duster.jpg');

/* dim_combustible */
INSERT INTO dim_combustible (id_combustible, tipo_combustible) VALUES
(1, 'Nafta'),
(2, 'Diésel'),
(3, 'Híbrido'),
(4, 'Eléctrico');

/* dim_transmision */
INSERT INTO dim_transmision (id_transmision, transmision) VALUES
(1, 'Manual'),
(2, 'Automática');

/* dim_color */
INSERT INTO dim_color (id_color, color) VALUES
(1, 'Blanco'),
(2, 'Negro'),
(3, 'Gris'),
(4, 'Rojo'),
(5, 'Azul'),
(6, 'Plateado');

/* dim_carroceria */
INSERT INTO dim_carroceria (id_carroceria, carroceria) VALUES
(1, 'Sedán'),
(2, 'Hatchback'),
(3, 'SUV'),
(4, 'Pickup');

/* dim_ubicacion */
INSERT INTO dim_ubicacion (id_ubicacion, provincia, localidad) VALUES
(1, 'Buenos Aires', 'La Plata'),
(2, 'Córdoba',      'Córdoba Capital'),
(3, 'Santa Fe',     'Rosario'),
(4, 'Mendoza',      'Godoy Cruz'),
(5, 'Neuquén',      'Neuquén Capital'),
(6, 'Salta',        'Salta Capital');

/* dim_estado */
INSERT INTO dim_estado (id_estado, estado) VALUES
(1, 'Nuevo'),
(2, 'Usado'),
(3, 'Seminuevo');

/* dim_origen */
INSERT INTO dim_origen (id_origen, origen) VALUES
(1, 'Nacional'),
(2, 'Importado');

/* dim_fecha */
INSERT INTO dim_fecha (id_fecha, anio, mes, dia) VALUES
('2024-01-15', 2024,  1, 15),
('2024-02-10', 2024,  2, 10),
('2024-03-20', 2024,  3, 20),
('2024-04-05', 2024,  4,  5),
('2024-05-18', 2024,  5, 18),
('2024-06-22', 2024,  6, 22),
('2024-07-12', 2024,  7, 12),
('2024-08-25', 2024,  8, 25),
('2024-09-30', 2024,  9, 30),
('2024-10-14', 2024, 10, 14),
('2024-11-09', 2024, 11,  9),
('2024-12-03', 2024, 12,  3);

/* =========================================================
   TABLAS DIMENSIÓN ADICIONALES
   ========================================================= */

/* dim_cliente */
INSERT INTO dim_cliente (id_cliente, nombre, apellido, email, telefono, provincia) VALUES
(1, 'Lucía',     'Fernández', 'lucia.fernandez@mail.com',  '011-4001-1001', 'Buenos Aires'),
(2, 'Pedro',     'Sánchez',   'pedro.sanchez@mail.com',    '0351-4001-2002', 'Córdoba'),
(3, 'Ana',       'Torres',    'ana.torres@mail.com',       '0341-4001-3003', 'Santa Fe'),
(4, 'Diego',     'Romero',    'diego.romero@mail.com',     '0261-4001-4004', 'Mendoza'),
(5, 'Valentina', 'Cruz',      'valentina.cruz@mail.com',   '0299-4001-5005', 'Neuquén');

/* dim_vendedor */
INSERT INTO dim_vendedor (id_vendedor, nombre, apellido, email, telefono) VALUES
(1, 'Carlos', 'García',   'carlos.garcia@feria.com',   '011-5000-0001'),
(2, 'María',  'López',    'maria.lopez@feria.com',     '011-5000-0002'),
(3, 'Jorge',  'Martínez', 'jorge.martinez@feria.com',  '011-5000-0003');

/* dim_financiacion */
INSERT INTO dim_financiacion (id_financiacion, descripcion, cant_cuotas, tasa_interes) VALUES
(1, 'Sin financiación',  0,  0.00),
(2, '12 cuotas',        12,  8.50),
(3, '24 cuotas',        24, 12.00),
(4, '36 cuotas',        36, 16.50);

/* =========================================================
   TABLA DE HECHOS
   ========================================================= */

INSERT INTO fact_auto
  (id_auto, id_modelo, id_combustible, id_transmision, id_color, id_carroceria,
   id_ubicacion, id_estado, id_origen, id_fecha_publicacion,
   anio_fabricacion, kilometraje, precio_ars, puertas, financiacion)
VALUES
( 1,  1, 1, 2, 1, 1, 1, 2, 1, '2024-01-15', 2020, 45000, 18500000.00, 4, 1),
( 2,  2, 2, 2, 3, 4, 2, 3, 1, '2024-02-10', 2021, 38000, 32500000.00, 4, 1),
( 3,  3, 1, 1, 4, 2, 3, 2, 1, '2024-03-20', 2019, 52000, 14200000.00, 5, 0),
( 4,  4, 2, 2, 2, 4, 1, 1, 1, '2024-04-05', 2024,     0, 42000000.00, 4, 1),
( 5,  5, 1, 2, 5, 1, 4, 3, 2, '2024-05-18', 2022, 27000, 21000000.00, 4, 1),
( 6,  6, 1, 1, 1, 2, 5, 2, 1, '2024-06-22', 2021, 31000, 16700000.00, 5, 0),
( 7,  7, 1, 1, 3, 2, 2, 2, 1, '2024-07-12', 2018, 69000, 11800000.00, 5, 0),
( 8,  8, 2, 2, 6, 4, 3, 3, 2, '2024-08-25', 2023, 12000, 39800000.00, 4, 1),
( 9,  9, 1, 1, 4, 2, 4, 1, 1, '2024-09-30', 2024,     0, 19500000.00, 5, 1),
(10, 10, 3, 2, 5, 3, 5, 3, 2, '2024-10-14', 2023,  9000, 35600000.00, 5, 1),
(11, 11, 1, 1, 1, 2, 6, 1, 1, '2024-11-09', 2024,     0, 12800000.00, 5, 1),
(12, 12, 1, 2, 2, 3, 1, 2, 2, '2024-12-03', 2022, 24000, 28900000.00, 5, 0);

/* =========================================================
   TABLAS TRANSACCIONALES
   ========================================================= */

/* trans_venta — 5 ventas concretadas */
INSERT INTO trans_venta
  (id_venta, id_auto, id_vendedor, id_cliente, id_financiacion, fecha_venta, precio_venta)
VALUES
(1,  1, 1, 1, 2, '2024-02-01', 18500000.00),
(2,  3, 2, 2, 1, '2024-04-10', 14200000.00),
(3,  5, 1, 3, 3, '2024-06-05', 21000000.00),
(4,  7, 3, 4, 1, '2024-08-15', 11800000.00),
(5,  9, 2, 5, 2, '2024-10-20', 19500000.00);

/* trans_pago — pagos asociados a cada venta */
INSERT INTO trans_pago
  (id_pago, id_venta, nro_cuota, fecha_pago,   monto_pagado,  estado)
VALUES
-- Venta 1: financiada 12 cuotas → primeras 2 cuotas pagadas
( 1, 1, 1, '2024-02-01',  1541666.67, 'Pagado'),
( 2, 1, 2, '2024-03-01',  1541666.67, 'Pagado'),
( 3, 1, 3,          NULL, 1541666.67, 'Pendiente'),
-- Venta 2: contado → pago único
( 4, 2, 1, '2024-04-10', 14200000.00, 'Pagado'),
-- Venta 3: financiada 24 cuotas → primera cuota pagada
( 5, 3, 1, '2024-06-05',   875000.00, 'Pagado'),
( 6, 3, 2,          NULL,   875000.00, 'Pendiente'),
-- Venta 4: contado → pago único
( 7, 4, 1, '2024-08-15', 11800000.00, 'Pagado'),
-- Venta 5: financiada 12 cuotas → primera cuota pagada
( 8, 5, 1, '2024-10-20',  1625000.00, 'Pagado'),
( 9, 5, 2,          NULL,  1625000.00, 'Pendiente');

/* =========================================================
   CONSULTAS DE CONTROL
   ========================================================= */
SELECT COUNT(*) AS total_marcas       FROM dim_marca;
SELECT COUNT(*) AS total_modelos      FROM dim_modelo;
SELECT COUNT(*) AS total_autos        FROM fact_auto;
SELECT COUNT(*) AS total_clientes     FROM dim_cliente;
SELECT COUNT(*) AS total_vendedores   FROM dim_vendedor;
SELECT COUNT(*) AS total_financiacion FROM dim_financiacion;
SELECT COUNT(*) AS total_ventas       FROM trans_venta;
SELECT COUNT(*) AS total_pagos        FROM trans_pago;
