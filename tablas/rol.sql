USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: ROL
--  Rol del sistema (admin, operador, etc.). Permite auditoría básica.
--  Dependencias:
--    - FKs a usuario(idusuario) para trazabilidad (creado/actualizado/eliminado).
--  Notas:
--    • Si todavía no existe la tabla `usuario`, comentá los FOREIGN KEY y
--      ejecutalos luego con ALTER TABLE cuando `usuario` ya esté creada.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `rol`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `rol` (
  -- Identificador único del rol
  `idrol`              INT NOT NULL AUTO_INCREMENT,

  -- Nombre corto del rol (ej.: 'admin', 'agente', 'supervisor')
  `nombre`             VARCHAR(40) NOT NULL,

  -- Descripción más extensa del alcance del rol
  `descripcion`        TEXT NULL,

  -- Auditoría temporal
  `creado_en`          DATETIME NOT NULL,
  `actualizado_en`     DATETIME NOT NULL,
  `eliminado_en`       DATETIME NULL,

  -- Auditoría de usuarios (quién hizo qué)
  `creado_por`         INT NULL,
  `actualizado_por`    INT NULL,
  `eliminado_por`      INT NULL,
  `eliminado_motivo`   VARCHAR(200) NULL,

  -- Clave primaria
  PRIMARY KEY (`idrol`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_rol_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: ROL
-- ═══════════════════════════════════════════════════════════════════════════════
