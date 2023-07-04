/* ## Ejercicio 32 ## (OK)
	Se desea conocer las familias que sus productos se facturaron juntos en las mismas
	facturas para ello se solicita que escriba una consulta sql que retorne los pares de
	familias que tienen productos que se facturaron juntos. Para ellos deberá devolver las
	siguientes columnas:
	- Código de familia
	- Detalle de familia
	- Código de familia
	- Detalle de familia
	- Cantidad de facturas
	- Total vendido
	Los datos deberan ser ordenados por Total vendido y solo se deben mostrar las familias
	que se vendieron juntas más de 10 veces.
*/

SELECT
	f1.fami_id, f1.fami_detalle,
	f2.fami_id, f2.fami_detalle,
	COUNT(DISTINCT fact_tipo+fact_sucursal+fact_numero) cant_facturas,
	SUM(if1.item_cantidad*if1.item_precio) + SUM(if2.item_cantidad*if2.item_precio)  total_vendido
FROM familia f1
JOIN producto p1 ON p1.prod_familia=f1.fami_id
JOIN item_factura if1 ON p1.prod_codigo=if1.item_producto
JOIN factura ON if1.item_tipo+if1.item_sucursal+if1.item_numero=fact_tipo+fact_sucursal+fact_numero
JOIN item_factura if2 ON if2.item_tipo+if2.item_sucursal+if2.item_numero=fact_tipo+fact_sucursal+fact_numero
JOIN producto p2 ON if2.item_producto=p2.prod_codigo
JOIN familia f2 ON p2.prod_familia=f2.fami_id
WHERE f2.fami_id < f1.fami_id
GROUP BY f1.fami_id, f1.fami_detalle,
	f2.fami_id, f2.fami_detalle
HAVING COUNT(DISTINCT fact_tipo+fact_sucursal+fact_numero) > 10
ORDER BY 6 ASC

