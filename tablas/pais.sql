USE `mydb`;

-- =================================================================================================
--  TABLA: PAIS
--  Rol: catálogo de países para normalizar referencias geográficas en el sistema.
--       Se usa, por ejemplo, en aeropuerto (FK) y puede usarse en direcciones/documentos.
--  Relacionada con:
--    - usuario (FKs de auditoría): quién creó/actualizó/eliminó lógicamente.
--    - aeropuerto (otras tablas referencian idpais).
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`pais`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`pais` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idpais` INT NOT NULL AUTO_INCREMENT,        -- PK interna del país

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `tag`     VARCHAR(2)   NOT NULL,             -- Código de país (ISO 3166-1 alfa-2, ej.: AR, US)
  `nombre`  VARCHAR(90)  NOT NULL,             -- Nombre oficial del país
  `activo`  TINYINT      NOT NULL,             -- 1=activo en catálogo, 0=inactivo

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`      DATETIME   NULL,            -- Cuándo se creó el registro
  `actualizado_en` DATETIME   NULL,            -- Última actualización
  `eliminado_en`   DATETIME   NULL,            -- Marca de borrado lógico (si aplica)

  `creado_por`     INT        NOT NULL,        -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT       NOT NULL,        -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`  INT        NULL,            -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,        -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idpais`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_pais_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_pais_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_pais_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- ÍNDICES / REGLAS DE UNICIDAD
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Unicidad de tag (código ISO alfa-2): evita duplicar el mismo país por código
CREATE UNIQUE INDEX `tag_UNIQUE`
  ON `mydb`.`pais` (`tag` ASC) VISIBLE;

-- =================================================================================================
--  NOTAS DE USO
--  • Usar `tag` para almacenar/validar códigos de país en otras tablas (ej.: aeropuerto.pais_idpais).
--  • `activo` permite ocultar países sin perder referencias históricas.
-- =================================================================================================
