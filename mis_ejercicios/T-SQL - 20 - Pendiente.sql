/* ## Ejercicio 20 ## (Pendiente)
	 Crear el/los objeto/s necesarios para mantener actualizadas las comisiones del vendedor.

	El cálculo de la comisión está dado por el 5% de la venta total efectuada por ese
	vendedor en ese mes, más un 3% adicional en caso de que ese vendedor haya
	vendido por lo menos 50 productos distintos en el mes.
*/

CREATE TRIGGER actualizarComisiones ON factura FOR INSERT --Update?
AS
BEGIN
	DECLARE @comisionBase DECIMAL(12,2);
	
	DECLARE @vendedor NUMERIC(6);
	DECLARE @total_facturas DECIMAL(12,2);

	DECLARE facturas CURSOR FOR SELECT fact_vendedor, SUM(fact_total) FROM inserted GROUP BY fact_vendedor;

	FETCH FROM facturas INTO @vendedor, @total_facturas;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		DECLARE @total_precio_vendedor DECIMAL(12,2);
		SET @total_precio_vendedor = SELECT SUM(fact_total) FROM factura WHERE fact_vendedor=@vendedor AND MONTH(GETDATE())=MONTH(;
		

		FETCH FROM facturas INTO @vendedor, @total_factura;
	END

	



END
