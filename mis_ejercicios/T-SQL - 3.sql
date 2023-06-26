
/* ## Ejercicio 3 ## (OK in my books)
	Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
	en caso que sea necesario. Se sabe que debería existir un único gerente general
	(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
	sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
	mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
	empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
	de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
	de empleados que había sin jefe antes de la ejecución.

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
