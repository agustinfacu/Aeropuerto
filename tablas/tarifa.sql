USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: TARIFA
--  Catálogo de tarifas por clase de cabina (económica, ejecutiva, etc.).
--  Campos clave:
--    • nombre: ENUM de clases disponibles (se indexa como único).
--    • precio, impuesto, tasa_fija, tarifacol: componentes del precio.
--    • vigencia_desde / vigencia_hasta: ventana de validez.
--    • condiciones: texto con reglas y restricciones.
--  Dependencias:
--    • usuario(idusuario) → auditoría (creado/actualizado/eliminado_por).
--  Notas:
--    • Podés validar que desde ≤ hasta con CHECK en MySQL 8.0+ (opcional).
--    • El índice único en `nombre` evita duplicar clases.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `tarifa`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `tarifa` (
  -- Identificador único
  `idtarifa`            INT NOT NULL AUTO_INCREMENT,

  -- Identidad de la tarifa (por clase)
  `nombre`              ENUM('Primera clase', 'Ejecutivo', 'Economica', 'Economica plus') NOT NULL,

  -- Componentes del precio
  `precio`              DECIMAL(12,2) NOT NULL,  -- base
  `impuesto`            DECIMAL(5,2)  NOT NULL,  -- % (0–100)
  `tasa_fija`           DECIMAL(12,2) NOT NULL,  -- cargos fijos
  `tarifacol`           DECIMAL(12,2) NOT NULL,  -- (sic) campo heredado de tu esquema

  -- Vigencia
  `vigencia_desde`      DATE NOT NULL,
  `vigencia_hasta`      DATE NOT NULL,

  -- Estado
  `activo`              TINYINT NOT NULL,        -- 0 = inactiva, 1 = activa

  -- Auditoría temporal
  `creado_en`           DATETIME NULL,
  `actualizado_en`      DATETIME NULL,
  `eliminado_en`        DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`          INT NULL,
  `actualizado_por`     INT NULL,
  `eliminado_por`       INT NULL,
  `eliminado_motivio`   VARCHAR(200) NULL,       -- (sic) motivo de eliminación

  -- Reglas/observaciones
  `condiciones`         TEXT NOT NULL,

  -- Clave primaria
  PRIMARY KEY (`idtarifa`),

  -- ────────────────
  -- Claves foráneas (auditoría)
  -- ────────────────
  CONSTRAINT `fk_tarifa_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_tarifa_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_tarifa_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

  -- (Opcional con MySQL 8.0+)
  -- ,CONSTRAINT `ck_tarifa_vigencia` CHECK (`vigencia_desde` <= `vigencia_hasta`)
)
ENGINE = InnoDB;

-- Índice único para el nombre de la tarifa (evita duplicados por clase)
CREATE UNIQUE INDEX `nombre_UNIQUE` ON `tarifa` (`nombre` ASC);

-- (Opcionales recomendados)
-- • Búsquedas por estado/fecha:
--   -- CREATE INDEX `ix_tarifa_activo` ON `tarifa` (`activo`);
--   -- CREATE INDEX `ix_tarifa_vigencia_desde` ON `tarifa` (`vigencia_desde`);
--   -- CREATE INDEX `ix_tarifa_vigencia_hasta` ON `tarifa` (`vigencia_hasta`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: TARIFA
-- ═══════════════════════════════════════════════════════════════════════════════
