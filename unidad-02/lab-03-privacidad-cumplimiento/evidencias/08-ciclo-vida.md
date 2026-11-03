# Ciclo de vida
## 14. Actividad 8 — Derecho de cancelación y ciclo de vida

|clientes|
|:---:|
       │
       ├──> Bitácoras WAL y Logs de Auditoría (Write-Ahead Logs)
       ├──> Respaldos físicos y lógicos (.bak / .sql / dumps)
       ├──> Réplicas de lectura / Instancias Standby
       ├──> Data Warehouse / Repositorios de Analítica (procesos ETL pasados)
       ├──> Archivos exportados (.csv / .xlsx en equipos de desarrollo o soporte)
       └──> Sistemas externos e integraciones (ej. proveedores de mailing)

Pregunta
- **¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la
información relacionada con esa persona haya desaparecido de la organización?**<br>
Ejecutar una instrucción ```DELETE FROM clientes WHERE id = X```; únicamente remueve la fila del archivo de datos activo en la instancia principal de PostgreSQL. Sin embargo, la información personal puede permanecer en múltiples ubicaciones del ciclo de vida técnico:

## 15. Actividad 9 — Derecho de oposición

**Analiza:**

**¿Es necesario eliminar inmediatamente todos sus datos de la base?**<br>No. El derecho de oposición no implica la destrucción total de los datos si estos siguen siendo necesarios para la finalidad primaria legítima (ej. relación contractual o facturación).

1. **Información que debe mantenerse:** Datos de identificación y fiscales (ej. nombre, rfc) necesarios para mantener el servicio activo o cumplir con obligaciones legales/fiscales.
2. **Información que deja de utilizarse:** Datos de contacto en listas de prospección publicitaria o perfiles de analítica de comportamiento.   
3. **Mecanismos técnicos de separación:**
    - Agregar banderas de estado en la base de datos.
    - Uso de Vistas que filtren automáticamente a los usuarios opuestos.
4. Por qué la decisión no debe ser tomada únicamente por el DBA, ya que desconoce si existen obligaciones legales que exijan conservar la información. La decisión requiere el dictamen de las áreas Jurídica y de Cumplimiento. 

