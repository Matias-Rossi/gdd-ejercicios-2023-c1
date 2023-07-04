/* ## Parcial del 27/06/23 (turno tarde) ## */

SELECT TOP 3
	clie_razon_social nombre,
	(
		SELECT COUNT(DISTINCT item_cantidad) FROM item_factura
		JOIN factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
		WHERE clie_codigo = fact_cliente AND YEAR(fact_fecha)=2012
	) cant_prods_dist_2012,
	(
		SELECT SUM(item_cantidad) FROM item_factura
		JOIN factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
		WHERE fact_cliente = clie_codigo AND YEAR(fact_fecha)=2012 AND MONTH(fact_fecha) <=6
	) cant_u_1_mitad_2012
FROM Cliente c
GROUP BY clie_codigo, clie_razon_social
HAVING (SELECT COUNT(DISTINCT fact_vendedor) FROM factura WHERE fact_cliente=clie_codigo) > 1 -- Deberia ser 3
ORDER BY (
	SELECT COUNT(*) FROM factura
	WHERE YEAR(fact_fecha)=2012 AND fact_cliente=clie_codigo
) DESC, clie_codigo