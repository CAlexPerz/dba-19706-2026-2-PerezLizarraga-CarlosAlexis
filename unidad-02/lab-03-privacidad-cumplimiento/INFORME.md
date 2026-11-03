## 1. Introducción

El presente informe aborda los problemas de privacidad, gobierno y cumplimiento normativo dentro de la administración de bases de datos relacionales en PostgreSQL 16. A través del escenario de Comercializadora Norte S.A. de C.V., se analiza que la seguridad técnica (cifrado, contraseñas, cortafuegos) no es suficiente si la organización almacena datos innecesarios, los procesa para finalidades no autorizadas o los conserva indefinidamente. 

Durante la práctica se tradujeron los principios de la Ley Federal de Protección de Datos Personales en Posesión de los Particulares (LFPDPPP) y estándares internacionales a controles técnicos concretos en PostgreSQL como la minimización de tablas, el control de acceso basado en roles (RBAC), la creación de vistas restringidas y la trazabilidad de los derechos ARCO.

## 2. Inventario de datos

| Campo | ¿Dato Personal? | Finalidad | ¿Necesario? | Nivel de Acceso | Retención |
| :---: | :--- | :---: | :---: | :---: | :---: |
| id | No (Técnico) | Identificador único en la BD | Sí | DBA, Operación | Duración de la cuenta |
| nombre | Sí | Identificación del cliente | Sí | Atención a clientes, Facturación | Relación comercial |
| correo | Sí | Contacto y notificaciones | Sí | Atención a clientes | Relación comercial |
| telefono | Sí | Contactación directa / soporte | Sí | Atención a clientes | Relación comercial |
| rfc | Sí (Fiscal) | Facturación y comprobantes | Sí | Únicamente Facturación | 5 años (Obligación fiscal) |
| edad | Sí | Agregación demográfica | No en Soporte | Analítica (vía vista) | Anonimizado / Indefinido |
| ciudad | Sí (Indirecto) | Análisis regional | Sí | Analítica, Operaciones | Periodo analítico |
| codigo_postal| Sí (Indirecto) | Logística y regiones | Sí | Operaciones, Analítica | Relación comercial |
| fecha_alta | No (Técnico) | Control de antigüedad | Sí | DBA, Operación | Indefinido / Auditoría |


## 3. Finalidades

1. **Atención al Cliente / Soporte:** Requiere únicamente datos directos de contacto (`nombre`, `correo`, `telefono`).
2. **Facturación:** Requiere datos fiscales de cumplimiento obligatorio (`nombre`, `rfc`).
3. **Analítica:** Requiere información puramente agregada o seudonimizada (`ciudad`, rangos de `edad`) para obtener métricas sin reidentificar al titular.

## 4. Minimización de datos

* **Área de Soporte:** Se sustituyó la consulta directa a la tabla `clientes` por la estructura reducida `clientes_soporte`, eliminando `rfc`, `edad`, `ciudad`, `codigo_postal` y `fecha_alta`.
* **Área de Analítica:** Se eliminaron todos los identificadores directos (`nombre`, `correo`, `telefono`, `rfc`), proporcionando agrupaciones estadísticas mediante `COUNT(*)` y categorías por rangos de edad.


## 5. Control de acceso por finalidad
* Se creó el rol `analista` sin permisos de inicio de sesión directo (`NOLOGIN`).
* Se creó la vista `v_analitica_clientes` para exponer exclusivamente agregaciones de edad y ciudad.
* Se revocó cualquier acceso directo del rol `analista` sobre la tabla principal `clientes` (`REVOKE SELECT ON clientes FROM analista;`), otorgando permiso únicamente sobre la vista (`GRANT SELECT ON v_analitica_clientes TO analista;`).

## 6. Implicaciones técnicas de los Derechos ARCO

* **Acceso (A):** Implica ejecutar consultas de localización completa de PII en la base de datos, además de proporcionar al titular información administrativa sobre transferencias y finalidades informadas en el Aviso de Privacidad.
* **Rectificación (R):** Requiere la ejecución de instrucciones `UPDATE` acotadas por la clave primaria (`id`), exigiendo trazabilidad y registro de auditoría (`audit log`) para verificar la autorización de la modificación.
* **Cancelación (C):** Trasciende la simple ejecución de un `DELETE` en la tabla activa, exigiendo la eliminación o depuración de copias en respaldos, réplicas, logs de transacciones (WAL), ambientes de desarrollo y data warehouses.
* **Oposición (O):** No elimina los datos principales si persiste una base legal o relación contractual, sino que exige la implementación de marcas de exclusión (banderas booleanas) o vistas filtradas para detener el tratamiento en finalidades secundarias (p. ej., marketing).

## 7. Retención y ciclo de vida

Conservar información indefinidamente incrementa los riesgos de exposición masiva ante incidentes de seguridad y violaciones normativas. La retención debe regirse por:
1. **Límites contractuales:** Duración del servicio o contrato con el cliente.
2. **Obligaciones legales:** Tiempos estipulados por leyes fiscales o comerciales (p. ej., 5 años para comprobantes de facturación).
3. **Depuración o Anonimización:** Eliminación definitiva o irreversibilidad de los datos al concluir el periodo legalmente justificado.


## 8. Gobierno de datos

| Dato | Finalidad Primaria | Data Owner (Propietario) | Custodio Técnico | Usuarios Autorizados | Acción al Finalizar |
| :---: | :---: | :---: | :---: | :---: | :---: |
| nombre | Servicio / Contrato | Dirección Operativa | DBA | Atención a Clientes | Eliminación / Cancelación |
| correo | Notificaciones | Dirección Operativa | DBA | Atención a Clientes | Bloqueo / Eliminación |
| telefono | Soporte directo | Atención al Cliente | DBA | Atención a Clientes | Depuración |
| rfc | Comprobación Fiscal | Dirección Financiera | DBA | Facturación | Eliminación tras 5 años |
| edad | Estadística | Dirección de Negocio | DBA | Analítica (Vista) | Anonimización |
| ciudad | Estadística regional | Dirección de Negocio | DBA | Analítica, Operaciones | Anonimización |


## 9. Evaluación integral de riesgos

| Problema Detectado | Principio Afectado | Riesgo Asociado | Control Propuesto |
| :--- | :--- | :--- | :--- |
| Acceso directo de Analítica a la tabla clientes | Limitación de Finalidad / Mínimo Privilegio | Exposición masiva e innecesaria de PII (RFC, teléfonos) | Restringir el acceso a tablas base y exponer solo Vistas agregadas |
| Copias completas con datos reales en Desarrollo | Privacidad por Defecto / Confidencialidad | Filtración de datos productivos en entornos no auditados | Aplicar procesos de Anonymization o Data Masking en bases de prueba |
| Conservación de datos por 12 años sin política | Retención y Minimización | Incremento de impacto ante brechas y sanciones por retención ilícita | Definir e implementar una Política de Retención automatizada |
| Correos usados para promociones sin consentimiento | Consentimiento y Finalidad | Sanciones legales por envío de publicidad no autorizada | Crear banderas de consentimiento (Opt-in) y vistas filtradas para Marketing |
| Falta de registros de auditoría en cambios de datos | Trazabilidad / Responsabilidad | Imposibilidad de verificar quién o cuándo rectificó un dato personal | Activar módulos de auditoría (`pgaudit`) para sentencias DDL/DML sensibles |

## 10. Conclusiones

1. **Seguridad vs. Privacidad:** Una base de datos con cifrado fuerte e infraestructura endurecida puede violar la ley de privacidad si recopila datos sin justificación o los usa para fines no informados.
2. **El Rol del DBA:** El DBA actúa como **custodio técnico**, encargado de traducir políticas organizacionales y normativas en esquemas, vistas, roles y permisos en el motor de base de datos.
3. **Privacidad desde el Diseño:** Incorporar controles de acceso y minimización desde la etapa del modelado relacional reduce drásticamente el riesgo de fuga de datos en la organización.

## 11. Preguntas de reflexión

1. **¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?**\
No. La seguridad técnica garantiza confidencialidad, integridad y disponibilidad (protección contra accesos no autorizados o ataques). La privacidad abarca la legitimidad, minimización, transparencia, consentimiento y finalidad del dato. Una base de datos cifrada y bien protegida incumple las normas de privacidad si almacena datos recopilados ilícitamente, sin consentimiento o para fines no autorizados.

2. **¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?**\
Porque al limitar las consultas y permisos de cada rol a lo estrictamente necesario para su función operativa, se reduce la exposición indebida de Datos Personales Identificables (PII), reduciendo la superficie de ataque y minimizando el riesgo de filtraciones internas o uso inapropiado de la información.

3. **¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?**\
El DBA posee un rol de **custodio técnico**, no de propietario de datos (*Data Owner*) ni apoderado legal. Definir la finalidad exige conocer el marco jurídico aplicable, las políticas comerciales de la empresa y las bases legales del tratamiento, decisiones que corresponden a las áreas de Privacidad, Dirección Jurídica y Negocio.

4. **¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?**\
Porque las bases de datos de producción contienen información real e identificable de clientes. Entregar estas copias viola el principio de minimización y expone información sensible en ambientes de prueba que habitualmente carecen de los mismos niveles de seguridad, cifrado y auditoría que producción.

5. **¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?**\
Porque los entornos de desarrollo suelen ser accedidos por múltiples personas (desarrolladores, testers, proveedores externos), se alojan con frecuencia en equipos portátiles o servidores con menos restricciones, y carecen de registros de auditoría estrictos, facilitando la extracción o pérdida no autorizada de datos reales.

6. **¿Por qué la retención debe formar parte del ciclo de vida de los datos?**\
Porque mantener datos indefinidamente contraviene el principio de temporabilidad y minimización. Acumular información obsoleta incrementa innecesariamente los costos de almacenamiento y el impacto legal y financiero en caso de una brecha de seguridad.

7. **¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?**\
La privacidad por diseño implica considerar la protección de los datos desde la conceptualización de los sistemas. En bases de datos, esto se traduce en diseñar tablas con campos estrictamente necesarios, definir tipos de datos acotados, aplicar restricciones de integridad, implementar aislamiento de esquemas y preconfigurar vistas restringidas antes de salir a producción.

8. **¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?**
    - Control de acceso basado en roles (RBAC) y vistas limitadas.
    - Cifrado en tránsito (TLS/SSL) y cifrado en reposo (TDE / pgcrypto).
    - Enmascaramiento dinámico o seudonimización de datos sensibles.
    - Habilitación de auditoría detallada de accesos y modificaciones (`pgaudit`).
    - Desacoplamiento de entornos operativos y analíticos.

9. **¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?**
   - Las tablas, vistas y esquemas donde se almacena la PII del titular.
   - La clave primaria o identificador único para localizar los registros.
   - La existencia de réplicas, respaldos, archivos de log y entornos secundarios.
   - Las dependencias relacionales (claves foráneas) para evaluar el impacto de una eliminación o anonimización.

10. **¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?**
    - **DBA (Custodio Técnico):** Implementa y mantiene los controles técnicos (roles, permisos, cifrado, vistas, auditoría) y ejecuta procedimientos técnicos de depuración autorizados.
    - **Responsable de Privacidad / DPO:** Diseña las políticas institucionales de privacidad, supervisa la atención a derechos ARCO y vigila el cumplimiento normativo.
    - **Área Jurídica:** Determina las bases legales del tratamiento, redacta los avisos de privacidad y responde ante requerimientos de autoridades reguladoras.
    - **Propietario de Datos (Data Owner):** Define la necesidad de negocio de cada dato, autoriza quién requiere acceso a la información y determina los periodos de retención operativa.