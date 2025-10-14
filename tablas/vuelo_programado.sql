USE `mydb`;

-- =================================================================================================
--  TABLA: VUELO_PROGRAMADO
--  Rol: define el “horario base” de un vuelo recurrente en una RUTA (ej.: AR123 L–V 08:00→10:00).
--       A partir de este patrón se generan/relacionan las instancias operativas en la tabla VUELO.
--  Relacionada con:
--    - ruta    (FK): tramo origen→destino al que pertenece el código de vuelo.
--    - usuario (FKs de auditoría): responsables de creación/actualización/borrado lógico.
--    - (indirecto) vuelo: cada vuelo del día referencia a un vuelo_programado.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`vuelo_programado`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`vuelo_programado` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idvuelo_programado` INT NOT NULL AUTO_INCREMENT,  -- PK interna del vuelo programado

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES DEL HORARIO
  -- ===============================================================================================
  `codigo_vuelo`   VARCHAR(10) NOT NULL,   -- Código público del vuelo (ej.: AR123, UX0456)
  `frecuencia`     VARCHAR(64)  NULL,      -- Patrón de días (ej.: 'L-M-X-J-V', 'Diario', 'L-M-V')
  `hora_salida`    TIME         NULL,      -- Hora estándar de salida local (origen)
  `hora_llegada`   TIME         NULL,      -- Hora estándar de llegada local (destino)
  `equipo_preferido` VARCHAR(45) NULL,     -- Equipo/modelo preferido (texto libre: 'A320', '738')
  `activo`         TINYINT      NULL,      -- 1=se usa para programar, 0=no visible en planificación

  -- ===============================================================================================
  -- 3) RELACIÓN CON RUTA
  -- ===============================================================================================
  `ruta_idruta`    INT NOT NULL,           -- FK → ruta.idruta (origen/destino asociado)

  -- ===============================================================================================
  -- 4) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME NULL,         -- Cuándo se creó
  `actualizado_en`  DATETIME NULL,         -- Última actualización
  `eliminado_en`    DATETIME NULL,         -- Marca de borrado lógico (si aplica)

  `creado_por`      INT NOT NULL,          -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT NOT NULL,          -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT NULL,              -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,    -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idvuelo_programado`),

  -- ------------------------------------------------------------------------------------------------
  -- FK con RUTA → ruta(idruta)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_vuelo_programado_ruta1`
    FOREIGN KEY (`ruta_idruta`)
    REFERENCES `mydb`.`ruta` (`idruta`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_vuelo_programado_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_vuelo_programado_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_vuelo_programado_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • `codigo_vuelo` + `ruta_idruta` suelen identificar el patrón; si querés evitar duplicados,
--    podés crear luego un UNIQUE compuesto (no incluido para no alterar tu DDL).
--  • La semántica de `frecuencia` es libre: podés almacenar “Diario”, “L-M-X-J-V” o una RRULE.
--  • Las horas son locales a cada aeropuerto; los husos están en la tabla AEROPUERTO.
--  • La selección de aeronave real por día/hora se registra en VUELO (instancia operativa).
-- =================================================================================================
