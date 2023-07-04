CREATE TRIGGER fk_factura_vendedor_existencia ON factura FOR INSERT -- Por que no update?
AS
BEGIN
	IF EXISTS (SELECT * FROM inserted JOIN empleado ON fact_vendedor=empl_codigo WHERE empl_codigo IS NULL)
	BEGIN
		PRINT('No se puede insertar una factura para un vendedor inexistente');
		ROLLBACK;
	END
END
GO

CREATE TRIGGER fk_factura_vendedor_borrado ON empleado FOR DELETE
AS
BEGIN
	IF EXISTS (SELECT * FROM deleted JOIN factura ON fact_vendedor=empl_codigo WHERE fact_tipo IS NOT NULL)
	BEGIN
		PRINT('No se puede borrar un empleado con ventas');
		ROLLBACK;
	END;
END

