/* ## Ejercicio 17 ## (REVISAR)
	Escriba una consulta que retorne una estadística de ventas por año y mes para cada
	producto.

	La consulta debe retornar:

	PERIODO: Año y mes de la estadística con el formato YYYYMM
	PROD: Código de producto
	DETALLE: Detalle del producto
	CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
	VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo pero del año anterior
	CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el periodo

	La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar
	ordenada por periodo y código de producto.
*/

SELECT 
	CAST(YEAR(f.fact_fecha) AS VARCHAR)+'/'+CAST(MONTH(f.fact_fecha) AS VARCHAR) periodo,
	prod_codigo prod,
	prod_detalle detalle,
	SUM(i.item_cantidad) cantidad_vendida,
	(
		SELECT ISNULL(SUM(item_cantidad), 0) FROM item_factura
		JOIN factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
		WHERE MONTH(fact_fecha)=MONTH(f.fact_fecha) AND YEAR(fact_fecha)=YEAR(f.fact_fecha)-1 AND 
		item_producto=i.item_producto
	) ventas_anio_ant,
	COUNT(f.fact_tipo+f.fact_sucursal+f.fact_numero) cant_facturas
FROM producto
JOIN item_factura i ON item_producto=prod_codigo
JOIN factura f ON i.item_tipo+i.item_sucursal+i.item_numero=f.fact_tipo+f.fact_sucursal+f.fact_numero
GROUP BY MONTH(f.fact_fecha), YEAR(f.fact_fecha), prod_codigo, prod_detalle, i.item_producto
ORDER BY YEAR(f.fact_fecha), MONTH(f.fact_fecha);
