USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: ASIENTO_VUELO
--  Estado de cada asiento para un vuelo específico (inventario por vuelo).
--  Campos clave:
--    • estado: LIBRE | RESERVADO | EMITIDO | BLOQUEADO.
--    • bloqueado_motivo: texto corto explicando el bloqueo (si aplica).
--    • codigo_asiento: etiqueta human-friendly (ej.: 12A), redundante a `asiento`.
--  Dependencias:
--    • vuelo(idvuelo)   → a qué vuelo pertenece el inventario.
--    • asiento(idasiento) → asiento físico referenciado.
--    • usuario(idusuario) → auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `asiento_vuelo`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `asiento_vuelo` (
  -- Identificador único
  `idasiento_vuelo`     INT NOT NULL AUTO_INCREMENT,

  -- Relaciones principales
  `vuelo_idvuelo`       INT NOT NULL,
  `asiento_idasiento`   INT NOT NULL,

  -- Estado y metadatos
  `estado`              ENUM('LIBRE', 'RESERVADO', 'EMITIDO', 'BLOQUEADO') NOT NULL,
  `bloqueado_motivo`    VARCHAR(100) NULL,
  `codigo_asiento`      VARCHAR(6) NOT NULL,  -- ej.: 12A (útil para reportes/UI)

  -- Auditoría temporal
  `creado_en`           DATETIME NULL,
  `actualizado_en`      DATETIME NULL,
  `eliminado_en`        DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`          INT NULL,
  `actualizado_por`     INT NULL,
  `eliminado_por`       INT NULL,
  `eliminado_motivo`    VARCHAR(200) NULL,

  -- Clave primaria
  PRIMARY KEY (`idasiento_vuelo`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_asiento_vuelo_vuelo1`
    FOREIGN KEY (`vuelo_idvuelo`)
    REFERENCES `vuelo` (`idvuelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_asiento_vuelo_asiento1`
    FOREIGN KEY (`asiento_idasiento`)
    REFERENCES `asiento` (`idasiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_asiento_vuelo_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_asiento_vuelo_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_asiento_vuelo_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Evitar duplicar el mismo asiento dentro del mismo vuelo:
--   CREATE UNIQUE INDEX `ux_asiento_vuelo_vuelo_asiento`
--     ON `asiento_vuelo` (`vuelo_idvuelo`, `asiento_idasiento`);
-- • Búsquedas rápidas por vuelo:
--   CREATE INDEX `ix_asiento_vuelo_vuelo` ON `asiento_vuelo` (`vuelo_idvuelo`);
-- • Búsquedas por estado:
--   CREATE INDEX `ix_asiento_vuelo_estado` ON `asiento_vuelo` (`estado`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: ASIENTO_VUELO
-- ═══════════════════════════════════════════════════════════════════════════════
