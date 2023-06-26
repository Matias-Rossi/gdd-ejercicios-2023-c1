
/* ## Ejercicio 3 ## (OK in my books)
	Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
	en caso que sea necesario. Se sabe que deber�a existir un �nico gerente general
	(deber�a ser el �nico empleado sin jefe). Si detecta que hay m�s de un empleado
	sin jefe deber� elegir entre ellos el gerente general, el cual ser� seleccionado por
	mayor salario. Si hay m�s de uno se seleccionara el de mayor antig�edad en la
	empresa. Al finalizar la ejecuci�n del objeto la tabla deber� cumplir con la regla
	de un �nico empleado sin jefe (el gerente general) y deber� retornar la cantidad
	de empleados que hab�a sin jefe antes de la ejecuci�n.

	Se crea un procedure porque se deben modificar datos.
*/

-- Para probar: UPDATE Empleado set empl_jefe = null WHERE empl_codigo > 5;

DROP PROCEDURE dbo.corregirGerenteGeneral;
GO

CREATE PROCEDURE dbo.corregirGerenteGeneral

AS
BEGIN
	DECLARE @codigoJefe NUMERIC(6,0);

	SELECT TOP 1
			@codigoJefe = empl_codigo
	FROM Empleado WHERE empl_jefe IS NULL
	ORDER BY empl_ingreso ASC, empl_salario DESC;

	UPDATE empleado SET empl_jefe = @codigoJefe
	WHERE empl_jefe IS NULL AND empl_codigo != @codigoJefe;

	RETURN;
END
GO

PRINT dbo.corregirGerenteGeneral
