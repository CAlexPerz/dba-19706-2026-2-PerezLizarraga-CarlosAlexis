# 25. Actividad 19 — Construcción de una línea base

## 1. Seguridad de Red
* **Interfaces de escucha:** El parámetro `listen_addresses` debe contener únicamente las direcciones IP de las interfaces estrictamente necesarias (ej. `localhost` o la IP privada del servidor). Nunca debe utilizarse `'*'`.
* **Puerto:** Mantener el puerto `5432` documentado y protegido mediante controles de red.
* **Firewall:** Se debe implementar un firewall perimetral y local que aplique una regla por defecto de denegación (*deny all*), permitiendo únicamente el tráfico entrante al puerto 5432 desde las direcciones IP de los servidores de aplicaciones autorizados.

## 2. Autenticación
* **Algoritmo de cifrado de claves:** `password_encryption = scram-sha-256`.
* **Prohibición de métodos laxos:** Queda estrictamente prohibido el uso de los métodos de autenticación `trust`, `password` en texto plano o `md5` en el archivo `pg_hba.conf`.
* **Políticas de contraseñas:** Todas las contraseñas de roles deben cumplir con criterios de complejidad (mínimo 16 caracteres, alfanuméricos y símbolos).

## 3. Autorización y Gestión de Roles
* **Segregación de funciones:**
  * **DBA:** Rol administrativo exclusivo para tareas de mantenimiento (`SUPERUSER`).
  * **APP:** Rol dedicado para la conexión de la aplicación con permisos estrictos (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) limitados a su esquema. Nunca debe ser `SUPERUSER`.
  * **CONSULTA:** Rol de solo lectura para auditoría o reportes.
* **Principio de Mínimo Privilegio:** Revocar el acceso por defecto del esquema `public` si no es necesario.

## 4. Configuración del Servicio
* **Extensiones:** Permitir únicamente aquellas extensiones que hayan sido evaluadas y aprobadas explícitamente.
* **Gestión de conexiones:**
  * Configurar `max_connections` acorde a la capacidad del servidor.
  * Reservar conexiones administrativas mediante `superuser_reserved_connections = 3`.
  * Configurar `idle_in_transaction_session_timeout` para finalizar sesiones colgadas dentro de transacciones.

## 5. Seguridad en el Sistema Operativo
* **Propietario de archivos:** Todos los archivos del directorio de datos y configuración deben ser propiedad del usuario del SO `postgres` y grupo `postgres`.
* **Permisos de archivos:**
  * Directorio de datos (`DATA`): Permisos `0700` (`drwx------`).
  * Archivos de configuración (`postgresql.conf`, `pg_hba.conf`): Permisos `0600` (`-rw-------`).

## 6. Cifrado en Tránsito
* **TLS Obligatorio:** `ssl = on`.
* **Versión mínima de protocolo:** `ssl_min_protocol_version = 'TLSv1.3'`.
* Las conexiones remotas deben rechazar tráfico sin cifrar.

## 7. Mantenimiento y Auditoría
* **Logs de auditoría:** Habilitar `log_connections = on` y `log_disconnections = on`.
* **Actualizaciones:** Aplicar parches de seguridad menores de PostgreSQL 16 de manera periódica.
* **Revisión continua:** Ejecutar la lista de verificación (checklist) de hardening de manera trimestral.