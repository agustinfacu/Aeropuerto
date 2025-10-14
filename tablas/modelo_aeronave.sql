USE `mydb`;

-- =================================================================================================
--  TABLA: MODELO_AERONAVE
--  Rol: catálogo técnico de modelos de aeronave (fabricante, familia, performance y capacidades).
--       Sirve de base para:
--         • asociar cada aeronave física a un modelo (tabla aeronave).
--         • definir plantillas de cabina por modelo (tabla configuracion_cabina).
--  Relacionada con:
--    - aeronave (otras tablas referencian idmodelo_aeronave desde aeronave).
--    - configuracion_cabina (otras tablas referencian idmodelo_aeronave).
--    - usuario (FKs de auditoría).
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`modelo_aeronave`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`modelo_aeronave` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idmodelo_aeronave` INT NOT NULL AUTO_INCREMENT,  -- PK interna del modelo

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES DEL MODELO
  -- ===============================================================================================
  `fabricante` VARCHAR(80) NOT NULL,                -- Fabricante (ej.: Airbus, Boeing, Embraer)
  `mdoelo`     VARCHAR(80) NOT NULL,                -- (Tal cual en tu DDL) Nombre de modelo (ej.: A320-200)
  `familia`    VARCHAR(60) NULL,                    -- Familia/serie (ej.: A320 family, 737NG)
  `alcance_km` INT NULL,                            -- Alcance típico en kilómetros
  `velocidad_crucero_kmh` INT NULL,                 -- Velocidad de crucero en km/h
  `capacidad_asiento` INT NULL,                     -- Capacidad típica de asientos (referencial)
  `capacidad_bodega_kg` INT NOT NULL,               -- Capacidad de bodega/carga en kg (referencial)
  `activo` TINYINT NOT NULL,                        -- 1=activo en catálogo, 0=inactivo

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`      DATETIME NULL,                   -- Cuándo se creó el registro
  `actualizado_en` DATETIME NULL,                   -- Última actualización
  `eliminado_en`   DATETIME NULL,                   -- Marca de borrado lógico (si aplica)

  `creado_por`     INT NOT NULL,                    -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT NOT NULL,                   -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`  INT NULL,                        -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,             -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idmodelo_aeronave`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_modelo_aeronave_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_modelo_aeronave_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_modelo_aeronave_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • “mdoelo” se mantiene exactamente como en tu definición original.
--  • Usá esta tabla para normalizar datos técnicos y luego referenciarlos desde “aeronave”.
--  • “configuracion_cabina” define plantillas por cabina basadas en cada modelo de esta tabla.
-- =================================================================================================
