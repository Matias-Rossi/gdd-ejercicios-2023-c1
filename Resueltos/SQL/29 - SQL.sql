/* 29. Se solicita que realice una estad�stica de venta por producto para el a�o 2011, solo para
los productos que pertenezcan a las familias que tengan m�s de 20 productos asignados
a ellas, la cual deber� devolver las siguientes columnas:
a. C�digo de producto
b. Descripci�n del producto
c. Cantidad vendida
d. Cantidad de facturas en la que esta ese producto
e. Monto total facturado de ese producto
Solo se deber� mostrar un producto por fila en funci�n a los considerandos establecidos
antes. El resultado deber� ser ordenado por el la cantidad vendida de mayor a menor.*/

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

