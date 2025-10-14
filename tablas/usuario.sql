USE `mydb`;

-- =================================================================================================
--  TABLA: USUARIO
--  Rol: cuentas de acceso al sistema (credenciales, estado de verificación/bloqueo) y metadatos.
--       Se asocian a una PERSONA y a un ROL. Incluye auditoría (self-FKs).
--  Relacionada con:
--    - rol     (FK): rol principal del usuario.
--    - persona (FK): datos personales vinculados a la cuenta.
--    - usuario (FKs de auditoría): quién creó/actualizó/eliminó lógicamente (self-reference).
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`usuario`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`usuario` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVE PRIMARIA
  -- ===============================================================================================
  `idusuario` INT NOT NULL AUTO_INCREMENT,                               -- PK interna del usuario

  -- ===============================================================================================
  -- 2) CREDENCIALES / CONTACTO
  -- ===============================================================================================
  `email`                VARCHAR(254)  NOT NULL,                          -- Email de login
  `email_norm`           VARCHAR(254)  NULL,                              -- Email normalizado (para unicidad)

  `password_hash`        VARBINARY(255) NOT NULL,                         -- Hash de contraseña
  `passwrod_algo`        ENUM('argon2id','bcrypt') NOT NULL,              -- (sic) Algoritmo usado para el hash
  `password_actualizado_en` DATETIME   NOT NULL,                          -- Último cambio de contraseña

  -- ===============================================================================================
  -- 3) ESTADO DE VERIFICACIÓN / SEGURIDAD
  -- ===============================================================================================
  `verificacion_email`      TINYINT     NOT NULL,                         -- 1=verificado, 0=no
  `verificacion_token_hash` VARBINARY(32) NULL,                           -- Hash del token de verificación
  `verificacion_expira`     DATETIME     NULL,                            -- Expiración del token de verificación

  `reset_token_hash`        VARBINARY(32) NULL,                           -- Hash del token de reseteo
  `reset_expira`            DATETIME     NULL,                            -- Expiración del token de reseteo

  `intentos_fallidos`       SMALLINT     NULL,                            -- Contador de intentos fallidos
  `bloqueado_hasta`         DATETIME     NULL,                            -- Bloqueo temporal hasta (si aplica)
  `ultimo_acceso_en`        DATETIME     NULL,                            -- Último login exitoso

  -- ===============================================================================================
  -- 4) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`          DATETIME   NOT NULL,                               -- Cuándo se creó
  `actualizado_en`     DATETIME   NOT NULL,                               -- Última actualización
  `eliminado_en`       DATETIME   NULL,                                   -- Marca de borrado lógico (si aplica)

  `creado_por`         INT        NULL,                                   -- FK self → usuario.idusuario
  `actualizado_por`    INT        NULL,                                   -- FK self → usuario.idusuario
  `eliminado_por`      INT        NULL,                                   -- FK self → usuario.idusuario
  `eliminado_motivo`   VARCHAR(200) NULL,                                 -- Motivo del borrado lógico

  -- Campo libre según tu DDL (puede servir como etiqueta/alias interno)
  `usuariocol`         VARCHAR(45) NULL,

  -- ===============================================================================================
  -- 5) RELACIONES FUNCIONALES
  -- ===============================================================================================
  `rol_idrol`          INT NOT NULL,                                      -- FK → rol.idrol
  `persona_idpersona`  INT NOT NULL,                                      -- FK → persona.idpersona

  -- ===============================================================================================
  -- 6) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idusuario`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs a ROL y PERSONA
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_usuario_rol1`
    FOREIGN KEY (`rol_idrol`)
    REFERENCES `mydb`.`rol` (`idrol`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_usuario_persona1`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `mydb`.`persona` (`idpersona`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA (self-reference) → usuario(idusuario)
  --   Nota: están permitidas en NULL para evitar ciclos duros al bootstrap del primer usuario.
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_usuario_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_usuario_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_usuario_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- ÍNDICES / REGLAS DE UNICIDAD
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Unicidad sobre el email normalizado (evita duplicados independientemente de mayúsculas/espacios)
CREATE UNIQUE INDEX `email_norm_UNIQUE`
  ON `mydb`.`usuario` (`email_norm` ASC) VISIBLE;

-- =================================================================================================
--  NOTAS DE USO
--  • `passwrod_algo` mantiene el nombre tal cual tu DDL original (typo incluido).
--  • Considerá agregar un índice normal (no único) sobre `email` para búsquedas directas.
--  • Los campos de auditoría self-FK en NULL facilitan crear el primer usuario “bootstrap”.
--  • Para hard-delete desaconsejado: preferir `eliminado_en`/`eliminado_por` y ocultar en queries.
-- =================================================================================================
