/* ## Ejercicio 6 ## (PENDIENTE)      Super grande, nunca hubo en un parcial o final
	Realizar un procedimiento que si en alguna factura se facturaron componentes que
	conforman un combo determinado (o sea que juntos componen otro producto de
	mayor nivel), en cuyo caso deberá reemplazar las filas correspondientes a dichos
	productos por una sola fila con el producto que componen con la cantidad de dicho
	producto que corresponda
*/

CREATE PROCEDURE dbo.reemplazarPorComponentes
AS
BEGIN

	DECLARE @tipo CHAR(1);
	DECLARE @sucursal CHAR(4);
	DECLARE @numero CHAR(8);

	

	DECLARE @producto CHAR(8);

	DECLARE facturas CURSOR FOR 
		SELECT fact_tipo, fact_sucursal, fact_numero--, item_producto, item_cantidad 
		FROM Factura --JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero

	FETCH FROM facturas INTO @tipo, @sucursal, @numero;

	WHILE @@FETCH_STATUS=0
		DECLARE @items_factura TABLE (item_producto CHAR(8), item_cantidad DECIMAL(12,2));

		INSERT INTO @items_factura 
			SELECT item_producto, item_cantidad FROM Item_Factura 
			WHERE item_tipo+item_sucursal+item_numero=@tipo+@sucursal+@numero;
		
		

	BEGIN
		

	END

END