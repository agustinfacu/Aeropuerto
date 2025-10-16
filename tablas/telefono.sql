USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: TELEFONO
--  Teléfonos asociados a una persona (móvil, fijo, trabajo, etc.).
--  Campos clave:
--    • tipo: clasifica el teléfono (ENUM).
--    • es_principal: marca el teléfono preferido de contacto (0/1).
--    • es_whatssap: indica si el número usa WhatsApp (0/1).  ← (sic)
--  Dependencias:
--    • persona(idpersona)  → titular del teléfono.
--    • usuario(idusuario)  → auditoría (creado/actualizado/eliminado_por).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `telefono`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `telefono` (
  -- Identificador único
  `idtelefono`           INT NOT NULL AUTO_INCREMENT,

  -- Datos del teléfono
  `tipo`                 ENUM('movil', 'fijo', 'trabajo', 'otro') NOT NULL,
  `numero`               VARCHAR(35) NOT NULL,
  `es_whatssap`          TINYINT NOT NULL,        -- 0 = no, 1 = sí (nombre heredado)
  `extension`            VARCHAR(6) NULL,         -- interno / extensión
  `es_principal`         TINYINT NOT NULL,        -- 0 = no, 1 = sí

  -- Auditoría temporal
  `creado_en`            DATETIME NOT NULL,
  `actualizado_en`       DATETIME NOT NULL,
  `eliminado_en`         DATETIME NULL,

  -- Auditoría de usuario
  `creado_por`           INT NULL,
  `actualizado_por`      INT NULL,
  `eliminado_por`        INT NULL,
  `eliminado_motivo`     VARCHAR(200) NULL,

  -- Relación fuerte
  `persona_idpersona`    INT NOT NULL,

  -- Clave primaria
  PRIMARY KEY (`idtelefono`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_telefono_persona1`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `persona` (`idpersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_telefono_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_telefono_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_telefono_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Búsquedas por persona:
--   CREATE INDEX `ix_telefono_persona` ON `telefono` (`persona_idpersona`);
-- • Evitar números duplicados por persona:
--   -- CREATE UNIQUE INDEX `ux_telefono_persona_numero`
--   --   ON `telefono` (`persona_idpersona`, `numero`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: TELEFONO
-- ═══════════════════════════════════════════════════════════════════════════════
