-- -----------------------------------------------------
-- Table `Aerolinea`.`tripulacion_miembro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Aerolinea`.`tripulacion_miembro` ;

CREATE TABLE IF NOT EXISTS `Aerolinea`.`tripulacion_miembro` (
  `idtripulacion_miembro` INT NOT NULL AUTO_INCREMENT,
  `tripulacion_idtripulacion` INT NOT NULL,
  `rango_tripulacion_idrango_tripulacion` INT NOT NULL,
  `usuario_idusuario` INT NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NULL,
  `actualizado_por` INT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivio` VARCHAR(200) NULL,
  PRIMARY KEY (`idtripulacion_miembro`),
  CONSTRAINT `fk_tripulacion_miembro_tripulacion1`
    FOREIGN KEY (`tripulacion_idtripulacion`)
    REFERENCES `Aerolinea`.`tripulacion` (`idtripulacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tripulacion_miembro_rango_tripulacion1`
    FOREIGN KEY (`rango_tripulacion_idrango_tripulacion`)
    REFERENCES `Aerolinea`.`rango_tripulacion` (`idrango_tripulacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tripulacion_miembro_usuario1`
    FOREIGN KEY (`usuario_idusuario`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tripulacion_miembro_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tripulacion_miembro_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tripulacion_miembro_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `Aerolinea`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `ix_trip_miembro_trip` ON `Aerolinea`.`tripulacion_miembro` (`tripulacion_idtripulacion`) ;

CREATE INDEX `ix_trip_miembro_rango` ON `Aerolinea`.`tripulacion_miembro` (`rango_tripulacion_idrango_tripulacion`) ;

CREATE UNIQUE INDEX `ux_tripulacion_usuario` ON `Aerolinea`.`tripulacion_miembro` (`tripulacion_idtripulacion` , `usuario_idusuario` ) ;

CREATE UNIQUE INDEX `ux_tripulacion_rango` ON `Aerolinea`.`tripulacion_miembro` (`tripulacion_idtripulacion` , `rango_tripulacion_idrango_tripulacion` ) ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
