USE `mydb`;

-- =================================================================================================
--  TABLA: PERMISO
--  Rol: catálogo de permisos del sistema (scopes/acciones) para control de acceso.
--       Se asocia típicamente a roles mediante una tabla de cruce (p.ej. rol_permiso).
--  Relacionada con:
--    - usuario (FKs de auditoría): quién creó/actualizó/eliminó lógicamente.
--    - rol_permiso (otras tablas referencian idpermiso para asignación a roles).
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`permiso`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`permiso` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idpermiso` INT NOT NULL AUTO_INCREMENT,      -- PK interna del permiso

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `codigo`       VARCHAR(90)  NOT NULL,         -- Código único del permiso (ej.: 'USUARIOS_LEER')
  `descripcion`  VARCHAR(200) NULL,             -- Descripción legible de la acción/alcance

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME   NOT NULL,        -- Cuándo se creó
  `actualizado_en`  DATETIME   NOT NULL,        -- Última actualización
  `eliminado_en`    DATETIME   NULL,            -- Marca de borrado lógico (si aplica)

  `creado_por`      INT        NOT NULL,        -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT        NOT NULL,        -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT        NULL,            -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,         -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idpermiso`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_permiso_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_permiso_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_permiso_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- ÍNDICES / REGLAS DE UNICIDAD
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Unicidad del código de permiso (identificador funcional)
CREATE UNIQUE INDEX `codigo_UNIQUE`
  ON `mydb`.`permiso` (`codigo` ASC) VISIBLE;

-- =================================================================================================
--  NOTAS DE USO
--  • Usá `codigo` como clave funcional para checks de autorización en la app.
--  • Asigná permisos a roles en la tabla de cruce (p.ej., rol_permiso).
-- =================================================================================================
