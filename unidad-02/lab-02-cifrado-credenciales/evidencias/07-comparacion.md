# 14. Actividad 7 — Comparar protección en reposo y protección en tránsito
## Completa la siguiente tabla:

| Situación |Mecanismo apropiado | ¿Qué protege? |
|-----|------|-------|
|Contraseña de usuario|Hash con salt (`crypt + gen_salt`)| Autenticación y credenciales en reposo |
|RFC almacenado en una tabla| Cifrado simétrico (`pgp_sym_encrypt`) | Datos sensibles recuperables en reposo |
|Consulta enviada desde un cliente al servidor|TLS (`sslmode=require` / `verify-full`) | Información durante su transmisión por red (en tránsito)|
|Respaldo de una base de datos| Cifrado de archivos de respaldo|Archivos almacenados fuera de la base de datos|
|Clave criptográfica| Gestor de secretos / Variables de entorno|Las claves que permiten descifrar los datos|