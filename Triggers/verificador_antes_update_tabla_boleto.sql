-- ============================================================
-- TRIGGER 2: BEFORE UPDATE en Aerolinea.boleto
-- - Actualiza actualizado_en
-- - Recalcula costo_total si cambia la reserva o viene NULL/0
-- - Revalida coherencia asiento-vuelo si cambian esos campos
-- ============================================================
DROP TRIGGER IF EXISTS Aerolinea.trg_boleto_bu_audit_precio;
DELIMITER //
CREATE TRIGGER Aerolinea.trg_boleto_bu_audit_precio
BEFORE UPDATE ON Aerolinea.boleto
FOR EACH ROW
BEGIN
  DECLARE v_vuelo_asiento INT;

  -- timestamp
  SET NEW.actualizado_en = NOW();

  -- costo_total: si cambia la reserva o viene NULL/0, recalcular
  IF (NEW.reserva_idreserva <> OLD.reserva_idreserva)
     OR NEW.costo_total IS NULL OR NEW.costo_total = 0 THEN
    SET NEW.costo_total = Aerolinea.fn_precio_final_reserva(NEW.reserva_idreserva);
  END IF;

  -- coherencia asiento-vuelo si cambian
  IF (NEW.asiento_vuelo_idasiento_vuelo <> OLD.asiento_vuelo_idasiento_vuelo)
     OR (NEW.vuelo_idvuelo <> OLD.vuelo_idvuelo) THEN
    IF NEW.asiento_vuelo_idasiento_vuelo IS NOT NULL THEN
      SELECT av.vuelo_idvuelo
        INTO v_vuelo_asiento
      FROM Aerolinea.asiento_vuelo av
      WHERE av.idasiento_vuelo = NEW.asiento_vuelo_idasiento_vuelo
        AND av.eliminado_en IS NULL;

      IF v_vuelo_asiento IS NULL OR v_vuelo_asiento <> NEW.vuelo_idvuelo THEN
        SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'El asiento_vuelo no pertenece al vuelo indicado o está eliminado.';
      END IF;
    END IF;
  END IF;
END//
DELIMITER ;
