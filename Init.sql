/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Initialization»
 *  	
 ********************************************/

--============================================================================= 
-- Etapa 1: «Drop Database if exists» 
--=============================================================================

IF DB_ID('AdventureWorks') IS NOT NULL
BEGIN
    USE master;
    ALTER DATABASE AdventureWorks SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AdventureWorks;
END;

IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'AdventureWorks')
BEGIN
    CREATE DATABASE AdventureWorks
	ON PRIMARY
	(NAME = 'AdventureWorksPrimary',
	FILENAME = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Files\AdventureWorksPrimary.mdf',
	SIZE = 2048 KB, FILEGROWTH = 1024 KB),
	FILEGROUP AdventureWorks_Medium_Update
	(NAME = 'AdventureWorks_Medium_Update',
	FILENAME = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Files\AdventureWorks_Medium_Update.ndf',
	SIZE = 2048 KB, FILEGROWTH = 1024 KB),
	FILEGROUP AdventureWorks_Low_Update
	(NAME = 'AdventureWorks_Low_Update',
	FILENAME = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Files\AdventureWorks_Low_Update.ndf',
	SIZE = 2048 KB, FILEGROWTH = 1024 KB)

END;
GO





USE AdventureWorks;
GO

--============================================================================= 
-- Etapa 2: «Create & Drop Schemas» 
--============================================================================= 

-- 1.1) «Drop Schema»
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'Sales')
	DROP SCHEMA Sales;
GO
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'Factory')
	DROP SCHEMA Factory;
GO
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'Administrator')
	DROP SCHEMA Factory;
GO

-- 1.2) «Create Schema»
CREATE SCHEMA Sales;
GO
CREATE SCHEMA Factory;
GO
CREATE SCHEMA Administrator;
GO
