/*14. Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que
debe retornar son:
Código del cliente
Cantidad de veces que compro en el último año
Promedio por compra en el último año
Cantidad de productos diferentes que compro en el último año
Monto de la mayor compra que realizo en el último año
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en
el último año.
No se deberán visualizar NULLs en ninguna columna

*/

SELECT C.clie_codigo
	,COUNT(DISTINCT F.fact_tipo + F.fact_sucursal + F.fact_numero) AS [Cantidad de veces que compro en el ultimo año]
	,AVG(F.fact_total) AS [Promedio por compra en el ultimo año]
	,COUNT(DISTINCT IFACT.item_producto) AS [Cantidad de compras realizadas en el ultimo año]
	,(
		SELECT TOP 1 fact_total
		FROM Factura
		WHERE fact_cliente = C.clie_codigo AND YEAR(fact_fecha) = (
			SELECT TOP 1 YEAR(fact_fecha)
			FROM Factura
			ORDER BY fact_fecha DESC
		)
		ORDER BY fact_total DESC
	) AS [Monto de la mayor compra en el ultimo año]
FROM Cliente C
	INNER JOIN Factura F
		ON F.fact_cliente = C.clie_codigo
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_numero = F.fact_numero AND IFACT.item_sucursal = F.fact_sucursal AND IFACT.item_tipo = F.fact_tipo

WHERE YEAR(F.fact_fecha) = (
	SELECT TOP 1 YEAR(fact_fecha)
	FROM Factura
	ORDER BY fact_fecha DESC
	)

GROUP BY C.clie_codigo
ORDER BY 2 DESC


SELECT fact_cliente	'Código Cliente',
	   COUNT(DISTINCT fact_tipo + fact_sucursal + fact_numero) 'Compras ultimo año',
	   AVG(fact_total) 'Promedio por Compra',
	   COUNT(DISTINCT item_producto) 'Cantidad de Artículos Diferentes',
	   MAX(fact_total) 'Compra Máxima'
FROM Factura JOIN Item_Factura
		ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero			
WHERE YEAR(fact_fecha) = (SELECT MAX(YEAR(fact_fecha)) FROM Factura)
GROUP BY fact_cliente
ORDER BY 2 DESC

SELECT * FROM Factura
WHERE fact_cliente = '01742'