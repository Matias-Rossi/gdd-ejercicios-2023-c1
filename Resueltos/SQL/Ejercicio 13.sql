/*13. Realizar una consulta que retorne para cada producto que posea composici�n nombre
del producto, precio del producto, precio de la sumatoria de los precios por la cantidad
de los productos que lo componen. Solo se deber�n mostrar los productos que est�n
compuestos por m�s de 2 productos y deben ser ordenados de mayor a menor por
cantidad de productos que lo componen.*/

SELECT COMBO.prod_detalle,COMBO.prod_precio,SUM(Componente.prod_precio * C.comp_cantidad)
FROM Producto COMBO
	INNER JOIN Composicion C
		ON C.comp_producto = COMBO.prod_codigo
	INNER JOIN Producto Componente
		ON Componente.prod_codigo = C.comp_componente
GROUP BY COMBO.prod_detalle,COMBO.prod_precio
HAVING SUM(C.comp_cantidad) > 2
ORDER BY SUM(C.comp_cantidad) DESC
