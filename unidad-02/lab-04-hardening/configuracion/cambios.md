# Cambios
## 22. Actividad 16 — Comparar configuración antes y después

| Control |Antes| Estado Final| Justificación|
| :--- | :--- | :--- | :--- |
| **`listen_addresses`** | `'*'` (Escucha en todas las interfaces) | `'localhost, 172.17.0.2'` | Reduce la superficie de escucha impidiendo conexiones desde interfaces de red no autorizadas. |
| **`pg_hba.conf`** | Regla amplia `host all all all scram-sha-256` | `host basedatos_app app_user 172.17.0.0/16 scram-sha-256` | Aplica el control de acceso por red restringiendo la base de datos, el usuario y la subred origen. |
| **Método de Autenticación** | Uso del método `trust` en conexiones locales/loopback | Sustitución completa por `scram-sha-256` | Elimina la posibilidad de que usuarios locales ingresen sin proporcionar contraseña. |
| **Usuarios administrativos** | Conexiones de desarrollo directo con rol `postgres` | Usuario `postgres` reservado exclusivamente para mantenimiento local | Evita la exposición del Superusuario en las sesiones de trabajo y aplicaciones. |
| **Cuentas de Aplicación** | Inexistencia de roles segregados para la aplicación | Creación del rol `app_user` (`NOSUPERUSER`) y `consulta_user` | Implementa el principio de mínimo privilegio en la capa de software. |
| **Puerto** | `5432` | `5432` (Protegido por lista de acceso y firewall) | Se mantiene el puerto estándar respaldado por controles de acceso reales y no por oscurecimiento. |
| **TLS** | Conexión local sin TLS forzado | **TLS v1.3** activo con cifrado `TLS_AES_256_GCM_SHA384` | Garantiza la confidencialidad e integridad del tráfico de datos y credenciales en tránsito. |
| **Permisos de SO** | Verificación de permisos del contenedor | Propietario `postgres:postgres`, directorio `0700`, archivos `0600` | Evita que otros usuarios del sistema operativo lean claves o archivos de datos directamente del disco. |
| **Extensiones** | Extensión predeterminada `plpgsql` | Extensión mantenida únicamente `plpgsql` | Previene habilitar extensiones con funciones de acceso a archivos (`file_fdw`) o red (`dblink`). |
| **Conexiones** | Sesiones inactivas sin límite de tiempo | Timeouts de inactividad de sesión configurados | Mitiga riesgos de denegación de servicio por agotamiento de recursos o bloqueos retenidos. |