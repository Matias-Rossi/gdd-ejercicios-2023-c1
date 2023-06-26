/* 11. Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para
el año 2012. */

SELECT FAM.fami_id,FAM.fami_detalle,COUNT(DISTINCT P.prod_detalle) AS [Prod vendidos por familia],SUM(F.fact_total) [Monto Total vendido sin impuestos]
FROM Familia FAM
	INNER JOIN Producto P
		ON P.prod_familia = FAM.fami_id
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero

GROUP BY FAM.fami_id,FAM.fami_detalle

HAVING EXISTS( 
		SELECT TOP 1 fact_numero
		FROM Factura
			INNER JOIN Item_Factura
				ON fact_tipo = item_tipo AND fact_sucursal = item_sucursal AND fact_numero = item_numero
			INNER JOIN Producto
				ON prod_codigo = item_producto
		WHERE YEAR(fact_fecha) = 2012 AND prod_familia = FAM.fami_id
		GROUP BY fact_numero
		HAVING SUM (fact_total) > 100
		)

ORDER BY 3 DESC

/*
SELECT fami_detalle, COUNT(DISTINCT prod_codigo) as cant_prod, SUM(item_precio * item_cantidad) as monto_ventas
FROM Familia fam
	 JOIN Producto p ON fami_id = prod_familia
	 JOIN Item_Factura i ON prod_codigo = item_producto
	 JOIN Factura fac ON item_numero = fact_numero
				 AND item_tipo = fact_tipo
				 AND item_sucursal = fact_sucursal
GROUP BY fami_detalle,fami_id
HAVING
		EXISTS(SELECT TOP 1 fact_numero, fact_tipo, fact_sucursal
		FROM Factura JOIN Item_Factura ON fact_sucursal=item_sucursal AND fact_tipo=item_tipo AND fact_numero=item_numero
					 JOIN Producto ON item_producto = prod_codigo
		WHERE YEAR(fact_fecha)=2012 AND prod_familia=fam.fami_id
		GROUP BY fact_numero, fact_tipo, fact_sucursal
		HAVING SUM(item_precio * item_cantidad)>20000)
ORDER BY monto_ventas DESC
*/