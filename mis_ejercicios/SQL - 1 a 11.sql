-- Guía de ejercicios SQL 2018
USE [GD2015C1]

/* ## Ejercicio 1 ## (VERIFICAR)
	Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea
	mayor o igual a $ 1000 ordenado por código de cliente.
	
	SELECT clie_codigo, clie_razon_social FROM Cliente 
	WHERE clie_limite_credito >= 1000 
	ORDER BY clie_codigo
*/

/* ## Ejercicio 2 ## (OK)
	Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados
	por cantidad vendida.
	
SELECT prod_codigo, prod_detalle 
FROM Item_Factura
JOIN Producto ON (item_producto=prod_codigo)
JOIN Factura ON (item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero)
WHERE year(fact_fecha) = 2012
GROUP BY prod_codigo, prod_detalle
ORDER BY SUM(item_cantidad) DESC
*/



/* ## Ejercicio 3 ## (OK)
	Realizar una consulta que muestre código de producto, nombre de producto y el
	stock total, sin importar en que deposito se encuentre, los datos deben ser ordenados
	por nombre del artículo de menor a mayor.

SELECT prod_codigo, prod_detalle, SUM(stoc_cantidad) FROM Producto
JOIN STOCK ON (prod_codigo=stoc_producto)
GROUP BY prod_codigo, prod_detalle
ORDER BY prod_detalle 
*/
	

/* ## Ejercicio 4 ## (OK)
	Realizar una consulta que muestre para todos los artículos código, detalle y cantidad
	de artículos que lo componen. Mostrar solo aquellos artículos para los cuales el
	stock promedio por depósito sea mayor a 100

SELECT prod_codigo, prod_detalle, COUNT(comp_producto) AS "Cantidad Componentes"
FROM Producto
LEFT JOIN Composicion ON prod_codigo=comp_producto
WHERE prod_codigo IN (
	SELECT stoc_producto FROM STOCK  -- Stock promedio de todos los depósitos para un producto
	GROUP BY stoc_producto
	HAVING AVG(stoc_cantidad) > 100
)
GROUP BY prod_codigo, prod_detalle
ORDER BY 3 DESC
*/

/* ## Ejercicio 5 ## (OK)
	Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos
	de stock que se realizaron para ese artículo en el año 2012 (egresan los productos
	que fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el
	2011

	-- **TODO**: Aparentemente habría que arrancarlo con "FROM Producto"
	-- NOTA: La condición del subselect puede ir tanto en WHERE como en JOIN

SELECT prod_codigo, prod_detalle, SUM(item_cantidad) FROM Item_Factura
JOIN Producto ON item_producto=prod_codigo
JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
WHERE YEAR(fact_fecha) = 2012
GROUP BY prod_codigo, prod_detalle
HAVING SUM(item_cantidad) > (
	-- Egresos 2011
	SELECT SUM(item_cantidad) FROM Item_Factura
	JOIN Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
	WHERE YEAR(fact_fecha) = 2011 AND item_producto = prod_codigo
)
	*/

/* ## Ejercicio 6 ## (OK)
	Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de
	ese rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos
	artículos que tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.

	NOTA: Ojo con si un LEFT JOIN es necesario o no, si es innecesario resta nota. Nunca va a haber más filas que las que hay en el subselect
	NOTA: No usar COUNT(*), pues contaría filas con columnas en NULL, contar según la tabla
	en la cual tenemos que constatar la existencia (Pasa por usar LEFT JOIN)
	NOTA: Ojo al joinear con tabla con PK doble, se puede repetir el codigo de producto cambiando el depósito
	Se salva haciendo que el código lo cuente una vez, que no cuente repetidos (distinct)
	CORR: se hace en un WHERE y no en un HAVING porque el HAVING nos da el total del rubro, y necesitamos el del producto
	
SELECT 
	rubr_id, 
	rubr_detalle, 
	COUNT(distinct prod_codigo) AS "Cant. artículos", 
	SUM(isnull(stoc_cantidad,0)) AS "Stock" FROM Rubro
LEFT JOIN producto ON prod_rubro=rubr_id --Left para que cuenten rubros sin productos
JOIN stock ON stoc_producto=prod_codigo --No left porque se filtra en WHERE
WHERE prod_codigo IN (
	SELECT stoc_producto
	FROM stock
	GROUP BY stoc_producto
	HAVING SUM(stoc_cantidad) > (
		SELECT SUM(stoc_cantidad) FROM stock WHERE stoc_producto='00000000' and stoc_deposito='00'
	))
GROUP BY rubr_id, rubr_detalle
*/


/* ## Ejercicio 7 ## (OK)
	Generar una consulta que muestre para cada articulo código, detalle, mayor precio
	menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio
	= 10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que
	posean stock.

	"A veces el resultado está bien, pero el quilombo está igual"
	-> Pones un JOIN donde no va y pasas de iterar 1000 a 1000 millones

SELECT 
	prod_codigo, 
	prod_detalle, 
	MAX(item_precio) AS "Mayor precio", 
	MIN(item_precio) AS "Menor precio",
	CAST((MAX(item_precio)-MIN(item_precio))/MIN(item_precio)*100 AS DECIMAL(10, 2)) AS "% Diferencia"
FROM item_factura
JOIN producto ON prod_codigo=item_producto
WHERE prod_codigo IN (
	SELECT stoc_producto FROM stock GROUP BY stoc_producto HAVING SUM(stoc_cantidad) > 0
)
GROUP BY prod_codigo, prod_detalle

*/

/* ## Ejercicio 8 ## (OK)
	Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
	artículo, stock del depósito que más stock tiene.


SELECT prod_detalle, max(stoc_cantidad) AS "Stock máx." FROM stock
JOIN producto ON prod_codigo=stoc_producto	-- Joineo tabla con una PK, así que no afecta atomicidad
WHERE stoc_cantidad > 0						-- Porque el stock puede ser negativo
GROUP BY prod_detalle
HAVING sum(stoc_cantidad) > 0 AND COUNT(*) = (SELECT COUNT(*) FROM deposito) -- Cantidad de depósitos (-algo para que de rtdo)
*/

/* ## Ejercicio 9 ## (OK)
	Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
	mismo y la cantidad de depósitos que ambos tienen asignados.
	CORR: Pide la suma, no tener los de uno y los del otro por separado

SELECT 
	empl_jefe AS 'Jefe', 
	empl_codigo AS 'Empleado', 
	RTRIM(empl_nombre)+' '+empl_apellido AS 'Nombre',
	COUNT(depo_codigo) AS 'Cant. depósitos'
FROM empleado
JOIN deposito ON depo_encargado=empl_codigo OR depo_encargado=empl_jefe
GROUP BY empl_jefe, empl_codigo, RTRIM(empl_nombre)+' '+empl_apellido
*/

/* ## Ejercicio 10 ## (OK)
	Mostrar los 10 productos más vendidos en la historia y también los 10 productos
	menos vendidos en la historia. Además mostrar de esos productos, quien fue el
	cliente que mayor compra realizo.

	NOTA: en ningún momento se dice que primero van los 10 más vendidos
	NOTA: si o si subselect, ya que se pide QUIEN MAS COMPRÓ al producto (select top 1)
	NOTA: el select principal no tiene group by ya que solo maneja la tabla producto, en la
	que solo aparecen una vez los mismos


SELECT
	prod_codigo,
	prod_detalle,
	(
		SELECT TOP 1 fact_cliente FROM factura
		JOIN item_factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
		WHERE item_producto=prod_codigo
		GROUP BY fact_cliente
		ORDER BY sum(item_cantidad) DESC	--MAX no porque sería el que más compró en una compra
	)
FROM producto
WHERE prod_codigo IN (
	SELECT TOP 10 item_producto FROM item_factura
	GROUP BY item_producto
	ORDER BY SUM(item_cantidad) DESC)
	OR prod_codigo IN (
	SELECT TOP 10 item_producto FROM item_factura
	GROUP BY item_producto
	ORDER BY SUM(item_cantidad) ASC)
*/

/* ## Ejercicio 11 ## (OK)
	Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de
	productos vendidos y el monto de dichas ventas sin impuestos. Los datos se deberán
	ordenar de mayor a menor, por la familia que más productos diferentes vendidos
	tenga, solo se deberán mostrar las familias que tengan una venta superior a 20000
	pesos para el año 2012.
	-- OBSERVACIÓN: venta = precio*cantidad
	-- Sin subq en SELECT https://drive.google.com/file/d/1tcKJqqmXSAnKcCriMgDcQm6IU8a8buXW/view 1:56:35
*/
SELECT 
	fami_detalle AS 'familia',
	COUNT(DISTINCT item_producto) AS 'prods. difs. vendidos',
	SUM(item_precio * item_cantidad) AS 'Total sin impuestos'
FROM Familia
JOIN Producto ON prod_familia=fami_id
JOIN Item_Factura ON item_producto=prod_codigo
WHERE 20000 < (
	SELECT 
		SUM(item_precio * item_cantidad) 
	FROM Producto 
	JOIN Item_Factura ON item_producto=prod_codigo
	JOIN Factura ON fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
	WHERE YEAR(fact_fecha)=2012 AND fami_id=prod_familia
	)
GROUP BY fami_detalle
ORDER BY 2 DESC


