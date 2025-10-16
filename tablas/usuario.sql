USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: USUARIO
--  Gestión de cuentas de acceso, seguridad, verificación y auditoría.
--  Dependencias:
--    • rol(idrol) → rol asignado al usuario.
--    • persona(idpersona) → datos personales vinculados.
--    • Autorreferencias (creado/actualizado/eliminado_por) → trazabilidad.
--  Índices:
--    • email_norm único (normalizado para búsquedas/caso-insensible).
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `usuario`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `usuario` (
  -- Identificador único
  `idusuario`                 INT NOT NULL AUTO_INCREMENT,

  -- Credenciales / Identidad
  `email`                     VARCHAR(254) NOT NULL,      -- email original
  `email_norm`                VARCHAR(254) NOT NULL,      -- email normalizado (p.ej. en minúsculas)
  `password_hash`             VARBINARY(255) NOT NULL,    -- hash de contraseña
  `password_algoritmo`        ENUM('argon2id', 'bcrypt') NOT NULL,
  `password_actualizado_en`   DATETIME NOT NULL,

  -- Verificación / Recupero
  `verificacion_email`        TINYINT NOT NULL,           -- 0/1 verificación de email
  `verificacion_token_hash`   VARBINARY(32) NULL,
  `verificacion_expira`       DATETIME NULL,
  `reset_token_hash`          VARBINARY(32) NULL,
  `reset_expira`              DATETIME NULL,

  -- Seguridad
  `intentos_fallidos`         SMALLINT NULL,
  `bloqueado_hasta`           DATETIME NULL,
  `ultimo_acceso_en`          DATETIME NULL,

  -- Auditoría temporal
  `creado_en`                 DATETIME NOT NULL,
  `actualizado_en`            DATETIME NOT NULL,
  `eliminado_en`              DATETIME NULL,

  -- Auditoría de usuario (autorreferencias)
  `creado_por`                INT NULL,
  `actualizado_por`           INT NULL,
  `eliminado_por`             INT NULL,
  `eliminado_motivo`          VARCHAR(200) NULL,

  -- Campos extra
  `usuariocol`                VARCHAR(45) NULL,

  -- Relaciones fuertes
  `rol_idrol`                 INT NOT NULL,
  `persona_idpersona`         INT NOT NULL,

  -- Clave primaria
  PRIMARY KEY (`idusuario`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_usuario_rol1`
    FOREIGN KEY (`rol_idrol`)
    REFERENCES `rol` (`idrol`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  -- ⚠ Si la tabla `persona` aún no existe, comentá este bloque y agregalo luego:
  CONSTRAINT `fk_usuario_persona1`
    FOREIGN KEY (`persona_idpersona`)
    REFERENCES `persona` (`idpersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  -- Autorreferencias de auditoría
  CONSTRAINT `fk_usuario_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_usuario_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_usuario_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- Índice único para evitar duplicados de email normalizado
CREATE UNIQUE INDEX `email_norm_UNIQUE` ON `usuario` (`email_norm` ASC);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: USUARIO
-- ═══════════════════════════════════════════════════════════════════════════════
