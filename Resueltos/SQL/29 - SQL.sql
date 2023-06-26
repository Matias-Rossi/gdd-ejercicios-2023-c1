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

use GD2020
SELECT P.prod_codigo
	,P.prod_detalle
	,SUM(IFACT.item_cantidad) AS [Cantidad Vendido]
	,COUNT(DISTINCT F.fact_tipo+F.fact_sucursal+F.fact_numero) AS [Cantidad de facturas]
	,SUM(IFACT.item_precio*IFACT.item_cantidad) AS [Monto total facturado sin impuestos]
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo
WHERE YEAR(F.fact_fecha) = 2011 and prod_familia in (select prod_familia from producto 
													group by prod_familia having count(*) > 20)
GROUP BY P.prod_codigo, P.prod_detalle

ORDER BY 4 DESC

