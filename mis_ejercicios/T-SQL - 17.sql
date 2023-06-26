/* ## Ejercicio 17 ## (OK)
	Sabiendo que el punto de reposicion del stock es la menor cantidad de ese objeto
	que se debe almacenar en el deposito y que el stock maximo es la maxima cantidad
	de ese producto en ese deposito, cree el/los objetos de base de datos necesarios para
	que dicha regla de negocio se cumpla automaticamente. No se conoce la forma de
	acceso a los datos ni el procedimiento por el cual se incrementa o descuenta stock

	SIEMPRE REIVSAR QUE ESTÉN BIEN LAS CONDICIONES DE LOS IF (que < o > no estén al revés!)

	Abajo con Instead of
*/

CREATE TRIGGER comprobarStockEnRango ON Stock FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS (
		SELECT * FROM inserted i 
		WHERE i.stoc_cantidad > i.stoc_stock_maximo OR i.stoc_cantidad < i.stoc_punto_reposicion
	)
	BEGIN
		PRINT('El STOCK queda menor al punto de reposición o mayor al stock máximo.');
		ROLLBACK;
	END
END
GO

-- Si me pidieran que entren los que están bien...
-- Ver que la condición, además de invertir los signos, lleva un AND (conjunción)
-- Para update hay que pasar una a una las columnas, excepto por la pK

CREATE TRIGGER comprobarStockEnRangoInsteadOf ON Stock INSTEAD OF INSERT, UPDATE
AS
BEGIN

	IF (SELECT COUNT(*) FROM deleted) = 0 --Se ejecutó un INSERT
		BEGIN
		INSERT stock SELECT * FROM inserted WHERE stoc_cantidad <= stoc_stock_maximo AND stoc_cantidad >= stoc_punto_reposicion;
	END --/if
	ELSE --Se ejecutó un UPDATE
		BEGIN

		DECLARE insertados CURSOR FOR SELECT * FROM inserted WHERE stoc_cantidad <= stoc_stock_maximo AND stoc_cantidad >= stoc_punto_reposicion;

		DECLARE @producto CHAR(8);
		DECLARE @deposito CHAR(2);
		DECLARE @cantidad DECIMAL(12,2);
		DECLARE @punto_reposicion DECIMAL(12,2);
		DECLARE @stock_maximo DECIMAL(12,2);
		DECLARE @detalle CHAR(100);
		DECLARE @proxima_reposicion SMALLDATETIME;

		FETCH FROM insertados INTO @producto, @deposito, @cantidad, @punto_reposicion, @stock_maximno, @detalle, @proxima_reposicion;

		WHILE @@FETCH_STATUS=0
		BEGIN
			UPDATE stock SET
				stoc_cantidad=@cantidad,
				stoc_punto_reposicion=@punto_reposicion,
				stoc_stock_maximo=@stock_maximo,
				stoc_detalle=@detalle,
				stoc_proxima_reposicion=@proxima_reposicion
			WHERE stoc_producto=@producto AND stoc_deposito=@deposito
		END --/while
		
	END --/else

END