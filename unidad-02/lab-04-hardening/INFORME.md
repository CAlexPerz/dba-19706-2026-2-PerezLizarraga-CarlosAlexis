# INFORME

## Actividad 1 - Identificar la Superficie de Ataque

### Tabla de Registro de Superficie de Ataque

| Elemento | Estado actual | ¿Es necesario? | Riesgo |
| :--- | :--- | :--- | :--- |
| **Puerto PostgreSQL** | `5432` | Sí | **Bajo/Medio:** Mantener el puerto estándar facilita escaneos automatizados si no está protegido por red/firewall. |
| **Interfaces de escucha** | `*` | No | **Alto:** Escuchar en todas las interfaces expone el servicio a cualquier tarjeta de red presente en el sistema o contenedor. |
| **Conexiones remotas** | Permitidas según `pg_hba.conf` | Solo para el servidor de aplicación | **Alto:** Reglas permisivas permiten intentos de conexión no autorizados. |
| **Usuarios administrativos** | Usuario `postgres` (Superuser) | Solo para administración local | **Crítico:** Si las aplicaciones usan esta cuenta, un compromiso otorga control total sobre la base de datos y el motor. |
| **SSL/TLS** | `off` por defecto (TLS v1.3 disponible en contenedor) | Sí | **Alto:** Si no se fuerza el cifrado, el tráfico y las credenciales viajan en texto claro. |
| **Métodos de autenticación** | `scram-sha-256` / `trust` (local) | Sí (solo métodos robustos) | **Alto:** El método `trust` en conexiones locales permite el ingreso sin contraseña. |

### Pregunta de Análisis
* **¿Por qué conocer la superficie de ataque debe preceder al hardening?**  
  No es posible proteger lo que se desconoce. Identificar los componentes expuestos (puertos, interfaces, métodos de autenticación, usuarios y conexiones activas) permite establecer una línea base real y determinar qué elementos son estrictamente necesarios para la operación y cuáles representan un riesgo innecesario que debe eliminarse.


## Actividad 2 - Identificar los Archivos de Configuración

### Pregunta de Análisis
* **¿Por qué es importante conocer la ubicación física de estos archivos?**  
  Porque la seguridad de la base de datos no depende solo de las sentencias SQL, sino también del sistema operativo. Conocer la ruta física permite auditar que los permisos a nivel de archivo (`0600`) y directorio (`0700`) sean estrictos y pertenezcan únicamente al usuario del sistema operativo `postgres`, impidiendo la manipulación o lectura no autorizada de credenciales.


## Actividad 3 - Revisar listen_addresses

### Documentación de Estado
* **Configuración encontrada:** `'*'` (Escuchando en todas las interfaces de red)
* **Interfaces necesarias:** `localhost` o la dirección IP interna/privada de la red asignada a la aplicación.
* **Interfaces innecesarias:** Interfaces públicas o no confiables expuestas directamente a redes externas.

### Análisis de Arquitectura
* **Escenario 1:** `Internet -> Firewall -> Servidor PostgreSQL (5432)`
* **Escenario 2:** `Internet -> Firewall -> Red privada -> Servidor PostgreSQL`

**Explicación de la arquitectura que reduce mejor la exposición:**  
El **Escenario 2** reduce drásticamente la exposición. Al ubicar el servidor de base de datos dentro de una red privada y bloquear el acceso directo desde Internet mediante segmentación y firewall, se impide que un atacante externo intente explotar directamente el puerto 5432, aplicando el principio de defensa en profundidad.

## Actividad 4 - Revisar pg_hba.conf

### Identificación de Reglas Encontradas
* **Reglas locales:** Tipo `local`, aplican a `all` bases de datos y usuarios mediante socket Unix con método `trust`.
* **Reglas IPv4/IPv6 Loopback:** Tipo `host`, direcciones `127.0.0.1/32` y `::1/128` con método `trust`.
* **Reglas Remotas:** Tipo `host`, dirección `all` (equivalente a `0.0.0.0/0`), afecta a todas las bases de datos y usuarios (`all`), utilizando `scram-sha-256`.

## Actividad 5 - Analizar una Regla Permisiva

### Análisis de la Regla: `host all all 0.0.0.0/0 scram-sha-256` (o `host all all all scram-sha-256`)
1. **¿Qué bases de datos permite?** Permite el acceso a todas las bases de datos del servidor (`all`).
2. **¿Qué usuarios permite?** Permite la autenticación con cualquier usuario registrado (`all`).
3. **¿Qué direcciones de origen permite?** Permite conexiones desde cualquier dirección IPv4 (`0.0.0.0/0`).
4. **¿Qué método de autenticación utiliza?** Utiliza validación criptográfica mediante `scram-sha-256`.
5. **¿Por qué representa una exposición innecesaria?** Porque viola el principio de mínimo privilegio y control de acceso por red al permitir que cualquier equipo de cualquier red intente autenticarse, facilitando ataques de fuerza bruta.
6. **¿Qué información se necesita para restringirla?** La subred/IP exacta de la aplicación, el nombre de la base de datos de producción y el usuario específico del servicio.

### Propuesta de Reestructuración de la Regla
* **Regla actual:** `host all all all scram-sha-256`
* **Problema:** Otorga acceso global sin restricción de origen, usuario ni base de datos objetivo.
* **Origen necesario:** `172.17.0.0/16` (Subred Docker / Servidor App)
* **Base de datos:** `basedatos_app`
* **Usuario:** `app_user`
* **Regla propuesta:** `host basedatos_app app_user 172.17.0.0/16 scram-sha-256`

## Actividad 6 - Aplicar Mínimo Privilegio a Conexiones

### Regla de Mínimo Privilegio Propuesta
```bash
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    basedatos_app   app_user        172.17.0.0/16           scram-sha-256
```

## Actividad 7 - Revisar Autenticación

### Preguntas de Análisis
1. **¿Qué diferencia existe entre autenticación y autorización?**  
   La autenticación verifica la identidad del usuario (quién es). La autorización determina qué acciones o recursos tiene permitidos ejecutar esa identidad ya verificada (qué puede hacer).
2. **¿Qué protege `scram-sha-256`?**  
   Protege contra la interceptación de credenciales en la red (*eavesdropping*) y ataques de retransmisión (*replay attacks*) mediante un esquema de desafío-respuesta criptográfico con sal.
3. **¿Por qué una contraseña almacenada mediante un mecanismo de autenticación no debe confundirse con cifrado reversible?**  
   Porque el almacenamiento de contraseñas utiliza funciones hash unidireccionales con sal designed para validar coincidencias. El cifrado reversible permite recuperar el texto claro original mediante una clave de descifrado.
4. **¿Qué sucede si una cuenta tiene permisos excesivos aunque utilice una contraseña fuerte?**  
   Si la cuenta o la sesión es comprometida (por ejemplo, vía SQL Injection en la aplicación), la contraseña fuerte queda eludida y el atacante dispondrá de acceso total para manipular o destruir la base de datos.

## Actividad 8 - Revisar Usuarios y Privilegios

### Tabla de Análisis de Roles

| Rol | LOGIN | SUPERUSER | CREATEROLE | CREATEDB | Función |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `postgres` | `true` | `true` | `true` | `true` | Administración general del motor de base de datos. |
| `pg_database_owner` | `false` | `false` | `false` | `false` | Rol de sistema para gestionar la propiedad de bases de datos. |
| `pg_read_all_data` | `false` | `false` | `false` | `false` | Rol de sistema para lectura global de tablas/vistas. |
| `pg_write_all_data` | `false` | `false` | `false` | `false` | Rol de sistema para escritura global en tablas/vistas. |

### Pregunta de Análisis
* **¿Por qué no debería utilizarse una cuenta SUPERUSER como cuenta normal de una aplicación?**  
  Porque otorga control total sobre el motor de base de datos, ignorando todos los controles de acceso e introduciendo el riesgo de que una vulnerabilidad en la aplicación permita a un atacante modificar archivos del sistema operativo, leer datos de otras bases o apagar el servicio.

## Actividad 9 - Separar Cuentas Administrativas y de Aplicación

### Tabla de Definición de Cuentas

| Cuenta | Propósito | LOGIN | Privilegios |
| :--- | :--- | :--- | :--- |
| **DBA** (`dba_admin`) | Mantenimiento y administración del servidor | Sí | `SUPERUSER` |
| **APP** (`app_user`) | Conexión operativa de la aplicación web/sistema | Sí | Privilegios explícitos `DML` (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) en tablas específicas |
| **CONSULTA** (`consulta_user`) | Reportes y auditorías de solo lectura | Sí | Solo lectura (`SELECT`) sobre tablas autorizadas |

### Pregunta de Análisis
* **¿Qué riesgo existe si la aplicación se conecta utilizando una cuenta administrativa?**  
  Riesgo de compromiso total de la infraestructura. La aplicación no requiere alterar la estructura del motor ni administrar roles; si es comprometida, el atacante adquiere facultades de DBA.


## Actividad 10 - Revisar Extensiones

### Análisis de Extensiones
1. **Extensiones existentes:** `plpgsql` (predeterminada en PostgreSQL 16).
2. **Extensiones necesarias:** `plpgsql` es requerida para el funcionamiento de funciones y procedimientos almacenados.
3. **Extensiones instaladas para prácticas:** Ninguna adicional en el estado inicial.
4. **Extensiones innecesarias/riesgosas en otros entornos:** Extensiones no utilizadas como `file_fdw` o `dblink` deben evitarse en producción si no se requieren, ya que amplían la superficie de ataque al permitir interactuar con archivos externos o redes remotas.


## Actividad 11 - Configuración de Conexiones

### Parámetros de Sesión Obtenidos
* **`max_connections`:** `100` (Límite máximo de conexiones concurrentes).
* **`superuser_reserved_connections`:** `3` (Conexiones reservadas exclusivamente para DBA).
* **`statement_timeout`:** `0` (Sin límite de tiempo para ejecución de consultas).
* **`idle_in_transaction_session_timeout`:** `0` (Sin límite de tiempo para sesiones inactivas en transacción).

### Pregunta de Análisis
* **¿Por qué mantener conexiones indefinidamente abiertas representa un problema de disponibilidad?**  
  Porque cada conexión consume memoria RAM y procesos del sistema operativo. Si las sesiones quedan inactivas o bloqueadas dentro de transacciones, agotan el límite `max_connections`, provocando una denegación de servicio (DoS) que impide el ingreso de usuarios legítimos.


## Actividad 12 - Permisos del Sistema Operativo

### Permisos Verificados en Contenedor Docker
* **Propietario:** `postgres`
* **Grupo:** `postgres`
* **Permisos del directorio (`/var/lib/postgresql/data`):** `drwx------` (`0700`).
* **Permisos de los archivos (`.conf`):** `-rw-------` (`0600`).

### Pregunta de Análisis
* **¿Por qué no es suficiente proteger PostgreSQL mediante GRANT y REVOKE si cualquier usuario del sistema operativo puede leer archivos sensibles?**  
  Porque los permisos SQL solo aplican dentro de la sesión de PostgreSQL. Si un usuario local del sistema operativo puede leer los archivos físicos de datos o configuración (`pg_hba.conf`, archivos de tabla), puede bypassear los controles SQL leyendo la información directamente desde el almacenamiento.

## Actividad 13 - Revisar Exposición de Red

### Registro de `ss -lntp` en el Contenedor
* **Dirección de escucha:** `0.0.0.0` y `:::` (debido a `listen_addresses = '*'`).
* **Puerto:** `5432`
* **¿Está expuesto fuera de la interfaz necesaria?** Sí, está expuesto en todas las interfaces de red del contenedor en lugar de estar restringido únicamente a las IPs de origen autorizadas.

## Actividad 14 - Diseñar una Política de Firewall

### Matriz de Política de Firewall Conceptual

| Origen | Destino | Puerto | Acción |
| :--- | :--- | :--- | :--- |
| `172.17.0.0/16` (Red Docker) / `10.10.10.0/24` | Servidor PostgreSQL (`10.10.10.20`) | `5432` | Permitir |
| Cualquier otro origen | Servidor PostgreSQL (`10.10.10.20`) | `5432` | Denegar |

### Pregunta de Análisis
* **¿Por qué `pg_hba.conf` y el firewall no son controles equivalentes?**  
  Operan en distintas capas del modelo OSI. El firewall bloquea paquetes en la capa de red/transporte (Nivel 3/4) impidiendo la apertura del puerto. `pg_hba.conf` es un control en la capa de aplicación (Nivel 7) que procesa la regla una vez que el cliente ya ha establecido la conexión TCP con el servidor.

## Actividad 15 - Revisar TLS y Corrección de Query

### Justificación Técnica de la Corrección
La guía original sugería ejecutar sobre `pg_stat_ssl` la consulta con `usename` y `client_addr`. Dado que esas dos columnas pertenecen a la vista `pg_stat_activity` y no a `pg_stat_ssl`, se corrigió la consulta a:

```sql
SELECT pid, ssl, version, cipher 
FROM pg_stat_ssl 
WHERE pid = pg_backend_pid();
```

### Determinación de Estado TLS
* **¿La conexión actual utiliza TLS?:** `true` (en el contenedor Docker de pruebas).
* **Versión:** `TLSv1.3`
* **Cipher:** `TLS_AES_256_GCM_SHA384`

## Actividad 18 - Caso Integral

### Matriz de Problemas, Riesgos y Controles

| # | Problema Identificado | Riesgo Asociado | Control Propuesto |
| :--- | :--- | :--- | :--- |
| 1 | Escuchando en todas las interfaces (`listen_addresses='*'`) | Exposición innecesaria del puerto a redes no confiables. | Configurar `listen_addresses` únicamente con la IP de la interfaz interna/local. |
| 2 | Regla `0.0.0.0/0` en `pg_hba.conf` | Apertura de autenticación a cualquier origen IPv4 global. | Restringir el parámetro `address` al segmento exacto del servidor de aplicaciones (`172.17.0.0/16`). |
| 3 | Aplicación conectada con usuario administrativo | Acceso ilimitado al motor en caso de SQLi en la aplicación. | Crear un rol de aplicación dedicado con permisos limitados (`DML` exclusivo sobre su esquema). |
| 4 | Regla de firewall permisiva para el puerto 5432 | Escaneos de puertos y ataques automatizados directos. | Aplicar políticas de firewall que permitan el tráfico al puerto 5432 solo desde la IP de la aplicación. |
| 5 | Reglas locales en `pg_hba.conf` con método `trust` | Conexión local sin requerir contraseña. | Cambiar todos los métodos de autenticación local a `scram-sha-256`. |
| 6 | Ausencia de cifrado de red (TLS deshabilitado o no forzado) | Interceptación de datos y credenciales en tránsito. | Habilitar `ssl = on` e imponer TLS v1.3 en las conexiones remotas. |
| 7 | Sin límite de tiempo de inactividad (`idle_in_transaction_session_timeout = 0`) | Bloqueos de tablas sostenidos y agotamiento de pool de conexiones. | Configurar tiempos de timeout para sesiones inactivas en transacción. |
| 8 | Falta de registro de conexiones y desconexiones | Imposibilidad de auditar accesos o detectar intrusiones. | Activar `log_connections = on` y `log_disconnections = on`. |
| 9 | Confianza exclusiva en "contraseñas fuertes" | Ignora vulnerabilidades de canal, permisos y arquitectura. | Aplicar el principio de Defensa en Profundidad (Red + SO + Auth + Privilegios). |
| 10 | Ausencia de monitoreo de cuentas y privilegios | Proliferación de roles obsoletos o con permisos heredados desmedidos. | Realizar auditorías periódicas a la vista `pg_roles`. |

### Respuesta Argumentada: ¿Es suficiente tener contraseñas fuertes?
**No, es completamente insuficiente.** La seguridad de una base de datos requiere una estrategia de **Defensa en Profundidad**:
* **Autenticación:** Valida identidad, pero no detiene ataques si la red está abierta.
* **Autorización:** Si una aplicación usa superusuario, la contraseña no evita acciones maliciosas internas.
* **Red:** Sin firewall o `pg_hba.conf` restrictivos, el servidor queda expuesto a ataques de fuerza bruta.
* **Sistema Operativo:** Si un atacante accede al SO, puede leer los datos directamente del disco omitiendo la contraseña.

# Preguntas del informe

1. **¿Cuál era la principal superficie de ataque?**  
   La combinación de `listen_addresses='*'`, reglas permisivas de red (`all` / `0.0.0.0/0`) y el uso de reglas locales con método `trust`.
2. **¿Qué configuración representaba el mayor riesgo?**  
   La existencia del método `trust` en `pg_hba.conf` junto a la posibilidad de que la aplicación opere con privilegios administrativos (`postgres`).
3. **¿Qué cambio produjo la mayor reducción de exposición?**  
   La restricción de red en `pg_hba.conf` delimitando las IPs autorizadas al segmento exacto de la aplicación (`172.17.0.0/16`) y la eliminación del método `trust`.
4. **¿Qué diferencia existe entre firewall y `pg_hba.conf`?**  
   El firewall detiene el tráfico antes de llegar al servicio (capa de red/transporte), mientras que `pg_hba.conf` evalúa la autorización de la conexión una vez establecida la sesión TCP en el motor de base de datos.
5. **¿Qué diferencia existe entre autenticación y autorización?**  
   Autenticación valida las credenciales de identidad; Autorización asigna y limita los permisos de operación de esa identidad.
6. **¿Por qué una cuenta de aplicación no debe ser SUPERUSER?**  
   Para limitar el radio de impacto (*blast radius*) en caso de que la aplicación sea vulnerada.
7. **¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?**  
   Porque cambiar el puerto es solo "seguridad por oscuridad". Un escaneo de puertos automatizado descubre el servicio en segundos.
8. **¿Por qué `listen_addresses='*'` puede ser innecesario?**  
   Porque obliga al motor a abrir sockets en todas las interfaces del servidor, incluyendo aquellas expuestas a redes no seguras o públicas.
9. **¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?**  
   El sistema operativo es la base sobre la que reside la seguridad física del almacenamiento, los procesos y los archivos de configuración. Si el SO es vulnerado, los controles internos de PostgreSQL pierden validez.
10. **¿Qué controles deberían revisarse periódicamente?**  
    Reglas de `pg_hba.conf`, roles y privilegios en `pg_roles`, registros de logs de auditoría, parches de actualización del motor y validez de certificados TLS.

## Reflexion

Si recibiera la responsabilidad de asegurar un servidor PostgreSQL en producción que ya se encuentra operando, mi primera acción prioritaria sería **revisar y corregir las reglas de acceso por red en `pg_hba.conf` y verificar los métodos de autenticación**, asegurando que no existan accesos tipo `trust` ni rangos `0.0.0.0/0`.

**Justificación:**  
Esta acción aborda directamente el mayor riesgo con el menor impacto en la continuidad del servicio. Corregir las reglas de red frena posibles intrusiones externas e intentos de fuerza bruta inmediatos sin alterar la lógica de las consultas de la aplicación ni tumbar la base de datos, garantizando la disponibilidad mientras se planifican los ajustes de roles y privilegios internos.
