USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: RESERVA_PERSONA
--  Vincula personas con una reserva y define su tipo (ADULTO/MENOR/INFANTE),
--  además de la documentación usada para viajar.
--  Dependencias:
--    • reserva(idreserva)
--    • persona(idpersona)
--    • documentacion(iddocumentacion)
--    • usuario(idusuario) → auditoría (creado/actualizado/eliminado_por)
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `reserva_persona`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `reserva_persona` (
  -- Identificador único
  `idreserva_persona`        INT NOT NULL AUTO_INCREMENT,

  -- Relaciones principales
  `reserva_idreserva`        INT NOT NULL,
  `persona_idpersona`        INT NOT NULL,

  -- Clasificación del pasajero
  `tipo`                     ENUM('ADULTO', 'MENOR', 'INFANTE') NOT NULL,

  -- Documento seleccionado para este viaje
  `documentacion_iddocumentacion` INT NOT NULL,

  -- Auditoría temporal
  `creado_en`                DATETIME NULL,
  `actualizdo_en`            DATETIME NULL,  -- (sic) en tu esquema
  `eliminado_en`             DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`               INT NULL,
  `actualizado_por`          INT NULL,
  `eliminado_por`            INT NULL,
  `eliminado_motivo`         VARCHAR(200) NULL,

  -- Clave primaria
  PRIMARY KEY (`idreserva_persona`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_reserva_pasajero_reserva1`
    FOREIGN KEY (`reserva_idreserva`)
    REFERENCES `reserva` (`idreserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_pasajero_persona1`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `persona` (`idpersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_persona_documentacion1`
    FOREIGN KEY (`documentacion_iddocumentacion`)
    REFERENCES `documentacion` (`iddocumentacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_persona_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_persona_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_reserva_persona_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Evitar duplicar a la misma persona en la misma reserva:
--   -- CREATE UNIQUE INDEX `ux_reserva_persona`
--   --   ON `reserva_persona` (`reserva_idreserva`, `persona_idpersona`);
-- • Búsquedas por reserva:
--   -- CREATE INDEX `ix_reserva_persona_reserva` ON `reserva_persona` (`reserva_idreserva`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: RESERVA_PERSONA
-- ═══════════════════════════════════════════════════════════════════════════════
