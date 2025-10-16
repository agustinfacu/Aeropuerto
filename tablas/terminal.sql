USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: TERMINAL
--  Terminales dentro de un aeropuerto (T1, T2, etc.).
--  Campos clave:
--    • nombre: identificador legible de la terminal.
--    • activo: habilita/deshabilita sin borrar físicamente.
--  Dependencias:
--    • aeropuerto(idaeropuerto) → a qué aeropuerto pertenece la terminal.
--    • usuario(idusuario) → auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `terminal`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `terminal` (
  -- Identificador único
  `idterminal`             INT NOT NULL AUTO_INCREMENT,

  -- Identidad / estado
  `nombre`                 VARCHAR(60) NOT NULL,
  `activo`                 TINYINT NOT NULL,      -- 0 = inactiva, 1 = activa

  -- Auditoría temporal
  `creado_en`              DATETIME NULL,
  `actualizado_en`         DATETIME NULL,
  `eliminado_en`           DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`             INT NULL,
  `actualizado_por`        INT NULL,
  `eliminado_por`          INT NULL,
  `eliminado_motivo`       VARCHAR(200) NULL,

  -- Relación fuerte
  `aeropuerto_idaeropuerto` INT NOT NULL,

  -- Clave primaria
  PRIMARY KEY (`idterminal`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_terminal_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_temrinal_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_terminal_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_terminal_aeropuerto1`
    FOREIGN KEY (`aeropuerto_idaeropuerto`)
    REFERENCES `aeropuerto` (`idaeropuerto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Búsquedas por aeropuerto:
--   CREATE INDEX `ix_terminal_aeropuerto` ON `terminal` (`aeropuerto_idaeropuerto`);
-- • Evitar nombres duplicados por aeropuerto:
--   -- CREATE UNIQUE INDEX `ux_terminal_nombre_aeropuerto`
--   --   ON `terminal` (`aeropuerto_idaeropuerto`, `nombre`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: TERMINAL
-- ═══════════════════════════════════════════════════════════════════════════════
