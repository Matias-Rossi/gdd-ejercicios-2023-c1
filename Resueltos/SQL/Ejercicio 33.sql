/*33. Se requiere obtener una estadística de venta de productos que sean componentes. Para
ello se solicita que realiza la siguiente consulta que retorne la venta de los
componentes del producto más vendido del año 2012. Se deberá mostrar:
a. Código de producto
b. Nombre del producto
c. Cantidad de unidades vendidas
d. Cantidad de facturas en la cual se facturo
e. Precio promedio facturado de ese producto.
f. Total facturado para ese producto
El resultado deberá ser ordenado por el total vendido por producto para el año 2012.*/

SELECT P.prod_codigo
	,P.prod_detalle
	,SUM(IFACT.item_cantidad) AS [Cantidad unidades vendidas]
	,COUNT(DISTINCT IFACT.item_numero+IFACT.item_tipo+IFACT.item_sucursal) [Cant fact realizadas]
	,AVG(IFACT.item_precio) [Precio promedio facturado]
	,SUM(IFACT.item_precio*IFACT.item_cantidad) [Total Facturado]
FROM Producto P
	INNER JOIN Composicion C
		ON C.comp_componente = P.prod_codigo
	INNER JOIN Producto COMBO
		ON COMBO.prod_codigo = C.comp_producto
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal
WHERE C.comp_producto = (
							SELECT TOP 1 item_producto
							FROM Item_Factura
								INNER JOIN Factura
									ON fact_numero = item_numero AND fact_tipo = item_tipo AND fact_sucursal = item_sucursal
							WHERE item_producto IN (SELECT comp_producto FROM Composicion) AND YEAR(fact_fecha) = 2012
							GROUP BY item_producto
							ORDER BY SUM(item_cantidad) DESC
							)
GROUP BY P.prod_codigo,P.prod_detalle

/*
SELECT P.prod_codigo,P.prod_detalle
	,(
		SELECT SUM(item_cantidad)
		FROM Item_Factura
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_tipo = item_tipo AND fact_sucursal = item_sucursal
		WHERE item_producto = P.prod_codigo AND YEAR(fact_fecha) = 2012
	)
FROM Producto P
	INNER JOIN Composicion C
		ON C.comp_producto = P.prod_codigo
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_numero = IFACT.item_numero AND F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal
WHERE YEAR(F.fact_fecha) = 2012
GROUP BY P.prod_codigo,P.prod_detalle
--ORDER BY SUM(item_cantidad) DESC

*/

/*
SELECT item_producto,SUM(item_cantidad) from Item_Factura
INNER JOIN Factura
				ON fact_numero = item_numero AND fact_tipo = item_tipo AND fact_sucursal = item_sucursal
WHERE item_producto IN (SELECT comp_producto FROM Composicion) AND YEAR(fact_fecha) = 2012
GROUP BY item_producto
ORDER BY SUM(item_cantidad) DESC


SELECT item_producto,SUM(item_cantidad) from Item_Factura
INNER JOIN Factura
				ON fact_numero = item_numero AND fact_tipo = item_tipo AND fact_sucursal = item_sucursal
WHERE item_producto IN ('00001718'/*'00001420','00001475'*/) AND YEAR(fact_fecha) = 2012
GROUP BY item_producto
*/