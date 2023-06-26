/*26. Escriba una consulta sql que retorne un ranking de empleados devolviendo las
siguientes columnas:
- Empleado
- Depósitos que tiene a cargo
- Monto total facturado en el año corriente
- Codigo de Cliente al que mas le vendió
- Producto más vendido
- Porcentaje de la venta de ese empleado sobre el total vendido ese año.
Los datos deberan ser ordenados por venta del empleado de mayor a menor.*/

SELECT E.empl_codigo
	,COUNT(DISTINCT D.depo_codigo) [Cant Depositos que tiene a cargo]
	,(
		SELECT SUM(fact_total)
		FROM Factura
		WHERE fact_vendedor = E.empl_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		
		) AS [Monto total facturado en el año corriente]
	,(							
		SELECT TOP 1 fact_cliente
		FROM Factura
		WHERE fact_vendedor = E.empl_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY fact_cliente
		ORDER BY SUM(fact_total) DESC
	) AS [Codigo Cliente al que mas vendio]
	,(
		SELECT TOP 1 item_producto
		FROM Item_Factura
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE fact_vendedor = E.empl_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
	) AS [Producto mas vendido]
	,((
		SELECT SUM(fact_total)
		FROM Factura
		WHERE fact_vendedor = E.empl_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
	)
	 *100) / (
				SELECT SUM(fact_total)
				FROM Factura
				WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
				) AS [Porcentaje vendido por el empleado sobre el total anual]

FROM EMPLEADO E
	LEFT OUTER JOIN DEPOSITO D
		ON D.depo_encargado = E.empl_codigo
	LEFT OUTER JOIN Factura F
		ON F.fact_vendedor = E.empl_codigo
WHERE YEAR(F.fact_fecha) = 2012--YEAR(GETDATE())
GROUP BY E.empl_codigo, YEAR(F.fact_fecha)
ORDER BY 3 DESC