/* 6 - Mostrar para todos los rubros de art�culos c�digo, detalle, cantidad de art�culos de ese
rubro y stock total de ese rubro de art�culos. Solo tener en cuenta aquellos art�culos que
tengan un stock mayor al del art�culo �00000000� en el dep�sito �00�.*/


SELECT R.rubr_id, R.rubr_detalle, COUNT(DISTINCT P.prod_codigo) as [Cantidad de Articulos], SUM(S.stoc_cantidad) AS [Stock Total]
FROM Producto P
	INNER JOIN RUBRO R
		ON R.rubr_id = P.prod_rubro
	INNER JOIN STOCK S
		ON S.stoc_producto = P.prod_codigo
	INNER JOIN DEPOSITO D
		ON D.depo_codigo = S.stoc_deposito
WHERE S.stoc_cantidad > (
		SELECT stoc_cantidad
		FROM STOCK
		WHERE stoc_producto = '00000000'
			AND stoc_deposito = '00'
		)
GROUP BY R.rubr_id,R.rubr_detalle
ORDER BY 1
