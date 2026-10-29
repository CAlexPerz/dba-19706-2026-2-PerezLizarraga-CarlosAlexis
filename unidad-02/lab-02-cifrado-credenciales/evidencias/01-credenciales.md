# Credenciales

## 7. Actividad 1 — Protección de credenciales
### 7.1 El problema

- **¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?**
**R:** Podría ver las contraseñas directamente en texto claro, lo que provocaría que una filtración de la base de datos se convierta en una filtración inmediata de credenciales.

### Evidencias de querys
![evidencia 1](..\recursos\credenciales\01.png)
![evidencia 2](..\recursos\credenciales\02.png)
![evidencia 3](..\recursos\credenciales\03.png)

### 7.3 Generar una representación no reversible

**Preguntas**
1. **¿Son iguales? R:**
No
2. **Si no son iguales, ¿por qué?  R:**
Porque `gen_salt()` genera un valor aleatorio (salt) distinto en cada ejecución, modificando la representación final.
3. **¿Qué función cumple gen_salt()? R:**
Genera una salt aleatoria que se combina con la contraseña para evitar que contraseñas iguales produzcan el mismo hash y proteger contra ataques con tablas precalculadas.
4. **¿Qué función cumple crypt()? R:**
Aplica un algoritmo de hashing para derivar un valor criptográfico a partir de la contraseña y la salt.
5. **¿Esto es cifrado reversible? R:**
No, es una transformación unidireccional, por lo que no se puede revertir para obtener la contraseña original.
### Evidencias de querys
![evidencia 4](..\recursos\credenciales\04.png)
### 7.4 Crear una tabla para credenciales protegidas
### Evidencias de querys
![evidencia 5](..\recursos\credenciales\05.png)
![evidencia 6](..\recursos\credenciales\06.png)
![evidencia 7](..\recursos\credenciales\07.png)
### 7.5 Verificar una contraseña

Preguntas
1. **¿Qué resultado obtuviste con la contraseña correcta? R:**
Un `true`

1. **¿Qué resultado obtuviste con la contraseña incorrecta? R:**
Un `false`
1. **¿Por qué no es necesario recuperar la contraseña original? R:**
Porque basta con procesar la contraseña ingresada con el mismo hash guardado y comparar si los resultados coinciden para validar el acceso.
1. **¿Por qué un hash no debe confundirse con cifrado? R:**
Un hash es unidireccional y no permite recuperar el dato original, mientras que el cifrado es bidireccional y está diseñado para descifrarse cuando existe la clave adecuada.
### Evidencias de querys
![evidencia 8](..\recursos\credenciales\08.png)
![evidencia 9](..\recursos\credenciales\09.png)
