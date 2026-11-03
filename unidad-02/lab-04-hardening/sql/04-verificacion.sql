-- 21. Actividad 15 — Revisar TLS
-- Consulta:
SHOW ssl;
SHOW ssl_min_protocol_version;
-- Después:
SELECT
    pid,
    usename,
    client_addr,
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();
