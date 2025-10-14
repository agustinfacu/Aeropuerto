-- =================================================================================================
--  MySQL Workbench Forward Engineering — PREÁMBULO DE ESQUEMA
--  Rol: configurar el entorno de creación (deshabilitar checks costosos) y crear el esquema base.
--  Uso: este archivo debe ejecutarse primero en tu proyecto multi-archivo (p.ej., 00_schema.sql).
--       Luego, ejecutá los archivos de tablas en el orden que prefieras.
--       Al finalizar TODO, restaurá los modos al estado previo (ver bloque final sugerido).
-- =================================================================================================

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- 1) DESACTIVAR CHEQUEOS/RESTRICCIONES (acelera la creación de muchas tablas y FKs)
--    Nota: Guardamos los valores anteriores en variables de sesión para restaurarlos al final.
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE,
    SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- 2) CREACIÓN DEL ESQUEMA (DATABASE)
--    - Se elimina si existía (útil para entornos de desarrollo).
--    - Se crea con charset 'utf8' (respetando tu DDL original).
--      * Sugerencia opcional futura: usar utf8mb4 para cobertura completa de Unicode.
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
DROP SCHEMA IF EXISTS `mydb`;
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8;
USE `mydb`;

-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- 3) RECORDATORIO: RESTAURAR LOS MODOS AL FINAL DEL TODO EL PROCESO DE CREACIÓN
--    Pegá este bloque en tu archivo FINAL (p.ej., 99_finalize.sql) o al final del último script.
-- ─────────────────────────────────────────────────────────────────────────────────────────────────
-- SET SQL_MODE=@OLD_SQL_MODE;
-- SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
-- SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- =================================================================================================
--  NOTAS
--  • Orden recomendado (a modo orientativo): catálogos → entidades base → relaciones → vistas/índices extra.
--  • Si vas a ejecutar archivos por separado, asegurate de que cada uno comience con: USE `mydb`;
--  • Mantener los bloques de “DROP TABLE IF EXISTS …” en cada archivo facilita reconstrucciones iterativas.
-- =================================================================================================
