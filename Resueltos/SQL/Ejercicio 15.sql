/* 15. Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.
Ejemplo de lo que retornaría la consulta:
PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2 */

SELECT P1.prod_codigo AS [Producto 1]
		,P1.prod_detalle AS [Detalle Producto 1]
		,P2.prod_codigo AS [Producto 2]
		,P2.prod_detalle AS [Detalle Producto 2]
		,COUNT(*) AS [Cantidad de veces vendidos juntos]
FROM Producto P1
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P1.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
	INNER JOIN Item_Factura IFACT2
		ON F.fact_numero = IFACT2.item_numero AND F.fact_sucursal = IFACT2.item_sucursal AND F.fact_tipo = IFACT2.item_tipo
	INNER JOIN Producto P2
		ON IFACT2.item_producto = P2.prod_codigo
WHERE P1.prod_codigo < P2.prod_codigo
	AND IFACT.item_numero + IFACT.item_tipo + IFACT.item_sucursal = IFACT2.item_numero + IFACT2.item_tipo + IFACT2.item_sucursal
GROUP BY P1.prod_codigo, P1.prod_detalle, P2.prod_codigo, P2.prod_detalle
HAVING COUNT(*) > 500
ORDER BY 5 DESC

SELECT  P1.prod_codigo 'Código Producto 1',
		P1.prod_detalle 'Detalle Producto 1',
		P2.prod_codigo 'Código Producto 2',
		P2.prod_detalle 'Detalle Producto 2',
		COUNT(*) 'Cantidad de veces'
FROM Producto P1 JOIN Item_Factura I1 ON P1.prod_codigo = I1.item_producto,
	 Producto P2 JOIN Item_Factura I2 ON P2.prod_codigo = I2.item_producto
WHERE I1.item_tipo + I1.item_sucursal + I1.item_numero = I2.item_tipo + I2.item_sucursal + I2.item_numero
	AND I1.item_producto < I2.item_producto
GROUP BY P1.prod_codigo, P1.prod_detalle, P2.prod_codigo, P2.prod_detalle
HAVING COUNT(*) > 500
ORDER BY 5 DESC