/* 10 - Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo.*/

SELECT
	P.prod_codigo AS [Codigo vendido]
	,P.prod_detalle [Detalle vendido]
	,(
		SELECT TOP 1 F1.fact_cliente
		FROM Factura F1
			INNER JOIN Item_Factura IFACT1
				ON F1.fact_sucursal = IFACT1.item_sucursal AND F1.fact_numero = IFACT1.item_numero AND F1.fact_tipo = IFACT1.item_tipo
		WHERE P.prod_codigo=IFACT1.item_producto
		GROUP BY F1.fact_cliente
		ORDER BY SUM(IFACT1.item_cantidad) DESC
	) AS [Cliente que realizó la compra]
	
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
WHERE 
	P.prod_codigo IN(
		SELECT TOP 10 item_producto
		FROM Item_Factura
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC
	)
	OR
	P.prod_codigo IN(
		SELECT TOP 10 item_producto
		FROM Item_Factura
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) ASC
	)
GROUP BY P.prod_codigo,P.prod_detalle




/*
SELECT TOP 10 
	P.prod_codigo AS [Codigo MAYOR vendido]
	,P.prod_detalle [Detalle MAYOR vendido]
	,(
		SELECT TOP 1 F1.fact_cliente
		FROM Factura F1
			INNER JOIN Item_Factura IFACT1
				ON F1.fact_sucursal = IFACT1.item_sucursal AND F1.fact_numero = IFACT1.item_numero AND F1.fact_tipo = IFACT1.item_tipo
		WHERE P.prod_codigo=IFACT1.item_producto
		GROUP BY F1.fact_cliente
		ORDER BY SUM(IFACT1.item_cantidad) DESC
	) AS [Cliente con MAYOR cantidad de compras realizadas]
	
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
GROUP BY P.prod_codigo,P.prod_detalle
ORDER BY SUM(IFACT.item_cantidad) DESC

SELECT TOP 10 
	P.prod_codigo AS [Codigo MENOR vendido]
	,P.prod_detalle [Detalle MENOR vendido]
	,(
		SELECT TOP 1 F1.fact_cliente
		FROM Factura F1
			INNER JOIN Item_Factura IFACT1
				ON F1.fact_sucursal = IFACT1.item_sucursal AND F1.fact_numero = IFACT1.item_numero AND F1.fact_tipo = IFACT1.item_tipo
		WHERE P.prod_codigo=IFACT1.item_producto
		GROUP BY F1.fact_cliente
		ORDER BY SUM(IFACT1.item_cantidad) DESC
	) AS [Cliente con MENOR cantidad de compras realizadas]
	
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
GROUP BY P.prod_codigo,P.prod_detalle
--ORDER BY SUM(IFACT.item_cantidad) ASC

/*
	INNER JOIN Factura F
		ON F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero AND F.fact_tipo = IFACT.item_tipo
	*/
	


/*
SELECT P.prod_codigo--, COUNT(P.prod_codigo)
	FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	GROUP BY P.prod_codigo
	ORDER BY COUNT(P.prod_codigo) DESC
	) AS MasVendidos
	*/

	*/