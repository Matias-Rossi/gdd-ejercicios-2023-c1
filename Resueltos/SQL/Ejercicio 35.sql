/*35. Se requiere realizar una estadística de ventas por año y producto, para ello se solicita
que escriba una consulta sql que retorne las siguientes columnas:
1 Año
2 Codigo de producto
3 Detalle del producto
4 Cantidad de facturas emitidas a ese producto ese año
5 Cantidad de vendedores diferentes que compraron ese producto ese año.
6 Cantidad de productos a los cuales compone ese producto, si no compone a ninguno
se debera retornar 0.
7 Porcentaje de la venta de ese producto respecto a la venta total de ese año.
Los datos deberan ser ordenados por año y por producto con mayor cantidad vendida.*/

SELECT YEAR(F.fact_fecha) AS [Año]
	,P.prod_codigo
	,P.prod_detalle
	,COUNT(DISTINCT F.fact_tipo+F.fact_sucursal+F.fact_numero) AS [Cant Facturas]
	,COUNT(DISTINCT F.fact_vendedor) AS [Cant vendedores diferentes del prod]
	,(
		SELECT COUNT(comp_componente)
		FROM Composicion
		WHERE comp_componente = P.prod_codigo
	) AS [Cant de prods que compone]
	,(
		(SUM(IFACT.item_precio*IFACT.item_cantidad)
		* 100)
		/
		(
			SELECT SUM(item_precio*item_cantidad)
			FROM Item_Factura
				INNER JOIN Factura
					ON fact_tipo = item_tipo AND fact_sucursal = item_sucursal AND fact_numero = fact_numero
			WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
		)
	) AS [Porcentaje de venta sobre el total]
	FROM Producto P
		INNER JOIN Item_Factura IFACT
			ON IFACT.item_producto = P.prod_codigo
		INNER JOIN Factura F
			ON F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero
GROUP BY YEAR(F.fact_fecha),P.prod_codigo,P.prod_detalle
ORDER BY 1, SUM(IFACT.item_cantidad) DESC