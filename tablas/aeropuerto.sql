USE `mydb`;

-- =================================================================================================
--  TABLA: AEROPUERTO
--  Rol: catálogo maestro de aeropuertos. Provee metadatos (IATA/ciudad/geo/timezone/estado)
--       para ser usados por rutas, vuelos programados, vuelos y la infraestructura (terminal/puerta).
--  Relacionada con:
--    - pais (FK): país al que pertenece el aeropuerto.
--    - terminal (otras tablas referencian idaeropuerto).
--    - ruta    (otras tablas referencian idaeropuerto como origen/destino).
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`aeropuerto`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`aeropuerto` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idaeropuerto` INT NOT NULL AUTO_INCREMENT,   -- PK interna del aeropuerto

  -- ===============================================================================================
  -- 2) ATRIBUTOS PRINCIPALES
  -- ===============================================================================================
  `tag`          VARCHAR(3)   NOT NULL,         -- Código IATA de 3 letras (ej.: EZE, AEP)
  `nombre`       VARCHAR(150) NOT NULL,         -- Nombre oficial del aeropuerto
  `ciudad`       VARCHAR(120) NOT NULL,         -- Ciudad principal a la que sirve

  -- Coordenadas geográficas (WGS84) para mapas/operaciones
  `latitud`      DECIMAL(9,6) NOT NULL,         -- Latitud (ej.: -34.8222)
  `longitud`     DECIMAL(9,6) NOT NULL,         -- Longitud (ej.: -58.5358)

  -- Zona horaria en formato IANA (ej.: "America/Argentina/Buenos_Aires")
  `huso_horario` VARCHAR(45)  NOT NULL,

  -- Estado operativo en catálogo (1=activo, 0=inactivo)
  `activo`       TINYINT      NOT NULL,

  -- ===============================================================================================
  -- 3) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME   NULL,            -- Cuándo se creó
  `actualizado_en`  DATETIME   NULL,            -- Última actualización
  `eliminado_en`    DATETIME   NULL,            -- Marca de borrado lógico (si aplica)

  `creado_por`      INT        NOT NULL,        -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT        NOT NULL,        -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT        NULL,            -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,         -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 4) RELACIÓN CON CATÁLOGO DE PAÍSES
  -- ===============================================================================================
  `pais_idpais`  INT NOT NULL,                  -- FK → pais.idpais (país del aeropuerto)

  -- ===============================================================================================
  -- 5) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idaeropuerto`),

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_aeropuerto_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_aeropuerto_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_aeropuerto_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FK con catálogo de países → pais(idpais)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_aeropuerto_pais1`
    FOREIGN KEY (`pais_idpais`)
    REFERENCES `mydb`.`pais` (`idpais`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- ÍNDICES / REGLAS DE UNICIDAD
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Unicidad de tag (IATA): evita duplicar el mismo aeropuerto por código
CREATE UNIQUE INDEX `tag_UNIQUE`
  ON `mydb`.`aeropuerto` (`tag` ASC) VISIBLE;

-- =================================================================================================
--  NOTAS DE USO
--  • terminal.aeropuerto_idaeropuerto referencia esta tabla para organizar terminales/puertas.
--  • ruta.origen_aeropuerto y ruta.destino_aeropuerto referencian idaeropuerto (origen/destino).
--  • vuelo y vuelo_programado la usan indirectamente a través de ruta/puerta.
-- =================================================================================================
