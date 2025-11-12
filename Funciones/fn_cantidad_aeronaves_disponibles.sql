-- ============================================================
-- Aerolinea.fn_cantidad_aeronaves_disponibles 
-- ------------------------------------------------------------
-- Output: INT
--   Cuenta aeronaves "disponibles":
--   - a.estado = 'activa' AND a.eliminado_en IS NULL
--   - NO asignadas a vuelos (v.eliminado_en IS NULL) en estado:
--     'PROGRAMADO','ABORDANDO','EN_AIRE','DEMORADO'
-- Nota: esta funcion usa CURSOR .
-- ============================================================

DROP FUNCTION IF EXISTS Aerolinea.fn_cantidad_aeronaves_disponibles;
DELIMITER //

CREATE FUNCTION Aerolinea.fn_cantidad_aeronaves_disponibles()
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_id INT;
  DECLARE v_bloqueada TINYINT;
  DECLARE v_cnt INT DEFAULT 0;
  DECLARE done TINYINT DEFAULT 0;

  -- Cursor sobre todas las aeronaves "activas" y no eliminadas
  DECLARE cur CURSOR FOR
    SELECT a.idaeronave
    FROM Aerolinea.aeronave a
    WHERE a.estado = 'activa'
      AND a.eliminado_en IS NULL
    ORDER BY a.idaeronave;

 
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO v_id;
    IF done = 1 THEN
      LEAVE read_loop;
    END IF;

   
    SELECT EXISTS (
             SELECT 1
             FROM Aerolinea.vuelo v
             WHERE v.aeronave_idaeronave = v_id
               AND v.eliminado_en IS NULL
               AND v.estado IN ('PROGRAMADO','ABORDANDO','EN_AIRE','DEMORADO')
           )
      INTO v_bloqueada;

   
    IF v_bloqueada = 0 THEN
      SET v_cnt = v_cnt + 1;
    END IF;
  END LOOP;

  CLOSE cur;

  RETURN v_cnt;
END//
DELIMITER ;
