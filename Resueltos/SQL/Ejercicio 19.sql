/*19. En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:
- Codigo de producto
- Detalle del producto
- Codigo de la familia del producto
- Detalle de la familia actual del producto
- Codigo de la familia sugerido para el producto
- Detalla de la familia sugerido para el producto
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres.
En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente*/


SELECT P.prod_codigo
	,P.prod_detalle
	,FAM.fami_id
	,FAM.fami_detalle
	,(
		SELECT TOP 1 prod_familia
		FROM Producto
		WHERE SUBSTRING(prod_detalle, 1, 5) = SUBSTRING(P.prod_detalle, 1, 5)
		GROUP BY prod_familia
		ORDER BY COUNT(*) DESC, prod_familia
		) AS [ID familia recomendada]
	,(
		SELECT fami_detalle
		FROM Familia
		WHERE fami_id = (
			SELECT TOP 1 prod_familia
			FROM Producto
			WHERE SUBSTRING(prod_detalle, 1, 5) = SUBSTRING(P.prod_detalle, 1, 5)
			GROUP BY prod_familia
			ORDER BY COUNT(*) DESC, prod_familia
			)
		) AS [Detalle Familia Recomendada]

FROM Producto P
	INNER JOIN Familia FAM
		ON FAM.fami_id = P.prod_familia
WHERE FAM.fami_id <> (
		SELECT TOP 1 prod_familia
		FROM Producto
		WHERE SUBSTRING(prod_detalle, 1, 5) = SUBSTRING(P.prod_detalle, 1, 5)
		GROUP BY prod_familia
		ORDER BY COUNT(*) DESC, prod_familia
		) --Magia para que no repita (Que el fami ID no sea igual al que trae por default)
Order BY 2

/*
SELECT P.prod_codigo
	,P.prod_detalle
	,FAM.fami_id
	,FAM.fami_detalle
FROM Producto P
	INNER JOIN Familia FAM
		ON FAM.fami_id = P.prod_familia
WHERE prod_detalle LIKE 'ALF. %'
Order BY 4

SELECT prod_familia,COUNT(*)
		FROM Producto
		WHERE SUBSTRING(prod_detalle, 1, 5) = SUBSTRING('ALF. %', 1, 5)
		GROUP BY prod_familia
		ORDER BY COUNT(*) DESC, prod_familia
		*/