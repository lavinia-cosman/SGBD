--query 1-1
USE AdventureWorks
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRAN
SELECT AddressTypeID, Name
FROM Person.AddressType
WHERE AddressTypeID BETWEEN 1 AND 6

-- query 1-2
SELECT resource_associated_entity_id, resource_type,
request_mode, request_session_id
FROM sys.dm_tran_locks

-- query 1-3
COMMIT TRAN -- termină tranzactia și eliberează lock-urile


-- query 2-1
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
GO
BEGIN TRAN
SELECT AddressTypeID, Name
FROM Person.AddressType
WHERE AddressTypeID BETWEEN 1 AND 6


-- query 2-2
-- de data aceasta nu creează lock-uri
SELECT resource_associated_entity_id, resource_type,
request_mode, request_session_id
FROM sys.dm_tran_locks


-- query 2-3
COMMIT TRAN -- termină tranzactia 



-- query 3-1
ALTER DATABASE AdventureWorks
SET ALLOW_SNAPSHOT_ISOLATION ON
GO
USE AdventureWorks
GO
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
GO
BEGIN TRAN
SELECT CurrencyRateID,
EndOfDayRate
FROM Sales.CurrencyRate
WHERE CurrencyRateID = 8317

-- query 3-2
USE AdventureWorks
GO
UPDATE Sales.CurrencyRate
SET EndOfDayRate = 1.00
WHERE CurrencyRateID = 8317


-- query 3-3
SELECT CurrencyRateID,
EndOfDayRate
FROM Sales.CurrencyRate
WHERE CurrencyRateID = 8317


-- query 3-4
COMMIT TRAN
SELECT CurrencyRateID,
EndOfDayRate
FROM Sales.CurrencyRate
WHERE CurrencyRateID = 8317