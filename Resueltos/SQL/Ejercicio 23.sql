/*23. Realizar una consulta SQL que para cada año muestre :
- Año
- El producto con composición más vendido para ese año.
- Cantidad de productos que componen directamente al producto más vendido
- La cantidad de facturas en las cuales aparece ese producto.
- El código de cliente que más compro ese producto.
- El porcentaje que representa la venta de ese producto respecto al total de venta
del año.
El resultado deberá ser ordenado por el total vendido por año en forma descendente*/

SELECT YEAR(F1.fact_fecha)
	,IFACT1.item_producto
	,(
		SELECT COUNT(*)
		FROM Producto Prod
			INNER JOIN Composicion C
				ON C.comp_producto = Prod.prod_codigo
			INNER JOIN Producto Componente
				ON Componente.prod_codigo = C.comp_componente
		WHERE Prod.prod_codigo = IFACT1.item_producto
	) AS [Productos que componen el mas vendido]
	,(
		SELECT COUNT(DISTINCT F.fact_numero+F.fact_sucursal+F.fact_tipo)
		FROM Factura F
			INNER JOIN Item_Factura IFACT
				ON F.fact_tipo = IFACT.item_tipo AND F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal
			INNER JOIN Producto Prod
				ON Prod.prod_codigo = IFACT.item_producto
			INNER JOIN Composicion C
				ON C.comp_producto = Prod.prod_codigo
		WHERE Prod.prod_codigo = IFACT1.item_producto AND YEAR(F.fact_fecha) = YEAR(F1.fact_fecha)
	) AS [Cantidad de facturas]
	,(
		SELECT TOP 1 F.fact_cliente
		FROM Factura F
			INNER JOIN Item_Factura IFACT
				ON F.fact_tipo = IFACT.item_tipo AND F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal
		WHERE IFACT.item_producto = IFACT1.item_producto AND YEAR(F.fact_fecha) = YEAR(F1.fact_fecha)
		GROUP BY F.fact_cliente
		ORDER BY SUM(IFACT.item_cantidad) DESC
	)
	,(
		SELECT ( SUM(IFACT.item_cantidad) /
					(
						SELECT TOP 1 SUM(item_cantidad)
						FROM Item_Factura
							INNER JOIN Factura
								ON fact_numero = item_numero AND fact_tipo = item_tipo AND fact_sucursal = item_sucursal
						WHERE YEAR(fact_fecha) = YEAR(F1.fact_fecha)
					) *100
					
				)
		FROM Factura F
			INNER JOIN Item_Factura IFACT
				ON F.fact_tipo = IFACT.item_tipo AND F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal
		WHERE IFACT.item_producto = IFACT1.item_producto AND YEAR(F.fact_fecha) = YEAR(F1.fact_fecha)
	)
FROM Factura F1
	INNER JOIN Item_Factura IFACT1
		ON F1.fact_tipo = IFACT1.item_tipo AND F1.fact_numero = IFACT1.item_numero AND F1.fact_sucursal = IFACT1.item_sucursal
WHERE IFACT1.item_producto = (
								SELECT TOP 1 P.prod_codigo
								FROM Producto P
									INNER JOIN Composicion C
										ON C.comp_producto = P.prod_codigo
									INNER JOIN Item_Factura IFACT
										ON IFACT.item_producto = P.prod_codigo
									INNER JOIN Factura F
										ON F.fact_tipo = IFACT.item_tipo AND F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal
								WHERE YEAR(F1.fact_fecha) = YEAR(F.fact_fecha)
								ORDER BY (IFACT.item_producto * IFACT.item_cantidad) DESC
							)						
GROUP BY YEAR(F1.fact_fecha),IFACT1.item_producto
ORDER BY SUM(IFACT1.item_cantidad) DESC

/*
SELECT  YEAR(F.fact_fecha) 'Año',
		I.item_producto 'Producto mas vendido',
		(SELECT COUNT(*) FROM Composicion WHERE comp_producto = I.item_producto) 'Cant. Componentes',
		COUNT(DISTINCT F.fact_tipo + F.fact_sucursal + F.fact_numero) 'Facturas',
		(SELECT TOP 1 fact_cliente
		FROM Factura JOIN Item_Factura
			ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
		WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha) AND item_producto = I.item_producto
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC) 'Cliente mas Compras',
		SUM(ISNULL(I.item_cantidad, 0)) /
			(SELECT SUM(item_cantidad)
			FROM Factura JOIN Item_Factura
				ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
			WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha))*100 'Porcentaje'
FROM Factura F JOIN Item_Factura I
    ON (F.fact_tipo + F.fact_sucursal + F.fact_numero = I.item_tipo + I.item_sucursal + I.item_numero)
WHERE  I.item_producto = (SELECT TOP 1 item_producto
							   FROM Item_Factura
							   JOIN Composicion
							     ON item_producto = comp_producto
							   JOIN Factura
							     ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
							 WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
							 GROUP BY item_producto
							 ORDER BY SUM(item_cantidad) DESC)
GROUP BY YEAR(F.fact_fecha), I.item_producto
ORDER BY SUM(I.item_cantidad) DESC
*/