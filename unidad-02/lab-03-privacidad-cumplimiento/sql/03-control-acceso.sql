-- 10. Actividad 4 — Control de acceso relacionado con la finalidad
-- Crea un rol:
CREATE ROLE analista NOLOGIN;
-- Otorga únicamente acceso a la información preparada para analítica.
-- Por ejemplo, crea una vista:
CREATE VIEW v_analitica_clientes AS SELECT  ciudad, CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más' END AS rango_edad FROM clientes;
-- Otorga permisos:
GRANT USAGE ON SCHEMA public TO analista;
GRANT SELECT ON v_analitica_clientes TO analista;
-- Verificación
-- Comprueba los privilegios:
SET ROLE analista;
SELECT   grantee,  table_name, privilege_type FROM information_schema.role_table_grants
WHERE grantee = 'analista';

SET ROLE postgres;

-- 12. Actividad 6 — Derechos ARCO y la base de datos

-- Identifica qué consulta permitiría localizar su información.
-- Ejemplo:
SELECT  id, nombre, correo, telefono, rfc, edad, ciudad, codigo_postal, fecha_alta
FROM clientes WHERE correo = 'ana@example.com';

-- SELECT  id, nombre, correo, telefono, rfc, edad, ciudad, codigo_postal, fecha_alta
-- FROM clientes WHERE correo = 'ana.lopez@example.test';

-- 13. Actividad 7 — Derecho de rectificación

-- Actualiza únicamente el dato correspondiente:
UPDATE clientes SET correo = 'nuevo-correo@example.com' WHERE id = 1;
-- Verifica:
SELECT id, nombre, correo FROM clientes WHERE id = 1;
