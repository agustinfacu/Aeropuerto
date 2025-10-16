USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: AERONAVE
--  Flota de aeronaves de la compañía.
--  Campos clave:
--    • matricula: identificador único de la aeronave (ej.: LV-ABC) → ÚNICO.
--    • estado: activa / en_mantenimiento / retirada.
--    • modelo_aeronave_idmodelo_aeronave: referencia al modelo técnico.
--  Dependencias:
--    • modelo_aeronave(idmodelo_aeronave) → especificaciones técnicas.
--    • usuario(idusuario) → auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `aeronave`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `aeronave` (
  -- Identificador único
  `idaeronave`                          INT NOT NULL AUTO_INCREMENT,

  -- Identidad / estado
  `matricula`                           VARCHAR(15) NOT NULL,  -- ej.: LV-ABC
  `fecha_de_alta`                       DATE NOT NULL,
  `estado`                              ENUM('activa', 'en_mantenimiento', 'retirada') NOT NULL,
  `nota`                                TEXT NULL,

  -- Auditoría temporal
  `creado_en`                           DATETIME NULL,
  `actualizado_en`                      DATETIME NULL,
  `eliminado_en`                        DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`                          INT NULL,
  `actualizado_por`                     INT NULL,
  `eliminado_por`                       INT NULL,
  `eliminado_motivo`                    VARCHAR(200) NULL,

  -- Relación fuerte
  `modelo_aeronave_idmodelo_aeronave`   INT NOT NULL,

  -- Clave primaria
  PRIMARY KEY (`idaeronave`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_aeronave_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_aeronave_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_aeronave_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_aeronave_modelo_aeronave1`
    FOREIGN KEY (`modelo_aeronave_idmodelo_aeronave`)
    REFERENCES `modelo_aeronave` (`idmodelo_aeronave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- Índice único para matrícula
CREATE UNIQUE INDEX `matricula_UNIQUE` ON `aeronave` (`matricula` ASC);

-- (Opcionales recomendados)
-- • Búsquedas por estado:
--   CREATE INDEX `ix_aeronave_estado` ON `aeronave` (`estado`);
-- • Búsquedas por modelo:
--   CREATE INDEX `ix_aeronave_modelo` ON `aeronave` (`modelo_aeronave_idmodelo_aeronave`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: AERONAVE
-- ═══════════════════════════════════════════════════════════════════════════════
