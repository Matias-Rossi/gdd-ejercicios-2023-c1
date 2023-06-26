/* ## Ejercicio 18 ## (Pendiente)
	Sabiendo que el limite de credito de un cliente es el monto maximo que se le puede
	facturar mensualmente, cree el/los objetos de base de datos necesarios para que
	dicha regla de negocio se cumpla automaticamente. No se conoce la forma de
	acceso a los datos ni el procedimiento por el cual se emiten las facturas

	Ojo a las cosas agrupadas (mes, año, cliente)
*/
-- VER ABAJO SOLUCION CON INSTEAD OF

CREATE TRIGGER revisarLimiteCredito ON Factura AFTER INSERT
AS
BEGIN
	IF EXISTS(
		SELECT i.fact_cliente, SUM(i.fact_total), clie_limite_credito, YEAR(i.fact_fecha), MONTH(i.fact_fecha)
		FROM inserted i
		JOIN cliente ON fact_cliente=clie_codigo 
		GROUP BY i.fact_cliente, YEAR(i.fact_fecha), MONTH(i.fact_fecha)
		HAVING (SUM(i.fact_total) + (
			SELECT SUM(f_ant.fact_total) 
			FROM factura f_ant 
			WHERE f_ant.fact_cliente=i.fact_cliente 
			AND MONTH(f_ant.fact_fecha)=MONTH(i.fact_fecha)
			AND YEAR(f_ant.fact_fecha)=YEAR(i.fact_fecha)
		) > clie_limite_credito ))
	BEGIN
		ROLLBACK;
	END
END
GO --/trigger

-- ##### INSTEAD OF #####
-- Conviene que devuelva aquellos que están bien, por lo que se invierte al booleano del having
-- Es muy complicado instead of con update
-- Instead of va cuando hay que controlar algo (y la condicion va por bien, a diferencia del after que va por lo que está mal)
CREATE TRIGGER revisarLimiteCreditoInsteadOf ON Factura INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO factura SELECT * FROM inserted WHERE fact_cliente IN (
		SELECT i.fact_cliente
		FROM inserted i
		JOIN cliente ON fact_cliente=clie_codigo 
		GROUP BY i.fact_cliente, YEAR(i.fact_fecha), MONTH(i.fact_fecha)
		HAVING (SUM(i.fact_total) + (
			SELECT SUM(f_ant.fact_total) 
			FROM factura f_ant 
			WHERE f_ant.fact_cliente=i.fact_cliente 
			AND MONTH(f_ant.fact_fecha)=MONTH(i.fact_fecha)
			AND YEAR(f_ant.fact_fecha)=YEAR(i.fact_fecha)
		) <= clie_limite_credito ))
	BEGIN
		ROLLBACK;
	END
END
GO --/trigger
