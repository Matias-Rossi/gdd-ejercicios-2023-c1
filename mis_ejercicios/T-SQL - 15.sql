/* ## Ejercicio 15 ## (OK)
	Cree el/los objetos de base de datos necesarios para que el objeto principal reciba un
	producto como parametro y retorne el precio del mismo.
	Se debe prever que el precio de los productos compuestos sera la sumatoria de los
	componentes del mismo multiplicado por sus respectivas cantidades. No se conocen
	los nivles de anidamiento posibles de los productos. Se asegura que nunca un
	producto esta compuesto por si mismo a ningun nivel. El objeto principal debe
	poder ser utilizado como filtro en el where de una sentencia select.
*/

CREATE FUNCTION dbo.obtenerPrecioSumatoriaComposicion(@producto CHAR(8))
RETURNS DECIMAL(12,2)
AS
BEGIN

	-- Revisando si el producto no es composicion
	IF NOT EXISTS (SELECT * FROM Composicion WHERE comp_producto=@producto)
	BEGIN
		RETURN (SELECT prod_precio FROM Producto WHERE prod_codigo=@producto);
	END --/if


	DECLARE @precioTotal DECIMAL(12,2);

	SET @precioTotal = (
		SELECT SUM(comp_cantidad * dbo.obtenerPrecioSumatoriaComposicion(comp_componente)) 
		FROM Composicion WHERE comp_producto = @producto );

	RETURN @precioTotal;
	
END --/create function
GO
--SELECT comp_componente, comp_cantidad, prod_precio From Composicion JOIN Producto ON comp_componente=prod_codigo WHERE comp_producto='00001104';
-- 1*3.51 + 2*1.7 = 6.91 OK
--SELECT dbo.obtenerPrecioSumatoriaComposicion('00001104');

