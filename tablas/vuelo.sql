USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: VUELO
--  Programa y operación de vuelos (horarios programados/real, estado y recursos).
--  Campos clave:
--    • codigo_publico: identificador visible (ej.: AR1234).
--    • fechas prog/real: salida/llegada programadas y efectivas.
--    • estado: ciclo operativo (PROGRAMADO, ABORDANDO, EN_AIRE, ATERRIZADO, CANCELADO, DEMORADO).
--  Dependencias:
--    • puerta(idpuerta), terminal(idterminal), aeropuerto(idaeropuerto)
--    • ruta(idruta), aeronave(idaeronave)
--    • usuario(idusuario) para auditoría (creado/actualizado/eliminado_por)
--  Notas:
--    • Podés agregar CHECKs (MySQL 8.0+) para validar fecha_salida ≤ fecha_llegada.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `vuelo`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `vuelo` (
  -- Identificador único
  `idvuelo`               INT NOT NULL AUTO_INCREMENT,

  -- Identidad pública y planificación
  `codigo_publico`        VARCHAR(10) NOT NULL,   -- ej.: AR1234
  `fecha_salida_prog`     DATETIME NOT NULL,
  `fecha_llegada_prog`    DATETIME NOT NULL,

  -- Tiempos reales de operación
  `fecha_salida_real`     DATETIME NULL,
  `fecha_llegada_real`    DATETIME NULL,

  -- Estado operativo
  `estado` ENUM('PROGRAMADO','ABORDANDO','EN_AIRE','ATERRIZADO','CANCELADO','DEMORADO') NOT NULL,

  -- Auditoría temporal
  `creado_en`             DATETIME NULL,
  `actualizado_en`        DATETIME NULL,
  `eliminado_en`          DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`            INT NULL,
  `actualizado_por`       INT NULL,
  `eliminado_por`         INT NULL,
  `eliminado_motivo`      VARCHAR(200) NULL,

  -- Relaciones fuertes con infraestructura y operación
  `puerta_idpuerta`       INT NOT NULL,
  `terminal_idterminal`   INT NOT NULL,
  `aeropuerto_idaeropuerto` INT NOT NULL,   -- aeropuerto base de operación (p.ej. salida)
  `ruta_idruta`           INT NOT NULL,     -- ruta origen→destino
  `aeronave_idaeronave`   INT NOT NULL,     -- aeronave asignada

  -- Clave primaria
  PRIMARY KEY (`idvuelo`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_vuelo_puerta1`
    FOREIGN KEY (`puerta_idpuerta`)
    REFERENCES `puerta` (`idpuerta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_vuelo_terminal1`
    FOREIGN KEY (`terminal_idterminal`)
    REFERENCES `terminal` (`idterminal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_vuelo_aeropuerto1`
    FOREIGN KEY (`aeropuerto_idaeropuerto`)
    REFERENCES `aeropuerto` (`idaeropuerto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_vuelo_ruta1`
    FOREIGN KEY (`ruta_idruta`)
    REFERENCES `ruta` (`idruta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_vuelo_aeronave1`
    FOREIGN KEY (`aeronave_idaeronave`)
    REFERENCES `aeronave` (`idaeronave`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  -- Auditoría (autorreferencias)
  CONSTRAINT `fk_vuelo_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_vuelo_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_vuelo_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

  -- (Opcionales con MySQL 8.0+)
  -- ,CONSTRAINT `ck_vuelo_prog` CHECK (`fecha_salida_prog` <= `fecha_llegada_prog`)
  -- ,CONSTRAINT `ck_vuelo_real` CHECK (
  --     `fecha_salida_real` IS NULL OR `fecha_llegada_real` IS NULL
  --     OR `fecha_salida_real` <= `fecha_llegada_real`
  -- )
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Búsquedas por fechas/estado:
--   CREATE INDEX `ix_vuelo_salida_prog`  ON `vuelo` (`fecha_salida_prog`);
--   CREATE INDEX `ix_vuelo_estado`       ON `vuelo` (`estado`);
-- • Búsquedas por recursos:
--   CREATE INDEX `ix_vuelo_aeronave`     ON `vuelo` (`aeronave_idaeronave`);
--   CREATE INDEX `ix_vuelo_ruta`         ON `vuelo` (`ruta_idruta`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: VUELO
-- ═══════════════════════════════════════════════════════════════════════════════
