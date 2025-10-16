USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: PERMISO
--  Catálogo de permisos (acciones atómicas) para el sistema.
--  Ejemplos de `codigo`: 'USER_CREATE', 'FLIGHT_EDIT', 'CHECKIN_VIEW'.
--  Dependencias:
--    • Auditoría hacia usuario(idusuario): creado/actualizado/eliminado_por.
--  Índices:
--    • `codigo` único para evitar duplicados.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `permiso`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `permiso` (
  -- Identificador único del permiso
  `idpermiso`         INT NOT NULL AUTO_INCREMENT,

  -- Código técnico del permiso (clave funcional única)
  `codigo`            VARCHAR(90) NOT NULL,

  -- Descripción legible del permiso
  `descripcion`       VARCHAR(200) NULL,

  -- Auditoría temporal
  `creado_en`         DATETIME NOT NULL,
  `actualizado_en`    DATETIME NOT NULL,
  `eliminado_en`      DATETIME NULL,

  -- Auditoría de usuarios (quién hizo qué)
  `creado_por`        INT NULL,
  `actualizado_por`   INT NULL,
  `eliminado_por`     INT NULL,
  `eliminado_motivo`  VARCHAR(200) NULL,

  -- Clave primaria
  PRIMARY KEY (`idpermiso`),

  -- ────────────────
  -- Claves foráneas (auditoría)
  -- ────────────────
  CONSTRAINT `fk_permiso_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_permiso_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_permiso_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- Índice único para el código del permiso
CREATE UNIQUE INDEX `codigo_UNIQUE` ON `permiso` (`codigo` ASC);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: PERMISO
-- ═══════════════════════════════════════════════════════════════════════════════
