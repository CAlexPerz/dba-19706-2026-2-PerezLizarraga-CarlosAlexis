# Informe final

1. **Introducción**\
En este laboratorio se abordó la protección de la base de datos PostgreSQL mediante mecanismos criptográficos, enfocándose en evitar la exposición de credenciales, datos sensibles en reposo, comunicaciones en tránsito y claves dentro del código.

2. **Protección de credenciales**\
El texto claro expone directamente las contraseñas. Un hash con salt transforma la contraseña en un valor irreversible e idéntico para verificación. A diferencia del cifrado, el hash no permite recuperar la contraseña original.

3. **Protección de datos sensibles**\
Se protegió el campo RFC de la tabla de clientes mediante cifrado simétrico con pgp_sym_encrypt(). Se eligió este mecanismo porque los datos sensibles requieren ser recuperados en texto claro por usuarios autorizados utilizando pgp_sym_decrypt().

4. **TLS**\
TLS resuelve el problema de la interceptación y modificación de datos durante el tránsito en la red. En PostgreSQL se verificó la activación de SSL/TLS mediante SHOW ssl; y se confirmó la sesión cifrada consultando la vista pg_stat_ssl.

5. **Gestión de claves**\
Las claves criptográficas no deben almacenarse junto con los scripts o en repositorios Git. Incluir secretos en el código (hardcoded) permite que cualquier persona con acceso al historial de cambios recupere las claves y comprometa la seguridad.

6. **Resultados**\
Se logró proteger la tabla de usuarios almacenando solo hashes de contraseñas, se cifraron las columnas sensibles con funciones de pgcrypted y se estableció exitosamente una conexión cifrada cliente-servidor mediante TLS.

7. **Problemas encontrados**\
Inicialmente el servidor PostgreSQL en el contenedor Docker tenía la opción ssl = off. Se resolvió generando certificados digitalmente con openssl, cambiando el parámetro ssl = 'on' con ALTER SYSTEM y reiniciando el contenedor.

8. **Conclusiones**\
La seguridad en bases de datos debe ser integral. El control de acceso por roles debe complementarse con hash de credenciales, cifrado de datos en reposo, TLS para datos en tránsito y un manejo estricto de claves fuera del control de versiones.

## Preguntas de Reflexión

1. **¿Por qué una contraseña no debe almacenarse como texto claro?**\
Porque si la base de datos se filtra o un usuario no autorizado obtiene acceso de lectura, las credenciales quedan expuestas inmediatamente.
2. **¿Por qué un hash no es equivalente a un cifrado?**\
Porque el hash es una transformación matemática unidireccional no reversible, mientras que el cifrado es bidireccional y permite recuperar el texto original usando la clave adecuada.
3. **¿Por qué el cifrado de una columna no sustituye al control de acceso?**\
Porque el control de acceso determina qué usuarios tienen permisos para interactuar con la tabla, mientras que el cifrado protege el contenido en caso de que los datos sean leídos directamente del disco o respaldos.
4. **¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?**\
Porque TLS solo protege y autentica el canal de comunicación en tránsito, mientras que la autorización define qué acciones y consultas tiene permitido realizar un usuario dentro del servidor.
5. **¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?**\
La información cifrada no podrá ser descifrada ni recuperada, resultando en una pérdida permanente de los datos.
6. **¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?**\
La clave queda expuesta a cualquier persona con acceso al repositorio. Aunque se borre en un commit posterior, seguirá siendo accesible en el historial de Git.
7. **¿Por qué un repositorio privado no debe considerarse un almacén de secretos?**\
Porque reduce la exposición pública, pero conserva los secretos en el historial de commits al que tienen acceso múltiples desarrolladores y copias locales.
8. **¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?**\
Proteger información almacenada (en reposo) previene la lectura en archivos, discos o respaldos mediante cifrado o hash, mientras que proteger información en transmisión (en tránsito) evita la interceptación en la red usando TLS.
9. **¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?**\
Porque aunque el algoritmo criptográfico sea matemáticamente indestructible, si la clave se expone, pierde o almacena de forma insegura, toda la protección del sistema se anula.
10. **¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?**\
Implementaría el cifrado directo de los archivos de respaldo en reposo antes de transferirlos, gestionando las claves de cifrado en un servicio de administración de secretos externo.