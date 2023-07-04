/* ## Ejercicio 35 ## (El porcentaje está turbio)

	Se requiere realizar una estadística de ventas por año y producto, para ello se solicita
	que escriba una consulta sql que retorne las siguientes columnas:

	- Año
	- Codigo de producto
	- Detalle del producto
	- Cantidad de facturas emitidas a ese producto ese año
	- Cantidad de vendedores diferentes que compraron ese producto ese año.
	- Cantidad de productos a los cuales compone ese producto, si no compone a ninguno se debera retornar 0.
	- Porcentaje de la venta de ese producto respecto a la venta total de ese año.

	Los datos deberan ser ordenados por año y por producto con mayor cantidad vendida.
*/

SELECT
	YEAR(fact_fecha) anio,
	prod_codigo cod_producto,
	prod_detalle det_producto,
	COUNT(DISTINCT fact_tipo+fact_sucursal+fact_numero) cant_facturas_emitidas,
	COUNT(DISTINCT fact_cliente) cant_clientes,
	COUNT(DISTINCT comp_producto) cant_productos_que_compone,
	(
		SELECT FORMAT((
		(SELECT SUM(item_cantidad * item_precio) FROM item_factura 
			JOIN factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
			WHERE item_producto=prod_codigo AND YEAR(fact_fecha)=YEAR(f.fact_fecha)
		)
		/
		(SELECT SUM(item_cantidad * item_precio) FROM item_factura 
			JOIN factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
			WHERE YEAR(fact_fecha)=YEAR(f.fact_fecha))
		),'P') as [Percentage]
		
	) porc_venta_total
FROM producto
JOIN item_factura ON item_producto=prod_codigo
JOIN factura f ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
LEFT JOIN composicion ON comp_componente=prod_codigo
GROUP BY prod_codigo, prod_detalle, YEAR(fact_fecha)
ORDER BY 1 DESC, SUM(item_cantidad) DESC