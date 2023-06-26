/*20. Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012
Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje
2012. El puntaje de cada empleado se calculara de la siguiente manera: para los que
hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas
que superen los 100 pesos que haya vendido en el año, para los que tengan menos de 50
facturas en el año el calculo del puntaje sera el 50% de cantidad de facturas realizadas
por sus subordinados directos en dicho año.*/


SELECT TOP 3 E.empl_codigo
	,E.empl_nombre
	,E.empl_apellido
	,E.empl_ingreso
	,CASE
		WHEN (
				SELECT COUNT(fact_vendedor)
				FROM Factura
				WHERE E.empl_codigo = fact_vendedor
					AND YEAR(fact_fecha) = 2011) >= 50 
		THEN (
				SELECT COUNT(*) 
				FROM FACTURA
				WHERE fact_total > 100
					AND E.empl_codigo = fact_vendedor
					AND YEAR(fact_fecha) = 2011
			)
		ELSE (
				SELECT COUNT(*) * 0.5
				FROM Factura
				WHERE fact_vendedor IN (
											SELECT empl_codigo
											FROM Empleado
											WHERE empl_jefe = E.empl_codigo
										)
					AND YEAR(fact_fecha) = 2011
			)													   
	END 'Puntaje 2011'
	,CASE
		WHEN (
				SELECT COUNT(fact_vendedor)
				FROM Factura
				WHERE E.empl_codigo = fact_vendedor
					AND YEAR(fact_fecha) = 2012) >= 50 
		THEN (
				SELECT COUNT(*) 
				FROM FACTURA
				WHERE fact_total > 100
					AND E.empl_codigo = fact_vendedor
					AND YEAR(fact_fecha) = 2012
			)
		ELSE (
				SELECT COUNT(*) * 0.5
				FROM Factura
				WHERE fact_vendedor IN (
											SELECT empl_codigo
											FROM Empleado
											WHERE empl_jefe = E.empl_codigo
										)
					AND YEAR(fact_fecha) = 2012
			)													   
	END 'Puntaje 2012'
FROM Empleado E
ORDER BY 6 DESC

/*
SELECT E.empl_codigo,COUNT(fact_vendedor),
	(SELECT COUNT(*)
	FROM Factura
	WHERE fact_total > 100 AND E.empl_codigo = fact_vendedor AND YEAR(fact_fecha) = 2011)
FROM Empleado E
	INNER JOIN Factura F
				ON F.fact_vendedor = E.empl_codigo
WHERE YEAR(fact_fecha) = 2011
GROUP BY E.empl_codigo

SELECT *
FROM Factura
WHERE YEAR(fact_fecha) = 2011 AND fact_vendedor = 3 AND fact_total > 100

*/
