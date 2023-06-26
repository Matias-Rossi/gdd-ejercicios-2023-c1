/*28. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:
- Año.
- Codigo de Vendedor
- Detalle del Vendedor
- Cantidad de facturas que realizó en ese año
- Cantidad de clientes a los cuales les vendió en ese año.
- Cantidad de productos facturados con composición en ese año
- Cantidad de productos facturados sin composicion en ese año.
- Monto total vendido por ese vendedor en ese año
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.*/

SELECT YEAR(fact_fecha)
	,F.fact_vendedor
	,E.empl_nombre
	,E.empl_apellido
	,COUNT(DISTINCT F.fact_numero+F.fact_sucursal+F.fact_tipo) AS [Cantidad de facturas realizadas]
	,COUNT(DISTINCT F.fact_cliente) AS [Cantidad de clientes a los que se vendió]
	,(
		SELECT COUNT(DISTINCT prod_codigo)
		FROM Producto
			INNER JOIN Composicion
				ON comp_producto = prod_codigo
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha) AND fact_vendedor = F.fact_vendedor
		) AS [Cantidad de productos facturados con composicion]
	,(
		SELECT COUNT(DISTINCT prod_codigo)
		FROM Producto
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha) AND fact_vendedor = F.fact_vendedor AND prod_codigo NOT IN (SELECT comp_producto FROM Composicion)
		) AS [Cantidad de productos facturados sin composicion]
	,SUM(F.fact_total)
FROM Factura F
	INNER JOIN Empleado E
		ON E.empl_codigo = F.fact_vendedor 
GROUP BY YEAR(fact_fecha),F.fact_vendedor,E.empl_nombre,E.empl_apellido
ORDER BY 1 DESC, (
					SELECT COUNT(DISTINCT prod_codigo)
					FROM Producto
						INNER JOIN Item_Factura
							ON item_producto = prod_codigo
						INNER JOIN Factura
							ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
					WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha) AND fact_vendedor = F.fact_vendedor
					) DESC
/*
SELECT item_producto,COUNT(DISTINCT fact_cliente)
FROM Factura
	INNER JOIN Item_Factura
		ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
WHERE fact_vendedor = 8 AND YEAR(fact_fecha) = 2012 AND item_producto IN (SELECT comp_producto FROM Composicion)
GROUP BY item_producto*/
/*
SELECT COUNT(DISTINCT item_producto)
FROM Factura
	INNER JOIN Item_Factura
		ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
WHERE fact_vendedor = 4 AND YEAR(fact_fecha) = 2012 AND item_producto IN (SELECT comp_producto FROM Composicion)*/

