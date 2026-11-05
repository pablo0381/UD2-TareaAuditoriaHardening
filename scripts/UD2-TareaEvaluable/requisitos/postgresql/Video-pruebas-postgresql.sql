-- analista_datos
-- SELECT sobre historico
SELECT * FROM tb_transacciones_historicas;

-- Acceso denegado DELETE
DELETE FROM tb_transacciones_historicas WHERE id_transaccion = 2;