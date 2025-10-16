USE `mydb`;

-- ═══════════════════════════════════════════════════════════════════════════════
--  TABLA: RUTA
--  Define un tramo origen → destino entre aeropuertos, con distancia y tiempo.
--  Campos clave:
--    • distancia_km: distancia estimada de la ruta.
--    • timepo_estimado (sic): duración estimada en minutos (SMALLINT).
--    • activo: habilita/deshabilita la ruta sin borrarla.
--  Dependencias:
--    • aeropuerto(idaeropuerto): origen_aeropuerto y destino_aeropuerto.
--    • usuario(idusuario): auditoría (creado/actualizado/eliminado_por).
--  Notas:
--    • Podés forzar que origen ≠ destino con un CHECK (MySQL 8.0+) o trigger.
--    • `origen_destino` quedó en el esquema; puede servir para una clave
--      derivada/normalizada (ej. hash o ID lógico). Lo mantengo tal cual.
-- ═══════════════════════════════════════════════════════════════════════════════

-- ───────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ───────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `ruta`;

-- ───────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ───────────────────────────────────────────────────────────────────────────────
CREATE TABLE `ruta` (
  -- Identificador único
  `idruta`             INT NOT NULL AUTO_INCREMENT,

  -- Métricas y estado
  `distancia_km`       INT NOT NULL,
  `timepo_estimado`    SMALLINT NULL,      -- (sic) minutos estimados de vuelo
  `activo`             TINYINT NULL,       -- 0 = inactiva, 1 = activa

  -- Auditoría temporal
  `creado_en`          DATETIME NULL,
  `actualizado_en`     DATETIME NULL,
  `eliminado_en`       DATETIME NULL,

  -- Auditoría de usuarios
  `creado_por`         INT NULL,
  `actualizado_por`    INT NULL,
  `eliminado_por`      INT NULL,
  `eliminado_motivo`   VARCHAR(200) NULL,

  -- Relaciones fuertes
  `origen_aeropuerto`  INT NOT NULL,
  `destino_aeropuerto` INT NOT NULL,

  -- Campo adicional presente en tu esquema
  `origen_destino`     INT NULL,

  -- Clave primaria
  PRIMARY KEY (`idruta`),

  -- ────────────────
  -- Claves foráneas
  -- ────────────────
  CONSTRAINT `fk_ruta_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_ruta_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_ruta_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `usuario` (`idusuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_ruta_origen_aeropuerto`
    FOREIGN KEY (`origen_aeropuerto`)
    REFERENCES `aeropuerto` (`idaeropuerto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_ruta_destino_aeropuerto`
    FOREIGN KEY (`destino_aeropuerto`)
    REFERENCES `aeropuerto` (`idaeropuerto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION

  -- (Opcional) Con MySQL 8.0+, podés activar:
  -- ,CONSTRAINT `ck_ruta_origen_neq_destino` CHECK (`origen_aeropuerto` <> `destino_aeropuerto`)
)
ENGINE = InnoDB;

-- (Opcionales recomendados)
-- • Búsquedas por origen/destino:
--   CREATE INDEX `ix_ruta_origen`  ON `ruta` (`origen_aeropuerto`);
--   CREATE INDEX `ix_ruta_destino` ON `ruta` (`destino_aeropuerto`);
-- • Evitar rutas duplicadas (origen, destino):
--   -- CREATE UNIQUE INDEX `ux_ruta_origen_destino`
--   --   ON `ruta` (`origen_aeropuerto`, `destino_aeropuerto`);

-- ═══════════════════════════════════════════════════════════════════════════════
--  FIN TABLA: RUTA
-- ═══════════════════════════════════════════════════════════════════════════════
