# Privacidad de diseño
## 18. Actividad 12 — Privacidad por diseño

Analiza el siguiente escenario:
Una nueva aplicación requiere registrar clientes.
El desarrollador propone:
```sql
CREATE TABLE clientes ( id BIGSERIAL, nombre TEXT, correo TEXT, telefono TEXT, rfc
TEXT,
edad INTEGER, direccion TEXT, ciudad TEXT, codigo_postal TEXT, fecha_nacimiento
DATE,
ocupacion TEXT, salario NUMERIC, estado_civil TEXT, ...);
```

La justificación es:

> “Es mejor guardar todos los datos por si posteriormente necesitamos alguno.”

Preguntas
1. **¿Qué problemas identificas?**<br>Se están solicitando datos altamente sensibles o innecesarios para la operación básica (salario, estado_civil, ocupacion, fecha_nacimiento completa) sin justificación operativa explicada.
2. **¿Qué principio de privacidad se está ignorando?**<br>Privacidad por Diseño, Privacidad por Defecto y Minimización de Datos.
3. **¿Qué preguntas realizarías antes de aprobar el diseño?**<br>
    - ¿Para qué función específica del sistema se requiere registrar el salario y el estado_civil?
    - ¿Es indispensable almacenar la fecha_nacimiento exacta o basta con confirmar la mayoría de edad?  
4. **¿Qué datos eliminarías?**<br>salario, estado_civil y ocupacion.
5. **¿Qué datos requerirían una justificación adicional?**<br>direccion completa (si no hay entregas físicas, basta con codigo_postal) y fecha_nacimiento.
6. **¿Cómo aplicarías privacidad por defecto?**<br>Configurando el esquema inicial para solicitar únicamente los campos mínimos esenciales (id, nombre, correo), dejando cualquier recopilación adicional desactivada y sujeta a consentimiento opt-in previo.

## 19. Actividad 13 — Diferenciar controles técnicos y administrativos

|Medida|Técnico|Administrativo|Justificación|
|:---:|:---:|:---:|:---:|
|Crear roles de PostgreSQL||X|Configuración directa de seguridad en el motor de base de datos|
|Cifrado de datos|X||Documento normativo que establece las reglas de conservación de datos de la empresa.|
|Procedimiento para solicitudes ARCO||X|Mecanismo criptográfico aplicado por software o motor para proteger la confidencialidad.|
|Vista con información limitada|X||Flujo organizacional y protocolo que define cómo atender a un titular.|
|Clasificación de información||X|Objeto de base de datos que restringe el acceso a columnas o filas.|
|Registro de auditoría|X||Marco institucional que define categorías de sensibilidad para los datos.|
|Política de control de acceso||X|Documento normativo que define quién tiene derecho a acceder a qué información.|