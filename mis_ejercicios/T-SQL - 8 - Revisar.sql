/* ## Ejercicio 8 ## (OK)
	Realizar un procedimiento que complete la tabla Diferencias de precios, para los
	productos facturados que tengan composición y en los cuales el precio de
	facturación sea diferente al precio del cálculo de los precios unitarios por cantidad
	de sus componentes, se aclara que un producto que compone a otro, también puede
	estar compuesto por otros y así sucesivamente, la tabla se debe crear y está formada
	por las siguientes columnas:

	DIFERENCIAS
	- Codigo: del articulo
	- Detalle: del articulo
	- Cantidad: de productos que conforman el combo
	- Precio_generado: precio que se compone a traves de sus componentes
	- Precio_facturado: precio del producto
*/

CREATE TABLE diferencias(
	dife_codigo CHAR(8),
	dife_detalle CHAR(50),
	dife_cantidad DECIMAL(12,2),
	dife_precio_generado DECIMAL(12,2),
	dife_precio_facturado DECIMAL(12,2)
)
ALTER TABLE diferencias ADD CONSTRAINT pk_diferencias PRIMARY KEY (dife_codigo)
GO

CREATE FUNCTION dbo.obtenerPrecioGenerado(@producto CHAR(8))
RETURNS DECIMAL(12,2)
AS
	BEGIN
		DECLARE @precio DECIMAL(12,2);
		SET @precio = 0;
		
		IF NOT EXISTS (SELECT * FROM Composicion WHERE comp_producto = @producto)
		BEGIN
			SET @precio = (SELECT prod_precio FROM Producto WHERE prod_codigo=@producto)
			RETURN @precio;
		END

		DECLARE componentes CURSOR FOR SELECT comp_componente, comp_cantidad FROM Composicion WHERE comp_producto=@producto;
		OPEN componentes;

		DECLARE @componente CHAR(8);
		DECLARE @cantidad DECIMAL(12,2);

		FETCH FROM componentes INTO @componente, @cantidad

		WHILE @@FETCH_STATUS=0 
		BEGIN
			SET @precio = @precio + @cantidad * dbo.obtenerPrecioGenerado(@componente);
			FETCH FROM componentes INTO @componente, @cantidad
		END

		CLOSE componentes;
		DEALLOCATE componentes;

		RETURN @precio;
	END;
GO

CREATE PROCEDURE dbo.llenarDiferencias()
AS
BEGIN
	INSERT INTO dbo.diferencias
	SELECT
		prod_compuesto.prod_codigo,
		prod_compuesto.prod_detalle,
		COUNT(DISTINCT compuesto.comp_componente) cantidad,
		dbo.obtenerPrecioGenerado(prod_compuesto.prod_codigo) precio_generado,
		item_precio precio_facturado
	FROM  Producto prod_compuesto
	JOIN Composicion compuesto ON prod_compuesto.prod_codigo = compuesto.comp_producto
	JOIN Item_Factura ON item_producto=compuesto.comp_producto
	WHERE dbo.obtenerPrecioGenerado(compuesto.comp_producto) <> item_precio
	GROUP BY 
		prod_compuesto.prod_codigo, 
		prod_compuesto.prod_detalle, 
		item_precio;
END

