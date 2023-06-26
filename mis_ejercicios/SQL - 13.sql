
/* ## Ejercicio 13 ## (VERIFICAR)
	Realizar una consulta que retorne para cada producto que posea composici�n
	nombre del producto, precio del producto, precio de la sumatoria de los precios por
	la cantidad de los productos que lo componen. Solo se deber�n mostrar los
	productos que est�n compuestos por m�s de 2 productos y deben ser ordenados de
	mayor a menor por cantidad de productos que lo componen.
*/

SELECT 
	pp.prod_detalle detalle,
	pp.prod_precio precio,
	SUM(pc.prod_precio * comp_cantidad) suma_componentes
FROM Composicion
JOIN Producto pp ON comp_producto=pp.prod_codigo
JOIN Producto pc ON comp_componente=pc.prod_codigo
GROUP BY pp.prod_detalle, pp.prod_precio
--HAVING COUNT(comp_componente) > 2
ORDER BY COUNT(pc.prod_codigo) DESC