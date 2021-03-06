USE AdventureWorks
GO
-- dacă s-a modificat GroupName operația este anulata
CREATE TRIGGER HumanResources.trg_U_Department
ON HumanResources.Department
AFTER UPDATE
AS
IF UPDATE(GroupName)
BEGIN
	PRINT 'Updates to GroupName require DBA involvement.'
	ROLLBACK
END
GO

-- testare trigger
UPDATE HumanResources.Department
SET GroupName = 'Research and Development'
WHERE DepartmentID = 10