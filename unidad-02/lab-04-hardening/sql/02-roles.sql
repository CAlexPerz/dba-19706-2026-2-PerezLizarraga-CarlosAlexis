-- 14. Actividad 8 — Revisar usuarios y privilegios
SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles ORDER BY rolname;
