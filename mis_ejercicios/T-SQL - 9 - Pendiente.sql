/* ## Ejercicio 9 ## (REVISAR)
	Crear el/los objetos de base de datos que ante alguna modificación de un ítem de
	factura de un artículo con composición realice el movimiento de sus
	correspondientes componentes.
*/

CREATE TRIGGER dbo.actualizarComponentes ON Item_Factura
AFTER UPDATE AS
BEGIN

	DECLARE @tipo CHAR(1);
	DECLARE @sucursal CHAR(4);
	DECLARE @numero CHAR(8);
	DECLARE @producto CHAR(8);
	DECLARE @cantidadVieja DECIMAL(12,2);
	DECLARE @cantidadNueva DECIMAL(12,2);


	DECLARE actualizados CURSOR FOR 
	SELECT i.item_tipo, i.item_sucursal, i.item_numero, i.item_producto, d.item_cantidad, i.item_cantidad  FROM inserted i
	JOIN deleted d ON i.item_tipo+i.item_sucursal+i.item_numero+i.item_producto=d.item_tipo+d.item_sucursal+d.item_numero+d.item_producto

	OPEN actualizados

	FETCH actualizados INTO @tipo, @sucursal, @numero, @producto, @cantidadVieja, @cantidadNueva;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS (SELECT comp_producto FROM Composicion WHERE comp_producto=@producto)
		BEGIN
			
			DECLARE @cantidadAgregada DECIMAL(12,2);
			SET @cantidadAgregada = @cantidadNueva - @cantidadVieja

			IF @cantidadAgregada <> 0 -- Evita entrar en caso de que solo cambie el precio
			BEGIN
				
				DECLARE @componente CHAR(8);
				DECLARE @componente_cant DECIMAL(12,2);

				DECLARE componentes CURSOR FOR SELECT comp_componente, comp_cantidad FROM Composicion WHERE comp_producto=@producto;
				OPEN componentes;
				FETCH componentes INTO @componente, @componente_cant;

				WHILE @@FETCH_STATUS = 0
				BEGIN
					-- Resto componentes del stock
					UPDATE TOP(1) STOCK SET stoc_cantidad = stoc_cantidad - @cantidadAgregada * @componente_cant 
					WHERE stoc_producto=@componente AND stoc_cantidad >= @cantidadAgregada * @componente_cant;

					FETCH componentes INTO @componente, @componente_cant;
				END -- /while

				CLOSE componentes;
				DEALLOCATE componentes;

				FETCH actualizados INTO @tipo, @sucursal, @numero, @producto, @cantidadVieja, @cantidadNueva;
			END -- /if

		END -- /if
	END -- /while

	CLOSE actualizados;
	DEALLOCATE actualizados;


END; -- /trigger
GO