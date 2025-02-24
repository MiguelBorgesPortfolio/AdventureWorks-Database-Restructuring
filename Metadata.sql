/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Metadata»
 *  	
 ********************************************/

USE AdventureWorks;
GO

--============================================================================= 
-- Etapa 1: «Cria um Histórico» 
--=============================================================================

-- 1.1) «Tabela HitoricData, guarda as informações relativas às alterações recentes nas sucessivas execuções da procedure»
DROP TABLE IF exists HistoricData;
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HistoricData')
    BEGIN
        CREATE TABLE HistoricData
        (
            ExecutionDateTime DATETIME,
            TableName NVARCHAR(255),
            ColumnName NVARCHAR(255),
            DataType NVARCHAR(50),
            DataSize INT,
            Constraints NVARCHAR(MAX)
        );
    END;

-- 1.2) «Drop da Procedure»
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('dbo.GenerateHistoricEntries') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_GenerateHistoricEntries;
END;
GO

-- 1.3) «Procedure insere informação na tabela HistoricData relativamente às alterações da base de dados»
CREATE PROCEDURE sp_GenerateHistoricEntries
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM sys.tables t
        WHERE t.modify_date > COALESCE((SELECT MAX(ExecutionDateTime) FROM HistoricData), '19000101')
    )
    BEGIN
        INSERT INTO HistoricData (ExecutionDateTime, TableName, ColumnName, DataType, DataSize, Constraints)
        SELECT 
            GETDATE(),
            t.name AS TableName,
            c.name AS ColumnName,
            ty.name AS DataType,
            c.max_length AS DataSize,
            CASE 
                WHEN fk.name IS NOT NULL THEN 'Foreign Key (' + fk.name + ') ' + 'References ' + ref.name + '(' + rc.name + ') ' +
				'On ' + CASE fk.delete_referential_action 
                 WHEN 1 THEN 'Cascade'
				 WHEN 2 THEN 'Set Null'
                 WHEN 3 THEN 'Set Default'
                 ELSE 'No Action' END
                 ELSE ''
            END AS Constraints
        FROM sys.tables t
        INNER JOIN sys.columns c ON t.object_id = c.object_id
        INNER JOIN sys.types ty ON c.system_type_id = ty.system_type_id
        LEFT JOIN sys.foreign_keys fk ON t.object_id = fk.parent_object_id
        LEFT JOIN sys.tables ref ON fk.referenced_object_id = ref.object_id
        LEFT JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
        LEFT JOIN sys.columns rc ON fkc.referenced_column_id = rc.column_id
        WHERE t.modify_date > COALESCE((SELECT MAX(ExecutionDateTime) FROM HistoricData), '19000101');
    END;
END;

exec sp_GenerateHistoricEntries;
GO

-- SELECT * FROM HistoricData order by ExecutionDateTime desc;

--DROP TABLE IF exists test;
--CREATE TABLE test (
--    ID INT PRIMARY KEY,
--    Nome NVARCHAR(255)
--);

--============================================================================= 
-- Etapa 2: «Disponibiliza da última alteração» 
--=============================================================================

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID('dbo.LatestHistoricData'))
BEGIN
    DROP VIEW vw_LatestHistoricData;
END;
GO

CREATE VIEW vw_LatestHistoricData AS
SELECT TOP 1 * FROM HistoricData ORDER BY ExecutionDateTime desc;
GO

--============================================================================= 
-- Etapa 3: «Estatísticas dos metadados» 
--=============================================================================

DROP TABLE IF exists StatisticsTable;
GO

-- 3.1) «Tabela StatisticsTable»
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StatisticsTable')    
 BEGIN         
 CREATE TABLE StatisticsTable (             
	 StatisticsTableID INT PRIMARY KEY IDENTITY(1,1),
	 TableName NVARCHAR(128),             
	 RecordCount INT,             
	 TotalSpaceOccupied INT,             
	 Timestamp DATETIME DEFAULT GETDATE()         
 );     
 END; 

 IF OBJECT_ID('StatisticsRegister', 'P') IS NOT NULL     
	DROP PROCEDURE sp_StatisticsRegister; 
 GO

-- 3.2) «Procedure regista os número de registos e o espaço ocupado de todas as tabelas»
 CREATE PROCEDURE sp_StatisticsRegister 
 AS 
 BEGIN          
	 INSERT INTO StatisticsTable (TableName, RecordCount, TotalSpaceOccupied)     
	 SELECT	T.TABLE_NAME,(SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = T.TABLE_NAME),         
		SUM(DATALENGTH(C.COLUMN_NAME)) AS TotalSpaceOccupied     
	 FROM INFORMATION_SCHEMA.TABLES T         
		LEFT JOIN INFORMATION_SCHEMA.COLUMNS C ON T.TABLE_NAME = C.TABLE_NAME     
	 WHERE T.TABLE_TYPE = 'BASE TABLE'     
	 GROUP BY T.TABLE_NAME; 
 END;  
 
 EXEC sp_StatisticsRegister;
 SELECT * from StatisticsTable;