USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: MODELO_AERONAVE
--  Catálogo técnico de modelos de aeronave (fabricante, familia, capacidades).
--  Campos clave:
--    • fabricante + mdoelo (sic): identificación textual del modelo.
--    • capacidades: asientos y bodega (kg), alcance y velocidad de crucero.
--    • activo: habilita/deshabilita sin borrar físicamente.
--  Dependencias:
--    • usuario(idusuario) → auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `modelo_aeronave`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `modelo_aeronave` (
  -- Identificador único
  `idmodelo_aeronave`      INT NOT NULL AUTO_INCREMENT,

  -- Identificación del modelo
  `fabricante`             VARCHAR(80) NOT NULL,
  `mdoelo`                 VARCHAR(80) NOT NULL,   -- ← (sic) nombre del modelo (p.ej. 737-800)
  `familia`                VARCHAR(60) NULL,       -- p.ej. 737, A320, E-Jet

  -- Especificaciones
  `alcance_km`             INT NULL,               -- alcance aproximado en km
  `velocidad_crucero_kmh`  INT NULL,               -- velocidad de crucero en km/h
  `capacidad_asiento`      INT NULL,               -- cantidad de asientos totales
  `capacidad_bodega_kg`    INT NOT NULL,           -- capacidad de bodega en kg

  -- Estado
  `activo`                 TINYINT NOT NULL,       -- 0 = inactivo, 1 = activo

  -- Auditoría temporal
  `creado_en`              DATETIME NULL,
  `actualizado_en`         DATETIME NULL,
  `eliminado_en`           DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`             INT NULL,
  `actualizado_por`        INT NULL,
  `eliminado_por`          INT NULL,
  `eliminado_motivo`       VARCHAR(200) NULL,

  -- Clave primaria
  PRIMARY KEY (`idmodelo_aeronave`),

  -- ────────────────
  -- Claves foráneas (auditoría)
  -- ────────────────
  CONSTRAINT `fk_modelo_aeronave_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_modelo_aeronave_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_modelo_aeronave_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Búsquedas por fabricante/modelo:
--   CREATE INDEX `ix_modelo_aeronave_fabricante` ON `modelo_aeronave` (`fabricante`);
--   CREATE INDEX `ix_modelo_aeronave_mdoelo` ON `modelo_aeronave` (`mdoelo`);
-- • Evitar duplicados por fabricante+modelo:
--   -- CREATE UNIQUE INDEX `ux_modelo_fabricante_modelo`
--   --   ON `modelo_aeronave` (`fabricante`, `mdoelo`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: MODELO_AERONAVE
-- ═══════════════════════════════════════════════════════════════════════════════
