USE `mydb`;

-- =================================================================================================
--  TABLA: TELEFONO
--  Rol: teléfonos de contacto asociados a una PERSONA.
--       Permite múltiples teléfonos por persona, marcando uno como principal y si usa WhatsApp.
--  Relacionada con:
--    - persona (FK): dueño del teléfono.
--    - usuario  (FKs de auditoría): responsables de creación/actualización/borrado lógico.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`telefono`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`telefono` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idtelefono` INT NOT NULL AUTO_INCREMENT,          -- PK interna del teléfono

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `tipo`         ENUM('movil','fijo','trabajo','otro') NOT NULL, -- Tipo de línea
  `numero`       VARCHAR(35) NOT NULL,               -- Número telefónico (incluir código país/área si aplica)
  `es_whatssap`  TINYINT NOT NULL,                   -- (sic, nombre tal cual) 1=usa WhatsApp, 0=no
  `extension`    VARCHAR(6)  NULL,                   -- Extensión (para internos de oficina)
  `es_principal` TINYINT NOT NULL,                   -- 1=principal para la persona, 0=secundario

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME NOT NULL,               -- Cuándo se creó
  `actualizado_en`  DATETIME NOT NULL,               -- Última actualización
  `eliminado_en`    DATETIME NULL,                   -- Marca de borrado lógico (si aplica)

  `creado_por`      INT NOT NULL,                    -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT NOT NULL,                    -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT NULL,                        -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,              -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIÓN CON PERSONA
  -- ===============================================================================================
  `persona_idpersona` INT NOT NULL,                  -- FK → persona.idpersona (titular del teléfono)

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idtelefono`),

  -- ------------------------------------------------------------------------------------------------
  -- FK con PERSONA → persona(idpersona)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_telefono_persona1`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `mydb`.`persona` (`idpersona`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_telefono_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_telefono_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_telefono_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • Podés agregar un índice para acelerar búsquedas por persona:
--      -- CREATE INDEX ix_telefono_persona ON mydb.telefono (persona_idpersona, es_principal);
--  • Si deseás validar formato E.164, hacelo desde la aplicación o con triggers/checks según tu versión.
--  • El campo `es_whatssap` conserva la ortografía original de tu DDL.
-- =================================================================================================
