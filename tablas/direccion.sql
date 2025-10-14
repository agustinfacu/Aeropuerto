USE `mydb`;

-- =================================================================================================
--  TABLA: DIRECCION
--  Rol: almacena los domicilios y otras direcciones asociadas a una PERSONA.
--       Permite múltiples direcciones por persona (domicilio, laboral, comercial, etc.)
--  Relacionada con:
--    - persona (FK): dueño de la dirección.
--    - usuario  (FKs de auditoría): responsables de creación/actualización/borrado lógico.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`direccion`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`direccion` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `iddireccion` INT NOT NULL AUTO_INCREMENT,         -- PK interna de la dirección

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `tipo`        ENUM('Domicilio','Laboral','Comercial','Otro') NOT NULL,  -- Clasificación de la dirección
  `pais`        CHAR(2)        NOT NULL,              -- Código de país (ISO 3166-1 alfa-2, ej.: AR, US)
  `provincia`   VARCHAR(120)   NULL,                  -- Provincia/estado/departamento
  `ciudad`      VARCHAR(120)   NOT NULL,              -- Ciudad/Localidad
  `cp`          VARCHAR(15)    NULL,                  -- Código postal
  `calle`       VARCHAR(120)   NOT NULL,              -- Calle/Avenida
  `numero`      VARCHAR(15)    NOT NULL,              -- Altura/Número
  `piso`        VARCHAR(10)    NULL,                  -- Piso (si aplica)
  `depto`       VARCHAR(10)    NULL,                  -- Depto/Unidad (si aplica)
  `comentario`  TEXT           NULL,                  -- Referencias adicionales, entrecalles, etc.
  `es_principal` TINYINT       NOT NULL,              -- 1=principal para la persona, 0=secundaria

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME   NOT NULL,              -- Cuándo se creó el registro
  `actualizado_en`  DATETIME   NOT NULL,              -- Última actualización
  `eliminado_en`    DATETIME   NULL,                  -- Marca de borrado lógico (si aplica)

  `creado_por`      INT        NOT NULL,              -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT        NOT NULL,              -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT        NULL,                  -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,               -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIÓN CON PERSONA
  -- ===============================================================================================
  `persona_idpersona` INT NOT NULL,                   -- FK → persona.idpersona (titular de la dirección)

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`iddireccion`),

  -- ------------------------------------------------------------------------------------------------
  -- FK con PERSONA → persona(idpersona)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_direccion_persona`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `mydb`.`persona` (`idpersona`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- (Nota: ON DELETE SET NULL fue tomado tal cual tu definición original.)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_direccion_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL ON UPDATE NO ACTION,

  CONSTRAINT `fk_direccion_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL ON UPDATE NO ACTION,

  CONSTRAINT `fk_direccion_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • Permite múltiples direcciones por persona; usá es_principal=1 para marcar la principal.
--  • Útil para facturación, contacto y reglas por país/provincia (impuestos, comunicaciones, etc.).
--  • El país se almacena como código de 2 letras para interoperabilidad.
-- =================================================================================================
