/* 24. Escriba una consulta que considerando solamente las facturas correspondientes a los
dos vendedores con mayores comisiones, retorne los productos con composición
facturados al menos en cinco facturas,
La consulta debe retornar las siguientes columnas:
- Código de Producto
- Nombre del Producto
- Unidades facturadas
El resultado deberá ser ordenado por las unidades facturadas descendente.

*/

SELECT Prod.prod_codigo
	,Prod.prod_detalle
	,SUM(IFACT.item_cantidad) AS [Unidades Facturadas]
FROM Producto Prod
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = Prod.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
WHERE F.fact_vendedor IN (
							SELECT TOP 2 empl_codigo
							FROM Empleado
							ORDER BY empl_comision DESC
							)
							AND
	Prod.prod_codigo IN (
							SELECT comp_producto
							FROM Composicion
							)
GROUP BY Prod.prod_codigo,Prod.prod_detalle
HAVING COUNT(IFACT.item_producto) > 5
ORDER BY 3 DESC

/*
SELECT item_producto,SUM(item_cantidad) AS [Cantidad Facturada]
FROM Item_Factura IFACT
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
WHERE item_producto IN ('00001718','00001707') AND F.fact_vendedor IN (3,8)
GROUP BY item_producto


SELECT TOP 2 *
FROM Empleado
ORDER BY empl_comision DESC

SELECT * from Composicion
*/