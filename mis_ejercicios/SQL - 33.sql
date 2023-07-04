/* ## Ejercicio 33 ## (PENDIENTE)
	Se requiere obtener una estadística de venta de productos que sean componentes. Para
	ello se solicita que realiza la siguiente consulta que retorne la venta de los
	componentes del producto más vendido del año 2012. Se deberá mostrar:
		a. Código de producto
		b. Nombre del producto
		c. Cantidad de unidades vendidas
		d. Cantidad de facturas en la cual se facturo
		e. Precio promedio facturado de ese producto.
		f. Total facturado para ese producto
	El resultado deberá ser ordenado por el total vendido por producto para el año 2012.
*/

SELECT
	prod_codigo cod_producto,
	prod_detalle nombre_producto,
	SUM(item_cantidad) cant_u_vendidas,
	COUNT(*) cant_facturas, -- ir probando con distinct y *
	AVG(item_precio) precio_promedio,
	SUM(item_precio * item_cantidad) total_facturado
FROM producto
LEFT JOIN item_factura ON item_producto=prod_codigo
LEFT JOIN factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
WHERE prod_codigo IN 
	( SELECT comp_componente FROM composicion WHERE comp_producto IN
		(
			SELECT TOP 1 item_producto FROM item_factura
			JOIN factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
			WHERE YEAR(fact_fecha)=2012 AND item_producto IN (SELECT DISTINCT comp_producto FROM composicion)
			GROUP BY item_producto
			ORDER BY SUM(item_cantidad) DESC
		)
	)
GROUP BY prod_codigo, prod_detalle
ORDER BY 6 DESC

SELECT p_compuesto.prod_detalle, p_compuesto.prod_codigo, p_componente.prod_detalle, p_componente.prod_codigo FROM Composicion
JOIN producto p_compuesto ON p_compuesto.prod_codigo=comp_producto
JOIN producto p_componente ON p_componente.prod_codigo=comp_componente