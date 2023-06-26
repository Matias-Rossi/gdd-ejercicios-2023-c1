/*18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30
días
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.*/

SELECT R.rubr_detalle
	,R.rubr_id
	,SUM(IFACT.item_precio * IFACT.item_cantidad)
	,ISNULL((
		SELECT TOP 1 item_producto
		FROM Producto
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
		WHERE R.rubr_id = prod_rubro
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad)DESC
		),0) AS [Cod del prod mas vendido]
	,ISNULL((
		SELECT TOP 1 item_producto
		FROM Producto
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
		WHERE R.rubr_id = prod_rubro
			AND prod_codigo <> (
									SELECT TOP 1 item_producto
									FROM Producto
										INNER JOIN Item_Factura
											ON item_producto = prod_codigo
									WHERE R.rubr_id = prod_rubro
									GROUP BY item_producto
									ORDER BY SUM(item_cantidad)DESC
									)
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad)DESC
		),0) AS [Cod del segundo prod mas vendido]
	,ISNULL((
		SELECT TOP 1 fact_cliente
		FROM Producto
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE prod_rubro = R.rubr_id --AND fact_fecha BETWEEN GETDATE() AND (GETDATE()-30)
			AND fact_fecha > DATEADD(DAY,-30,(SELECT MAX(fact_fecha) FROM Factura))--
			--AND fact_fecha BETWEEN DATEADD(DAY,-30,(SELECT MAX(fact_fecha) FROM Factura)) AND (SELECT MAX(fact_fecha) FROM Factura)
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC
		),'-') AS [Cod CLiente]
FROM RUBRO R
	INNER JOIN Producto P
		ON P.prod_rubro = R.rubr_id
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
GROUP BY R.rubr_detalle,R.rubr_id
ORDER BY COUNT(DISTINCT IFACT.item_producto)