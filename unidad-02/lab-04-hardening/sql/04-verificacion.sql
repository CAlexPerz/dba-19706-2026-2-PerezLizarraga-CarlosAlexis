-- 21. Actividad 15 — Revisar TLS
-- Consulta:
SHOW ssl;
SHOW ssl_min_protocol_version;
-- Después:
SELECT
    pid,
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();

select * from pg_stat_ssl;

-- Verificación de parámetros clave de hardening
SHOW listen_addresses;
SHOW password_encryption;

-- Verificación de reglas de autenticación
SELECT type, database, user_name, address, auth_method 
FROM pg_hba_file_rules;

-- Verificación de cifrado activo en la sesión
SELECT pid, ssl, version, cipher 
FROM pg_stat_ssl 
WHERE pid = pg_backend_pid();