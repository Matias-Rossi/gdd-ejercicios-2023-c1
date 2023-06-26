/* ## Ejercicio 4 ## (OK)
	Cree el/los objetos de base de datos necesarios para actualizar la columna de
	empleado empl_comision con la sumatoria del total de lo vendido por ese empleado
	a lo largo del �ltimo a�o. Se deber� retornar el c�digo del vendedor que m�s vendi�
	(en monto) a lo largo del �ltimo a�o.
*/

-- OBSERVACI�N: si bien no est� en el modelo, en Factura se tiene al vendedor!
-- OBSERVACI�N: �ltimo a�o que se vendi� SELECT TOP 1 YEAR(fact_fecha) FROM Factura ORDER BY fact_fecha desc
--              explicado en la clase del 16-5-2023 en el minuto 2:15:00

DROP PROCEDURE dbo.actualizarComisiones
GO

CREATE PROCEDURE dbo.actualizarComisiones(@vendedorQueMasVendio NUMERIC(6) OUTPUT)
AS
BEGIN

	UPDATE empleado
	SET empl_comision = (
		SELECT COUNT(*) 
		FROM Factura 
		WHERE 
			fact_vendedor=empl_codigo AND 
			YEAR(fact_fecha) = (SELECT TOP 1 YEAR(fact_fecha) FROM Factura ORDER BY fact_fecha DESC)
	);

	SELECT TOP 1 @vendedorQueMasVendio = empl_codigo
	FROM empleado 
	JOIN Factura ON fact_vendedor=empl_codigo 
	WHERE YEAR(fact_fecha) = (SELECT TOP 1 YEAR(fact_fecha) FROM Factura ORDER BY fact_fecha DESC)
	GROUP BY empl_codigo 
	ORDER BY SUM(fact_total) DESC;

END
GO

-- Testing
DECLARE @empleado NUMERIC(6)
EXEC dbo.actualizarComisiones @empleado
