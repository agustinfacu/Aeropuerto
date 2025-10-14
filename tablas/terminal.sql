USE `mydb`;

-- =================================================================================================
--  TABLA: TERMINAL
--  Rol: catálogo de terminales dentro de un AEROPUERTO.
--       Sirve como contenedor de puertas (tabla PUERTA) y como referencia para operaciones.
--  Relacionada con:
--    - aeropuerto (FK): a qué aeropuerto pertenece la terminal.
--    - usuario    (FKs de auditoría): quién creó/actualizó/borró lógicamente el registro.
--    - (indirecto) puerta: cada puerta referencia a su terminal.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`terminal`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`terminal` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idterminal` INT NOT NULL AUTO_INCREMENT,     -- PK interna de la terminal

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `nombre` VARCHAR(60) NOT NULL,                -- Nombre visible (ej.: Terminal A, T1)
  `activo` TINYINT NOT NULL,                    -- 1=activa en operación, 0=fuera de servicio

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`      DATETIME NULL,               -- Cuándo se creó
  `actualizado_en` DATETIME NULL,               -- Última actualización
  `eliminado_en`   DATETIME NULL,               -- Marca de borrado lógico (si aplica)

  `creado_por`      INT NOT NULL,               -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT NOT NULL,               -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT NULL,                   -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,         -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIÓN CON AEROPUERTO
  -- ===============================================================================================
  `aeropuerto_idaeropuerto` INT NOT NULL,       -- FK → aeropuerto.idaeropuerto (pertenencia)

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idterminal`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_terminal_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- Nota: el nombre de esta constraint viene con un typo "temrinal" en tu DDL original (se respeta).
  CONSTRAINT `fk_temrinal_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_terminal_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FK con AEROPUERTO → aeropuerto(idaeropuerto)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_terminal_aeropuerto1`
    FOREIGN KEY (`aeropuerto_idaeropuerto`)
    REFERENCES `mydb`.`aeropuerto` (`idaeropuerto`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • Considerá un índice UNIQUE (aeropuerto_idaeropuerto, nombre) si necesitás evitar duplicados
--    de nombre de terminal dentro del mismo aeropuerto.
--  • El flag `activo` permite deshabilitar terminales temporalmente sin perder historial.
-- =================================================================================================
