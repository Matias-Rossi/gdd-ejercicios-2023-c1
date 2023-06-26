
/* ## Ejercicio 14 ## (Verificar)
	Escriba una consulta que retorne una estadística de ventas por cliente. Los campos
	que debe retornar son:

	- Código del cliente
	- Cantidad de veces que compro en el último año
	- Promedio por compra en el último año
	- Cantidad de productos diferentes que compro en el último año
	- Monto de la mayor compra que realizo en el último año

	Se deberán retornar todos los clientes ordenados por la cantidad de veces que
	compro en el último año.
	No se deberán visualizar NULLs en ninguna columna
*/

SELECT
	clie_codigo,
	COUNT(fact_tipo+fact_sucursal+fact_numero) cant_compras,
	AVG(fact_total) monto_promedio,
	(SELECT COUNT(DISTINCT item_producto) 
	 FROM Item_Factura 
	 JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
	 WHERE fact_cliente=clie_codigo
	) prods_distintos,
	MAX(fact_total) monto_max
FROM Cliente
JOIN Factura ON clie_codigo=fact_cliente

WHERE YEAR(fact_fecha)=2012
GROUP BY clie_codigo
ORDER BY 2 DESC