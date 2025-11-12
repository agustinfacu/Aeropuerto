-- ============================================================
-- Aerolinea.fn_precio_final_reserva
-- ------------------------------------------------------------
-- Output: DECIMAL(12,2)
--   - Devuelve el precio FINAL (neto) de una reserva.
--   - Fórmula base:
--       bruto = precio + tasa_fija + (precio * impuesto / 100)
--       neto  = bruto * (1 - valor/100) si la promoción está activa.
--   - Si la promoción NO está activa (o no existe), devuelve el BRUTO como neto.
-- Notas:
--   - Lee tarifa/promoción desde la reserva indicada.
--   - Redondea a 2 decimales.
-- ============================================================

DROP FUNCTION IF EXISTS Aerolinea.fn_precio_final_reserva;
DELIMITER //

CREATE FUNCTION Aerolinea.fn_precio_final_reserva(p_idreserva INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_precio    DECIMAL(12,2);
  DECLARE v_impuesto  DECIMAL(5,2);
  DECLARE v_tasa_fija DECIMAL(12,2);
  DECLARE v_desc      SMALLINT;
  DECLARE v_activo    TINYINT;
  DECLARE v_bruto     DECIMAL(12,2);
  DECLARE v_neto      DECIMAL(12,2);

  /* Trae datos de tarifa y promo asociados a la reserva */
  SELECT
      t.precio, t.impuesto, t.tasa_fija,
      pr.valor, pr.activo
  INTO
      v_precio, v_impuesto, v_tasa_fija,
      v_desc, v_activo
  FROM Aerolinea.reserva r
  JOIN Aerolinea.tarifa t
    ON t.idtarifa = r.tarifa_idtarifa
  LEFT JOIN Aerolinea.promocion pr
    ON pr.idpromocion = r.promocion_idpromocion
  WHERE r.idreserva = p_idreserva;

  /* Si no hay fila correspondiente, retorna NULL */
  IF v_precio IS NULL THEN
    RETURN NULL;
  END IF;

  /* Calcula bruto */
  SET v_bruto = ROUND(v_precio + v_tasa_fija + (v_precio * v_impuesto / 100.0), 2);

  /* Aplica promo solo si está activa (=1). Si no, devuelve bruto como neto */
  IF v_activo = 1 THEN
    SET v_neto = ROUND(v_bruto * (1 - (COALESCE(v_desc, 0) / 100.0)), 2);
  ELSE
    SET v_neto = v_bruto;
  END IF;

  RETURN v_neto;
END//
DELIMITER ;
