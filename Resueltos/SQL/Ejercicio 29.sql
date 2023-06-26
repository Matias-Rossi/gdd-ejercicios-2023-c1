/* 29. Se solicita que realice una estadística de venta por producto para el año 2011, solo para
los productos que pertenezcan a las familias que tengan más de 20 productos asignados
a ellas, la cual deberá devolver las siguientes columnas:
a. Código de producto
b. Descripción del producto
c. Cantidad vendida
d. Cantidad de facturas en la que esta ese producto
e. Monto total facturado de ese producto
Solo se deberá mostrar un producto por fila en función a los considerandos establecidos
antes. El resultado deberá ser ordenado por el la cantidad vendida de mayor a menor.*/

SELECT P.prod_codigo
	,P.prod_detalle
	,SUM(IFACT.item_cantidad) AS [Cantidad Vendido]
	,COUNT(DISTINCT F.fact_tipo+F.fact_sucursal+F.fact_numero) AS [Cantidad de facturas]
	,SUM(IFACT.item_precio*IFACT.item_cantidad) AS [Monto total facturado sin impuestos]
FROM Producto P
	INNER JOIN Familia FAM
		ON FAM.fami_id = P.prod_familia
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
WHERE YEAR(F.fact_fecha) = 2011
GROUP BY P.prod_codigo, P.prod_detalle, FAM.fami_id
HAVING (
		SELECT COUNT(DISTINCT prod_codigo)
		FROM Producto
			INNER JOIN Familia
				ON fami_id = prod_familia
		WHERE fami_id = FAM.fami_id

		GROUP BY fami_id
		) > 20

ORDER BY 4 DESC

/*
SELECT FAM.fami_id,FAM.fami_detalle, COUNT(DISTINCT P.prod_codigo)
FROM Producto P
	INNER JOIN Familia FAM
		ON FAM.fami_id = P.prod_familia

GROUP BY FAM.fami_id,FAM.fami_detalle
HAVING COUNT(DISTINCT P.prod_codigo) > 20*/

/*
SELECT P.prod_codigo,P.prod_detalle, SUM(IFACT.item_cantidad)
FROM Producto P
	INNER JOIN Familia FAM
		ON FAM.fami_id = P.prod_familia
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
WHERE YEAR(F.fact_fecha) = 2011 AND FAM.fami_id = '006'
GROUP BY P.prod_codigo,P.prod_detalle*/