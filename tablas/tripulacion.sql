-- -----------------------------------------------------
-- Table `Aerolinea`.`tripulacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aerolinea`.`tripulacion` ;

CREATE TABLE IF NOT EXISTS `Aerolinea`.`tripulacion` (
  `idtripulacion` INT NOT NULL AUTO_INCREMENT,
  `estado` ENUM('PUBLICADA', 'BORRADOR', 'CERRADA') NOT NULL,
  `nota` VARCHAR(200) NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NULL,
  `actualizado_por` INT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  PRIMARY KEY (`idtripulacion`),
  CONSTRAINT `fk_tripulacion_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tripulacion_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tripulacion_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
