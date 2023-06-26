
/* ## Ejercicio 2 ## (OK)
	Realizar una función que dado un artículo y una fecha, retorne el stock que
	existía a esa fecha
*/

DROP FUNCTION dbo.stockEnFecha; 
GO

CREATE FUNCTION dbo.stockEnFecha(@articulo_codigo CHAR(8), @fecha DATE)
RETURNS DECIMAL(12,2)
AS
BEGIN
	DECLARE @EXISTENCIAS DECIMAL(12,2);
	SELECT @EXISTENCIAS = ISNULL(SUM(stoc_cantidad), 0)
	FROM STOCK 
	WHERE stoc_producto=@articulo_codigo;

	DECLARE @VENTAS_DESDE_FECHA DECIMAL(12,2);
	SELECT 
		@VENTAS_DESDE_FECHA = ISNULL(SUM(item_cantidad), 0)
	FROM Item_Factura 
	JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
	WHERE fact_fecha > @fecha AND item_producto=@articulo_codigo;

	RETURN @EXISTENCIAS + @VENTAS_DESDE_FECHA;
END
GO


-- Prueba

DECLARE @date date = '10-10-25';  
SELECT prod_detalle, dbo.stockEnFecha(prod_codigo, @date) FROM Producto;
