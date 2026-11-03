# LAB-04 — Hardening y configuración segura de PostgreSQL
## Objetivo
Aplicar un proceso integral de hardening sobre un servidor PostgreSQL, identificando su superficie de ataque, reduciendo los puntos de exposición de red, fortaleciendo la autenticación, aplicando el principio de mínimo privilegio sobre los roles y auditando la seguridad en el sistema operativo.

## Entorno
* **Motor BD:** PostgreSQL 16.x corriendo en contenedor Docker (`LABORATORIO`).
* **Red de Host/Contenedor:** Interfaz Bridge de Docker (`172.17.0.1`).

## Superficie de Ataque Inicial
* **Interfaces de escucha:** `listen_addresses = '*'` (abierto en todas las interfaces).
* **Control de acceso por red (`pg_hba.conf`):** Presencia del método `trust` para conexiones locales y regla global permisiva (`host all all all scram-sha-256`).
* **Conexiones activas:** Conexiones directas realizadas con el usuario superadministrador `postgres` desde la IP del host Docker (`172.17.0.1`).
* **Roles:** Presencia de cuentas de sistema y roles sin la debido segregación de funciones para la capa de aplicación.

## Hallazgos
1. El motor aceptaba conexiones locales sin autenticación estricta debido a reglas con método `trust`.
2. Las herramientas de desarrollo ingresaban al servidor utilizando la cuenta `postgres` (`SUPERUSER`).
3. Existía exposición global en `listen_addresses`, permitiendo bind en cualquier IP asignada al contenedor.
4. Se constató que el contenedor incluye soporte nativo activo para **TLS v1.3** con cifrado `TLS_AES_256_GCM_SHA384`.

## Cambios Realizados
1. Modificación de `listen_addresses` para restringir la escucha a interfaces autorizadas.
2. Reestructuración de `pg_hba.conf` eliminando el método `trust` y sustituyéndolo por `scram-sha-256`.
3. Creación de roles independientes (`app_user`, `consulta_user`, `dba_admin`) para aislar la cuenta de aplicación del usuario superadministrador.
4. Corrección de la consulta de auditoría de SSL sobre la vista `pg_stat_ssl` eliminando referencias a columnas inexistentes (`usename`, `client_addr`).

## Justificación de los Cambios
Cada cambio reduce la superficie de ataque aplicando el principio de mínimo privilegio y defensa en profundidad, garantizando que el acceso requiera siempre credenciales fuertes, cifrado en tránsito y limitación por red origen.

## Verificación
Se ejecutaron scripts de comprobación registrados en `sql/04-verificacion.sql` que ratifican el estado de las reglas activas, cifrado TLS v1.3 y la restricción de privilegios sobre los roles.

## Checklist de Hardening

| # | Control | Verificado | Evidencia |
| :--- | :--- | :---: | :--- |
| 1 | Puerto por defecto documentado | Sí | `SHOW port;` |
| 2 | Interfaces de escucha restringidas | Sí | `SHOW listen_addresses;` |
| 3 | Reglas de `pg_hba.conf` auditadas | Sí | `SELECT * FROM pg_hba_file_rules;` |
| 4 | Redes no autorizadas bloqueadas | Sí | Regla IP específica en `pg_hba.conf` |
| 5 | Autenticación segura (`scram-sha-256`) | Sí | `SHOW password_encryption;` |
| 6 | Superusuarios identificados y limitados | Sí | Consulta a `pg_roles` |
| 7 | Cuentas de aplicación independientes creadas | Sí | Script `sql/02-roles.sql` |
| 8 | Mínimo privilegio aplicado a roles | Sí | Asignación de roles sin `SUPERUSER` |
| 9 | Extensiones innecesarias revisadas | Sí | `SELECT * FROM pg_extension;` |
| 10 | Cifrado TLS v1.3 verificado | Sí | `SELECT * FROM pg_stat_ssl;` |
| 11 | Archivos `.conf` protegidos en el SO | Sí | Permisos `0600` en contenedor |
| 12 | Directorio de datos aislado | Sí | Permisos `0700` en `/var/lib/postgresql/data` |
| 13 | Política de firewall conceptual diseñada | Sí | Matriz de firewall en `baseline.md` |
| 14 | Mantenimiento y parches documentados | Sí | Sección de mantenimiento en `baseline.md` |
| 15 | Línea base consolidada | Sí | Documento `configuracion/baseline.md` |

## Conclusiones
El hardening es un proceso continuo que exige asegurar tanto la configuración lógica de PostgreSQL como el entorno físico del sistema operativo y la red. La eliminación de métodos inseguros como `trust` y la separación de roles reduce drásticamente el riesgo de intrusión y escalación de privilegios en el sistema.
