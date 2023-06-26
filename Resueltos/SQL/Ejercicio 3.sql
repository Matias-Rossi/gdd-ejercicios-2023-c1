/*Realizar una consulta que muestre código de producto, nombre de producto y el stock
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por
nombre del artículo de menor a mayor.*/

SELECT P.prod_codigo
		,P.prod_detalle
		,SUM(S.stoc_cantidad)
FROM Producto P
	INNER JOIN STOCK S
		ON S.stoc_producto = P.prod_codigo
	INNER JOIN DEPOSITO D
		ON D.depo_codigo = S.stoc_deposito
GROUP BY P.prod_codigo
		,P.prod_detalle
ORDER BY P.prod_detalle