/* ## Ejercicio 31 ## (OK)
	Escriba una consulta sql que retorne una estad�stica por A�o y Vendedor que retorne las
	siguientes columnas:

	- A�o
	- Codigo de Vendedor
	- Detalle del Vendedor
	- Cantidad de facturas que realiz� en ese a�o
	- Cantidad de clientes a los cuales les vendi� en ese a�o.
	- Cantidad de productos facturados con composici�n en ese a�o
	- Cantidad de productos facturados sin composicion en ese a�o.
	- Monto total vendido por ese vendedor en ese a�o

	Los datos deberan ser ordenados por a�o y dentro del a�o por el vendedor que haya
	vendido mas productos diferentes de mayor a menor
*/

SELECT
	YEAR(fact_fecha) anio,
	empl_codigo codigo_vendedor,
	empl_nombre+' '+empl_apellido detalle_vendedor,
	COUNT(fact_tipo+fact_sucursal+fact_numero) cant_facturas_anio,
	COUNT(DISTINCT fact_cliente) cant_clientes_anio,
	(
		SELECT SUM(item_cantidad) FROM factura  --COUNT(DISTINCT item_producto) para que sea por producto distinto
		JOIN item_factura ON item_tipo+item_numero+item_sucursal=fact_tipo+fact_numero+fact_sucursal
		WHERE fact_vendedor=f.fact_vendedor AND YEAR(f.fact_fecha)=YEAR(fact_fecha)
		AND EXISTS (SELECT comp_producto FROM composicion WHERE item_producto=comp_producto)
	) cant_productos_compuestos_anio,
	(
		SELECT SUM(item_cantidad) FROM factura --COUNT(DISTINCT item_producto) para que sea por producto distinto
		JOIN item_factura ON item_tipo+item_numero+item_sucursal=fact_tipo+fact_numero+fact_sucursal
		WHERE fact_vendedor=f.fact_vendedor AND YEAR(f.fact_fecha)=YEAR(fact_fecha)
		AND NOT EXISTS (SELECT comp_producto FROM composicion WHERE item_producto=comp_producto)
	) cant_productos_no_compuestos_anio,
	SUM(fact_total) monto_total_anio
FROM empleado
JOIN factura f ON fact_vendedor=empl_codigo
GROUP BY YEAR(fact_fecha), empl_codigo, empl_nombre, empl_apellido, fact_vendedor
ORDER BY YEAR(fact_fecha), (
	SELECT COUNT(DISTINCT item_producto) FROM item_factura 
	JOIN factura ON item_tipo+item_numero+item_sucursal=fact_tipo+fact_numero+fact_sucursal
	WHERE YEAR(fact_fecha)=YEAR(f.fact_fecha) AND f.fact_vendedor=fact_vendedor
) DESC

