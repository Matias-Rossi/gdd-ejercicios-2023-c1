/*17. Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:
PERIODO: Año y mes de la estadística con el formato YYYYMM
PROD: Código de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo
pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el
periodo
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por periodo y código de producto.*/

SELECT STR(YEAR(F.fact_fecha))+STR(MONTH(F.fact_fecha))--FORMAT (F.fact_fecha, 'yyyyMM') AS [Periodo]--(YEAR(F.fact_fecha) ++ MONTH(F.fact_fecha))
	--FORMAT (F.fact_fecha, 'yyyyMM') AS [Periodo]
	,P.prod_codigo
	,P.prod_detalle
	,SUM(IFACT.item_cantidad)
	,ISNULL((
		SELECT SUM(item_cantidad)
		FROM Item_Factura
			INNER JOIN Factura
				ON item_tipo = fact_tipo AND item_numero = fact_numero AND item_sucursal = fact_sucursal
		WHERE YEAR(fact_fecha) = (YEAR(F.fact_fecha)-1) AND MONTH(fact_fecha) = MONTH(F.fact_fecha) AND P.prod_codigo = item_producto
		),0) AS [Cantidad del mismo producto en el año anterior]
	,COUNT(F.fact_tipo + F.fact_sucursal + F.fact_numero) AS [Cant de facturas]
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON IFACT.item_tipo = F.fact_tipo AND IFACT.item_numero = F.fact_numero AND IFACT.item_sucursal = F.fact_sucursal
WHERE p.prod_codigo = '00010200'
GROUP BY --,P.prod_codigo,P.prod_detalle

YEAR(F.fact_fecha), MONTH(F.fact_fecha),P.prod_codigo,P.prod_detalle
ORDER BY 1 ASC, P.prod_codigo


