/* ## Ejercicio 19 ## (PENDIENTE)

	En virtud de una recategorizacion de productos referida a la familia de los mismos
	se solicita que desarrolle una consulta sql que retorne para todos los productos:

		- Codigo de producto
		- Detalle del producto
		- Codigo de la familia del producto
		- Detalle de la familia actual del producto
		- Codigo de la familia sugerido para el producto
		- Detalle de la familia sugerido para el producto

	La familia sugerida para un producto es la que poseen la mayoria de los productos
	cuyo detalle coinciden en los primeros 5 caracteres.

	En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de
	menor codigo. Solo se deben mostrar los productos para los cuales la familia actual
	sea diferente a la sugerida.

	Los resultados deben ser ordenados por detalle de producto de manera ascendente
*/

-- 2190 productos, 95 familias

SELECT
	prod_codigo,
	prod_detalle,
	act.fami_id,
	act.fami_detalle
	--sug.fami_id,
	--sug.fami_detalle
FROM producto
JOIN familia act ON act.fami_id=prod_familia
JOIN familia sug ON sug.fami_id=(
	
)
ORDER BY prod_detalle ASC


