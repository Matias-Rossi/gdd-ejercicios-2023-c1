/* ## Ejercicio 10 ## (OK)
	Crear el/los objetos de base de datos que ante el intento de borrar un artículo
	verifique que no exista stock y si es así lo borre en caso contrario que emita un
	mensaje de error.
*/


CREATE TRIGGER dbo.verificarStockAlBorrarArticulo ON producto INSTEAD OF DELETE
AS
BEGIN
	IF EXISTS (
		SELECT stoc_producto, stoc_deposito FROM deleted JOIN stock ON stoc_producto=prod_codigo 
		GROUP BY stoc_producto, stoc_deposito
		HAVING SUM(stoc_cantidad) > 0
	)
	BEGIN
		PRINT('No es posible borrar un artículo con stock cargado')
		ROLLBACK;
	END
	ELSE
	BEGIN
		DELETE FROM stock WHERE stoc_producto IN (SELECT prod_codigo FROM deleted)
		DELETE FROM producto WHERE prod_codigo IN (SELECT prod_codigo FROM deleted)
	END
END

-- 00009831 tiene 0, 00000124 tiene 1
SELECT stoc_producto, SUM(stoc_cantidad) FROM stock GROUP BY stoc_producto HAVING SUM(stoc_cantidad) = 0;

DELETE FROM producto WHERE prod_codigo='00000124'

DELETE FROM producto WHERE prod_codigo='00009831'

