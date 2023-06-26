/* ## Ejercicio 5 ## (PENDIENTE, NO ANDA)
	Realizar un procedimiento que complete con los datos existentes en el modelo
	provisto la tabla de hechos denominada Fact_table tiene las siguiente definición:
*/
DROP TABLE dbo.fact_table 
GO

Create table dbo.fact_table( 
	anio char(4) NOT NULL,
	mes char(2) NOT NULL,
	familia char(3) NOT NULL,
	rubro char(4) NOT NULL,
	zona char(3) NOT NULL,
	cliente char(6) NOT NULL,
	producto char(8) NOT NULL,
	cantidad decimal(12,2),
	monto decimal(12,2)
)
Alter table fact_table
Add constraint pk_fact_table primary key(anio,mes,familia,rubro,zona,cliente,producto)
-- FIN DEFINIICÓN ENUNCIADO
GO

DROP PROCEDURE dbo.poblar_fact_table
GO

CREATE PROCEDURE dbo.poblar_fact_table
AS
BEGIN
	INSERT INTO fact_table
	SELECT DISTINCT
		anio = YEAR(fact_fecha),
		mes = MONTH(fact_fecha),
		familia = prod_familia,
		rubro = prod_rubro,
		zona = (SELECT depa_zona FROM Empleado JOIN Departamento ON empl_departamento=depa_codigo WHERE empl_codigo=fact_vendedor),
		cliente = fact_cliente,
		producto = prod_codigo,
		cantidad = item_cantidad,
		monto = item_cantidad*item_precio
	FROM Factura
	JOIN Item_Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
	JOIN Producto ON item_producto=prod_codigo
END
GO

BEGIN TRY
	EXEC dbo.poblar_fact_table
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
END CATCH
