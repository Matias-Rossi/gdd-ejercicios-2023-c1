/* ## Ejercicio 13 ## (OK)
	Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
	“Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de sus
	empleados totales (directos + indirectos)”. Se sabe que en la actualidad dicha regla
	se cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos y
	tecnologías
*/

CREATE FUNCTION dbo.sueldoEmpleadosDebajo(@jefe_codigo NUMERIC(6))
RETURNS DECIMAL(12,2)
AS
BEGIN
	DECLARE @suma_salarios DECIMAL(12,2);
	SET @suma_salarios = 0;

	IF NOT EXISTS (SELECT * FROM Empleado WHERE empl_jefe=@jefe_codigo)
	BEGIN
		RETURN @suma_salarios;
	END --/if

	SET @suma_salarios = (SELECT SUM(empl_salario + dbo.sueldoEmpleadosDebajo(empl_codigo)) FROM Empleado WHERE empl_jefe=@jefe_codigo)

	RETURN @suma_salarios;
END --/function
GO

CREATE TRIGGER limiteSueldoJefes ON Empleado
AFTER INSERT, UPDATE
AS
BEGIN
	IF EXISTS(SELECT * FROM inserted i WHERE dbo.sueldoEmpleadosDebajo(i.empl_codigo) * 0.2 > i.empl_salario)
	BEGIN
		ROLLBACK;
	END --/if
	
END -- /procedure
