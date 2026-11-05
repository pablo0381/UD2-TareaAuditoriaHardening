-- Agente Sara
-- (vista enmascarada funciona)
SELECT * FROM panel_clientes;
-- (error 1142 al acceder a las tablas base)
SELECT * FROM tb_clientes;


-- Root
-- (para auditar plugins y el límite de conexiones del bot_extraccion)
SELECT * FROM mysql.global_priv;

-- (privilegios de rol_atencion_cliente)
SELECT * FROM mysql.tables_priv;

-- (asignación de usuarios)
SELECT * FROM mysql.roles_mapping;