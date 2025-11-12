-- -----------------------------------------------------
-- Table `Aerolinea`.`rango_tripulacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aerolinea`.`rango_tripulacion` ;

CREATE TABLE IF NOT EXISTS `Aerolinea`.`rango_tripulacion` (
  `idrango_tripulacion` INT NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(40) NOT NULL,
  `descripcion` VARCHAR(200) NULL,
  `activo` TINYINT NOT NULL,
  `creado_por` INT NULL,
  `actualizado_por` INT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  PRIMARY KEY (`idrango_tripulacion`),
  CONSTRAINT `fk_rango_tripulacion_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rango_tripulacion_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rango_triupulacion_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `codigo_UNIQUE` ON `Aerolinea`.`rango_tripulacion` (`codigo`) ;
