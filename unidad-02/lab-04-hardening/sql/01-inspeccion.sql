-- 7. Actividad 1 — Identificar la superficie de ataque
-- Ejecuta:
SELECT version();
-- Después:
SHOW port;
SHOW listen_addresses;
SHOW ssl;
SHOW password_encryption;
-- Obtén también información sobre las conexiones:
SELECT
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity;

-- 8. Actividad 2 — Identificar los archivos de configuración
-- Consulta:
SHOW config_file;
SHOW hba_file;
SHOW ident_file;
-- Documenta las rutas obtenidas.
-- Después identifica otros parámetros importantes:
SHOW data_directory;
SHOW log_directory;
SHOW log_connections;
SHOW log_disconnections;

-- 9. Actividad 3 — Revisar listen_addresses
-- Consulta:
SHOW listen_addresses;

-- 10. Actividad 4 — Revisar pg_hba.conf
-- Consulta las reglas configuradas:
SELECT type, database, user_name, address, auth_method
FROM pg_hba_file_rules;

-- 16. Actividad 10 — Revisar extensiones
-- Consulta:
SELECT extname, extversion
FROM pg_extension ORDER BY extname;

-- 17. Actividad 11 — Revisar configuración relacionada con conexiones
-- Consulta:
SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;
