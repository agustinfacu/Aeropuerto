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

-- -----------------------------------------------------
-- Table `Aerolinea`.`persona`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aerolinea`.`persona` ;

CREATE TABLE IF NOT EXISTS `Aerolinea`.`persona` (
  `idpersona` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(80) NOT NULL,
  `apellido` VARCHAR(80) NOT NULL,
  `fecha_de_nacimiento` DATE NOT NULL,
  `creado_en` DATETIME NOT NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NULL,
  `actualizado_por` INT NULL,
  `eliminado_por` INT NULL,
  PRIMARY KEY (`idpersona`),
  CONSTRAINT `fk_persona_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_persona_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_persona_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
