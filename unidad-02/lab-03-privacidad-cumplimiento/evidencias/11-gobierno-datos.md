# Gobierno de datos
## 17. Actividad 11 — Diseñar una matriz de gobierno de datos

|Campo|Finalidad|Responsable|Usuarios autorizados|Protección|Retención|Acción al finalizar|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|nombre|Identificación del cliente|Atención al cliente|Atención al cliente, Facturación, DBA|Control de acceso (RBAC)|Durante la relación comercial|Cancelación / Eliminación|
|correo|Comunicación y notificaciones|Atención al cliente|Atención al cliente, DBA|Control de acceso, Cifrado en tránsito|Durante la relación comercial|Cancelación / Bloqueo|
|telefono|Soporte técnico directo|Atención al cliente|Atención al cliente, DBA|Control de acceso|Durante la relación comercial|Eliminación|
|rfc|Emisión de comprobantes fiscales|Facturación|Facturación, DBA|Control de acceso estricto, Cifrado|5 años|Eliminación definitiva|
|edad|Segmentación demográfica|Analítica|Analítica (vista agregada), DBA|Seudonimización / Agregación|Indefinido|Anonimización irreversible|
|ciudad|Análisis de mercado regional|Analítica|Analítica, Operaciones, DBA|Control de acceso vía Vista|3 años|Anonimización|
|codigo_postal|Logística y regiones|Operaciones|Operaciones, Analítica, DBA|Control de acceso|Durante la relación comercial|Eliminación / Depuración|