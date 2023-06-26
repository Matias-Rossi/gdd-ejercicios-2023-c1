
/* ## Ejercicio 12 ## (VERIFICAR)
	Mostrar nombre de producto, 
	cantidad de clientes distintos que lo compraron,
	importe promedio pagado por el producto, 
	cantidad de depósitos en lo cuales hay	stock del producto
	y stock actual del producto en todos los depósitos. 
	Se deberán mostrar aquellos productos que hayan tenido operaciones en el año 2012 y 
	los datos deberán ordenarse de mayor a menor por monto vendido del producto.

	Hecho con dos subqueries menos : https://drive.google.com/file/d/1tcKJqqmXSAnKcCriMgDcQm6IU8a8buXW/view 2:02:59
	VERSION CORREGIDA (VA EL LEFT JOIN?)
*/
SELECT 
	prod_detalle,
	COUNT(DISTINCT fact_cliente) clies_distintos,
	AVG(item_precio) precio_promedio,
	(SELECT COUNT(stoc_deposito) FROM STOCK WHERE stoc_producto=prod_codigo AND stoc_cantidad > 0) depositos_con_stock,
	(SELECT SUM(stoc_cantidad) FROM STOCK WHERE stoc_producto=prod_codigo ) stock_total
FROM Producto
JOIN Item_Factura ON prod_codigo=item_producto
JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
WHERE prod_codigo IN (
	SELECT item_producto FROM Item_Factura
	JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
	WHERE YEAR(fact_fecha)=2012
)
GROUP BY prod_codigo, prod_detalle
ORDER BY SUM(item_cantidad*item_precio) DESC


/* Version vieja
-- 629 rows
SELECT 
	prod_detalle AS 'Producto',
	COUNT(DISTINCT fact_cliente) AS 'Qty. clientes distintos',
	AVG(item_precio) AS 'Promedio pagado',
	(SELECT COUNT(stoc_deposito) FROM STOCK WHERE stoc_cantidad > 0 AND stoc_producto=prod_codigo) AS 'Depositos con Stock',
	ISNULL(SUM(stoc_cantidad),0) AS 'Stock actual total'
FROM Producto
JOIN Item_Factura ON item_producto=prod_codigo
JOIN Factura ON item_tipo=fact_tipo AND item_sucursal=fact_sucursal AND item_numero=fact_numero 
LEFT JOIN STOCK ON stoc_producto=prod_codigo
WHERE EXISTS (SELECT item_producto 
				FROM Item_Factura 
				JOIN Factura ON item_tipo=fact_tipo AND item_sucursal=fact_sucursal AND item_numero=fact_numero
				WHERE item_producto=prod_codigo AND YEAR(fact_fecha)=2012)
GROUP BY prod_detalle, prod_codigo
ORDER BY SUM(item_precio) DESC
*/