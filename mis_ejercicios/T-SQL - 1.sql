USE [GD2015C1]; GO;
/*
	Pendiente (P); Hecho (H); Testeado(T); Corregido (OK)

	Ejericios	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15	16	17	18	19	20
				T	P
*/
/* ## Ejercicio 1 ## (PENDIENTE)

	Hacer una función que dado un artículo y un deposito devuelva un string que
	indique el estado del depósito según el artículo. Si la cantidad almacenada es
	menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el
	% de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar
	“DEPOSITO COMPLETO”.

*/

-- OBSERVACIÓN: Hacer un IF más para evitar división por 0

CREATE FUNCTION dbo.estadoDeposito(@producto_codigo CHAR(8), @deposito_codigo CHAR(2))
RETURNS CHAR(30)
AS 
BEGIN
	DECLARE @limite_producto DECIMAL(12,2);
	DECLARE @stock_actual DECIMAL(12,2);
	SELECT 
		@limite_producto = stoc_stock_maximo,
		@stock_actual = stoc_cantidad
	FROM STOCK
	WHERE stoc_producto=@producto_codigo AND stoc_deposito=stoc_deposito;

	IF(@stock_actual < @limite_producto)
	BEGIN
		DECLARE @ocupacion DECIMAL(12,2) = 100*@stock_actual/@limite_producto;
		RETURN CONCAT('OCUPACION DEL DEPOSITO ', CAST(@ocupacion AS VARCHAR), '%');
	END
	RETURN 'DEPOSITO COMPLETO';
END
GO

-- Pruebas (OK)
SELECT TOP 2 stoc_producto, stoc_deposito, stoc_cantidad, stoc_stock_maximo FROM STOCK;
PRINT(dbo.estadoDeposito('00000030', '00'))-- 0.2
PRINT(dbo.estadoDeposito('00000032', '00')) -- 0.2

-- prueba en select
SELECT stoc_producto, stoc_deposito, dbo.estadoDeposito(stoc_producto, stoc_deposito)
FROM STOCK
WHERE stoc_stock_maximo != 0