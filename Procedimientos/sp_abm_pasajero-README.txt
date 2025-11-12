Notas de uso

Alta (‘A’): crea persona → (opcional) direccion / telefono / documentacion → usuario con rol pasajero.

Modificar (‘M’): actualiza cualquier campo; si no pasás un valor, no se toca (usa COALESCE). Para direccion/telefono podés pasar ID; si no, el SP toma la principal y hace upsert (si no existe, inserta). En documentacion, si no pasás p_iddocumentacion y mandás datos, inserta una nueva.

Baja (‘B’): marca eliminado_en y motivo en usuario, persona, direccion, telefono y documentacion.


Validaciones clave

Email normalizado único: si cambiás p_email_norm, se valida contra usuario.email_norm no eliminado.

Rol fijo: el usuario queda siempre con rol_idrol = (SELECT idrol FROM rol WHERE nombre='pasajero').

País válido: si se especifica, direccion.pais y documentacion.pais_emisor deben existir en pais(tag) con activo=1 y no eliminados.