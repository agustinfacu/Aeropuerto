USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: BOLETO
--  Tiquete/billete emitido por pasajero y vuelo. Puede quedar “abierto”,
--  emitido, usado, no show, reembolsado o cancelado.
--  Dependencias:
--    • reserva(idreserva)                  → a qué reserva pertenece.
--    • reserva_persona(idreserva_persona)  → pasajero dentro de la reserva.
--    • vuelo(idvuelo)                      → vuelo al que aplica el boleto.
--    • asiento_vuelo(idasiento_vuelo)      → asiento asignado (puede ser NULL).
--    • usuario(idusuario)                  → auditoría (creado/actualizado/eliminado_por).
--  Notas:
--    • Tu esquema define UNIQUE sobre vuelo_idvuelo, reserva_idreserva y
--      reserva_persona_idreserva_persona individualmente (muy restrictivo).
--      Más abajo dejo una alternativa opcional más flexible.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `boleto`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `boleto` (
  -- Identificador único del boleto
  `idboleto`                         INT NOT NULL AUTO_INCREMENT,

  -- Relaciones principales
  `reserva_idreserva`                INT NOT NULL,
  `reserva_persona_idreserva_persona` INT NOT NULL,
  `vuelo_idvuelo`                    INT NOT NULL,
  `asiento_vuelo_idasiento_vuelo`    INT NULL,         -- puede estar sin asiento al crear

  -- Estado y costos
  `estado_boleto` ENUM('ABIERTO','EMITIDO','USADO','NO_SHOW','REEMBOLSADO','CANCELADO') NOT NULL,
  `costo_total`    DECIMAL(12,2) NOT NULL,

  -- Auditoría temporal
  `creado_en`      DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en`   DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`     INT NULL,
  `actualizado_por`INT NULL,
  `eliminado_por`  INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,

  -- Clave primaria
  PRIMARY KEY (`idboleto`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_boleto_reserva1`
    FOREIGN KEY (`reserva_idreserva`)
    REFERENCES `reserva` (`idreserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_boleto_reserva_persona1`
    FOREIGN KEY (`reserva_persona_idreserva_persona`)
    REFERENCES `reserva_persona` (`idreserva_persona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_boleto_vuelo1`
    FOREIGN KEY (`vuelo_idvuelo`)
    REFERENCES `vuelo` (`idvuelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_boleto_asiento_vuelo1`
    FOREIGN KEY (`asiento_vuelo_idasiento_vuelo`)
    REFERENCES `asiento_vuelo` (`idasiento_vuelo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_boleto_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_boleto_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_boleto_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- Índices ÚNICOS (tal cual tu esquema original)
CREATE UNIQUE INDEX `vuelo_idvuelo_UNIQUE`
  ON `boleto` (`vuelo_idvuelo` ASC);

CREATE UNIQUE INDEX `reserva_idreserva_UNIQUE`
  ON `boleto` (`reserva_idreserva` ASC);

CREATE UNIQUE INDEX `reserva_persona_idreserva_persona_UNIQUE`
  ON `boleto` (`reserva_persona_idreserva_persona` ASC);

-- ───────────────────────────────────────────────────────────────────────────────
-- Alternativa recomendada (OPCIONAL, si querés permitir múltiples boletos por vuelo,
-- pero uno solo por (reserva_persona, vuelo) y sin repetir asiento):
--
-- -- DROP INDEX `vuelo_idvuelo_UNIQUE` ON `boleto`;
-- -- DROP INDEX `reserva_idreserva_UNIQUE` ON `boleto`;
-- -- DROP INDEX `reserva_persona_idreserva_persona_UNIQUE` ON `boleto`;
-- -- CREATE UNIQUE INDEX `ux_boleto_pasajero_vuelo`
-- --   ON `boleto` (`reserva_persona_idreserva_persona`, `vuelo_idvuelo`);
-- -- (Opcional) si querés evitar asignar dos boletos al mismo asiento de vuelo:
-- -- CREATE UNIQUE INDEX `ux_boleto_asiento_vuelo` ON `boleto` (`asiento_vuelo_idasiento_vuelo`);
-- ───────────────────────────────────────────────────────────────────────────────

-- (Opcionales recomendados)
-- • Búsquedas por estado:
--   -- CREATE INDEX `ix_boleto_estado` ON `boleto` (`estado_boleto`);
-- • Búsquedas por fechas de auditoría:
--   -- CREATE INDEX `ix_boleto_creado_en` ON `boleto` (`creado_en`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: BOLETO
-- ═══════════════════════════════════════════════════════════════════════════════
