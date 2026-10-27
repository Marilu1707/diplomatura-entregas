/* =========================================================
   Archivo: Entrega1_Massironi.sql
   Proyecto: Base de Datos - Feria del Automovil (Entrega 1)
   Motor: MySQL 8+ (MySQL Workbench)
   Descripcion:
     - Esquema en estrella (tabla de hechos + dimensiones)
     - PK/FK, UNIQUE e indices para performance
   ========================================================= */

/* Recomendacion Workbench:
   - File > Open SQL Script > Ejecutar (rayo)
   - O Database > Forward Engineer si lo armas desde EER
*/

DROP DATABASE IF EXISTS feria_massironi;
CREATE DATABASE feria_massironi
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_spanish_ci;

USE feria_massironi;

-- =======================
-- TABLAS DIMENSIÓN
-- =======================

/* Catálogo de marcas */
CREATE TABLE dim_marca (
  id_marca INT AUTO_INCREMENT PRIMARY KEY,
  marca VARCHAR(60) NOT NULL,
  UNIQUE KEY uq_dim_marca_marca (marca)
) ENGINE=InnoDB;

/* Catálogo de modelos (depende de marca) */
CREATE TABLE dim_modelo (
  id_modelo INT AUTO_INCREMENT PRIMARY KEY,
  id_marca INT NOT NULL,
  modelo VARCHAR(80) NOT NULL,
  image_url VARCHAR(255) NULL,

  UNIQUE KEY uq_dim_modelo_marca_modelo (id_marca, modelo),
  KEY idx_dim_modelo_id_marca (id_marca),

  CONSTRAINT fk_dim_modelo_marca
    FOREIGN KEY (id_marca) REFERENCES dim_marca(id_marca)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;

/* Combustibles */
CREATE TABLE dim_combustible (
  id_combustible INT AUTO_INCREMENT PRIMARY KEY,
  tipo_combustible VARCHAR(40) NOT NULL,
  UNIQUE KEY uq_dim_combustible (tipo_combustible)
) ENGINE=InnoDB;

/* Transmisiones */
CREATE TABLE dim_transmision (
  id_transmision INT AUTO_INCREMENT PRIMARY KEY,
  transmision VARCHAR(40) NOT NULL,
  UNIQUE KEY uq_dim_transmision (transmision)
) ENGINE=InnoDB;

/* Colores */
CREATE TABLE dim_color (
  id_color INT AUTO_INCREMENT PRIMARY KEY,
  color VARCHAR(40) NOT NULL,
  UNIQUE KEY uq_dim_color (color)
) ENGINE=InnoDB;

/* Carrocerías */
CREATE TABLE dim_carroceria (
  id_carroceria INT AUTO_INCREMENT PRIMARY KEY,
  carroceria VARCHAR(40) NOT NULL,
  UNIQUE KEY uq_dim_carroceria (carroceria)
) ENGINE=InnoDB;

/* Ubicaciones */
CREATE TABLE dim_ubicacion (
  id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
  provincia VARCHAR(60) NOT NULL,
  localidad VARCHAR(80) NOT NULL,

  KEY idx_dim_ubicacion_provincia (provincia),
  KEY idx_dim_ubicacion_localidad (localidad)
) ENGINE=InnoDB;

/* Estados del vehículo */
CREATE TABLE dim_estado (
  id_estado INT AUTO_INCREMENT PRIMARY KEY,
  estado VARCHAR(40) NOT NULL,
  UNIQUE KEY uq_dim_estado (estado)
) ENGINE=InnoDB;

/* Origen del vehículo */
CREATE TABLE dim_origen (
  id_origen INT AUTO_INCREMENT PRIMARY KEY,
  origen VARCHAR(40) NOT NULL,
  UNIQUE KEY uq_dim_origen (origen)
) ENGINE=InnoDB;

/* Calendario / Fecha de publicacion (granularidad diaria)
   Nota: usar DATE como PK simplifica joins y evita una surrogate key extra.
*/
CREATE TABLE dim_fecha (
  id_fecha DATE PRIMARY KEY,
  anio SMALLINT NOT NULL,
  mes TINYINT NOT NULL,
  dia TINYINT NOT NULL,

  -- CHECKs: en MySQL 8+ se validan (en versiones antiguas se ignoran)
  CONSTRAINT ck_dim_fecha_mes CHECK (mes BETWEEN 1 AND 12),
  CONSTRAINT ck_dim_fecha_dia CHECK (dia BETWEEN 1 AND 31)
) ENGINE=InnoDB;

-- =======================
-- TABLA DE HECHOS
-- =======================

/* Publicaciones / inventario de autos */
CREATE TABLE fact_auto (
  id_auto INT NOT NULL AUTO_INCREMENT,
  id_modelo INT NOT NULL,
  id_combustible INT NOT NULL,
  id_transmision INT NOT NULL,
  id_color INT NOT NULL,
  id_carroceria INT NOT NULL,
  id_ubicacion INT NOT NULL,
  id_estado INT NOT NULL,
  id_origen INT NOT NULL,
  id_fecha_publicacion DATE NOT NULL,

  anio_fabricacion SMALLINT NOT NULL,
  kilometraje INT NOT NULL,
  precio_ars DECIMAL(12,2) NOT NULL,
  puertas TINYINT,
  financiacion TINYINT,

  PRIMARY KEY (id_auto),

  KEY idx_fact_modelo (id_modelo),
  KEY idx_fact_combustible (id_combustible),
  KEY idx_fact_transmision (id_transmision),
  KEY idx_fact_color (id_color),
  KEY idx_fact_carroceria (id_carroceria),
  KEY idx_fact_ubicacion (id_ubicacion),
  KEY idx_fact_estado (id_estado),
  KEY idx_fact_origen (id_origen),
  KEY idx_fact_fecha (id_fecha_publicacion),

  CONSTRAINT fk_fact_modelo
    FOREIGN KEY (id_modelo) REFERENCES dim_modelo(id_modelo),

  CONSTRAINT fk_fact_combustible
    FOREIGN KEY (id_combustible) REFERENCES dim_combustible(id_combustible),

  CONSTRAINT fk_fact_transmision
    FOREIGN KEY (id_transmision) REFERENCES dim_transmision(id_transmision),

  CONSTRAINT fk_fact_color
    FOREIGN KEY (id_color) REFERENCES dim_color(id_color),

  CONSTRAINT fk_fact_carroceria
    FOREIGN KEY (id_carroceria) REFERENCES dim_carroceria(id_carroceria),

  CONSTRAINT fk_fact_ubicacion
    FOREIGN KEY (id_ubicacion) REFERENCES dim_ubicacion(id_ubicacion),

  CONSTRAINT fk_fact_estado
    FOREIGN KEY (id_estado) REFERENCES dim_estado(id_estado),

  CONSTRAINT fk_fact_origen
    FOREIGN KEY (id_origen) REFERENCES dim_origen(id_origen),

  CONSTRAINT fk_fact_fecha
    FOREIGN KEY (id_fecha_publicacion) REFERENCES dim_fecha(id_fecha)
) ENGINE=InnoDB;

-- =======================
-- TABLAS ADICIONALES
-- =======================

/* Catálogo de clientes */
CREATE TABLE dim_cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre     VARCHAR(80)  NOT NULL,
  apellido   VARCHAR(80)  NOT NULL,
  email      VARCHAR(120) NULL,
  telefono   VARCHAR(20)  NULL,
  provincia  VARCHAR(60)  NULL,
  UNIQUE KEY uq_dim_cliente_email (email)
) ENGINE=InnoDB;

/* Catálogo de vendedores */
CREATE TABLE dim_vendedor (
  id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(80)  NOT NULL,
  apellido    VARCHAR(80)  NOT NULL,
  email       VARCHAR(120) NULL,
  telefono    VARCHAR(20)  NULL,
  UNIQUE KEY uq_dim_vendedor_email (email)
) ENGINE=InnoDB;

/* Catálogo de planes de financiación */
CREATE TABLE dim_financiacion (
  id_financiacion INT AUTO_INCREMENT PRIMARY KEY,
  descripcion     VARCHAR(60)    NOT NULL,  -- ej. 'Sin financiación', '12 cuotas', etc.
  cant_cuotas     TINYINT        NOT NULL DEFAULT 0,
  tasa_interes    DECIMAL(5,2)   NOT NULL DEFAULT 0.00,
  UNIQUE KEY uq_dim_financiacion (descripcion)
) ENGINE=InnoDB;

/* Transacción: ventas concretadas */
CREATE TABLE trans_venta (
  id_venta        INT AUTO_INCREMENT PRIMARY KEY,
  id_auto         INT            NOT NULL,
  id_vendedor     INT            NOT NULL,
  id_cliente      INT            NOT NULL,
  id_financiacion INT            NOT NULL,
  fecha_venta     DATE           NOT NULL,
  precio_venta    DECIMAL(12,2)  NOT NULL,

  KEY idx_transv_auto         (id_auto),
  KEY idx_transv_vendedor     (id_vendedor),
  KEY idx_transv_cliente      (id_cliente),
  KEY idx_transv_financiacion (id_financiacion),

  CONSTRAINT fk_transv_auto
    FOREIGN KEY (id_auto)         REFERENCES fact_auto(id_auto)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_transv_vendedor
    FOREIGN KEY (id_vendedor)     REFERENCES dim_vendedor(id_vendedor)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_transv_cliente
    FOREIGN KEY (id_cliente)      REFERENCES dim_cliente(id_cliente)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_transv_financiacion
    FOREIGN KEY (id_financiacion) REFERENCES dim_financiacion(id_financiacion)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

/* Transacción: pagos de cuotas de cada venta */
CREATE TABLE trans_pago (
  id_pago      INT AUTO_INCREMENT PRIMARY KEY,
  id_venta     INT            NOT NULL,
  nro_cuota    TINYINT        NOT NULL DEFAULT 1,
  fecha_pago   DATE           NULL,
  monto_pagado DECIMAL(12,2)  NOT NULL,
  estado       VARCHAR(20)    NOT NULL DEFAULT 'Pendiente',  -- 'Pagado' | 'Pendiente'

  KEY idx_transp_venta (id_venta),

  CONSTRAINT fk_transp_venta
    FOREIGN KEY (id_venta) REFERENCES trans_venta(id_venta)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================================
-- FIN DEL SCRIPT
-- =========================================================
