USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: PUERTA
--  Puertas de embarque dentro de un aeropuerto (ej.: A1, B3, C12).
--  Campos clave:
--    • codigo: identificador legible de la puerta (no necesariamente único global).
--    • activo: habilita/deshabilita sin borrar.
--  Dependencias:
--    • aeropuerto(idaeropuerto) → a qué aeropuerto pertenece la puerta.
--    • usuario(idusuario) → auditoría (creado/actualizado/eliminado_por).
--  Recomendación:
--    • Si querés evitar duplicados de código dentro del mismo aeropuerto,
--      agregá un índice único compuesto (aeropuerto, codigo).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `puerta`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `puerta` (
  -- Identificador único
  `idpuerta`            INT NOT NULL AUTO_INCREMENT,

  -- Identidad / estado
  `codigo`              VARCHAR(10) NOT NULL,     -- Ej.: A1, B12
  `activo`              TINYINT NOT NULL,         -- 0 = inactiva, 1 = activa

  -- Auditoría temporal
  `creado_en`           DATETIME NULL,
  `actualizado_en`      DATETIME NULL,
  `eliminado_en`        DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`          INT NULL,
  `actualizado_por`     INT NULL,
  `eliminado_por`       INT NULL,
  `eliminado_motivo`    VARCHAR(200) NULL,

  -- Relación fuerte
  `aeropuerto_idaeropuerto` INT NOT NULL,

  -- Clave primaria
  PRIMARY KEY (`idpuerta`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_puerta_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_puerta_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_puerta_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_puerta_aeropuerto1`
    FOREIGN KEY (`aeropuerto_idaeropuerto`)
    REFERENCES `aeropuerto` (`idaeropuerto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Evitar códigos duplicados dentro del mismo aeropuerto:
--   -- CREATE UNIQUE INDEX `ux_puerta_codigo_aeropuerto`
--   --   ON `puerta` (`aeropuerto_idaeropuerto`, `codigo`);
-- • Búsquedas por aeropuerto:
--   -- CREATE INDEX `ix_puerta_aeropuerto` ON `puerta` (`aeropuerto_idaeropuerto`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: PUERTA
-- ═══════════════════════════════════════════════════════════════════════════════
