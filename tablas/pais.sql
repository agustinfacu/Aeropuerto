USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: PAIS
--  Catálogo de países para normalizar direcciones y referencias geográficas.
--  Campos clave:
--    • tag: código ISO-3166-1 alfa-2 (AR, BR, US, etc.) → ÚNICO.
--    • activo: habilita/deshabilita el país sin borrarlo.
--  Dependencias:
--    • usuario(idusuario) para auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `pais`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `pais` (
  -- Identificador único del país
  `idpais`            INT NOT NULL AUTO_INCREMENT,

  -- Código ISO-3166-1 alfa-2 (AR, BR, US, ...)
  `tag`               VARCHAR(2) NOT NULL,

  -- Nombre oficial/estándar del país
  `nombre`            VARCHAR(90) NOT NULL,

  -- Auditoría temporal
  `creado_en`         DATETIME NULL,
  `actualizado_en`    DATETIME NULL,
  `eliminado_en`      DATETIME NULL,

  -- Auditoría de usuario
  `creado_por`        INT NULL,
  `actualizado_por`   INT NULL,
  `eliminado_por`     INT NULL,
  `eliminado_motivo`  VARCHAR(200) NULL,

  -- Estado lógico
  `activo`            TINYINT NOT NULL,

  -- Clave primaria
  PRIMARY KEY (`idpais`),

  -- ────────────────
  -- Claves foráneas (auditoría)
  -- ────────────────
  CONSTRAINT `fk_pais_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_pais_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_pais_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- Índice único para el código de país (evita duplicados)
CREATE UNIQUE INDEX `tag_UNIQUE` ON `pais` (`tag` ASC);

-- (Opcional) Índice para búsquedas por nombre:
-- CREATE INDEX `ix_pais_nombre` ON `pais` (`nombre`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: PAIS
-- ═══════════════════════════════════════════════════════════════════════════════
