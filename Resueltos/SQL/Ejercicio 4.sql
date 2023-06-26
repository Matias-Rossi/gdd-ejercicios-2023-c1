/*Realizar una consulta que muestre para todos los art�culos c�digo, detalle y cantidad de
art�culos que lo componen. Mostrar solo aquellos art�culos para los cuales el stock
promedio por dep�sito sea mayor a 100.*/

SELECT P.prod_codigo, P.prod_detalle, COUNT(DISTINCT(C.comp_componente)) AS [Articulos que lo componen], AVG(S.stoc_cantidad)
FROM Producto P
	LEFT OUTER JOIN Composicion C
		ON C.comp_producto = P.prod_codigo
	INNER JOIN STOCK S
		ON S.stoc_producto = P.prod_codigo
	INNER JOIN DEPOSITO D
		ON D.depo_codigo = S.stoc_deposito


GROUP BY P.prod_codigo, P.prod_detalle
HAVING AVG(S.stoc_cantidad) > 100
ORDER BY 3

SELECT * FROM Composicion

