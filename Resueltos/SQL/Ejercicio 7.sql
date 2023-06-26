/* 7 - Generar una consulta que muestre para cada artículo código, detalle, mayor precio
menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio =
10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean
stock.*/

SELECT P.prod_codigo,P.prod_detalle
		,MIN(IFACT.item_precio) AS [Menor Precio]
		,MAX(IFACT.item_precio) AS [Mayor Precio]
		,((MAX(IFACT.item_precio)-MIN(IFACT.item_precio))*100)/MIN(IFACT.item_precio) AS [Diferencia de Precios]
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN STOCK S
		ON S.stoc_producto = P.prod_codigo
WHERE S.stoc_cantidad > 0
GROUP BY P.prod_codigo,P.prod_detalle
