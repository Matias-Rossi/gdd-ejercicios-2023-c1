/*12. Mostrar nombre de producto, 
cantidad de clientes distintos que lo compraron,
importe promedio pagado por el producto, 
cantidad de depósitos en los cuales hay stock del producto y stock actual del producto en todos los depósitos. 
Se deberán mostrar aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
ordenarse de mayor a menor por monto vendido del producto.*/

SELECT P.prod_detalle
	,COUNT(DISTINCT F.fact_cliente) AS [Cantidad Clientes que compraron el prod]
	,AVG(IFACT.item_precio) [Importe Promedio]
	,(
		SELECT COUNT(DISTINCT stoc_deposito) 
		FROM STOCK
		WHERE P.prod_codigo = stoc_producto 
			AND ISNULL(stoc_cantidad,0)>0
	) AS [Cantidad de Depositos en los que hay stock]
	,(
		SELECT SUM(stoc_cantidad)
		FROM STOCK
		WHERE P.prod_codigo = stoc_producto
	) AS [Stock Actual en todos los depositos]
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero
	/*INNER JOIN STOCK S
		ON P.prod_codigo = S.stoc_producto*/
WHERE YEAR(F.fact_fecha) = 2012
GROUP BY P.prod_codigo, P.prod_detalle
ORDER BY SUM(IFACT.item_cantidad * IFACT.item_precio) DESC



SELECT 
--nombre
	p.prod_detalle
	AS producto,
--cantidad clientes distintos que lo compraron
	(SELECT COUNT(DISTINCT f1.fact_cliente)
	 FROM Factura f1 JOIN Item_Factura i1 ON i1.item_numero=f1.fact_numero AND i1.item_sucursal=f1.fact_sucursal AND i1.item_tipo=f1.fact_tipo
	 WHERE i1.item_producto=p.prod_codigo)
	AS compradores,
--importe promedio del producto (interpreto suma de precio*cantidad en cada factura dividido la cantidad vendida en todas las facturas)
	(SELECT SUM(i1.item_precio*i1.item_cantidad)/SUM(i1.item_cantidad)
	 FROM Item_Factura i1 WHERE i1.item_producto=p.prod_codigo)
	AS importe_promedio,
--cantidad depositos con stock
	(SELECT COUNT(s1.stoc_deposito)
	 FROM STOCK s1
	 WHERE s1.stoc_producto=p.prod_codigo AND ISNULL(s1.stoc_cantidad,0)>0)
	AS Depositos_con_stock,
--stock en todos los depositos (interpreto sumatoria de todos los depositos)
	isnull((SELECT SUM(isnull(s1.stoc_cantidad,0))
			FROM STOCK s1 WHERE s1.stoc_producto=p.prod_codigo)
			,0)
	AS stock_total
--operaciones se interpreta como ventas
FROM Producto p JOIN Item_Factura i ON i.item_producto=p.prod_codigo
				JOIN Factura f ON i.item_numero=f.fact_numero AND i.item_sucursal=f.fact_sucursal AND i.item_tipo=f.fact_tipo
WHERE YEAR(f.fact_fecha)=2012
GROUP BY p.prod_codigo, p.prod_detalle
--se interpreta ordenar por monto vendido en 2012
ORDER BY SUM(i.item_cantidad*i.item_precio) DESC



SELECT P.prod_detalle,S.stoc_deposito,S.stoc_cantidad
FROM Producto P
 INNER JOIN STOCK S
	ON S.stoc_producto = P.prod_codigo
WHERE prod_detalle = 'TARJETAS C.T.I. DE $ 20'

