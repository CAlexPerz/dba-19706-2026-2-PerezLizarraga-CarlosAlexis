-- 10. Actividad 4 — Control de acceso relacionado con la finalidad
-- Crea un rol:
CREATE ROLE analista NOLOGIN;
-- Otorga únicamente acceso a la información preparada para analítica.
-- Por ejemplo, crea una vista:
CREATE VIEW v_analitica_clientes AS SELECT ciudad, CASE
    WHEN edad &lt; 18 THEN &#39;Menor de 18&#39;
    WHEN edad BETWEEN 18 AND 29 THEN &#39;18-29&#39;
    WHEN edad BETWEEN 30 AND 44 THEN &#39;30-44&#39;
    WHEN edad BETWEEN 45 AND 59 THEN &#39;45-59&#39;
ELSE &#39;60 o más&#39; END AS rango_edad FROM clientes;
-- Otorga permisos:
GRANT USAGE ON SCHEMA public TO analista;
GRANT SELECT ON v_analitica_clientes TO analista;

-- Verificación
-- Comprueba los privilegios:
SELECT grantee, table_name, privilege_type FROM information_schema.role_table_grants
WHERE grantee = &#39;analista&#39;;

-- 12. Actividad 6 — Derechos ARCO y la base de datos

-- Identifica qué consulta permitiría localizar su información.
-- Ejemplo:
SELECT id, nombre, correo, telefono, rfc, edad, ciudad, codigo_postal, fecha_alta
FROM clientes WHERE correo = &#39;ana@example.com&#39;;

-- 13. Actividad 7 — Derecho de rectificación

-- Actualiza únicamente el dato correspondiente:
UPDATE clientes SET correo = &#39;nuevo-correo@example.com&#39; WHERE id = 1;
-- Verifica:
SELECT id, nombre, correo FROM clientes WHERE id = 1;
