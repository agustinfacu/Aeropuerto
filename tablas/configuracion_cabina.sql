USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: CONFIGURACION_CABINA
--  Plantillas de cabina por clase: define filas y asientos por fila.
--  Campos clave:
--    • cabina: ENUM con las clases disponibles.
--    • fila / asiento_por_fila: dimensiones básicas de la cabina.
--  Uso típico:
--    • Se usa como “molde” para generar asientos de un modelo/aeronave,
--      o para validar límites por clase.
--  Dependencias:
--    • usuario(idusuario) → auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `configuracion_cabina`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `configuracion_cabina` (
  -- Identificador único
  `idconfiguracion_cabina`  INT NOT NULL AUTO_INCREMENT,

  -- Clase/categoría de la cabina
  `cabina`                  ENUM('primera clase', 'ejecutivo', 'economica') NOT NULL,

  -- Dimensiones
  `fila`                    INT NOT NULL,        -- cantidad de filas
  `asiento_por_fila`        INT NOT NULL,        -- asientos por cada fila

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
  PRIMARY KEY (`idconfiguracion_cabina`),

  -- ────────────────
  -- Claves foráneas (auditoría)
  -- ────────────────
  CONSTRAINT `fk_configuracion_cabina_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_configuracion_cabina_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_configuracion_cabina_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Si usás esta tabla como catálogo de plantillas y querés evitar duplicados
--   por combinación de (cabina, fila, asiento_por_fila):
--   -- CREATE UNIQUE INDEX `ux_conf_cabina_combo`
--   --   ON `configuracion_cabina` (`cabina`, `fila`, `asiento_por_fila`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: CONFIGURACION_CABINA
-- ═══════════════════════════════════════════════════════════════════════════════
