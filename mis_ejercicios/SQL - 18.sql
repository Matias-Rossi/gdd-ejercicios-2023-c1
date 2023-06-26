/* ## Ejercicio 18 ## (¿OK?)
	Escriba una consulta que retorne una estadística de ventas para todos los rubros.

	La consulta debe retornar:

	DETALLE_RUBRO: Detalle del rubro
	VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
	PROD1: Código del producto más vendido de dicho rubro
	PROD2: Código del segundo producto más vendido de dicho rubro
	CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30 días

	La consulta no puede mostrar NULL en ninguna de sus columnas, y 
	debe estar ordenada por cantidad de productos diferentes vendidos del rubro.

	! Como retornar la 2da fila (prod2)
	! Últimos 30 días
	! no olvidar distinct dentro de counts donde aplicasen
	! probar todo, incluyendo lo usado en ORDER BY y funciones de grupo
	! literal fecha
*/

SELECT
	rubr_detalle detalle_rubro,
	ISNULL(CAST(SUM(item_cantidad * item_precio) AS DECIMAL(12,2)), 0) ventas,
	COALESCE((
		SELECT TOP 1 prod_codigo FROM Producto JOIN Item_Factura ON item_producto=prod_codigo 
		WHERE prod_rubro=rubr_id GROUP BY prod_codigo ORDER BY SUM(item_cantidad) DESC
	),'N/A') prod1,
	COALESCE((
		SELECT prod_codigo FROM Producto JOIN Item_Factura ON item_producto=prod_codigo 
		WHERE prod_rubro=rubr_id GROUP BY prod_codigo ORDER BY SUM(item_cantidad) DESC 
		OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY
	),'N/A') prod2,
	COALESCE((
		SELECT TOP 1 fact_cliente FROM factura 
		JOIN item_factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
		JOIN producto ON prod_codigo=item_producto
		WHERE prod_rubro=rubr_id AND fact_fecha >= DATEADD(day, 30, CAST('2012-01-01' AS DATETIME))--GETDATE())
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC
	), 'Sin ventas') cliente
FROM rubro
JOIN producto ON prod_rubro=rubr_id
LEFT JOIN item_factura ON item_producto=prod_codigo
GROUP BY rubr_id, rubr_detalle
ORDER BY COUNT(DISTINCT prod_codigo) DESC --produtos diferentes 


-- pruebas
SELECT rubr_detalle, COUNT(*) FROM Producto
JOIN rubro ON prod_rubro=rubr_id
GROUP BY rubr_detalle
ORDER BY COUNT(*) DESC