/*25. Realizar una consulta SQL que para cada año y familia muestre :
a. Año
b. El código de la familia más vendida en ese año.
c. Cantidad de Rubros que componen esa familia.
d. Cantidad de productos que componen directamente al producto más vendido de
esa familia.
e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa
familia.
f. El código de cliente que más compro productos de esa familia.
g. El porcentaje que representa la venta de esa familia respecto al total de venta
del año.
El resultado deberá ser ordenado por el total vendido por año y familia en forma
descendente.*/

SELECT YEAR(F.fact_fecha) AS [AÑO]
	,FAM.fami_id
	,COUNT(DISTINCT P.prod_rubro) AS [CANTIDAD DE RUBROS QUE COMPONEN LA FAMILIA (SUBDIVIDO ANUALMENTE)]
	,CASE 
		WHEN(
				(
		SELECT TOP 1 prod_codigo
		FROM Producto
			INNER JOIN Item_Factura
				ON item_producto = prod_codigo
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE prod_familia = FAM.fami_id AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY prod_codigo
		ORDER BY SUM(item_cantidad) DESC
		) IN (
		
				SELECT comp_producto
				FROM Composicion
			)
		)
		THEN (
				SELECT COUNT(*)
				FROM Composicion
				WHERE comp_producto = (
										SELECT TOP 1 prod_codigo
										FROM Producto
											INNER JOIN Item_Factura
												ON item_producto = prod_codigo
											INNER JOIN Factura
												ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
										WHERE prod_familia = FAM.fami_id AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
										GROUP BY prod_codigo
										ORDER BY SUM(item_cantidad) DESC
										)
		)
		ELSE 1
	END AS [CANT DE PROD QUE CONFORMAN EL MAS VENDIDO]
	,COUNT(DISTINCT F.fact_tipo+F.fact_numero+F.fact_sucursal) AS [CANT FACTURAS EN LOS QUE APARECEN PRODS DE LA FAMI]
	,(
		SELECT TOP 1 fact_cliente
		FROM Factura
			INNER JOIN Item_Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
			INNER JOIN Producto	
				ON prod_codigo = item_producto
		WHERE prod_familia = FAM.fami_id AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC
		) AS [CLIENTE QUE MAS COMPRO DE LA FAMILIA]
	,(SUM(IFACT.item_cantidad*IFACT.item_precio) *100) / (
													SELECT SUM(item_cantidad * item_precio)
													FROM Factura
														INNER JOIN Item_Factura
															ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
														INNER JOIN Producto	
															ON prod_codigo = item_producto
													WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
													) AS [PORCENTAJE VENDIDO POR FAMILIA VS TOTAL ANUAL]
FROM FAMILIA FAM
	INNER JOIN Producto P
		ON P.prod_familia = FAM.fami_id
	INNER JOIN Rubro R
		ON R.rubr_id = P.prod_rubro
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON  F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_tipo = IFACT.item_tipo

WHERE FAM.fami_id = (
						SELECT TOP 1 prod_familia
						FROM Producto
							INNER JOIN Item_Factura
								ON item_producto = prod_codigo
							INNER JOIN Factura
								ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
						GROUP BY prod_familia
						ORDER BY SUM(item_cantidad) DESC
						)

GROUP BY YEAR(F.fact_fecha),FAM.fami_id
ORDER BY SUM(IFACT.item_cantidad*IFACT.item_precio) DESC, 2

/*
SELECT fact_cliente, SUM(item_cantidad)
FROM Producto
	INNER JOIN Item_Factura
		ON item_producto = prod_codigo
	INNER JOIN Factura
		ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
WHERE prod_familia = '997' AND YEAR(fact_fecha) = 2010
GROUP BY fact_cliente
ORDER BY 2 DESC
*/
/*
SELECT prod_familia, YEAR(fact_fecha), SUM(item_cantidad)
						FROM Producto
							INNER JOIN Item_Factura
								ON item_producto = prod_codigo
							INNER JOIN Factura
								ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
						GROUP BY prod_familia,YEAR(fact_fecha)
						ORDER BY 2,SUM(item_cantidad) DESC

SELECT prod_rubro,YEAR(fact_fecha) 
FROM Producto
	INNER JOIN Item_Factura
		ON item_producto = prod_codigo
	INNER JOIN Factura
		ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo where prod_familia = '997'
GROUP BY prod_rubro,YEAR(fact_fecha) 
ORDER BY 2,1
*/