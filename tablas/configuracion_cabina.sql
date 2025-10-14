USE `mydb`;

-- =================================================================================================
--  TABLA: CONFIGURACION_CABINA
--  Rol: plantilla de distribución por cabina para un MODELO de aeronave (no para un avión específico).
--       Define cómo es el layout por clase (filas y asientos por fila) de un determinado modelo.
--  Relacionada con:
--    - modelo_aeronave (FK): a qué modelo pertenece esta configuración (A320, B737, etc.).
--    - asiento (indirecto): sirve como base para generar el plano físico en cada aeronave concreta.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`configuracion_cabina`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`configuracion_cabina` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idconfiguracion_cabina` INT NOT NULL AUTO_INCREMENT, -- PK interna de la configuración

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES DE LA CONFIGURACIÓN
  -- ===============================================================================================
  `cabina`           ENUM('primera clase','ejecutivo','economica') NOT NULL, -- Clase/cabina
  `fila`             INT  NOT NULL,     -- Cantidad de filas que tiene esta cabina en el modelo
  `asiento_por_fila` INT  NOT NULL,     -- Asientos por fila (ancho de la cabina: p.ej. 6 = A–F)

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`        DATETIME   NULL,   -- Cuándo se creó
  `actualizado_en`   DATETIME   NULL,   -- Última actualización
  `eliminado_en`     DATETIME   NULL,   -- Marca de borrado lógico (si aplica)
  `creado_por`       INT        NOT NULL, -- FK → usuario.idusuario (quién crea)
  `actualizado_por`  INT        NOT NULL, -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`    INT        NULL,     -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,   -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIÓN CON CATÁLOGO DE MODELOS
  -- ===============================================================================================
  `modelo_aeronave_idmodelo_aeronave` INT NOT NULL, -- FK → modelo_aeronave.idmodelo_aeronave

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idconfiguracion_cabina`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_configuracion_cabina_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_configuracion_cabina_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_configuracion_cabina_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FK con el catálogo de modelos → modelo_aeronave(idmodelo_aeronave)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_configuracion_cabina_modelo_aeronave1`
    FOREIGN KEY (`modelo_aeronave_idmodelo_aeronave`)
    REFERENCES `mydb`.`modelo_aeronave` (`idmodelo_aeronave`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • Esta tabla es una PLANTILLA por modelo (A320 con cabina Y de 30 filas x 6 asientos, etc.).
--  • Para cada aeronave física (tabla aeronave) se puede materializar un plano de asientos (tabla asiento).
--  • Si un modelo tiene múltiples cabinas (J/Y), habrá múltiples filas en esta tabla, una por cabina.
-- =================================================================================================
