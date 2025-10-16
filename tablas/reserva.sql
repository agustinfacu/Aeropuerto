USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: RESERVA
--  Encabezado de la reserva (estado, precios, moneda y vínculos a usuario/tarifa/promo).
--  Campos clave:
--    • estado: NUEVA | CONFIRMADA | CANCELADA | CHECKIN | VOLADA.
--    • codigo_reserva: localizador de 6 caracteres (ÚNICO).
--    • totales: total_bruto / total_neto en 'moneda' (ISO-4217, p.ej. ARS, USD).
--  Dependencias:
--    • usuario(idusuario)   → dueño/cuenta que realiza la reserva (puede ser NULL).
--    • tarifa(idtarifa)     → tarifa base aplicada.
--    • promocion(idpromocion) → promoción aplicada.
--    • usuario(idusuario)   → auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `reserva`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `reserva` (
  -- Identificador único
  `idreserva`               INT NOT NULL AUTO_INCREMENT,

  -- Estado y localizador
  `estado`                  ENUM('NUEVA','CONFIRMADA','CANCELADA','CHECKIN','VOLADA') NOT NULL,
  `codigo_reserva`          CHAR(6) NOT NULL,     -- localizador único (ej.: ABC123)

  -- Relaciones principales
  `usuario_idusuario`       INT NULL,             -- puede ser anónima/guest → NULL
  `tarifa_idtarifa`         INT NOT NULL,
  `promocion_idpromocion`   INT NOT NULL,

  -- Monetario
  `moneda`                  CHAR(3) NOT NULL,     -- ISO-4217 (ARS, USD, ...)
  `total_bruto`             DECIMAL(12,2) NOT NULL,
  `total_neto`              DECIMAL(12,2) NOT NULL,

  -- Auditoría temporal
  `creado_en`               DATETIME NULL,
  `actualizado_en`          DATETIME NULL,
  `eliminado_en`            DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`              INT NULL,
  `actualizado_por`         INT NULL,
  `eliminado_por`           INT NULL,
  `eliminado_motivo`        VARCHAR(200) NULL,

  -- Clave primaria
  PRIMARY KEY (`idreserva`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_reserva_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_tarifa1`
    FOREIGN KEY (`tarifa_idtarifa`)
    REFERENCES `tarifa` (`idtarifa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_promocion1`
    FOREIGN KEY (`promocion_idpromocion`)
    REFERENCES `promocion` (`idpromocion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- Índice único para el localizador
CREATE UNIQUE INDEX `codigo_reserva_UNIQUE` ON `reserva` (`codigo_reserva` ASC);

-- (Opcionales recomendados)
-- • Búsquedas por usuario/estado:
--   CREATE INDEX `ix_reserva_usuario` ON `reserva` (`usuario_idusuario`);
--   CREATE INDEX `ix_reserva_estado`  ON `reserva` (`estado`);
-- • Búsquedas por fechas de auditoría:
--   CREATE INDEX `ix_reserva_creado_en` ON `reserva` (`creado_en`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: RESERVA
-- ═══════════════════════════════════════════════════════════════════════════════
