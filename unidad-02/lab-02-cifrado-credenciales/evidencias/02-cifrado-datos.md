# Cifrado de datos
## 8. Actividad 2 — Cifrado de información sensible
En LAB-01 se identificaron datos que pueden requerir protección adicional.
Para esta actividad utilizaremos el campo RFC como ejemplo.

### 8.1 Crear una tabla de demostración
### Evidencias de querys
![evidencia 1](..\recursos\cifrado\01.png)
![evidencia 2](..\recursos\cifrado\02.png)
![evidencia 3](..\recursos\cifrado\03.png)
### 8.2 Recuperar el dato

**Preguntas**
1. **¿Qué diferencia existe entre crypt() y pgp_sym_encrypt()? R:**
`crypt()` genera una representación no reversible (hash) diseñada para verificar contraseñas, mientras que `pgp_sym_encrypt()` realiza un cifrado simétrico bidireccional diseñado para proteger datos que necesitan recuperarse posteriormente.
1. **¿Cuál de los dos mecanismos permite recuperar el dato original? R:**
`pgp_sym_encrypt()`, utilizando la función `pgp_sym_decrypt()` junto con la clave secreta correspondiente.
1. **¿Qué ocurre si se utiliza una clave incorrecta? R:**
La función `pgp_sym_decrypt()` falla y muestra un error de descifrado, impidiendo recuperar el texto legible original.
1. **¿Qué problema de seguridad representa colocar la clave directamente en una consulta? R:**
Constituye una práctica de secreto embebido en código (hardcoded secret), lo que provoca que la clave quede guardada en texto claro dentro de scripts, historiales de consultas, registros del servidor (logs) o repositorios.
### Evidencias de querys
![evidencia 4](..\recursos\cifrado\04.png)
