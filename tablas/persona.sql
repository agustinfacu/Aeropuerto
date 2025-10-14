USE `mydb`;

-- =================================================================================================
--  TABLA: PERSONA
--  Rol: núcleo de identidad para usuarios, clientes, pasajeros, empleados, etc.
--       Centraliza nombre y metadatos de auditoría. Otras tablas (usuario, direccion, telefono,
--       documentacion, reservas futuras) referencian a persona para mantener consistencia.
--  Relacionada con:
--    - usuario (FKs de auditoría): quién creó/actualizó/eliminó lógicamente el registro.
--    - (indirecto) usuario: una persona puede estar asociada a un usuario del sistema.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`persona`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`persona` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idpersona` INT NOT NULL AUTO_INCREMENT,     -- PK interna de la persona

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `nombre`        VARCHAR(80) NOT NULL,        -- Nombres
  `apellido`      VARCHAR(80) NOT NULL,        -- Apellidos

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`     DATETIME    NOT NULL,        -- Cuándo se creó el registro
  `actualizado_en` DATETIME   NULL,            -- Última actualización
  `eliminado_en`  DATETIME    NULL,            -- Marca de borrado lógico (si aplica)

  `creado_por`    INT         NOT NULL,        -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT       NOT NULL,        -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por` INT         NULL,            -- FK → usuario.idusuario (quién “elimina” lógicamente)

  -- ===============================================================================================
  -- 4) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idpersona`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- (Nota: se mantiene tu ON DELETE SET NULL tal cual. Si se borrara un usuario de auditoría,
  --        estos campos se pondrán en NULL; recuerda que aquí `creado_por` y `actualizado_por`
  --        son NOT NULL, lo que en producción suele requerir ON DELETE NO ACTION o permitir NULL.)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_persona_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL ON UPDATE NO ACTION,

  CONSTRAINT `fk_persona_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL ON UPDATE NO ACTION,

  CONSTRAINT `fk_persona_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE SET NULL ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • Es la entidad base para datos personales; expande con direccion, telefono y documentacion.
--  • Conviene indexar por nombre/apellido si vas a buscar mucho por texto (lo podés agregar luego).
--  • Revisa la política de auditoría: si querés conservar NOT NULL, cambiá ON DELETE a NO ACTION.
-- =================================================================================================
