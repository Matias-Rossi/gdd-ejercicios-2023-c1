/*31. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:
- Año.
- Codigo de Vendedor
- Detalle del Vendedor
- Cantidad de facturas que realizó en ese año
- Cantidad de clientes a los cuales les vendió en ese año.
- Cantidad de productos facturados con composición en ese año
- Cantidad de productos facturados sin composicion en ese año.
- Monto total vendido por ese vendedor en ese año
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.*/

SELECT YEAR(F.fact_fecha) AS [Año]
	,E.empl_codigo
	,E.empl_nombre
	,E.empl_apellido
	,COUNT(DISTINCT F.fact_tipo+F.fact_tipo+F.fact_numero) AS [Cantidad de facturas realizadas]
	,COUNT(DISTINCT F.fact_cliente) AS [Cantidad de clientes a los que se le facturo]
	,(
		SELECT SUM(item_cantidad)
		FROM Item_Factura
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE fact_vendedor = E.empl_codigo 
			AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
			AND item_producto IN (
									SELECT comp_producto
									FROM Composicion	
								)
	) AS [Cant Prod Fact CON comp]
	,(
		SELECT SUM(item_cantidad)
		FROM Item_Factura
			INNER JOIN Factura
				ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
		WHERE fact_vendedor = E.empl_codigo 
			AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
			AND item_producto NOT IN (
									SELECT comp_producto
									FROM Composicion	
								)
			AND item_producto IN (
									SELECT prod_codigo
									FROM Producto
								)
		) AS [Cant Prod Fact SIN comp]
		,SUM(F.fact_total) AS [Total vendido por vendedor]
FROM Factura F
	INNER JOIN Empleado E
		ON E.empl_codigo = F.fact_vendedor

GROUP BY YEAR(F.fact_fecha),E.empl_codigo,E.empl_nombre,E.empl_apellido--,F.fact_numero+F.fact_tipo+F.fact_sucursal
ORDER BY 2,(
			SELECT COUNT(DISTINCT item_cantidad)
			FROM Item_Factura
				INNER JOIN Factura
					ON fact_numero = item_numero AND fact_sucursal = item_sucursal AND fact_tipo = item_tipo
			WHERE fact_vendedor = E.empl_codigo 
				AND YEAR(fact_fecha) = YEAR(F.fact_fecha)
			) DESC
