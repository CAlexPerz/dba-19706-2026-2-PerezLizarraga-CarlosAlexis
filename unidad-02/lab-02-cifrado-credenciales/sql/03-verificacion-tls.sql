-- 9. Actividad 3 — El problema de la gestión de claves
-- El siguiente ejemplo funciona técnicamente:
SELECT pgp_sym_decrypt(rfc_cifrado,  'CLAVE-DE-PRUEBA') FROM clientes_protegidos;

-- 11. Actividad 5 — Verificar el estado de TLS en PostgreSQL
-- Consulta:
SHOW ssl;
-- También:
SHOW ssl_min_protocol_version;
-- Consulta el puerto:
SHOW port;
-- Y:
SHOW listen_addresses;

-- 11.1 Verificar la conexión actual
-- Ejecuta:
SELECT
    inet_client_addr(),
    inet_client_port();

-- Ahora verifica si la sesión actual utiliza TLS:
SELECT    ssl,  version, cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();
-- Analiza los resultados.

