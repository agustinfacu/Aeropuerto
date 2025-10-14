USE `mydb`;

-- =================================================================================================
--  TABLA: ROL
--  Rol: catálogo de roles del sistema (perfiles como Admin, Agente, Operaciones, etc.).
--       Se usa para agrupar permisos (vía tabla de cruce rol_permiso) y asociarlos a usuarios.
--  Relacionada con:
--    - usuario (FKs de auditoría): quién creó/actualizó/borró lógicamente el rol.
--    - rol_permiso (otras tablas referencian idrol para asignar permisos a cada rol).
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`rol`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`rol` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idrol` INT NOT NULL AUTO_INCREMENT,        -- PK interna del rol

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `nombre`      VARCHAR(40) NOT NULL,         -- Nombre del rol (ej.: 'ADMIN', 'AGENTE')
  `descripcion` TEXT        NULL,             -- Descripción legible del alcance del rol

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`      DATETIME   NOT NULL,       -- Cuándo se creó el rol
  `actualizado_en` DATETIME   NOT NULL,       -- Última actualización
  `eliminado_en`   DATETIME   NULL,           -- Marca de borrado lógico (si aplica)

  `creado_por`      INT NOT NULL,             -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT NOT NULL,             -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT NULL,                 -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,       -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idrol`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_rol_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_rol_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- ÍNDICES / REGLAS DE UNICIDAD
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Unicidad del nombre del rol para evitar duplicados (clave funcional)
CREATE UNIQUE INDEX `nombre_UNIQUE`
  ON `mydb`.`rol` (`nombre` ASC) VISIBLE;

-- =================================================================================================
--  NOTAS DE USO
--  • Combiná roles con permisos en la tabla rol_permiso.
--  • Asociá usuarios a roles desde la tabla usuario (FK usuario.rol_idrol).
--  • Si querés evitar borrado de usuarios de auditoría, podés usar ON DELETE NO ACTION (ya aplicado).
-- =================================================================================================
