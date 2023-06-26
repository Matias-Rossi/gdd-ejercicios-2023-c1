/* 34. Escriba una consulta sql que retorne para todos los rubros la cantidad de facturas mal
facturadas por cada mes del año 2011 Se considera que una factura es incorrecta cuando
en la misma factura se factutan productos de dos rubros diferentes. Si no hay facturas
mal hechas se debe retornar 0. Las columnas que se deben mostrar son:
1- Codigo de Rubro
2- Mes
3- Cantidad de facturas mal realizadas.*/

SELECT P.prod_rubro AS [Rubro]
	,MONTH(F.fact_fecha) AS [MES]
	,COUNT(DISTINCT F.fact_tipo+F.fact_sucursal+F.fact_numero) AS [Fact mal realizadas]
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero
WHERE YEAR(F.fact_fecha) = 2011 AND (
										SELECT COUNT(DISTINCT prod_rubro)
										FROM Producto
											INNER JOIN Item_Factura
												ON item_producto = prod_codigo
										WHERE item_tipo+item_sucursal+item_numero = IFACT.item_tipo+IFACT.item_sucursal+IFACT.item_numero
										GROUP BY item_tipo+item_sucursal+item_numero
										) > 1
GROUP BY P.prod_rubro, MONTH(F.fact_fecha)
ORDER BY 1


/*
SELECT P.prod_rubro
	,MONTH(F.fact_fecha)
	,COUNT(DISTINCT F.fact_tipo+F.fact_sucursal+F.fact_numero)
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero
WHERE YEAR(F.fact_fecha) = 2011
GROUP BY P.prod_rubro, MONTH(F.fact_fecha)
ORDER BY 1*/

/*
SELECT IFACT.item_tipo+IFACT.item_sucursal+IFACT.item_numero
	,MONTH(F.fact_fecha)
	,COUNT(DISTINCT P.prod_rubro)
FROM Producto P
	INNER JOIN Item_Factura IFACT
		ON IFACT.item_producto = P.prod_codigo
	INNER JOIN Factura F
		ON F.fact_tipo = IFACT.item_tipo AND F.fact_sucursal = IFACT.item_sucursal AND F.fact_numero = IFACT.item_numero
WHERE YEAR(F.fact_fecha) = 2011
GROUP BY IFACT.item_tipo+IFACT.item_sucursal+IFACT.item_numero, MONTH(F.fact_fecha)
ORDER BY 1

SELECT * FROM
Item_Factura where item_tipo+item_sucursal+item_numero = 'A000300087974'

SELECT * FROM
Factura where fact_tipo+fact_sucursal+fact_numero = 'A000300087974'

SELECT * FROM Producto WHERE prod_codigo IN ('00000102','00000109')*/