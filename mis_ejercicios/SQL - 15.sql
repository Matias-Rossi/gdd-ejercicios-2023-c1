/* ## Ejercicio 15 ## (VERIFICAR)
	Escriba una consulta que retorne los pares de productos que hayan sido vendidos
	juntos (en la misma factura) más de 500 veces. El resultado debe mostrar el código
	y descripción de cada uno de los productos y la cantidad de veces que fueron
	vendidos juntos. El resultado debe estar ordenado por la cantidad de veces que se
	vendieron juntos dichos productos. Los distintos pares no deben retornarse más de
	una vez.
*/

-- OBSERVACIÓN: Uso del '<' para evitar duplicados en el WHERE

SELECT 
	p1.prod_codigo,
	p1.prod_detalle,
	p2.prod_codigo,
	p2.prod_detalle,
	COUNT(DISTINCT if1.item_tipo+if1.item_sucursal+if1.item_numero) veces_juntos
FROM Producto p1
JOIN Item_Factura if1 ON p1.prod_codigo=if1.item_producto
JOIN Item_Factura if2 ON if1.item_tipo+if1.item_sucursal+if1.item_numero=if2.item_tipo+if2.item_sucursal+if2.item_numero
JOIN Producto p2 ON p2.prod_codigo=if2.item_producto
WHERE p2.prod_codigo != p1.prod_codigo AND p2.prod_codigo < p1.prod_codigo
GROUP BY p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle
HAVING COUNT(DISTINCT if1.item_tipo+if1.item_sucursal+if1.item_numero) > 500 