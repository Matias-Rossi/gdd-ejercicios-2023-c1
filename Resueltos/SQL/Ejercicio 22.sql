/*22. Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por
trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1
por cada trimestre).
Se deben mostrar 4 columnas:
- Detalle del rubro
- Numero de trimestre del año (1 a 4)
- Cantidad de facturas emitidas en el trimestre en las que se haya vendido al
menos un producto del rubro
- Cantidad de productos diferentes del rubro vendidos en el trimestre
El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada
rubro primero el trimestre en el que mas facturas se emitieron.
No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas
no superen las 100.
En ningun momento se tendran en cuenta los productos compuestos para esta
estadistica.*/

SELECT R.rubr_detalle
	,CASE
		WHEN MONTH(F.fact_fecha) = 1 OR MONTH(F.fact_fecha) = 2 OR MONTH(F.fact_fecha) = 3
		THEN 1
		WHEN MONTH(F.fact_fecha) = 4 OR MONTH(F.fact_fecha) = 5 OR MONTH(F.fact_fecha) = 6
		THEN 2
		WHEN MONTH(F.fact_fecha) = 7 OR MONTH(F.fact_fecha) = 8 OR MONTH(F.fact_fecha) = 9
		THEN 3
		ELSE 4
	END AS [Trimestre]
	,COUNT(DISTINCT F.fact_tipo+F.fact_numero+F.fact_sucursal) [Cantidad de facturas emitidas]
	,COUNT(DISTINCT IFACT.item_producto)
	,YEAR(F.fact_fecha)
FROM Rubro R
	INNER JOIN Producto P
		ON P.prod_rubro = R.rubr_id
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON IFACT.item_numero = F.fact_numero AND IFACT.item_sucursal = F.fact_sucursal AND IFACT.item_tipo = F.fact_tipo
WHERE P.prod_codigo NOT IN (
							SELECT comp_producto
							FROM Composicion
							)
GROUP BY R.rubr_detalle ,CASE
		WHEN MONTH(F.fact_fecha) = 1 OR MONTH(F.fact_fecha) = 2 OR MONTH(F.fact_fecha) = 3
		THEN 1
		WHEN MONTH(F.fact_fecha) = 4 OR MONTH(F.fact_fecha) = 5 OR MONTH(F.fact_fecha) = 6
		THEN 2
		WHEN MONTH(F.fact_fecha) = 7 OR MONTH(F.fact_fecha) = 8 OR MONTH(F.fact_fecha) = 9
		THEN 3
		ELSE 4
	END,
	YEAR(F.fact_fecha)--MONTH(F.fact_fecha)
HAVING COUNT(DISTINCT F.fact_tipo+F.fact_numero+F.fact_sucursal) > 100
ORDER BY 1,3 DESC

/*

SELECT  rubr_detalle 'Rubro',
		DATEPART(QUARTER, fact_fecha) 'Trimestre',
		COUNT(DISTINCT fact_tipo + fact_sucursal + fact_numero) 'Facturas',
		COUNT(DISTINCT prod_codigo) 'Productos Diferentes',
		YEAR(fact_fecha)
FROM Rubro JOIN Producto ON rubr_id = prod_rubro
		   JOIN Item_Factura ON item_producto = prod_codigo
		   JOIN Factura ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
WHERE prod_codigo NOT IN (SELECT comp_producto FROM Composicion)
GROUP BY rubr_detalle, DATEPART(QUARTER, fact_fecha), YEAR(fact_fecha)
HAVING COUNT(DISTINCT fact_tipo + fact_sucursal + fact_numero) > 100
ORDER BY 1, 3 DESC

SELECT MONTH(fact_fecha)
FROM Factura

*/

	