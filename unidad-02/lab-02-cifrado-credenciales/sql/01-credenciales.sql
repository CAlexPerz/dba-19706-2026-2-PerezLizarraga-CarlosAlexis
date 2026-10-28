CREATE TABLE usuarios_insegura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);
-- Insertamos un usuario de prueba:
INSERT INTO usuarios_insegura (usuario, password)
VALUES ('juan', 'Password123');
-- Consulta:
SELECT * FROM usuarios_insegura;

-- 7.3 Generar una representación no reversible
-- Para fines didácticos utilizaremos pgcrypto.
-- Ejemplo:
SELECT crypt( 'Password123',    gen_salt('bf'));

-- Observa el resultado.
-- Ejecuta nuevamente:
SELECT crypt(  'Password123',  gen_salt('bf'));

-- 7.4 Crear una tabla para credenciales protegidas
-- Crea:
CREATE TABLE usuarios_segura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);
-- Inserta un usuario:
INSERT INTO usuarios_segura (usuario, password_hash)
VALUES (
    'juan',
    crypt('Password123', gen_salt('bf'))
);
-- Consulta:
SELECT * FROM usuarios_segura;
-- Observa que ya no aparece la contraseña original.

-- 7.5 Verificar una contraseña
-- Para verificar una contraseña:
SELECT    usuario,    password_hash = crypt('Password123', password_hash)
        AS contraseña_correcta FROM usuarios_segura WHERE usuario = 'juan';

-- Prueba ahora con una contraseña incorrecta:
SELECT usuario, password_hash = crypt('OtraPassword', password_hash)
        AS contraseña_correcta FROM usuarios_segura WHERE usuario = 'juan';
