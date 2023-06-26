/* 8 - Mostrar para el o los art�culos que tengan stock en todos los dep�sitos, nombre del
art�culo, stock del dep�sito que m�s stock tiene. */

SELECT P.prod_codigo
		,P.prod_detalle
		,(
			SELECT TOP 1 stoc_cantidad
			FROM STOCK
			WHERE P.prod_codigo = stoc_producto
			ORDER BY stoc_cantidad DESC) AS [Stock del dep�sito mayor cantidad]
		,count(DISTINCT S.stoc_deposito)
FROM Producto P
	INNER JOIN STOCK S
		ON S.stoc_producto = P.prod_codigo
GROUP BY P.prod_codigo,P.prod_detalle

HAVING (count(DISTINCT S.stoc_deposito)) = (
		SELECT COUNT(depo_codigo)
		FROM DEPOSITO
		)
ORDER BY 1 DESC
-- NO TRAE RESULTADOS PORQUE NO EXISTE PRODUCTO QUE ESTE EN TODOS LOS DEPOSITOS