USE `mydb`;

-- =================================================================================================
--  TABLA: AERONAVE
--  Rol: catálogo maestro de las aeronaves físicas de la flota
--  Relacionada con: 
--    - modelo_aeronave (FK): define fabricante/modelo/capacidades
--    - asiento (otras tablas referencian idaeronave para el plano de butacas)
--    - vuelo  (otras tablas referencian idaeronave para asignación de equipo a un vuelo)
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`aeronave`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`aeronave` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idaeronave` INT NOT NULL AUTO_INCREMENT,     -- PK interna de la aeronave; usada por otras tablas

  -- ===============================================================================================
  -- 2) CLAVES DE NEGOCIO / ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `matricula`       VARCHAR(15) NOT NULL,       -- Matrícula única del avión (ej.: LV-HXX, N123AB)
  `fecha_de_alta`   DATE        NOT NULL,       -- Fecha en que el avión ingresa a la flota
  `estado`          ENUM('activa','en_mantenimiento','retirada') NOT NULL,  -- Situación operativa
  `nota`            TEXT        NULL,           -- Observaciones libres (historial, particularidades)

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME    NULL,           -- Cuándo se creó el registro
  `actualizado_en`  DATETIME    NULL,           -- Última actualización
  `eliminado_en`    DATETIME    NULL,           -- Marca de borrado lógico (si aplica)

  `creado_por`      INT         NOT NULL,       -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT         NOT NULL,       -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT         NULL,           -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,         -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIÓN CON CATÁLOGO DE MODELOS
  -- ===============================================================================================
  `modelo_aeronave_idmodelo_aeronave` INT NOT NULL, -- FK → modelo_aeronave.idmodelo_aeronave

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idaeronave`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_aeronave_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_aeronave_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_aeronave_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FK con el catálogo de modelos → modelo_aeronave(idmodelo_aeronave)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_aeronave_modelo_aeronave1`
    FOREIGN KEY (`modelo_aeronave_idmodelo_aeronave`)
    REFERENCES `mydb`.`modelo_aeronave` (`idmodelo_aeronave`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- ÍNDICES / REGLAS DE UNICIDAD
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Unicidad de matrícula: evita duplicar aeronaves con el mismo registro
CREATE UNIQUE INDEX `matricula_UNIQUE`
  ON `mydb`.`aeronave` (`matricula` ASC) VISIBLE;

-- =================================================================================================
--  NOTAS DE USO
--  • asiento.aeronave_idaeronave referencia esta tabla para el plano de butacas por avión.
--  • vuelo.aeronave_idaeronave referencia esta tabla para la asignación de equipo a cada vuelo.
--  • modelo_aeronave define el tipo/base técnica que hereda esta aeronave (fabricante, familia, etc.).
-- =================================================================================================
