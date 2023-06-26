/*5 - Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.*/

SELECT P.prod_codigo,P.prod_detalle,SUM(IFACT.item_cantidad)
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON P.prod_codigo = IFACT.item_producto
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
WHERE YEAR(F.fact_fecha) = 2012
GROUP BY P.prod_codigo, P.prod_detalle
HAVING SUM(IFACT.item_cantidad) > (
		SELECT SUM(IFACT2.item_cantidad)
		FROM Item_Factura IFACT2
			INNER JOIN Factura F2
				ON F2.fact_numero = IFACT2.item_numero AND F2.fact_sucursal = IFACT2.item_sucursal AND F2.fact_tipo = IFACT2.item_tipo
		WHERE YEAR(F2.fact_fecha) = 2011 AND IFACT2.item_producto = P.prod_codigo
		)
ORDER BY P.prod_codigo

