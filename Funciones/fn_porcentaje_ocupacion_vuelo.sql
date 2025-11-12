-- ============================================================
-- Aerolinea.fn_porcentaje_ocupacion_vuelo
-- ------------------------------------------------------------
-- Output: DECIMAL(5,2)
--   - Porcentaje de ocupación entre 0.00 y 100.00
--   - Incluye en "ocupados": RESERVADO, EMITIDO y BLOQUEADO
--   - No considera registros con eliminado_en IS NOT NULL
-- Reglas:
--   - Si el vuelo no tiene asientos mapeados (v_total = 0) -> 0.00
-- ============================================================

DROP FUNCTION IF EXISTS Aerolinea.fn_porcentaje_ocupacion_vuelo;
DELIMITER //

CREATE FUNCTION Aerolinea.fn_porcentaje_ocupacion_vuelo(p_idvuelo INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_total    INT DEFAULT 0;
  DECLARE v_ocupados INT DEFAULT 0;

  -- Total de asientos válidos del vuelo (no eliminados)
  SELECT COUNT(*)
    INTO v_total
  FROM Aerolinea.asiento_vuelo av
  WHERE av.vuelo_idvuelo = p_idvuelo
    AND av.eliminado_en IS NULL;   -- soft delete

  IF v_total = 0 THEN
    RETURN 0.00;
  END IF;

  -- Asientos ocupados/no disponibles: RESERVADO, EMITIDO, BLOQUEADO (no eliminados)
  SELECT COUNT(*)
    INTO v_ocupados
  FROM Aerolinea.asiento_vuelo av
  WHERE av.vuelo_idvuelo = p_idvuelo
    AND av.eliminado_en IS NULL
    AND av.estado IN ('RESERVADO','EMITIDO','BLOQUEADO');

  RETURN ROUND(v_ocupados * 100.0 / v_total, 2);
END//

DELIMITER ;
