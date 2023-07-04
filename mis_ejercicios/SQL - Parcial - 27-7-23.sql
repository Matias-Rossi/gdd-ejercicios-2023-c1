SELECT
	zona_detalle detalle_zona,
	COUNT(depo_codigo) cant_depositos_zona,
	(
		SELECT COUNT(DISTINCT stoc_producto) FROM stock 
		JOIN deposito ON stoc_deposito=depo_codigo
		WHERE stoc_producto IN (SELECT comp_producto FROM composicion)
		AND depo_zona=z.zona_codigo
		GROUP BY depo_zona	
	) cant_prod_distintos_compuestos,
	(
		SELECT TOP 1 item_producto FROM item_factura
		JOIN factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
		WHERE YEAR(fact_fecha)=2012 
		AND EXISTS (
			SELECT stoc_producto FROM stock 
			JOIN deposito ON stoc_deposito=depo_codigo
			WHERE depo_zona=zona_codigo AND stoc_producto=item_producto
			GROUP BY stoc_producto
			HAVING SUM(stoc_cantidad) > 0
		)
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
	) prod_mas_vendido_2012,
	(
		SELECT TOP 1 empl_codigo FROM empleado
		JOIN factura ON fact_vendedor=empl_codigo
		JOIN deposito ON depo_encargado=empl_codigo
		WHERE depo_zona=zona_codigo 
		GROUP BY empl_codigo
		ORDER BY SUM(fact_total) DESC
	) mejor_encargado
FROM zona z
JOIN deposito ON depo_zona=zona_codigo
GROUP BY zona_detalle, zona_codigo
HAVING COUNT(depo_codigo) >= 3
ORDER BY (
		SELECT TOP 1 SUM(fact_total) FROM empleado
		JOIN departamento ON depa_codigo=empl_departamento
		JOIN zona ON depa_zona=zona_codigo
		JOIN factura ON fact_vendedor=empl_codigo
		JOIN deposito ON depo_zona=zona_codigo
		WHERE zona_codigo=z.zona_codigo 
		GROUP BY zona_codigo, empl_codigo
		ORDER BY SUM(fact_total) DESC
	) DESC
