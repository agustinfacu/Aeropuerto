USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: PERSONA
--  Detalle de identidad básica para individuos (pasajeros, empleados, etc.).
--  Dependencias:
--    • Auditoría: referencias a usuario.idusuario (quién creó/actualizó/eliminó).
--  Notas:
--    • Las FKs de auditoría usan ON DELETE SET NULL: si el usuario auditor se borra,
--      no se pierde el registro de persona; solo se “desasocia” el autor.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `persona`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `persona` (
  -- Identificador único
  `idpersona`         INT NOT NULL AUTO_INCREMENT,

  -- Identidad
  `nombre`            VARCHAR(80) NOT NULL,
  `apellido`          VARCHAR(80) NOT NULL,

  -- Auditoría temporal
  `creado_en`         DATETIME NOT NULL,
  `actualizado_en`    DATETIME NULL,
  `eliminado_en`      DATETIME NULL,

  -- Auditoría de usuarios (autores de acciones)
  `creado_por`        INT NULL,
  `actualizado_por`   INT NULL,
  `eliminado_por`     INT NULL,

  -- Clave primaria
  PRIMARY KEY (`idpersona`),

  -- ────────────────
  -- Claves foráneas (auditoría)
  -- ────────────────
  CONSTRAINT `fk_persona_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_persona_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_persona_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: PERSONA
-- ═══════════════════════════════════════════════════════════════════════════════
