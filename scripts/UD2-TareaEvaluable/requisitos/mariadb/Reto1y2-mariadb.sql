-- Reto 1: Ecosistema MariaDB - Red y Data Masking
-- SEGURIDAD RED Y CUENTAS
SHOW PLUGINS;

-- Crear usuario administrativo con plugin ed25519 r a la puerta de enlace de Docker
CREATE USER 'dba_core'@'172.18.0.1' IDENTIFIED VIA ed25519 USING PASSWORD('@dbacore123');


-- Crear usuario auditor_externo r a toda la subred interna de Docker
CREATE USER 'auditor_externo'@'172.18.0.%' IDENTIFIED BY 'auditorexterno123!';


-- ABSTRACCIÓN Y DATA MASKING
-- Creación de la vista con enmascaramiento de PAN y exclusión del CVV
CREATE VIEW v_tarjetas_seguras AS
SELECT 
    c.dni,
    c.nombre_completo,
    c.nivel_riesgo,
    CONCAT('**** **** **** ', SUBSTRING(t.pan_tarjeta, 13, 4)) AS pan_enmascarado
FROM tb_clientes c
JOIN tb_tarjetas t ON c.id_cliente = t.id_cliente;


-- OCULTACIÓN
CREATE OR REPLACE VIEW panel_clientes AS 
SELECT * FROM v_tarjetas_seguras;


-- Reto 2: Ecosistema MariaDB - RBAC y Control de Recursos
-- ROLES
CREATE ROLE rol_gestor_fraude;
CREATE ROLE rol_atencion_cliente;

-- Permisos DML totales para el gestor de fraude
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_clientes TO rol_gestor_fraude;
GRANT SELECT, INSERT, UPDATE, DELETE ON tb_tarjetas TO rol_gestor_fraude;

-- Permiso SELECT únicamente sobre el panel de clientes (vista)
GRANT SELECT ON panel_clientes TO rol_atencion_cliente;


-- CREAR USUARIOS NEGOCIO
CREATE USER 'jefe_seguridad'@'%' IDENTIFIED BY 'negseguridad123@';
CREATE USER 'agente_sara'@'%' IDENTIFIED BY 'negsara123@';


-- ASIGNAR ROLES
GRANT rol_gestor_fraude TO 'jefe_seguridad'@'%';
GRANT rol_atencion_cliente TO 'agente_sara'@'%';

-- Configurar roles por defecto
SET DEFAULT ROLE rol_gestor_fraude FOR 'jefe_seguridad'@'%';
SET DEFAULT ROLE rol_atencion_cliente FOR 'agente_sara'@'%';


-- PREVENCION DDOS
CREATE USER 'bot_extraccion'@'%' IDENTIFIED BY 'BotPassword123!'
WITH MAX_USER_CONNECTIONS 3;

-- Asignar el rol correspondiente
GRANT rol_atencion_cliente TO 'bot_extraccion'@'%';
SET DEFAULT ROLE rol_atencion_cliente FOR 'bot_extraccion'@'%';
