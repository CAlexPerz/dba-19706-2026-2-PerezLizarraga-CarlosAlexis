# Gestion de claves
## 9. Actividad 3 — El problema de la gestión de claves
### 9.1 Identificar una mala práctica

- **¿Qué ocurriría si esta clave fuera una clave utilizada realmente por una organización y el archivo se publicara en un repositorio Git?**\
**R:** La clave quedaría expuesta ante personas o sistemas no autorizados. Aunque el archivo se elimine en un commit posterior, la clave permanecerá en el historial de control de versiones de Git, permitiendo que cualquiera con acceso al repositorio la recupere y descifre la información sensible almacenada en la base de datos.
### Evidencias de querys
![evidencia 1](..\recursos\verificacion\g-claves-01.png)