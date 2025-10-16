USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: ROL_PERMISO
--  Vincula roles con permisos (M:N). Incluye campos de auditoría.
--  Dependencias:
--    • permiso(idpermiso)
--    • rol(idrol)
--    • usuario(idusuario) para auditoría (creado/actualizado/eliminado_por)
--  Nota:
--    • Si querés evitar duplicados (mismo rol-permiso repetido), podés agregar
--      un índice único compuesto sobre (rol_idrol, permiso_idpermiso).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `rol_permiso`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `rol_permiso` (
  -- Identificador de la fila de relación
  `idrol_permiso`       INT NOT NULL AUTO_INCREMENT,

  -- Auditoría temporal
  `creado_en`           DATETIME NOT NULL,
  `actualizado_en`      DATETIME NOT NULL,
  `eliminado_en`        DATETIME NULL,

  -- Auditoría de usuario
  `creado_por`          INT NULL,
  `actualizado_por`     INT NULL,
  `eliminado_por`       INT NULL,
  `eliminado_motivo`    VARCHAR(200) NULL,

  -- Relaciones principales
  `permiso_idpermiso`   INT NOT NULL,
  `rol_idrol`           INT NOT NULL,

  -- Clave primaria
  PRIMARY KEY (`idrol_permiso`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_rol_permiso_permiso1`
    FOREIGN KEY (`permiso_idpermiso`)
    REFERENCES `permiso` (`idpermiso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_permiso_rol1`
    FOREIGN KEY (`rol_idrol`)
    REFERENCES `rol` (`idrol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_permiso_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_permiso_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_permiso_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- (Opcional recomendado) Evitar duplicados rol-permiso:
-- CREATE UNIQUE INDEX `ux_rol_permiso_pair`
--   ON `rol_permiso` (`rol_idrol`, `permiso_idpermiso`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: ROL_PERMISO
-- ═══════════════════════════════════════════════════════════════════════════════
