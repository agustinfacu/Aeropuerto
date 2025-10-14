USE `mydb`;

-- =================================================================================================
--  TABLA: TARIFA
--  Rol: catálogo de tarifas por RUTA y por CLASE de cabina.
--       Define el precio base y cargos/impuestos simples con vigencia temporal.
--  Relacionada con:
--    - ruta    (FK): tramo origen→destino al que aplica la tarifa.
--    - usuario (FKs de auditoría): responsables de creación/actualización/borrado lógico.
--  Notas:
--    • `clase` usa el mismo ENUM que tus asientos: 'primera clase' | 'ejecutivo' | 'economica'.
--    • Estructura minimalista para “poder cobrar” sin complejidad de reglas dinámicas.
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Limpieza (solo para entornos de desarrollo)
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP TABLE IF EXISTS `mydb`.`tarifa`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- Definición de tabla
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS `mydb`.`tarifa` (

  -- ===============================================================================================
  -- 1) IDENTIDAD / CLAVES
  -- ===============================================================================================
  `idtarifa` INT NOT NULL AUTO_INCREMENT,           -- PK interna de la tarifa

  -- ===============================================================================================
  -- 2) RELACIÓN CON RUTA Y CLASE
  -- ===============================================================================================
  `ruta_idruta` INT NOT NULL,                       -- FK → ruta.idruta (tramo al que aplica)
  `clase` ENUM('primera clase','ejecutivo','economica') NOT NULL, -- Clase/cabina

  -- ===============================================================================================
  -- 3) COMPONENTES DE PRECIO
  -- ===============================================================================================
  `precio_base` DECIMAL(12,2) NOT NULL,             -- Precio base (moneda de la compañía)
  `impuesto`    DECIMAL(5,2)  NOT NULL,             -- Porcentaje de impuesto (ej.: 21.00 = 21%)
  `tasa_fija`   DECIMAL(12,2) NOT NULL,             -- Cargos fijos (ej.: tasas aeroportuarias)
  `tarifacol`   VARCHAR(45)   NOT NULL,             -- Campo libre según tu DDL (código/nota de tarifa)

  -- ===============================================================================================
  -- 4) VIGENCIA / ESTADO
  -- ===============================================================================================
  `vigencia_desde` DATE NULL,                       -- Inicio de vigencia (inclusive)
  `vigencia_hasta` DATE NULL,                       -- Fin de vigencia (inclusive)
  `activo`         TINYINT NOT NULL,                -- 1=vigente/usable, 0=no disponible

  -- ===============================================================================================
  -- 5) AUDITORÍA (borrado lógico incluido)
  -- ===============================================================================================
  `creado_en`       DATETIME NULL,                  -- Cuándo se creó
  `actualizado_en`  DATETIME NULL,                  -- Última actualización
  `eliminado_en`    DATETIME NULL,                  -- Marca de borrado lógico (si aplica)

  `creado_por`      INT NOT NULL,                   -- FK → usuario.idusuario (quién crea)
  `actualizado_por` INT NOT NULL,                   -- FK → usuario.idusuario (quién actualiza)
  `eliminado_por`   INT NULL,                       -- FK → usuario.idusuario (quién “elimina” lógicamente)
  `eliminado_motivo` VARCHAR(200) NULL,             -- Motivo del borrado lógico (si existe)

  -- ===============================================================================================
  -- 6) CLAVES / RESTRICCIONES
  -- ===============================================================================================
  PRIMARY KEY (`idtarifa`),

  -- ------------------------------------------------------------------------------------------------
  -- FK con RUTA → ruta(idruta)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_tarifa_ruta1`
    FOREIGN KEY (`ruta_idruta`)
    REFERENCES `mydb`.`ruta` (`idruta`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  -- ------------------------------------------------------------------------------------------------
  -- FKs de AUDITORÍA → usuario(idusuario)
  -- ------------------------------------------------------------------------------------------------
  CONSTRAINT `fk_tarifa_creado_por`
    FOREIGN KEY (`creado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_tarifa_actualizado_por`
    FOREIGN KEY (`actualizado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,

  CONSTRAINT `fk_tarifa_eliminado_por`
    FOREIGN KEY (`eliminado_por`)
    REFERENCES `mydb`.`usuario` (`idusuario`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;

-- =================================================================================================
--  NOTAS DE USO
--  • Cálculo simple del total (ejemplo):
--      total = precio_base + tasa_fija + (precio_base * impuesto / 100)
--  • Para evitar duplicados por ruta+clase dentro de la misma vigencia, podrías agregar luego:
--      -- CREATE UNIQUE INDEX ux_tarifa_ruta_clase_fecha
--      --   ON mydb.tarifa (ruta_idruta, clase, vigencia_desde, IFNULL(vigencia_hasta,'9999-12-31'));
--  • Si vas a consultar por rutas activas vigentes, conviene indexar (ruta_idruta, clase, activo).
-- =================================================================================================
