/* ## Ejercicio 30 ## (PENDIENTE)
	Se desea obtener una estadistica de ventas del año 2012, para los empleados que sean
	jefes, o sea, que tengan empleados a su cargo, para ello se requiere que realice la
	consulta que retorne las siguientes columnas:

	- Nombre del Jefe
	- Cantidad de empleados a cargo
	- Monto total vendido de los empleados a cargo
	- Cantidad de facturas realizadas por los empleados a cargo
	- Nombre del empleado con mejor ventas de ese jefe

	Debido a la perfomance requerida, solo se permite el uso de una subconsulta si fuese necesario.

	Los datos deberan ser ordenados por de mayor a menor por el Total vendido y solo se
	deben mostrarse los jefes cuyos subordinados hayan realizado más de 10 facturas.
*/

-- Año 2012

SELECT
	j.empl_nombre nombre_jefe,
	COUNT(DISTINCT e.empl_codigo) cant_empl_a_cargo,
	SUM(fact_total) monto_vendido_a_cargo,
	COUNT(*) cant_facturas_a_cargo,
	(
		SELECT TOP 1 empl_codigo FROM empleado v
		JOIN factura ON v.empl_codigo=fact_vendedor
		WHERE YEAR(fact_fecha)=2012 AND v.empl_jefe=j.empl_codigo
		GROUP BY empl_codigo
		ORDER BY SUM(fact_total) DESC
	) subordinado_con_mejor_vtas
FROM empleado j
JOIN empleado e ON e.empl_jefe=j.empl_codigo
JOIN factura ON e.empl_codigo=fact_vendedor
WHERE YEAR(fact_fecha)=2012
GROUP BY j.empl_codigo, j.empl_nombre
HAVING COUNT(*) > 10
ORDER BY 3 DESC