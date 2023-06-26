/*21. Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al
menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta
al menos una factura y que cantidad de facturas se realizaron de manera incorrecta. Se
considera que una factura es incorrecta cuando la diferencia entre el total de la factura
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de
los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar
son:
- Año
- Clientes a los que se les facturo mal en ese año
- Facturas mal realizadas en ese año*/

SELECT YEAR(fact_fecha) AS [AÑO]
		,F.fact_cliente
		,COUNT(F.fact_cliente) AS [FACTURAS MAL REALIZADAS]
FROM FACTURA F
	/*INNER JOIN Item_Factura IFACT
		ON IFACT.item_numero = F.fact_numero AND IFACT.item_sucursal = F.fact_sucursal AND IFACT.item_tipo = F.fact_tipo*/
WHERE (F.fact_total-F.fact_total_impuestos) BETWEEN (
												SELECT SUM(item_precio)-1
												FROM Item_Factura
												WHERE item_numero+item_sucursal+item_tipo = F.fact_numero+F.fact_sucursal+F.fact_tipo
												)
												AND
												(
												SELECT SUM(item_precio)+1
												FROM Item_Factura
												WHERE item_numero+item_sucursal+item_tipo = F.fact_numero+F.fact_sucursal+F.fact_tipo
												)
GROUP BY YEAR(fact_fecha), F.fact_cliente

SELECT YEAR(fact_fecha) AS [AÑO]
		,COUNT(DISTINCT F.fact_cliente) AS [Clientes mal facturados]
		,COUNT(DISTINCT F.fact_tipo + F.fact_sucursal + F.fact_numero) AS [FACTURAS MAL REALIZADAS]
FROM FACTURA F
	/*INNER JOIN Item_Factura IFACT
		ON IFACT.item_numero = F.fact_numero AND IFACT.item_sucursal = F.fact_sucursal AND IFACT.item_tipo = F.fact_tipo*/
WHERE (F.fact_total-F.fact_total_impuestos) NOT BETWEEN (
												SELECT SUM(item_cantidad * item_precio)-1
												FROM Item_Factura
												WHERE item_numero+item_sucursal+item_tipo = F.fact_numero+F.fact_sucursal+F.fact_tipo
												)
												AND
												(
												SELECT SUM(item_cantidad * item_precio)+1
												FROM Item_Factura
												WHERE item_numero+item_sucursal+item_tipo = F.fact_numero+F.fact_sucursal+F.fact_tipo
												)
GROUP BY YEAR(fact_fecha)