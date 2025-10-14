USE `mydb`;

-- =================================================================================================
--  TABLA: VUELO
--  Rol: instancia OPERATIVA de un vuelo para un día concreto (fecha_operacion).
--       Guarda horarios planificados/estimados/reales, estado e infraestructura asignada.
--  Relacionada con:
--    - vuelo_programado (FK): patrón base del que nace esta instancia.
--    - aeronave         (FK): avión asignado a operar el vuelo.
--    - puerta           (FK): puerta de salida y (opcional) de llegada.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`vuelo`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`vuelo` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idvuelo` INT NOT NULL AUTO_INCREMENT,              -- PK interna de la instancia de vuelo

  -- ===============================================================================================
  -- 2) FECHA DE OPERACIÓN
  -- ===============================================================================================
  `fecha_operacion` DATE NOT NULL,                    -- Fecha calendario local del origen (día del vuelo)

  -- ===============================================================================================
  -- 3) TIEMPOS (Programado / Estimado / Real)
  --     Convenciones:
  --       - STD: Scheduled Time of Departure   (salida programada)
  --       - STA: Scheduled Time of Arrival     (llegada programada)
  --       - ETD: Estimated Time of Departure   (salida estimada)
  --       - ETA: Estimated Time of Arrival     (llegada estimada)
  --       - ATD: Actual Time of Departure      (salida real, off-block)
  --       - ATA: Actual Time of Arrival        (llegada real, on-block)
  -- ===============================================================================================
  `std` DATETIME NULL,                                 -- Salida programada
  `sta` DATETIME NULL,                                 -- Llegada programada
  `etd` DATETIME NULL,                                 -- Salida estimada
  `eta` DATETIME NULL,                                 -- Llegada estimada
  `atd` DATETIME NULL,                                 -- Salida real
  `ata` DATETIME NULL,                                 -- Llegada real

  -- ===============================================================================================
  -- 4) ESTADO OPERATIVO
  -- ===============================================================================================
  `estado` ENUM('programado','embarque','en_ruta','aterrizado','cancelado','desviado') NOT NULL,
                                                     -- Estado actual del vuelo
  `irregularidad_motivo` VARCHAR(200) NULL,          -- Motivo si hay cancelación/desvío/demora

  -- ===============================================================================================
  -- 5) INFRAESTRUCTURA ASIGNADA Y EQUIPO
  -- ===============================================================================================
  `puerta_salida_idpuerta` INT NOT NULL,             -- FK → puerta.idpuerta (puerta de embarque)
  `puerta_llegada_idpuerta` INT NULL,                -- FK → puerta.idpuerta (puerta de arribo, si se conoce)
  `aeronave_idaeronave` INT NOT NULL,                -- FK → aeronave.idaeronave (avión asignado)
  `vuelo_programado_idvuelo_programado` INT NOT NULL,-- FK → vuelo_programado.idvuelo_programado (patrón)

  -- ===============================================================================================
  -- 6) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idvuelo`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs con PUERTA → puerta(idpuerta)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_vuelo_puerta_llegada`
    FOREIGN KEY (`puerta_llegada_idpuerta`)
    REFERENCES `mydb`.`puerta` (`idpuerta`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_vuelo_puerta_salida`
    FOREIGN KEY (`puerta_salida_idpuerta`)
    REFERENCES `mydb`.`puerta` (`idpuerta`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FK con AERONAVE → aeronave(idaeronave)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_vuelo_aeronave1`
    FOREIGN KEY (`aeronave_idaeronave`)
    REFERENCES `mydb`.`aeronave` (`idaeronave`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FK con VUELO_PROGRAMADO → vuelo_programado(idvuelo_programado)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_vuelo_vuelo_programado1`
    FOREIGN KEY (`vuelo_programado_idvuelo_programado`)
    REFERENCES `mydb`.`vuelo_programado` (`idvuelo_programado`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • Consultas típicas:
--      - “salidas hoy”: WHERE fecha_operacion=CURRENT_DATE AND estado IN ('programado','embarque','en_ruta')
--      - puntualidad: usar diferencias entre STD/ATD y STA/ATA.
--  • Si necesitás evitar duplicados por (vuelo_programado_id, fecha_operacion), podés agregar:
--      -- CREATE UNIQUE INDEX ux_vuelo_programado_fecha
--      --   ON mydb.vuelo (vuelo_programado_idvuelo_programado, fecha_operacion);
--  • Las horas suelen ser locales del aeropuerto; si usás UTC en la app, documentá la conversión.
-- =================================================================================================
s