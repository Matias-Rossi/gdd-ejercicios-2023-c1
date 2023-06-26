/*27. Escriba una consulta sql que retorne una estadística basada en la facturacion por año y
envase devolviendo las siguientes columnas:
- Año
- Codigo de envase
- Detalle del envase
- Cantidad de productos que tienen ese envase
- Cantidad de productos facturados de ese envase
- Producto mas vendido de ese envase
- Monto total de venta de ese envase en ese año
- Porcentaje de la venta de ese envase respecto al total vendido de ese año
Los datos deberan ser ordenados*/

SELECT YEAR(F.fact_fecha)
	,E.enva_codigo
	,E.enva_detalle
	,COUNT (DISTINCT IFACT.item_producto) AS [Cantidad de productos facturados para ese envase]
	,SUM (IFACT.item_cantidad) AS [Cantidad de productos facturados para ese envase]
	,(
		SELECT TOP 1 item_producto
		FROM Producto
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE prod_envase = E.enva_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
		) AS [Producto mas vendido del envase]
	,SUM(IFACT.item_precio * IFACT.item_cantidad) AS [Monto Total de venta del envase]
	,(SUM(IFACT.item_precio * IFACT.item_cantidad) *100) / (
															SELECT SUM(fact_total)
															FROM Factura
															WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
															) AS [Procentaje de la venta respecto al total]
FROM Producto P
	INNER JOIN Envases E
		ON E.enva_codigo = P.prod_envase
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
GROUP BY YEAR(F.fact_fecha),E.enva_codigo,E.enva_detalle
ORDER BY 1,2



-------------------------------------------------------------------------------------------------------------------------

SELECT YEAR(F.fact_fecha)
	,E.enva_codigo
	,E.enva_detalle
	,COUNT (DISTINCT IFACT.item_producto) AS [Cantidad de productos facturados para ese envase]
	,SUM (IFACT.item_cantidad) AS [Cantidad de productos facturados para ese envase]
	,(
		SELECT TOP 1 item_producto
		FROM Producto
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE prod_envase = E.enva_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
		) AS [Producto mas vendido del envase]
	,SUM(IFACT.item_precio * IFACT.item_cantidad) AS [Monto Total de venta del envase]
	,(SUM(IFACT.item_precio * IFACT.item_cantidad) *100) / (
															SELECT SUM(item_precio * item_cantidad)
															FROM Item_Factura
																INNER JOIN Factura
																	ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
															WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
															) AS [Procentaje de la venta respecto al total]
FROM Producto P
	INNER JOIN Envases E
		ON E.enva_codigo = P.prod_envase
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
GROUP BY YEAR(F.fact_fecha),E.enva_codigo,E.enva_detalle
ORDER BY 1,2

/*
SELECT * FROM Factura
WHERE fact_tipo+fact_sucursal+fact_numero = 'A000300068710'

SELECT * FROM Item_Factura
WHERE item_tipo+item_sucursal+item_numero = 'A000300068710'*/


SELECT YEAR(F.fact_fecha)
	,E.enva_codigo
	,E.enva_detalle
	,COUNT (DISTINCT P.prod_codigo) AS [Cantidad de productos facturados para ese envase]
	,COUNT(DISTINCT IFACT.item_producto) AS [Cantidad de productos facturados para ese envase]--SUM (IFACT.item_cantidad) AS [Cantidad de productos facturados para ese envase]--COUNT(DISTINCT IFACT.item_producto)
	,(
		SELECT TOP 1 item_producto
		FROM Producto
			LEFT OUTER JOIN Item_Factura
				ON item_producto = prod_codigo
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE prod_envase = E.enva_codigo AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
		) AS [Producto mas vendido del envase]
	,SUM(IFACT.item_precio * IFACT.item_cantidad) AS [Monto Total de venta del envase]
	,(SUM(IFACT.item_precio * IFACT.item_cantidad) *100) / (
															SELECT SUM(item_precio * item_cantidad)
															FROM Item_Factura
																INNER JOIN Factura
																	ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
															WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
															) AS [Procentaje de la venta respecto al total]
FROM Producto P
	INNER JOIN Envases E
		ON E.enva_codigo = P.prod_envase
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
GROUP BY YEAR(F.fact_fecha),E.enva_codigo,E.enva_detalle
ORDER BY 1,2