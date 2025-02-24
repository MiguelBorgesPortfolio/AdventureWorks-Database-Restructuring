/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Layout»
 *  	
 ********************************************/
--Espaço ocupado por cada tabela com o número atual de registos;

USE AdventureWorks;

-- Sales.Territory
EXEC sp_spaceused 'Sales.Territory';
SELECT COUNT(*) AS RecordCount FROM Sales.Territory;

-- Sales.CustomerInfo
EXEC sp_spaceused 'Sales.CustomerInfo';
SELECT COUNT(*) AS RecordCount FROM Sales.CustomerInfo;

-- Sales.City
EXEC sp_spaceused 'Sales.City';
SELECT COUNT(*) AS RecordCount FROM Sales.City;

-- Sales.Customer
EXEC sp_spaceused 'Sales.Customer';
SELECT COUNT(*) AS RecordCount FROM Sales.Customer;

-- Sales.Currency
EXEC sp_spaceused 'Sales.Currency';
SELECT COUNT(*) AS RecordCount FROM Sales.Currency;

-- Sales.Promotion
EXEC sp_spaceused 'Sales.Promotion';
SELECT COUNT(*) AS RecordCount FROM Sales.Promotion;

-- Sales.Sale
EXEC sp_spaceused 'Sales.Sale';
SELECT COUNT(*) AS RecordCount FROM Sales.Sale;

-- Sales.Orders
EXEC sp_spaceused 'Sales.Orders';
SELECT COUNT(*) AS RecordCount FROM Sales.Orders;

-- Sales.SaleCustomer
EXEC sp_spaceused 'Sales.SaleCustomer';
SELECT COUNT(*) AS RecordCount FROM Sales.SaleCustomer;

-- Factory.Product
EXEC sp_spaceused 'Factory.Product';
SELECT COUNT(*) AS RecordCount FROM Factory.Product;

-- Factory.ProductType
EXEC sp_spaceused 'Factory.ProductType';
SELECT COUNT(*) AS RecordCount FROM Factory.ProductType;
