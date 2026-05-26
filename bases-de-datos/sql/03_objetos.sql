/* =========================================================
   Archivo: Entrega2_Massironi_Objetos_CORREGIDO.sql
   Proyecto: Feria del Automóvil - Entrega 2
   Función: creación de vistas, funciones, stored procedures y triggers
   Motor: MySQL 8+ (MySQL Workbench)

   Requisitos previos:
   1) Ejecutar Entrega1_Massironi.sql
   2) Ejecutar Entrega2_Massironi_Datos.sql
   ========================================================= */

USE feria_massironi;

/* =======================
   LIMPIEZA PREVIA
   ======================= */
DROP VIEW IF EXISTS vw_autos_detalle;
DROP VIEW IF EXISTS vw_precio_promedio_marca;
DROP VIEW IF EXISTS vw_autos_por_provincia;
DROP VIEW IF EXISTS vw_autos_financiados;
DROP VIEW IF EXISTS vw_ventas_por_mes;

DROP FUNCTION IF EXISTS fn_precio_con_financiacion;
DROP FUNCTION IF EXISTS fn_antiguedad_auto;

DROP PROCEDURE IF EXISTS sp_insertar_auto;
DROP PROCEDURE IF EXISTS sp_autos_por_marca;
DROP PROCEDURE IF EXISTS sp_actualizar_precio;

DROP TRIGGER IF EXISTS trg_validar_precio_before_insert;
DROP TRIGGER IF EXISTS trg_validar_km_before_insert;
DROP TRIGGER IF EXISTS trg_log_cambio_precio_after_update;

DROP TABLE IF EXISTS log_precio_auto;
DROP TABLE IF EXISTS trans_pago;
DROP TABLE IF EXISTS trans_venta;

/* =======================
   VISTAS
   ======================= */

/* 1) Detalle completo de autos */
CREATE VIEW vw_autos_detalle AS
SELECT
    fa.id_auto,
    ma.marca,
    mo.modelo,
    co.tipo_combustible,
    tr.transmision,
    ca.carroceria,
    ub.provincia,
    ub.localidad,
    es.estado,
    ori.origen,
    df.id_fecha AS fecha_publicacion,
    fa.anio_fabricacion,
    fa.kilometraje,
    fa.precio_ars,
    fa.puertas,
    fa.financiacion
FROM fact_auto fa
INNER JOIN dim_modelo mo ON fa.id_modelo = mo.id_modelo
INNER JOIN dim_marca ma ON mo.id_marca = ma.id_marca
INNER JOIN dim_combustible co ON fa.id_combustible = co.id_combustible
INNER JOIN dim_transmision tr ON fa.id_transmision = tr.id_transmision
INNER JOIN dim_carroceria ca ON fa.id_carroceria = ca.id_carroceria
INNER JOIN dim_ubicacion ub ON fa.id_ubicacion = ub.id_ubicacion
INNER JOIN dim_estado es ON fa.id_estado = es.id_estado
INNER JOIN dim_origen ori ON fa.id_origen = ori.id_origen
INNER JOIN dim_fecha df ON fa.id_fecha_publicacion = df.id_fecha;

/* 2) Precio promedio por marca */
CREATE VIEW vw_precio_promedio_marca AS
SELECT
    ma.marca,
    ROUND(AVG(fa.precio_ars), 2) AS precio_promedio,
    COUNT(*) AS cantidad_autos
FROM fact_auto fa
INNER JOIN dim_modelo mo ON fa.id_modelo = mo.id_modelo
INNER JOIN dim_marca ma ON mo.id_marca = ma.id_marca
GROUP BY ma.marca;

/* 3) Cantidad de autos por provincia */
CREATE VIEW vw_autos_por_provincia AS
SELECT
    ub.provincia,
    COUNT(*) AS cantidad_autos,
    ROUND(AVG(fa.precio_ars), 2) AS precio_promedio
FROM fact_auto fa
INNER JOIN dim_ubicacion ub ON fa.id_ubicacion = ub.id_ubicacion
GROUP BY ub.provincia;

/* 5) Ventas agrupadas por mes */
CREATE VIEW vw_ventas_por_mes AS
SELECT
    YEAR(tv.fecha_venta)                       AS anio,
    MONTH(tv.fecha_venta)                      AS mes,
    COUNT(*)                                   AS cantidad_ventas,
    SUM(tv.precio_venta)                       AS total_vendido,
    ROUND(AVG(tv.precio_venta), 2)             AS ticket_promedio
FROM trans_venta tv
GROUP BY YEAR(tv.fecha_venta), MONTH(tv.fecha_venta)
ORDER BY anio, mes;

/* =======================
   TABLA LOG PARA TRIGGER
   ======================= */
CREATE TABLE log_precio_auto (
    id_log INT NOT NULL AUTO_INCREMENT,
    id_auto INT NOT NULL,
    precio_anterior DECIMAL(12,2),
    precio_nuevo DECIMAL(12,2),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_log)
) ENGINE=InnoDB;

/* =======================
   FUNCIONES + PROCEDURES + TRIGGERS
   ======================= */
DELIMITER $$

/* Función: precio con financiación */
CREATE FUNCTION fn_precio_con_financiacion(
    p_precio DECIMAL(12,2),
    p_financiacion TINYINT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE v_resultado DECIMAL(12,2);

    IF p_financiacion = 1 THEN
        SET v_resultado = p_precio * 1.10;
    ELSE
        SET v_resultado = p_precio;
    END IF;

    RETURN v_resultado;
END$$

/* Función: antigüedad del auto */
CREATE FUNCTION fn_antiguedad_auto(
    p_anio INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN YEAR(CURDATE()) - p_anio;
END$$

/* Procedure: insertar auto */
CREATE PROCEDURE sp_insertar_auto(
    IN p_id_modelo INT,
    IN p_id_combustible INT,
    IN p_id_transmision INT,
    IN p_id_color INT,
    IN p_id_carroceria INT,
    IN p_id_ubicacion INT,
    IN p_id_estado INT,
    IN p_id_origen INT,
    IN p_id_fecha_publicacion DATE,
    IN p_anio_fabricacion SMALLINT,
    IN p_kilometraje INT,
    IN p_precio_ars DECIMAL(12,2),
    IN p_puertas TINYINT,
    IN p_financiacion TINYINT
)
BEGIN
    INSERT INTO fact_auto (
        id_modelo,
        id_combustible,
        id_transmision,
        id_color,
        id_carroceria,
        id_ubicacion,
        id_estado,
        id_origen,
        id_fecha_publicacion,
        anio_fabricacion,
        kilometraje,
        precio_ars,
        puertas,
        financiacion
    )
    VALUES (
        p_id_modelo,
        p_id_combustible,
        p_id_transmision,
        p_id_color,
        p_id_carroceria,
        p_id_ubicacion,
        p_id_estado,
        p_id_origen,
        p_id_fecha_publicacion,
        p_anio_fabricacion,
        p_kilometraje,
        p_precio_ars,
        p_puertas,
        p_financiacion
    );
END$$

/* Procedure: autos por marca */
CREATE PROCEDURE sp_autos_por_marca(
    IN p_marca VARCHAR(60)
)
BEGIN
    SELECT *
    FROM vw_autos_detalle
    WHERE marca = p_marca
    ORDER BY precio_ars DESC;
END$$

/* Procedure: actualizar precio */
CREATE PROCEDURE sp_actualizar_precio(
    IN p_id_auto INT,
    IN p_nuevo_precio DECIMAL(12,2)
)
BEGIN
    UPDATE fact_auto
    SET precio_ars = p_nuevo_precio
    WHERE id_auto = p_id_auto;
END$$

/* Trigger: validar precio */
CREATE TRIGGER trg_validar_precio_before_insert
BEFORE INSERT ON fact_auto
FOR EACH ROW
BEGIN
    IF NEW.precio_ars < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio no puede ser negativo';
    END IF;
END$$

/* Trigger: validar kilometraje */
CREATE TRIGGER trg_validar_km_before_insert
BEFORE INSERT ON fact_auto
FOR EACH ROW
BEGIN
    IF NEW.kilometraje < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El kilometraje no puede ser negativo';
    END IF;
END$$

/* Trigger: log de cambios de precio */
CREATE TRIGGER trg_log_cambio_precio_after_update
AFTER UPDATE ON fact_auto
FOR EACH ROW
BEGIN
    IF OLD.precio_ars <> NEW.precio_ars THEN
        INSERT INTO log_precio_auto (id_auto, precio_anterior, precio_nuevo)
        VALUES (NEW.id_auto, OLD.precio_ars, NEW.precio_ars);
    END IF;
END$$

DELIMITER ;

/* 4) Autos con financiación disponible
      Depende de fn_precio_con_financiacion → se crea DESPUÉS de las funciones */
CREATE VIEW vw_autos_financiados AS
SELECT
    fa.id_auto,
    ma.marca,
    mo.modelo,
    fa.anio_fabricacion,
    fa.kilometraje,
    fa.precio_ars,
    fn_precio_con_financiacion(fa.precio_ars, 1) AS precio_con_financiacion,
    ub.provincia,
    es.estado
FROM fact_auto fa
INNER JOIN dim_modelo    mo ON fa.id_modelo    = mo.id_modelo
INNER JOIN dim_marca     ma ON mo.id_marca     = ma.id_marca
INNER JOIN dim_ubicacion ub ON fa.id_ubicacion = ub.id_ubicacion
INNER JOIN dim_estado    es ON fa.id_estado    = es.id_estado
WHERE fa.financiacion = 1;

/* =======================
   PRUEBAS RÁPIDAS
   ======================= */
SELECT * FROM vw_autos_detalle;
SELECT * FROM vw_precio_promedio_marca;
SELECT * FROM vw_autos_por_provincia;
SELECT * FROM vw_autos_financiados;
SELECT * FROM vw_ventas_por_mes;

SELECT fn_precio_con_financiacion(10000000, 1) AS precio_financiado;
SELECT fn_antiguedad_auto(2020) AS antiguedad_auto;

CALL sp_autos_por_marca('Toyota');
CALL sp_actualizar_precio(1, 19000000.00);
