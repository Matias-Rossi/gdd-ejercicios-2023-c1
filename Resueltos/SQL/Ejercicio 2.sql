/*Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por cantidad vendida.*/


SELECT P.prod_codigo,P.prod_detalle,SUM(IFACT.item_cantidad)
FROM Producto P
INNER JOIN Item_Factura IFACT
	ON IFACT.item_producto = P.prod_codigo
INNER JOIN Factura F
	ON F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero

WHERE YEAR(F.fact_fecha) = 2012
GROUP BY P.prod_codigo,P.prod_detalle
ORDER BY SUM(IFACT.item_cantidad)
