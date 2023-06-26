
/* ## Ejercicio 14 ## (Verificar)
	Escriba una consulta que retorne una estad�stica de ventas por cliente. Los campos
	que debe retornar son:

	- C�digo del cliente
	- Cantidad de veces que compro en el �ltimo a�o
	- Promedio por compra en el �ltimo a�o
	- Cantidad de productos diferentes que compro en el �ltimo a�o
	- Monto de la mayor compra que realizo en el �ltimo a�o

	Se deber�n retornar todos los clientes ordenados por la cantidad de veces que
	compro en el �ltimo a�o.
	No se deber�n visualizar NULLs en ninguna columna
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