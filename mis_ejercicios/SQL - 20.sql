/* ## Ejercicio 20 ## (OK)
	Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012.

	Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje
	2012. 
	
	El puntaje de cada empleado se calculara de la siguiente manera: para los que
	hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de
	facturas que superen los 100 pesos que haya vendido en el año, para los que tengan
	menos de 50 facturas en el año el calculo del puntaje sera el 50% de cantidad de
	facturas realizadas por sus subordinados directos en dicho año.

	Al menos 50 facturas: COUNT( facturas > 100 pesos en el año)
	menos de 10 facturas: 0.5 * COUNT(facturas_de_subordinados) en el año

	! CASE
	! Releer siempre enunciado al final antes de corroborar una vez más
	! Siempre la tabla con alias es la de afuera
*/

SELECT TOP 3
	e.empl_codigo legajo,
	e.empl_nombre nombre,
	e.empl_apellido apellido,
	YEAR(e.empl_ingreso) ingreso,
	(
		CASE
			-- 50 < facturas
			WHEN (SELECT COUNT(fact_vendedor) FROM factura WHERE fact_vendedor=e.empl_codigo AND YEAR(fact_fecha)=2011) >= 50
			THEN (
				SELECT COUNT(*) FROM factura 
				WHERE fact_vendedor=e.empl_codigo AND 
					YEAR(fact_fecha)=2011 AND 
					fact_total>100
			)
			-- 50 > facturas
			WHEN (SELECT COUNT(fact_vendedor) FROM factura WHERE fact_vendedor=e.empl_codigo AND YEAR(fact_fecha)=2011) < 50
			THEN (
				SELECT 0.5 * COUNT(*) FROM factura
				WHERE fact_vendedor IN (
					SELECT empl_codigo FROM Empleado
					WHERE empl_jefe=e.empl_codigo
				) AND YEAR(fact_fecha)=2011
			)
			END
	) puntaje_2011,
	(
		CASE
			-- 50 < facturas
			WHEN (SELECT COUNT(fact_vendedor) FROM factura WHERE fact_vendedor=e.empl_codigo AND YEAR(fact_fecha)=2012) >= 50
			THEN (
				SELECT COUNT(*) FROM factura 
				WHERE fact_vendedor=e.empl_codigo AND 
					YEAR(fact_fecha)=2012 AND 
					fact_total>100
			)
			-- 50 > facturas
			WHEN (SELECT COUNT(fact_vendedor) FROM factura WHERE fact_vendedor=e.empl_codigo AND YEAR(fact_fecha)=2012) < 50
			THEN (
				SELECT 0.5 * COUNT(*) FROM factura
				WHERE fact_vendedor IN (
					SELECT empl_codigo FROM Empleado
					WHERE empl_jefe=e.empl_codigo
				) AND YEAR(fact_fecha)=2012
			)
			END
	) puntaje_2012
FROM Empleado e
ORDER BY 6 DESC