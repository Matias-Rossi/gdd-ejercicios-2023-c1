/*32. Se desea conocer las familias que sus productos se facturaron juntos en las mismas
facturas para ello se solicita que escriba una consulta sql que retorne los pares de
familias que tienen productos que se facturaron juntos. Para ellos deberá devolver las
siguientes columnas:
- Código de familia
- Detalle de familia
- Código de familia
- Detalle de familia
- Cantidad de facturas
- Total vendido
Los datos deberan ser ordenados por Total vendido y solo se deben mostrar las familias
que se vendieron juntas más de 10 veces.*/

SELECT FAM1.fami_id AS [FAMI Cod 1]
	,FAM1.fami_detalle AS [FAMI Detalle 1]
	,FAM2.fami_id AS [FAMI Cod 2]
	,FAM2.fami_detalle [FAMI Detalle 2]
	,COUNT(DISTINCT IFACT2.item_numero+IFACT2.item_tipo+IFACT2.item_sucursal) AS [Cantidad de facturas]
	,SUM(IFACT1.item_cantidad*IFACT1.item_precio) + SUM(IFACT2.item_cantidad*IFACT2.item_precio) AS [Total Vendido entre items de ambas familias]
FROM Familia FAM1
	INNER JOIN Producto P1
		ON P1.prod_familia = FAM1.fami_id
	INNER JOIN Item_Factura IFACT1
		ON IFACT1.item_producto = P1.prod_codigo
	,Familia FAM2
	INNER JOIN Producto P2
		ON P2.prod_familia = FAM2.fami_id
	INNER JOIN Item_Factura IFACT2
		ON IFACT2.item_producto = P2.prod_codigo
WHERE FAM1.fami_id < FAM2.fami_id
	AND IFACT1.item_numero+IFACT1.item_tipo+IFACT1.item_sucursal = IFACT2.item_numero+IFACT2.item_tipo+IFACT2.item_sucursal
GROUP BY FAM1.fami_id,FAM1.fami_detalle,FAM2.fami_id,FAM2.fami_detalle
HAVING COUNT(DISTINCT IFACT2.item_numero+IFACT2.item_tipo+IFACT2.item_sucursal) > 10
ORDER BY 6