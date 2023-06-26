/* ## Ejercicio 17 ## ()
	Agregar el/los objetos necesarios para crear una regla por la cual un cliente no pueda comprar m�s de 
	100 unidades en el mes de ning�n producto. Si esto ocurre no se deber� ingresar la operaci�n y se deber� emitir
	un mensaje "Se ha superado el l�mite m�ximo de compra de un producto". Se sabe que esta regla se cumple y que
	las facturas no pueden ser modificadas	

	! NO OLVIDAR AGRUPAR POR A�O CUANDO SE PIDE AGRUPAR POR MES 
	! Ojo al no usar subselects no limitarse a los inserted nom�s ignorando los registros anteriores. 
	! Si una tabla tiene alias, la otra tabla igual no necesita

	! No se mandan todos los productos juntos, por lo que antes de realizar el rollback se deber�a borrar la factura
	! Todo esto debe contemplarse cuando un ejercicio dice que se desconoce alg�n procedimiento
		(Depende del modelo, no pueden dejarse algunos renglones s� y otros no por ejemplo de un cabecero o factura)
		"Cuando se tiene una tabla transaccional que se conforma de un conjunto de cosas"
		- Adem�s de controlar que entra o no, se debe controlar la consistencia. Pasa con tablas de clave compuestas, o
		  muchos componentes de un mismo algo (como componentes o items de factura)

	! A menos que el ejercicio diga "los que est�n bien entran, los que est�n mal no", escaparle al instead of
	! Usar un segundo cursor cuando no es requerido no va a "estar MAL"

*/

CREATE TRIGGER limiteComprasMes ON Item_Factura FOR INSERT
AS
BEGIN
	IF EXISTS (
		SELECT f.fact_cliente, i.item_producto FROM inserted i
		JOIN factura f ON i.item_tipo+i.item_sucursal+i.item_numero=f.fact_tipo+f.fact_sucursal+f.fact_numero
		GROUP BY MONTH(f.fact_fecha), YEAR(f.fact_fecha), f.fact_cliente, i.item_producto
		HAVING SUM(i.item_cantidad) + (
			SELECT SUM(item_cantidad) FROM item_factura 
			JOIN factura f ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
			WHERE item_producto=i.item_producto AND fact_cliente=f.fact_cliente 
			AND MONTH(fact_fecha)=MONTH(f.fact_fecha) AND YEAR(fact_fecha)=YEAR(f.fact_fecha)
		) > 100
	)
	BEGIN
		-- Borro los otros items de la factura (aquellos que habr�an entrado antes)
		DELETE item_factura WHERE item_tipo+item_sucursal+item_numero IN (
			SELECT f.fact_tipo+f.fact_sucursal+f.fact_numero FROM inserted i
			JOIN factura f ON i.item_tipo+i.item_sucursal+i.item_numero=f.fact_tipo+f.fact_sucursal+f.fact_numero
			GROUP BY MONTH(f.fact_fecha), YEAR(f.fact_fecha), f.fact_cliente, i.item_producto
			HAVING SUM(i.item_cantidad) + (
				SELECT SUM(item_cantidad) FROM item_factura 
				JOIN factura f ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
				WHERE item_producto=i.item_producto AND fact_cliente=f.fact_cliente 
				AND MONTH(fact_fecha)=MONTH(f.fact_fecha) AND YEAR(fact_fecha)=YEAR(f.fact_fecha)
			) > 100
		)

		-- Borro la factura
		DELETE factura WHERE fact_tipo+fact_sucursal+fact_numero IN (
			SELECT f.fact_tipo+f.fact_sucursal+f.fact_numero FROM inserted i
			JOIN factura f ON i.item_tipo+i.item_sucursal+i.item_numero=f.fact_tipo+f.fact_sucursal+f.fact_numero
			GROUP BY MONTH(f.fact_fecha), YEAR(f.fact_fecha), f.fact_cliente, i.item_producto
			HAVING SUM(i.item_cantidad) + (
				SELECT SUM(item_cantidad) FROM item_factura 
				JOIN factura f ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
				WHERE item_producto=i.item_producto AND fact_cliente=f.fact_cliente 
				AND MONTH(fact_fecha)=MONTH(f.fact_fecha) AND YEAR(fact_fecha)=YEAR(f.fact_fecha)
			) > 100
		)

		-- Imprimo error y rollback
		PRINT('Se ha superado el l�mite m�ximo de compra de un producto');
		ROLLBACK;
	END --/if
END --/trigger




/*
	SELECT fact_cliente, item_producto FROM inserted 
	JOIN factura ON item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
	GROUP BY MONTH(fact_fecha), YEAR(fact_fecha), fact_cliente, item_producto
	HAVING SUM(item_cantidad) > 100
*/