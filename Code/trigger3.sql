-- folsim aceleasi obiecte ca si in trigger1.sql
-- trigger-ul va fi recreat
USE AdventureWorks
GO
-- eliminam trigger-ul daca exista unul cu acelasi nume
IF EXISTS
(
	SELECT 1
	FROM sys.triggers
	WHERE object_id =
	OBJECT_ID(N'[Production].[trg_uid_ProductInventoryAudit]')
)
DROP TRIGGER [Production].[trg_uid_ProductInventoryAudit]
GO

CREATE TRIGGER Production.trg_uid_ProductInventoryAudit
ON Production.ProductInventory
AFTER INSERT, DELETE
AS
SET NOCOUNT ON
IF EXISTS(SELECT Shelf FROM inserted WHERE Shelf = 'A')
BEGIN
	PRINT 'Shelf ''A'' is closed for new inventory.'
	ROLLBACK
END
-- Inserted rows
INSERT Production.ProductInventoryAudit
(
	ProductID, LocationID, Shelf, Bin, 
	Quantity, rowguid, ModifiedDate, InsOrUPD
)
SELECT DISTINCT i.ProductID, i.LocationID, i.Shelf, i.Bin, 
	i.Quantity, i.rowguid, GETDATE(), 'I'
FROM inserted i
-- Deleted rows
INSERT Production.ProductInventoryAudit
(
	ProductID, LocationID, Shelf, Bin, 
	Quantity, rowguid, ModifiedDate, InsOrUPD
)
SELECT d.ProductID, d.LocationID, d.Shelf, d.Bin, 
	d.Quantity, d.rowguid, GETDATE(), 'D'
FROM deleted d

IF EXISTS(SELECT Quantity FROM deleted WHERE Quantity > 0)
BEGIN
	PRINT 'You cannot remove positive quantity rows!'
ROLLBACK
END
GO


-- testare trigger - tranzactie implicita
INSERT Production.ProductInventory
(ProductID, LocationID, Shelf, Bin, Quantity)
VALUES (316, 6, 'A', 4, 22)


-- testare trigger - tranzactie explicita
-- prima stergere este permisa
-- a doua nu este permisa prin urmare intreaga tranzactia va esua 
-- nu este stearsa nici o inregistrare
BEGIN TRANSACTION

	-- Deleting a row with a zero quantity
	DELETE  Production.ProductInventory
	WHERE ProductID = 853 AND LocationID = 7

	-- Deleting a row with a non-zero quantity
	DELETE Production.ProductInventory
	WHERE ProductID = 999 AND LocationID = 60
	-- trigger-ul emite ROLLBACK 
	-- prin urmare și tranzacția externă este invalidată
	
COMMIT TRANSACTION