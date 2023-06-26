/*16. Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son
inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
Además mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente.
Aclaraciones:
La composición es de 2 niveles, es decir, un producto compuesto solo se compone de
productos no compuestos.
Los clientes deben ser ordenados por código de provincia ascendente.*/

SELECT DISTINCT C.clie_razon_social
	,COUNT(IFACT.item_producto) [Unidades vendidas para el cliente]
	,(
		SELECT TOP 1 item_producto
		FROM Item_Factura
			INNER JOIN Factura
				ON item_tipo = fact_tipo AND item_numero = fact_numero AND item_sucursal = fact_sucursal
		WHERE c.clie_codigo = fact_cliente AND YEAR(fact_fecha) = '2012'
		GROUP BY item_producto
		ORDER BY COUNT(item_producto) DESC, item_producto ASC
		) [Producto mas vendido]
FROM Cliente C
	INNER JOIN Factura F
		ON F.fact_cliente = C.clie_codigo
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_tipo = F.fact_tipo AND IFACT.item_numero = F.fact_numero AND IFACT.item_sucursal = F.fact_sucursal
WHERE F.fact_total > (
	(SELECT TOP 1 AVG(item_precio)
	FROM Item_Factura
		INNER JOIN Factura
			ON item_tipo = fact_tipo AND item_numero = fact_numero AND item_sucursal =fact_sucursal
	WHERE YEAR(fact_fecha) = 2012
	ORDER BY COUNT (*) DESC
	) /3)
	AND YEAR(F.fact_fecha) = 2012
GROUP BY C.clie_razon_social,clie_codigo


SELECT  clie_razon_social 'Razón Social',
		clie_domicilio 'Domicilio',	
		SUM(item_cantidad) 'Unidades totales compradas',
		(SELECT TOP 1 item_producto
		FROM Item_Factura JOIN Factura ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
		WHERE YEAR (fact_fecha) = 2012 AND fact_cliente = clie_codigo
		GROUP BY item_producto
		ORDER BY SUM(item_cantidad) DESC, item_producto ASC) 'Producto mas comprado'
FROM Cliente JOIN Factura ON clie_codigo = fact_cliente
			 JOIN Item_Factura ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
WHERE YEAR(fact_fecha) = 2012
GROUP BY clie_codigo, clie_razon_social, clie_domicilio
HAVING SUM(item_cantidad) < 1.00/3*(SELECT TOP 1 SUM(item_cantidad)
									FROM Item_Factura
										JOIN Factura ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
									WHERE YEAR(fact_fecha) = 2012
									GROUP BY item_producto
									ORDER BY SUM(item_cantidad) DESC)
ORDER BY clie_domicilio ASC