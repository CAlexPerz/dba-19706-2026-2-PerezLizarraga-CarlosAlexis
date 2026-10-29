# 15. Actividad 8 — Analizar un escenario de seguridad
### Considera la siguiente situación:
Una empresa almacena los siguientes elementos:
- nombre
- correo electrónico
- contraseña
- RFC
- información financiera
- claves criptográficas

La base de datos utiliza usuarios y roles correctamente.\
Sin embargo:
- las contraseñas están almacenadas en texto claro
- el RFC está almacenado en texto claro
- las conexiones utilizan una configuración sin validación adecuada del servidor
- las claves criptográficas aparecen en archivos SQL
- los respaldos se almacenan sin protección adicional


**Responde:**
1. **¿Cuáles son los principales riesgos? R:**\
Filtración inmediata de contraseñas y datos sensibles al estar en texto claro, exposición de claves en código/SQL, interceptación de tráfico en la red por falta de validación e información vulnerada en respaldos.
1. **¿Qué mecanismo utilizarías para cada elemento? R:**
    - Contraseñas: Hash con salt con `bcrypt` o `crypt`.
    - RFC e información financiera: Cifrado simétrico en reposo con `pgp_sym_encrypt`.   
    - Conexiones: TLS con validación completa  con `sslmode=verify-full`.   
    - Claves criptográficas: Almacén de secretos dedicado (Vault o variables de entorno).
    - Respaldos: Cifrado del archivo de respaldo. 
1. **¿Cuál de los problemas consideras más crítico y por qué? R:**\
El almacenamiento de contraseñas y claves en texto claro en archivos SQL, ya que compromete todo el sistema y deja sin efecto cualquier otro mecanismo de defensa.
1. **¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos? Justifica tu respuesta. R:**\
No. Los usuarios y permisos regulan la autorización interna, pero no impiden que se lea el tráfico de red, que se sustraiga una copia del archivo de la base de datos o que se expongan claves escritas en código.
