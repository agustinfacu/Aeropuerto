USE `mydb`;

-- =================================================================================================
--  TABLA: RUTA
--  Rol: catálogo de tramos origen→destino entre aeropuertos. Base para vuelos programados y vuelos.
--  Relacionada con:
--    - aeropuerto (FK doble): origen_aeropuerto y destino_aeropuerto.
--    - usuario (FKs de auditoría): quién creó/actualizó/borró lógicamente.
--    - vuelo_programado / vuelo (indirecto): referencian esta ruta para planificar/operar.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`ruta`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`ruta` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idruta` INT NOT NULL AUTO_INCREMENT,           -- PK interna de la ruta

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `distancia_km`    INT       NOT NULL,          -- Distancia estimada del tramo en kilómetros
  `timepo_estimado` SMALLINT  NULL,              -- (sic, tal cual en tu DDL) Tiempo estimado (minutos)
  `activo`          TINYINT   NULL,              -- 1=disponible para programar, 0=no disponible

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME  NULL,              -- Cuándo se creó
  `actualizado_en`  DATETIME  NULL,              -- Última actualización
  `eliminado_en`    DATETIME  NULL,              -- Marca de borrado lógico (si aplica)
  `creado_por`      INT       NOT NULL,          -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT       NOT NULL,          -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT       NULL,              -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,          -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIONES ORIGEN/DESTINO
  -- ===============================================================================================
  `origen_aeropuerto`  INT NOT NULL,             -- FK → aeropuerto.idaeropuerto (salida)
  `destino_aeropuerto` INT NOT NULL,             -- FK → aeropuerto.idaeropuerto (llegada)

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idruta`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_ruta_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_ruta_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_ruta_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FKs con AEROPUERTO → aeropuerto(idaeropuerto)
  --   Nota: ON DELETE CASCADE significa que al borrar un aeropuerto se borran sus rutas asociadas.
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_ruta_origen_aeropuerto`
    FOREIGN KEY (`origen_aeropuerto`)
    REFERENCES `mydb`.`aeropuerto` (`idaeropuerto`)
    ON DELETE CASCADE ON UPDATE NO ACTION,

  CONSTRAINT `fk_ruta_destino_aeropuerto`
    FOREIGN KEY (`destino_aeropuerto`)
    REFERENCES `mydb`.`aeropuerto` (`idaeropuerto`)
    ON DELETE CASCADE ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- ÍNDICES / REGLAS DE UNICIDAD
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Nota: índice UNIQUE original sobre origen_aeropuerto. 
--       En práctica suele usarse UNIQUE (origen_aeropuerto, destino_aeropuerto) para evitar duplicar
--       rutas en el mismo sentido, permitiendo múltiples orígenes con el mismo aeropuerto.
--       Se deja tal cual para NO modificar tu esquema actual.
CREATE UNIQUE INDEX `origen_aeropuerto_UNIQUE`
  ON `mydb`.`ruta` (`origen_aeropuerto` ASC) VISIBLE;

-- =================================================================================================
--  NOTAS DE USO
--  • Base para vuelo_programado (frecuencia/hora estándar) y vuelo (instancias operativas).
--  • Considerá agregar más adelante:
--      - UNIQUE (origen_aeropuerto, destino_aeropuerto)
--      - Índices por (origen_aeropuerto) y (destino_aeropuerto) para búsquedas rápidas.
--      - Validación para evitar origen=destino.
-- =================================================================================================
