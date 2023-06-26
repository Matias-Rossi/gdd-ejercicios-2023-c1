/* 9. Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.*/

SELECT J.empl_codigo AS [Codigo Jefe]
		,E.empl_codigo [Codigo Empleado]
		,E.empl_nombre [Nombre Empleado]
		,E.empl_apellido [Apellido Empleado]
		,COUNT(D.depo_encargado) AS [Depositos Empleado]
		,(
			SELECT COUNT(depo_encargado)
			FROM DEPOSITO
			WHERE J.empl_codigo = depo_encargado
		) AS [Depositos Jefe]
FROM Empleado E
	LEFT JOIN Empleado J
		ON J.empl_codigo = E.empl_jefe
	LEFT JOIN DEPOSITO D
		ON D.depo_encargado = E.empl_codigo
	GROUP BY J.empl_codigo,E.empl_codigo,E.empl_nombre,E.empl_apellido

