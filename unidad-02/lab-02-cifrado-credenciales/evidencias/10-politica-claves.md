# Actividad 10 — Crear una política mínima de protección de claves
### Define una política de entre 5 y 10 reglas para la gestión de claves criptográficas.

1. **Generación:** Las claves deben generarse utilizando algoritmos criptográficos estándar y generadores de números aleatorios seguros.   
1. **Almacenamiento:** Queda estrictamente prohibido guardar claves dentro del código fuente, scripts SQL o repositorios Git; deben gestionarse en un servicio de secretos.   
1. **Acceso:** El acceso a las claves se restringirá exclusivamente a las aplicaciones o servicios autorizados bajo el principio de mínimo privilegio.   
1. **Rotación:** Las claves de cifrado deben rotarse periódicamente según el ciclo de vida definido por la organización.   
1. **Respaldo:** Los respaldos de las claves deben guardarse en un almacén cifrado y físicamente separado de los datos que protegen.   
1. **Revocación:** Toda clave sospechosa de compromiso debe ser revocada e invalidada inmediatamente.   
1. **Exposición accidental:** Si una clave se publica en un repositorio o registro, debe considerarse comprometida, rotarse de inmediato y eliminarse del historial.   
1. **Eliminación:** Al finalizar el ciclo de vida de una clave, se debe destruir mediante procedimientos que garanticen su irrecuperabilidad

Actividad 18 - Verificación final
- **¿Una contraseña debe cifrarse o protegerse mediante un mecanismo de derivación de claves para contraseñas? R:**\
Debe protegerse mediante un mecanismo de derivación de claves (hash con salt) para evitar su recuperación directa.   
- **¿Qué diferencia existe entre enmascaramiento, seudonimización y cifrado? R:**\
El enmascaramiento oculta parte del dato para visualización; la seudonimización reemplaza identificadores reales por valores ficticios; el cifrado transforma el dato mediante un algoritmo matemático y requiere una clave para volver a leerlo.   
- **¿Qué problema resuelve TLS? R:**\
Protege la información en tránsito entre el cliente y el servidor, garantizando confidencialidad, integridad y autenticación de la comunicación.   
- **¿Dónde debería almacenarse una clave criptográfica en un entorno real? R:**\
En un gestor de secretos externo o cargada mediante variables de entorno en tiempo de ejecución, nunca en el repositorio.   
- **¿Es correcto subir una contraseña o clave real a GitLab aunque el repositorio sea privado? R:**\
No. Un repositorio privado reduce la visibilidad externa, pero conserva el secreto dentro del historial de commits exponiéndolo a usuarios con acceso y copias locales. 