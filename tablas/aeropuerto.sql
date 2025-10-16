USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: AEROPUERTO
--  Catálogo de aeropuertos (IATA de 3 letras, ubicación y metadatos).
--  Campos clave:
--    • tag: código IATA (3 caracteres) → ÚNICO.
--    • latitud/longitud: precisión DECIMAL(9,6).
--    • huso_horario: zona IANA (ej.: 'America/Argentina/Buenos_Aires').
--    • activo: habilita/deshabilita sin borrar.
--  Dependencias:
--    • usuario(idusuario) → auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `aeropuerto`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `aeropuerto` (
  -- Identificador único
  `idaeropuerto`     INT NOT NULL AUTO_INCREMENT,

  -- Identidad y ubicación
  `tag`              VARCHAR(3) NOT NULL,       -- Código IATA (EZE, AEP, GRU, etc.)
  `nombre`           VARCHAR(150) NOT NULL,     -- Nombre oficial
  `ciudad`           VARCHAR(120) NOT NULL,     -- Ciudad principal
  `latitud`          DECIMAL(9,6) NOT NULL,     -- Latitud geográfica
  `longitud`         DECIMAL(9,6) NOT NULL,     -- Longitud geográfica
  `huso_horario`     VARCHAR(45) NOT NULL,      -- Zona horaria IANA
  `activo`           TINYINT NOT NULL,          -- 0 = inactivo, 1 = activo

  -- Auditoría temporal
  `creado_en`        DATETIME NULL,
  `actualizado_en`   DATETIME NULL,
  `eliminado_en`     DATETIME NULL,

  -- Auditoría de usuario
  `creado_por`       INT NULL,
  `actualizado_por`  INT NULL,
  `eliminado_por`    INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,

  -- Clave primaria
  PRIMARY KEY (`idaeropuerto`),

  -- ────────────────
  -- Claves foráneas (auditoría)
  -- ────────────────
  CONSTRAINT `fk_aeropuerto_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_aeropuerto_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_aeropuerto_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- Índice único para el código IATA
CREATE UNIQUE INDEX `tag_UNIQUE` ON `aeropuerto` (`tag` ASC);

-- (Opcionales recomendados)
-- • Búsquedas por ciudad:
--   CREATE INDEX `ix_aeropuerto_ciudad` ON `aeropuerto` (`ciudad`);
-- • Búsquedas por activo:
--   CREATE INDEX `ix_aeropuerto_activo` ON `aeropuerto` (`activo`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: AEROPUERTO
-- ═══════════════════════════════════════════════════════════════════════════════
