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
1. ¿Qué problemas identificas?
2. ¿Qué principio de privacidad se está ignorando?
3. ¿Qué preguntas realizarías antes de aprobar el diseño?
4. ¿Qué datos eliminarías?
5. ¿Qué datos requerirían una justificación adicional?
6. ¿Cómo aplicarías privacidad por defecto?

### Evidencias de querys

## 19. Actividad 13 — Diferenciar controles técnicos y administrativos

|Medida|Técnico|Administrativo|
|:---:|:---:|:---:|
|nombre|||
|correo|||
|telefono|||
|rfc|||
|edad|||
|ciudad|||
|codigo_postal|||