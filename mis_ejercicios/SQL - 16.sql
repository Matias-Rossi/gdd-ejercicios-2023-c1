/* ## Ejercicio 16 ## (NO SE ENTIENDE EL ENUNCIADO)
	Con el fin de lanzar una nueva campaña comercial para los clientes que menos
	compran en la empresa, se pide una consulta SQL que retorne aquellos clientes
	cuyas ventas son inferiores a 1/3 del promedio de ventas del/los producto/s que más
	se vendieron en el 2012.

	Además mostrar:
		1. Nombre del Cliente
		2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
		3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
		   mostrar solamente el de menor código) para ese cliente.

	Aclaraciones:
		- La composición es de 2 niveles, es decir, un producto compuesto solo se compone
	 	  de productos no compuestos.
		- Los clientes deben ser ordenados por código de provincia ascendente.

*/

SELECT 
	clie_razon_social,
	COUNT(DISTINCT fact_tipo+fact_sucursal+fact_numero)
FROM Cliente
JOIN Factura ON fact_cliente=clie_codigo
JOIN Item_Factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
GROUP BY clie_razon_social