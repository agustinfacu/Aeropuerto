-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`rol`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`rol` ;

CREATE TABLE IF NOT EXISTS `mydb`.`rol` (
  `idrol` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(40) NOT NULL,
  `descripcion` TEXT NULL,
  `creado_en` DATETIME NOT NULL,
  `actualizado_en` DATETIME NOT NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  PRIMARY KEY (`idrol`),
  CONSTRAINT `fk_rol_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rol_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rol_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `nombre_UNIQUE` ON `mydb`.`rol` (`nombre` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`usuario` ;

CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (
  `idusuario` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(254) NOT NULL,
  `email_norm` VARCHAR(254) NULL,
  `password_hash` VARBINARY(255) NOT NULL,
  `passwrod_algo` ENUM('argon2id', 'bcrypt') NOT NULL,
  `password_actualizado_en` DATETIME NOT NULL,
  `verificacion_email` TINYINT NOT NULL,
  `verificacion_token_hash` VARBINARY(32) NULL,
  `verificacion_expira` DATETIME NULL,
  `reset_token_hash` VARBINARY(32) NULL,
  `reset_expira` DATETIME NULL,
  `intentos_fallidos` SMALLINT NULL,
  `bloqueado_hasta` DATETIME NULL,
  `ultimo_acceso_en` DATETIME NULL,
  `creado_en` DATETIME NOT NULL,
  `actualizado_en` DATETIME NOT NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NULL,
  `actualizado_por` INT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `usuariocol` VARCHAR(45) NULL,
  `rol_idrol` INT NOT NULL,
  `persona_idpersona` INT NOT NULL,
  PRIMARY KEY (`idusuario`),
  CONSTRAINT `fk_usuario_rol1`
    FOREIGN KEY (`rol_idrol`)
    REFERENCES `mydb`.`rol` (`idrol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_persona1`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `mydb`.`persona` (`idpersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_norm_UNIQUE` ON `mydb`.`usuario` (`email_norm` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`persona`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`persona` ;

CREATE TABLE IF NOT EXISTS `mydb`.`persona` (
  `idpersona` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(80) NOT NULL,
  `apellido` VARCHAR(80) NOT NULL,
  `creado_en` DATETIME NOT NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  PRIMARY KEY (`idpersona`),
  CONSTRAINT `fk_persona_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_persona_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_persona_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`permiso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`permiso` ;

CREATE TABLE IF NOT EXISTS `mydb`.`permiso` (
  `idpermiso` INT NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(90) NOT NULL,
  `descripcion` VARCHAR(200) NULL,
  `creado_en` DATETIME NOT NULL,
  `actualizado_en` DATETIME NOT NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  PRIMARY KEY (`idpermiso`),
  CONSTRAINT `fk_permiso_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_permiso_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_permiso_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `codigo_UNIQUE` ON `mydb`.`permiso` (`codigo` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`rol_permiso`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`rol_permiso` ;

CREATE TABLE IF NOT EXISTS `mydb`.`rol_permiso` (
  `idrol_permiso` INT NOT NULL AUTO_INCREMENT,
  `creado_en` DATETIME NOT NULL,
  `actualizado_en` DATETIME NOT NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `permiso_idpermiso` INT NOT NULL,
  `rol_idrol` INT NOT NULL,
  PRIMARY KEY (`idrol_permiso`),
  CONSTRAINT `fk_rol_permiso_permiso1`
    FOREIGN KEY (`permiso_idpermiso`)
    REFERENCES `mydb`.`permiso` (`idpermiso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rol_permiso_rol1`
    FOREIGN KEY (`rol_idrol`)
    REFERENCES `mydb`.`rol` (`idrol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rol_permiso_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rol_permiso_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rol_permiso_eliminado_por`
    FOREIGN KEY ()
    REFERENCES `mydb`.`persona` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`documentacion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`documentacion` ;

CREATE TABLE IF NOT EXISTS `mydb`.`documentacion` (
  `iddocumentacion` INT NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('DNI', 'PASAPORTE', 'OTRO') NOT NULL,
  `numero` VARCHAR(32) NOT NULL,
  `pais_emisor` VARCHAR(2) NOT NULL,
  `estado` ENUM('VALIDO', 'VENCIDO', 'OBSERVADO', 'OTRO') NOT NULL,
  `autoridad` VARCHAR(130) NOT NULL,
  `fecha_emision` DATETIME NOT NULL,
  `fecha_vencimiento` DATETIME NOT NULL,
  `observacion` TEXT NULL,
  `creado_en` DATETIME NOT NULL,
  `actualizado_en` DATETIME NOT NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_en` DATETIME NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `persona_idpersona` INT NOT NULL,
  PRIMARY KEY (`iddocumentacion`),
  CONSTRAINT `fk_documentacion_persona1`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `mydb`.`persona` (`idpersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_documentacion_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_documentacion_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`direccion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`direccion` ;

CREATE TABLE IF NOT EXISTS `mydb`.`direccion` (
  `iddireccion` INT NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('Domicilio', 'Laboral', 'Comercial', 'Otro') NOT NULL,
  `pais` CHAR(2) NOT NULL,
  `provincia` VARCHAR(120) NULL,
  `ciudad` VARCHAR(120) NOT NULL,
  `cp` VARCHAR(15) NULL,
  `calle` VARCHAR(120) NOT NULL,
  `numero` VARCHAR(15) NOT NULL,
  `piso` VARCHAR(10) NULL,
  `depto` VARCHAR(10) NULL,
  `comentario` TEXT NULL,
  `es_principal` TINYINT NOT NULL,
  `creado_en` DATETIME NOT NULL,
  `actualizado_en` DATETIME NOT NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `persona_idpersona` INT NOT NULL,
  PRIMARY KEY (`iddireccion`),
  CONSTRAINT `fk_direccion_persona`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `mydb`.`persona` (`idpersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_direccion_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_direccion_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_direccion_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`telefono`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`telefono` ;

CREATE TABLE IF NOT EXISTS `mydb`.`telefono` (
  `idtelefono` INT NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('movil', 'fijo', 'trabajo', 'otro') NOT NULL,
  `numero` VARCHAR(35) NOT NULL,
  `es_whatssap` TINYINT NOT NULL,
  `extension` VARCHAR(6) NULL,
  `es_principal` TINYINT NOT NULL,
  `creado_en` DATETIME NOT NULL,
  `actualizado_en` DATETIME NOT NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `persona_idpersona` INT NOT NULL,
  PRIMARY KEY (`idtelefono`),
  CONSTRAINT `fk_telefono_persona1`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `mydb`.`persona` (`idpersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_telefono_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_telefono_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_telefono_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pais`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`pais` ;

CREATE TABLE IF NOT EXISTS `mydb`.`pais` (
  `idpais` INT NOT NULL AUTO_INCREMENT,
  `tag` VARCHAR(2) NOT NULL,
  `nombre` VARCHAR(90) NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `activo` TINYINT NOT NULL,
  PRIMARY KEY (`idpais`),
  CONSTRAINT `fk_pais_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pais_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pais_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `tag_UNIQUE` ON `mydb`.`pais` (`tag` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`aeropuerto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`aeropuerto` ;

CREATE TABLE IF NOT EXISTS `mydb`.`aeropuerto` (
  `idaeropuerto` INT NOT NULL AUTO_INCREMENT,
  `tag` VARCHAR(3) NOT NULL,
  `nombre` VARCHAR(150) NOT NULL,
  `ciudad` VARCHAR(120) NOT NULL,
  `latitud` DECIMAL(9,6) NOT NULL,
  `longitud` DECIMAL(9,6) NOT NULL,
  `huso_horario` VARCHAR(45) NOT NULL,
  `activo` TINYINT NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `pais_idpais` INT NOT NULL,
  PRIMARY KEY (`idaeropuerto`),
  CONSTRAINT `fk_aeropuerto_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_aeropuerto_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_aeropuerto_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_aeropuerto_pais1`
    FOREIGN KEY (`pais_idpais`)
    REFERENCES `mydb`.`pais` (`idpais`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `tag_UNIQUE` ON `mydb`.`aeropuerto` (`tag` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`terminal`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`terminal` ;

CREATE TABLE IF NOT EXISTS `mydb`.`terminal` (
  `idterminal` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(60) NOT NULL,
  `activo` TINYINT NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `aeropuerto_idaeropuerto` INT NOT NULL,
  PRIMARY KEY (`idterminal`),
  CONSTRAINT `fk_terminal_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_temrinal_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_terminal_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_terminal_aeropuerto1`
    FOREIGN KEY (`aeropuerto_idaeropuerto`)
    REFERENCES `mydb`.`aeropuerto` (`idaeropuerto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`puerta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`puerta` ;

CREATE TABLE IF NOT EXISTS `mydb`.`puerta` (
  `idpuerta` INT NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(10) NOT NULL,
  `activo` TINYINT NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `terminal_idterminal` INT NOT NULL,
  PRIMARY KEY (`idpuerta`),
  CONSTRAINT `fk_puerta_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_puerta_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_puerta_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_puerta_terminal1`
    FOREIGN KEY (`terminal_idterminal`)
    REFERENCES `mydb`.`terminal` (`idterminal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`modelo_aeronave`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`modelo_aeronave` ;

CREATE TABLE IF NOT EXISTS `mydb`.`modelo_aeronave` (
  `idmodelo_aeronave` INT NOT NULL AUTO_INCREMENT,
  `fabricante` VARCHAR(80) NOT NULL,
  `mdoelo` VARCHAR(80) NOT NULL,
  `familia` VARCHAR(60) NULL,
  `alcance_km` INT NULL,
  `velocidad_crucero_kmh` INT NULL,
  `capacidad_asiento` INT NULL,
  `capacidad_bodega_kg` INT NOT NULL,
  `activo` TINYINT NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  PRIMARY KEY (`idmodelo_aeronave`),
  CONSTRAINT `fk_modelo_aeronave_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_modelo_aeronave_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_modelo_aeronave_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`configuracion_cabina`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`configuracion_cabina` ;

CREATE TABLE IF NOT EXISTS `mydb`.`configuracion_cabina` (
  `idconfiguracion_cabina` INT NOT NULL AUTO_INCREMENT,
  `cabina` ENUM('primera clase', 'ejecutivo', 'economica') NOT NULL,
  `fila` INT NOT NULL,
  `asiento_por_fila` INT NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `modelo_aeronave_idmodelo_aeronave` INT NOT NULL,
  PRIMARY KEY (`idconfiguracion_cabina`),
  CONSTRAINT `fk_configuracion_cabina_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_configuracion_cabina_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_configuracion_cabina_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_configuracion_cabina_modelo_aeronave1`
    FOREIGN KEY (`modelo_aeronave_idmodelo_aeronave`)
    REFERENCES `mydb`.`modelo_aeronave` (`idmodelo_aeronave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`aeronave`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`aeronave` ;

CREATE TABLE IF NOT EXISTS `mydb`.`aeronave` (
  `idaeronave` INT NOT NULL AUTO_INCREMENT,
  `matricula` VARCHAR(15) NOT NULL,
  `fecha_de_alta` DATE NOT NULL,
  `estado` ENUM('activa', 'en_mantenimiento', 'retirada') NOT NULL,
  `nota` TEXT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `modelo_aeronave_idmodelo_aeronave` INT NOT NULL,
  PRIMARY KEY (`idaeronave`),
  CONSTRAINT `fk_aeronave_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_aeronave_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_aeronave_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_aeronave_modelo_aeronave1`
    FOREIGN KEY (`modelo_aeronave_idmodelo_aeronave`)
    REFERENCES `mydb`.`modelo_aeronave` (`idmodelo_aeronave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `matricula_UNIQUE` ON `mydb`.`aeronave` (`matricula` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`asiento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`asiento` ;

CREATE TABLE IF NOT EXISTS `mydb`.`asiento` (
  `idasiento` INT NOT NULL AUTO_INCREMENT,
  `cabina` ENUM('primera clase', 'ejecutivo', 'economica') NOT NULL,
  `fila` SMALLINT NOT NULL,
  `columna` CHAR(1) NOT NULL,
  `codigo_asiento` VARCHAR(6) NOT NULL,
  `asiento_bulkhead` TINYINT NOT NULL,
  `asiento_en_salida` TINYINT NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `nota` VARCHAR(200) NULL,
  `aeronave_idaeronave` INT NOT NULL,
  PRIMARY KEY (`idasiento`),
  CONSTRAINT `fk_asiento_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_asiento_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_asiento_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_asiento_aeronave1`
    FOREIGN KEY (`aeronave_idaeronave`)
    REFERENCES `mydb`.`aeronave` (`idaeronave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `cabina_UNIQUE` ON `mydb`.`asiento` (`cabina` ASC) VISIBLE;

CREATE UNIQUE INDEX `fila_UNIQUE` ON `mydb`.`asiento` (`fila` ASC) VISIBLE;

CREATE UNIQUE INDEX `columna_UNIQUE` ON `mydb`.`asiento` (`columna` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`ruta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`ruta` ;

CREATE TABLE IF NOT EXISTS `mydb`.`ruta` (
  `idruta` INT NOT NULL AUTO_INCREMENT,
  `distancia_km` INT NOT NULL,
  `timepo_estimado` SMALLINT NULL,
  `activo` TINYINT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  `origen_aeropuerto` INT NOT NULL,
  `destino_aeropuerto` INT NOT NULL,
  PRIMARY KEY (`idruta`),
  CONSTRAINT `fk_ruta_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ruta_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ruta_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ruta_origen_aeropuerto`
    FOREIGN KEY (`origen_aeropuerto`)
    REFERENCES `mydb`.`aeropuerto` (`idaeropuerto`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ruta_destino_aeropuerto`
    FOREIGN KEY (`destino_aeropuerto`)
    REFERENCES `mydb`.`aeropuerto` (`idaeropuerto`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `origen_aeropuerto_UNIQUE` ON `mydb`.`ruta` (`origen_aeropuerto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`vuelo_programado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`vuelo_programado` ;

CREATE TABLE IF NOT EXISTS `mydb`.`vuelo_programado` (
  `idvuelo_programado` INT NOT NULL AUTO_INCREMENT,
  `codigo_vuelo` VARCHAR(10) NOT NULL,
  `frecuencia` VARCHAR(64) NULL,
  `hora_salida` TIME NULL,
  `hora_llegada` TIME NULL,
  `equipo_preferido` VARCHAR(45) NULL,
  `activo` TINYINT NULL,
  `ruta_idruta` INT NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  PRIMARY KEY (`idvuelo_programado`),
  CONSTRAINT `fk_vuelo_programado_ruta1`
    FOREIGN KEY (`ruta_idruta`)
    REFERENCES `mydb`.`ruta` (`idruta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vuelo_programado_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vuelo_programado_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vuelo_programado_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vuelo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`vuelo` ;

CREATE TABLE IF NOT EXISTS `mydb`.`vuelo` (
  `idvuelo` INT NOT NULL AUTO_INCREMENT,
  `fecha_operacion` DATE NOT NULL,
  `std` DATETIME NULL,
  `sta` DATETIME NULL,
  `etd` DATETIME NULL,
  `eta` DATETIME NULL,
  `atd` DATETIME NULL,
  `ata` DATETIME NULL,
  `estado` ENUM('programado', 'embarque', 'en_ruta', 'aterrizado', 'cancelado', 'desviado') NOT NULL,
  `irregularidad_motivo` VARCHAR(200) NULL,
  `puerta_salida_idpuerta` INT NOT NULL,
  `puerta_llegada_idpuerta` INT NULL,
  `aeronave_idaeronave` INT NOT NULL,
  `vuelo_programado_idvuelo_programado` INT NOT NULL,
  PRIMARY KEY (`idvuelo`),
  CONSTRAINT `fk_vuelo_puerta_llegada`
    FOREIGN KEY (`puerta_llegada_idpuerta`)
    REFERENCES `mydb`.`puerta` (`idpuerta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vuelo_aeronave1`
    FOREIGN KEY (`aeronave_idaeronave`)
    REFERENCES `mydb`.`aeronave` (`idaeronave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vuelo_vuelo_programado1`
    FOREIGN KEY (`vuelo_programado_idvuelo_programado`)
    REFERENCES `mydb`.`vuelo_programado` (`idvuelo_programado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vuelo_puerta_salida`
    FOREIGN KEY (`puerta_salida_idpuerta`)
    REFERENCES `mydb`.`puerta` (`idpuerta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tarifa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`tarifa` ;

CREATE TABLE IF NOT EXISTS `mydb`.`tarifa` (
  `idtarifa` INT NOT NULL AUTO_INCREMENT,
  `ruta_idruta` INT NOT NULL,
  `clase` ENUM('primera clase', 'ejecutivo', 'economica') NOT NULL,
  `precio_base` DECIMAL(12,2) NOT NULL,
  `impuesto` DECIMAL(5,2) NOT NULL,
  `tasa_fija` DECIMAL(12,2) NOT NULL,
  `tarifacol` VARCHAR(45) NOT NULL,
  `vigencia_desde` DATE NULL,
  `vigencia_hasta` DATE NULL,
  `activo` TINYINT NOT NULL,
  `creado_en` DATETIME NULL,
  `actualizado_en` DATETIME NULL,
  `eliminado_en` DATETIME NULL,
  `creado_por` INT NOT NULL,
  `actualizado_por` INT NOT NULL,
  `eliminado_por` INT NULL,
  `eliminado_motivo` VARCHAR(200) NULL,
  PRIMARY KEY (`idtarifa`),
  CONSTRAINT `fk_tarifa_ruta1`
    FOREIGN KEY (`ruta_idruta`)
    REFERENCES `mydb`.`ruta` (`idruta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tarifa_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tarifa_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tarifa_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
