USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: ASIENTO
--  Asientos físicos de una aeronave: clase/cabina, fila y columna (letra).
--  Campos clave:
--    • cabina: 'primera clase' | 'ejecutivo' | 'economica'.
--    • fila: número de fila (SMALLINT).
--    • columna: letra de asiento (A, B, C, ...).
--    • codigo_asiento: etiqueta legible (p.ej., 12A).
--    • flags: asiento_bulkhead (mampara), asiento_en_salida (fila de emergencia).
--  Dependencias:
--    • aeronave(idaeronave) → a qué avión pertenece el asiento.
--    • usuario(idusuario)   → auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `asiento`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `asiento` (
  -- Identificador único
  `idasiento`            INT NOT NULL AUTO_INCREMENT,

  -- Identidad del asiento
  `cabina`               ENUM('primera clase', 'ejecutivo', 'economica') NOT NULL,
  `fila`                 SMALLINT NOT NULL,
  `columna`              CHAR(1) NOT NULL,
  `codigo_asiento`       VARCHAR(6) NOT NULL,  -- etiqueta legible (ej.: 12A)

  -- Atributos del asiento
  `asiento_bulkhead`     TINYINT NOT NULL,     -- 0/1: pegado a mampara
  `asiento_en_salida`    TINYINT NOT NULL,     -- 0/1: fila de emergencia

  -- Auditoría temporal
  `creado_en`            DATETIME NULL,
  `actualizado_en`       DATETIME NULL,
  `eliminado_en`         DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`           INT NULL,
  `actualizado_por`      INT NULL,
  `eliminado_por`        INT NULL,
  `eliminado_motivo`     VARCHAR(200) NULL,

  -- Notas y relación fuerte
  `nota`                 VARCHAR(200) NULL,
  `aeronave_idaeronave`  INT NOT NULL,

  -- Clave primaria
  PRIMARY KEY (`idasiento`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_asiento_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_asiento_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_asiento_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_asiento_aeronave1`
    FOREIGN KEY (`aeronave_idaeronave`)
    REFERENCES `aeronave` (`idaeronave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- Índices ÚNICOS (tal como en tu esquema original)
CREATE UNIQUE INDEX `cabina_UNIQUE`  ON `asiento` (`cabina`  ASC);
CREATE UNIQUE INDEX `fila_UNIQUE`    ON `asiento` (`fila`    ASC);
CREATE UNIQUE INDEX `columna_UNIQUE` ON `asiento` (`columna` ASC);

-- ───────────────────────────────────────────────────────────────────────────────
-- Alternativa recomendada (OPCIONAL, no ejecutar si mantenés los UNIQUE de arriba):
-- Para evitar duplicados de asientos dentro de una misma aeronave,
-- suele usarse un índice único compuesto por (aeronave, cabina, fila, columna).
-- Descomentar si querés esa lógica y eliminar los tres UNIQUE individuales.
--
-- -- DROP INDEX `cabina_UNIQUE`  ON `asiento`;
-- -- DROP INDEX `fila_UNIQUE`    ON `asiento`;
-- -- DROP INDEX `columna_UNIQUE` ON `asiento`;
-- -- CREATE UNIQUE INDEX `ux_asiento_por_aeronave`
-- --   ON `asiento` (`aeronave_idaeronave`, `cabina`, `fila`, `columna`);
-- ───────────────────────────────────────────────────────────────────────────────

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: ASIENTO
-- ═══════════════════════════════════════════════════════════════════════════════
