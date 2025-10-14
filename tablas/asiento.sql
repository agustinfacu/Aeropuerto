USE `mydb`;

-- =================================================================================================
--  TABLA: ASIENTO
--  Rol: define el plano físico de butacas INSTALADAS en UNA aeronave específica.
--       Cada fila+columna representa un asiento real (p.ej.: 12C) y su cabina/atributos especiales.
--  Relacionada con:
--    - aeronave (FK): a qué avión pertenece cada asiento.
--    - (indirecto) reservas/check-in: otras tablas podrían referenciar el código_asiento por vuelo.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`asiento`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`asiento` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idasiento` INT NOT NULL AUTO_INCREMENT,        -- PK interna del asiento

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES DEL ASIENTO
  -- ===============================================================================================
  `cabina`           ENUM('primera clase','ejecutivo','economica') NOT NULL,  -- Cabina a la que pertenece
  `fila`             SMALLINT NOT NULL,               -- Número de fila (p.ej.: 12)
  `columna`          CHAR(1)  NOT NULL,               -- Columna/letra (p.ej.: C)
  `codigo_asiento`   VARCHAR(6) NOT NULL,             -- Identificador visible (p.ej.: '12C')
  `asiento_bulkhead` TINYINT NOT NULL,                -- 1 si está junto al mamparo (bulkhead), 0 si no
  `asiento_en_salida` TINYINT NOT NULL,               -- 1 si es fila de salida de emergencia, 0 si no
  `nota`             VARCHAR(200) NULL,               -- Observaciones (visibilidad, reclinado, etc.)

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME   NULL,                  -- Cuándo se creó el registro
  `actualizado_en`  DATETIME   NULL,                  -- Última actualización
  `eliminado_en`    DATETIME   NULL,                  -- Marca de borrado lógico (si aplica)
  `creado_por`      INT        NOT NULL,              -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT        NOT NULL,              -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT        NULL,                  -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,               -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIÓN CON AERONAVE
  -- ===============================================================================================
  `aeronave_idaeronave` INT NOT NULL,                 -- FK → aeronave.idaeronave (dueño del asiento)

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idasiento`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_asiento_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_asiento_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_asiento_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FK con aeronave → aeronave(idaeronave)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_asiento_aeronave1`
    FOREIGN KEY (`aeronave_idaeronave`)
    REFERENCES `mydb`.`aeronave` (`idaeronave`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- ÍNDICES / REGLAS DE UNICIDAD
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- NOTA: Estos índices UNIQUE están copiados tal cual tu definición original.
--       En producción normalmente se usa un UNIQUE compuesto por (aeronave_idaeronave, cabina, fila, columna)
--       o bien por (aeronave_idaeronave, codigo_asiento), para no bloquear valores repetidos entre aeronaves.
CREATE UNIQUE INDEX `cabina_UNIQUE`
  ON `mydb`.`asiento` (`cabina` ASC) VISIBLE;

CREATE UNIQUE INDEX `fila_UNIQUE`
  ON `mydb`.`asiento` (`fila` ASC) VISIBLE;

CREATE UNIQUE INDEX `columna_UNIQUE`
  ON `mydb`.`asiento` (`columna` ASC) VISIBLE;

-- =================================================================================================
--  NOTAS DE USO
--  • Representa asientos físicos de UNA aeronave (no de un vuelo específico).
--  • Se puede cruzar con asignaciones de asiento por vuelo/reserva (en otras tablas) usando el código.
--  • Los flags bulkhead/salida sirven para reglas de elegibilidad y pricing diferenciado.
-- =================================================================================================
