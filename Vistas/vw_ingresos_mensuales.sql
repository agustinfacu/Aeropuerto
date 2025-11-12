-- ============================================================
-- VISTA 2: Aerolinea.vw_ingresos_mensuales
-- ------------------------------------------------------------
-- Resumen de ingresos mes a mes (por año, mes) considerando
-- boletos con estado 'EMITIDO' o 'USADO'.
-- Fecha de referencia de la venta: COALESCE(b.creado_en, v.fecha_salida_prog)
-- ============================================================

DROP VIEW IF EXISTS Aerolinea.vw_ingresos_mensuales;
CREATE VIEW Aerolinea.vw_ingresos_mensuales AS
SELECT
  YEAR(COALESCE(b.creado_en, v.fecha_salida_prog))   AS anio,
  MONTH(COALESCE(b.creado_en, v.fecha_salida_prog))  AS mes,
  SUM(b.costo_total)                                  AS ingresos_total,
  COUNT(b.idboleto)                                   AS boletos_emitidos_usados
FROM Aerolinea.boleto b
JOIN Aerolinea.vuelo v
  ON v.idvuelo = b.vuelo_idvuelo
WHERE b.eliminado_en IS NULL
  AND b.estado_boleto IN ('EMITIDO','USADO')
GROUP BY
  YEAR(COALESCE(b.creado_en, v.fecha_salida_prog)),
  MONTH(COALESCE(b.creado_en, v.fecha_salida_prog))
ORDER BY anio, mes;
