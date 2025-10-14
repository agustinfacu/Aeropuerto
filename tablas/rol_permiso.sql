USE `mydb`;

-- =================================================================================================
--  TABLA: ROL_PERMISO
--  Rol: tabla de cruce (many-to-many) entre ROL y PERMISO para control de acceso.
--       Cada fila asigna un permiso a un rol, con campos de auditoría.
--  Relacionada con:
--    - rol     (FK): rol al que se le asigna un permiso.
--    - permiso (FK): permiso que se asigna al rol.
--    - usuario (FKs de auditoría): quién creó/actualizó/borró lógicamente la asignación.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`rol_permiso`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`rol_permiso` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idrol_permiso` INT NOT NULL AUTO_INCREMENT,   -- PK interna de la asignación rol↔permiso

  -- ===============================================================================================
  -- 2) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME NOT NULL,           -- Cuándo se creó la asignación
  `actualizado_en`  DATETIME NOT NULL,           -- Última actualización
  `eliminado_en`    DATETIME NULL,               -- Marca de borrado lógico (si aplica)

  `creado_por`      INT NOT NULL,                -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT NOT NULL,                -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT NULL,                    -- (ver NOTA al final sobre la FK vacía)
  `eliminado_motivo` VARCHAR(200) NULL,          -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 3) RELACIÓN ROL ↔ PERMISO
  -- ===============================================================================================
  `permiso_idpermiso` INT NOT NULL,              -- FK → permiso.idpermiso
  `rol_idrol`         INT NOT NULL,              -- FK → rol.idrol

  -- ===============================================================================================
  -- 4) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idrol_permiso`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs a PERMISO y ROL
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_rol_permiso_permiso1`
    FOREIGN KEY (`permiso_idpermiso`)
    REFERENCES `mydb`.`permiso` (`idpermiso`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_permiso_rol1`
    FOREIGN KEY (`rol_idrol`)
    REFERENCES `mydb`.`rol` (`idrol`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_rol_permiso_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_permiso_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- ATENCIÓN: Esta FK viene VACÍA en tu DDL original y así se deja para no alterar el esquema.
  --           MySQL no permite una FOREIGN KEY sin columnas/tabla válidas; esto fallará al ejecutar.
  --           Si querés mantener auditoría de “eliminado_por”, lo correcto sería:
  --             CONSTRAINT `fk_rol_permiso_eliminado_por`
  --               FOREIGN KEY (`eliminado_por`) REFERENCES `mydb`.`usuario`(`idusuario`)
  --               ON DELETE NO ACTION ON UPDATE NO ACTION
  --           (dejamos el bloque tal cual para respetar tu código original)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_rol_permiso_eliminado_por`
    FOREIGN KEY ()
    REFERENCES `mydb`.`persona` ()
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • Recomendación (opcional y no incluida para no modificar tu DDL):
--      Crear un índice UNIQUE compuesto para evitar duplicados del mismo permiso en el mismo rol:
--        -- CREATE UNIQUE INDEX ux_rol_permiso ON mydb.rol_permiso (rol_idrol, permiso_idpermiso);
--  • Los campos de auditoría permiten trazar quién creó/actualizó y quién marcó el borrado lógico.
--  • Corregí la FK `fk_rol_permiso_eliminado_por` si querés que el script ejecute sin error.
-- =================================================================================================
