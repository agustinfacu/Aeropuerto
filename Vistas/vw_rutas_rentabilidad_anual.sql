-- ============================================================
-- VISTA 3 : Aerolinea.vw_rutas_rentabilidad_anual
-- ------------------------------------------------------------
-- Muestra los ingresos por RUTA y AÑO, mostrando el nombre
-- de los aeropuertos de origen y destino en lugar del id.
-- ------------------------------------------------------------
-- Criterios:
--   * Solo boletos con estado 'EMITIDO' o 'USADO'
--   * Sin registros eliminados
--   * Fecha de referencia: COALESCE(b.creado_en, v.fecha_salida_prog)
-- ============================================================

DROP VIEW IF EXISTS Aerolinea.vw_rutas_rentabilidad_anual;
CREATE VIEW Aerolinea.vw_rutas_rentabilidad_anual AS
SELECT
  YEAR(COALESCE(b.creado_en, v.fecha_salida_prog)) AS anio,
  ao.tag     AS origen_codigo,
  ao.nombre  AS origen_nombre,
  ad.tag     AS destino_codigo,
  ad.nombre  AS destino_nombre,
  SUM(b.costo_total)  AS ingresos_ruta,
  COUNT(b.idboleto)   AS boletos_emitidos_usados
FROM Aerolinea.boleto b
JOIN Aerolinea.vuelo v
  ON v.idvuelo = b.vuelo_idvuelo
JOIN Aerolinea.ruta r
  ON r.idruta = v.ruta_idruta
JOIN Aerolinea.aeropuerto ao
  ON ao.idaeropuerto = r.origen_aeropuerto
JOIN Aerolinea.aeropuerto ad
  ON ad.idaeropuerto = r.destino_aeropuerto
WHERE b.eliminado_en IS NULL
  AND b.estado_boleto IN ('EMITIDO','USADO')
GROUP BY
  YEAR(COALESCE(b.creado_en, v.fecha_salida_prog)),
  ao.tag, ao.nombre, ad.tag, ad.nombre
ORDER BY anio, ingresos_ruta DESC, origen_codigo, destino_codigo;



