/* ## Ejercicio 34 ## (VERIFICAR)

	Escriba una consulta sql que retorne para todos los rubros la cantidad de facturas mal
	facturadas por cada mes del año 2011 Se considera que una factura es incorrecta cuando
	en la misma factura se factutan productos de dos rubros diferentes. Si no hay facturas
	mal hechas se debe retornar 0. Las columnas que se deben mostrar son:

	1- Codigo de Rubro
	2- Mes
	3- Cantidad de facturas mal realizadas
*/
--31 rubros

SELECT
	r1.rubr_id codigo_rubro,
	MONTH(fact_fecha) mes,
	COUNT(DISTINCT fact_tipo+fact_numero+fact_sucursal) cant_facturas_malas
FROM rubro r1
JOIN producto p1 ON p1.prod_rubro=r1.rubr_id
JOIN item_factura if1 ON if1.item_producto=p1.prod_codigo
JOIN factura ON fact_tipo+fact_numero+fact_sucursal=if1.item_tipo+if1.item_numero+if1.item_sucursal
LEFT JOIN item_factura if2 ON if2.item_tipo+if2.item_numero+if2.item_sucursal=fact_tipo+fact_numero+fact_sucursal
LEFT JOIN producto p2 ON p2.prod_codigo = if2.item_producto
WHERE r1.rubr_id <> p2.prod_rubro AND YEAR(fact_fecha)=2011
GROUP BY r1.rubr_id, MONTH(fact_fecha)
ORDER BY 1, 2 -- NO SE PIDE


