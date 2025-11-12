-- ============================================================
-- VISTA: Aerolinea.vw_vuelos_resumen
-- ------------------------------------------------------------
-- Muestra cada vuelo con su:
--   - Código público y estado
--   - Matrícula del avión asignado
--   - Distancia y tiempo estimado de su ruta
--   - Cantidad de pasajeros (boletos con estado EMITIDO o USADO)
-- ------------------------------------------------------------
-- Reglas:
--   * Se excluyen vuelos eliminados (v.eliminado_en IS NULL)
--   * Se cuentan solo boletos con estado 'EMITIDO' o 'USADO'
-- ============================================================

DROP VIEW IF EXISTS Aerolinea.vw_vuelos_resumen;
CREATE VIEW Aerolinea.vw_vuelos_resumen AS
SELECT 
    v.idvuelo,
    v.codigo_publico,
    v.estado          AS estado_vuelo,
    a.matricula       AS aeronave_matricula,
    r.distancia_km,
    r.timepo_estimado AS tiempo_estimado_min,
    COUNT(b.idboleto) AS cantidad_pasajeros
FROM Aerolinea.vuelo v
JOIN Aerolinea.aeronave a
  ON a.idaeronave = v.aeronave_idaeronave
JOIN Aerolinea.ruta r
  ON r.idruta = v.ruta_idruta
LEFT JOIN Aerolinea.boleto b
  ON b.vuelo_idvuelo = v.idvuelo
 AND b.estado_boleto IN ('EMITIDO','USADO')
 AND b.eliminado_en IS NULL
WHERE v.eliminado_en IS NULL
GROUP BY 
    v.idvuelo, v.codigo_publico, v.estado,
    a.matricula, r.distancia_km, r.timepo_estimado
ORDER BY v.idvuelo;
