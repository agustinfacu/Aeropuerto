USE `mydb`;

-- =================================================================================================
--  TABLA: PUERTA
--  Rol: catálogo de puertas de embarque/desembarque dentro de una TERMINAL de un aeropuerto.
--       Se usa para asignar puertas a vuelos (salida/llegada) y gestionar su disponibilidad.
--  Relacionada con:
--    - terminal (FK): a qué terminal pertenece la puerta.
--    - usuario  (FKs de auditoría): quién creó/actualizó/eliminó lógicamente el registro.
--    - (indirecto) vuelo: referencia esta tabla para puerta_salida_idpuerta y puerta_llegada_idpuerta.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`puerta`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`puerta` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idpuerta` INT NOT NULL AUTO_INCREMENT,         -- PK interna de la puerta

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `codigo` VARCHAR(10) NOT NULL,                  -- Código visible de la puerta (ej.: A4, B12)
  `activo` TINYINT NOT NULL,                      -- 1=activa en operación, 0=fuera de servicio

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`      DATETIME NULL,                 -- Cuándo se creó
  `actualizado_en` DATETIME NULL,                 -- Última actualización
  `eliminado_en`   DATETIME NULL,                 -- Marca de borrado lógico (si aplica)

  `creado_por`      INT NOT NULL,                 -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT NOT NULL,                 -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT NULL,                     -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,           -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIÓN CON TERMINAL
  -- ===============================================================================================
  `terminal_idterminal` INT NOT NULL,             -- FK → terminal.idterminal (pertenencia)

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idpuerta`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_puerta_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_puerta_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_puerta_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FK con TERMINAL → terminal(idterminal)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_puerta_terminal1`
    FOREIGN KEY (`terminal_idterminal`)
    REFERENCES `mydb`.`terminal` (`idterminal`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • El par (terminal, codigo) suele ser único a nivel de negocio; si lo necesitás, podés crear
--    un índice UNIQUE compuesto para evitar duplicados dentro de la misma terminal.
--  • Los vuelos hacen referencia a esta tabla para definir de qué puerta salen y a cuál arriban.
--  • El flag `activo` permite sacar temporalmente una puerta de servicio sin borrar su historial.
-- =================================================================================================
