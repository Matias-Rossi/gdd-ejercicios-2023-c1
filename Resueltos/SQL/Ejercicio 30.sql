/*30. Se desea obtener una estadistica de ventas del año 2012, para los empleados que sean
jefes, o sea, que tengan empleados a su cargo, para ello se requiere que realice la
consulta que retorne las siguientes columnas:
- Nombre del Jefe
- Cantidad de empleados a cargo
- Monto total vendido de los empleados a cargo
- Cantidad de facturas realizadas por los empleados a cargo
- Nombre del empleado con mejor ventas de ese jefe
Debido a la perfomance requerida, solo se permite el uso de una subconsulta si fuese
necesario.
Los datos deberan ser ordenados por de mayor a menor por el Total vendido y solo se
deben mostrarse los jefes cuyos subordinados hayan realizado más de 10 facturas.*/

SELECT J.empl_nombre
	,J.empl_apellido
	,COUNT(DISTINCT E.empl_codigo) AS [Cantidad de empleados a cargo]
	,SUM(F.fact_total) AS [Monto total vendido empleados]
	,COUNT(F.fact_vendedor) [Cantidad de facturas]
	,(
		SELECT TOP 1 empl_codigo
		FROM Empleado
			INNER JOIN Factura
				ON fact_vendedor = empl_codigo
		WHERE empl_jefe = J.empl_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY empl_codigo
		ORDER BY SUM(fact_total) DESC
		) AS [Empleado con mejor ventas ]
FROM Empleado J
	INNER JOIN Empleado E
		ON E.empl_jefe = J.empl_codigo
	LEFT JOIN Factura F
		ON F.fact_vendedor = E.empl_codigo
WHERE YEAR(F.fact_fecha) = 2012
GROUP BY J.empl_nombre, J.empl_apellido, J.empl_codigo, YEAR(F.fact_fecha)
HAVING COUNT(F.fact_numero+F.fact_tipo+F.fact_sucursal) > 10
ORDER BY 4 DESC
