USE `mydb`;

-- =================================================================================================
--  TABLA: DOCUMENTACION
--  Rol: almacena documentos de identidad y viaje asociados a una PERSONA
--       (DNI, Pasaporte, u otros), incluyendo vigencia, estado y autoridad emisora.
--  Relacionada con:
--    - persona (FK): titular del documento.
--    - usuario  (FKs de auditoría): responsables de creación/actualización/borrado lógico.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`documentacion`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`documentacion` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `iddocumentacion` INT NOT NULL AUTO_INCREMENT,  -- PK interna del documento

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES DEL DOCUMENTO
  -- ===============================================================================================
  `tipo`            ENUM('DNI','PASAPORTE','OTRO') NOT NULL,  -- Tipo de documento
  `numero`          VARCHAR(32) NOT NULL,                     -- Número del documento
  `pais_emisor`     VARCHAR(2)  NOT NULL,                     -- País emisor (ISO 3166-1 alfa-2, ej.: AR)
  `estado`          ENUM('VALIDO','VENCIDO','OBSERVADO','OTRO') NOT NULL, -- Estado de validez
  `autoridad`       VARCHAR(130) NOT NULL,                    -- Autoridad emisora (ej.: RENAPER)
  `fecha_emision`   DATETIME    NOT NULL,                     -- Fecha de emisión
  `fecha_vencimiento` DATETIME  NOT NULL,                     -- Fecha de expiración
  `observacion`     TEXT        NULL,                         -- Notas (observaciones, restricciones)

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`        DATETIME   NOT NULL,    -- Cuándo se creó el registro
  `actualizado_en`   DATETIME   NOT NULL,    -- Última actualización
  `creado_por`       INT        NOT NULL,    -- FK → usuario.idusuario (quién crea)
  `actualizado_por`  INT        NOT NULL,    -- FK → usuario.idusuario (quién actualiza)
  `eliminado_en`     DATETIME   NULL,        -- Marca de borrado lógico (si aplica)
  `eliminado_por`    INT        NULL,        -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,      -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIÓN CON PERSONA
  -- ===============================================================================================
  `persona_idpersona` INT NOT NULL,          -- FK → persona.idpersona (titular del documento)

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`iddocumentacion`),

  -- ------------------------------------------------------------------------------------------------
  -- FK con PERSONA → persona(idpersona)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_documentacion_persona1`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `mydb`.`persona` (`idpersona`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_documentacion_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_documentacion_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • Cada persona puede tener múltiples documentos (DNI, pasaportes, etc.).
--  • El campo estado facilita validaciones en check-in/embarque (p.ej., pasaporte vencido).
--  • pais_emisor se guarda como código de 2 letras para interoperabilidad.
-- =================================================================================================
