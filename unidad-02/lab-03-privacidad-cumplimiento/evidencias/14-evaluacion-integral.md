# Evaluación integral
## 20. Actividad 14 — Escenario integral
Considera la siguiente situación:
>- La empresa tiene una base de datos con información de 50,000 clientes.
>- Todos los empleados del área de analítica pueden consultar directamente la tabla clientes.
>- La tabla contiene nombre, correo, teléfono, RFC, edad, ciudad y código postal.
>- El área de analítica únicamente genera estadísticas mensuales.
>- Los datos se conservan desde hace 12 años.
>- No existe una política documentada de retención.
>- Los desarrolladores reciben copias completas de la base de datos para realizar pruebas.
>- Las copias de desarrollo contienen información real.
>- El área de marketing utiliza los correos electrónicos para campañas promocionales.
>- No existe documentación clara sobre qué finalidad corresponde a cada dato.

**Identifica al menos 10 problemas o riesgos.**

|Problema|Principio afectado|Riesgo|Control propuesto|
|:---:|:---:|:---:|:---:|
|Acceso directo de Analítica a la tabla clientes|Mínimo Privilegio / Limitación de Finalidad|Exposición masiva e innecesaria de PII (nombres, correos, RFC)|Crear Vistas agregadas y revocar permisos a la tabla base|
Conservación de datos por más de 12 años sin política|Retención y Minimización|Brechas de seguridad graves sobre datos obsoletos y multas regulatorias|Implementar Política de Retención y depuración programada|
|Entrega de copias con datos reales a Desarrolladores|Confidencialidad y Privacidad por Defecto|Filtración de datos productivos en entornos desprotegidos de dev/test|Aplicar técnicas de Anonymization o Data Masking en BDs de desarrollo|
|Marketing utiliza correos para promociones sin consentimiento|Consentimiento y Limitación de Finalidad|Sanciones legales por spam/prospección no autorizada|Implementar campo de consentimiento y vistas filtradas por opt-in|
|Ausencia de documentación sobre la finalidad por dato|Gobierno de Datos y Transparencia|Incapacidad de justificar el tratamiento ante auditorías de privacidad|Crear y publicar la Matriz de Inventario y Gobierno de Datos|
|Todos los empleados de Analítica tienen permisos de consulta|Mínimo Privilegio|Fuga interna de datos por accesos no acotados a funciones|Restringir permisos por sub-roles específicos de analistas|
Copias de la base de datos sin control de ciclo de vida|Control de Accesos y Trazabilidad|Existencia de múltiples réplicas huérfanas en equipos locales|Implementar un inventario centralizado de respaldos y cifrado de backups|
|Falta de controles de auditoría en consultas analíticas|Trazabilidad y Responsabilidad|Imposibilidad de detectar quién o cuándo se extrajo información|Habilitar el módulo de auditoría de PostgreSQL (pgaudit)|
|Uso de datos operativos mezclados con datos analíticos|Separación de Funciones|Modificación o degradación inadvertida de datos de producción|Desacoplar la base de datos operativa del ambiente analítico|
|Inexistencia de canal o flujo para derechos ARCO|Atención a Titulares|Incumplimiento legal que imposibilita rectificar o cancelar datos|Establecer procedimiento administrativo y técnico para solicitudes ARCO|