-- HERENCIA DE ROLES
-- Crea un grupo grp_lectura_analitica - NOLOGIN - (Equivale a un grupo)
CREATE ROLE grp_lectura_analitica NOLOGIN;


-- Nivel de Base de Datos: Permiso para conectarse a finanzas_db
GRANT CONNECT ON DATABASE finanzas_db TO grp_lectura_analitica;

-- Nivel de Esquema: Permiso de uso (usage) para atravesar el esquema public
GRANT USAGE ON SCHEMA public TO grp_lectura_analitica;

-- Nivel de Tablas: Permiso SELECT sobre todas las tablas actuales del esquema public
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grp_lectura_analitica;


-- with login (Equivale a un usuario)
CREATE ROLE analista_datos WITH LOGIN PASSWORD 'analistadatos123'; 

-- Asignar el rol del grupo al usuario analista_datos
GRANT grp_lectura_analitica TO analista_datos;

-- Configurar la herencia de permisos activa por defecto
ALTER ROLE analista_datos INHERIT;


-- PRIVILEGIOS FUTUROS
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO grp_lectura_analitica;


-- CUENTA TEMPORAL
-- Crear el rol con login, contraseña y fecha de caducidad
CREATE ROLE auditor_temporal_pg WITH LOGIN PASSWORD 'auditortemp123' VALID UNTIL '2026-12-31';

-- Asignar el grupo de lectura al usuario temporal
GRANT grp_lectura_analitica TO auditor_temporal_pg;

-- Asegurar la herencia automática de permisos
ALTER ROLE auditor_temporal_pg INHERIT;