USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: PROMOCION
--  Promociones/bonificaciones asociadas a una tarifa.
--  Campos clave:
--    • nombre: identificador legible de la promo.
--    • valor: porcentaje o unidad (según definas en la app).
--    • activo: habilita/deshabilita la promo sin borrarla.
--  Dependencias:
--    • tarifa(idtarifa)  → a qué tarifa aplica la promoción.
--    • usuario(idusuario)→ auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `promocion`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `promocion` (
  -- Identificador único
  `idpromocion`        INT NOT NULL AUTO_INCREMENT,

  -- Identidad / reglas
  `nombre`             VARCHAR(120) NOT NULL,
  `descripcion`        VARCHAR(200) NULL,
  `valor`              SMALLINT NOT NULL,   -- interpreta como %, puntos, etc. según tu negocio
  `activo`             TINYINT NOT NULL,    -- 0 = inactiva, 1 = activa

  -- Relación fuerte
  `tarifa_idtarifa`    INT NOT NULL,

  -- Auditoría temporal
  `creado_en`          DATETIME NULL,
  `actualizado_en`     DATETIME NULL,
  `eliminado_en`       DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`         INT NULL,
  `actualizado_por`    INT NULL,
  `eliminado_por`      INT NULL,
  `eliminado_motivo`   VARCHAR(200) NULL,

  -- Clave primaria
  PRIMARY KEY (`idpromocion`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_promocion_tarifa1`
    FOREIGN KEY (`tarifa_idtarifa`)
    REFERENCES `tarifa` (`idtarifa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_promocion_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_promocion_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_promocion_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Búsquedas por tarifa/estado:
--   CREATE INDEX `ix_promocion_tarifa` ON `promocion` (`tarifa_idtarifa`);
--   CREATE INDEX `ix_promocion_activo` ON `promocion` (`activo`);
-- • Evitar nombres duplicados por tarifa:
--   -- CREATE UNIQUE INDEX `ux_promocion_nombre_tarifa`
--   --   ON `promocion` (`tarifa_idtarifa`, `nombre`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: PROMOCION
-- ═══════════════════════════════════════════════════════════════════════════════
