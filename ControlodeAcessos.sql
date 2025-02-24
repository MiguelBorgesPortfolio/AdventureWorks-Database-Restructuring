/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Controlo de acessos»
 *  	
 ********************************************/


Use AdventureWorks;


--Acesso Admin

DROP USER AdminUser;
DROP LOGIN AdminLogin;
DROP ROLE AdministratorRole;

-- 1. Criar Login
CREATE LOGIN AdminLogin WITH PASSWORD = 'AdminPassWord';

-- 2. Criar Role
CREATE ROLE AdministratorRole;

-- 3. Criar Usuário associado ao Login
CREATE USER AdminUser FOR LOGIN AdminLogin;

-- 4. Conceder Permissões ao Role (AdministratorRole)
USE AdventureWorks; 
GRANT SELECT, UPDATE, INSERT, DELETE, CONTROL ON DATABASE::AdventureWorks TO AdministratorRole;

-- 5. Adicionar User ao Role
ALTER ROLE AdministratorRole ADD MEMBER AdminUser;


--Testes
EXECUTE AS USER = 'AdminUser'
GO
EXEC sp_who

--Todas são executadas com sucesso

SELECT * FROM Sales.Territory;
SELECT * FROM Sales.SaleCustomer;
SELECT * FROM Sales.Sale;
SELECT * FROM Sales.Promotion;
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.CustomerInfo;
SELECT * FROM Sales.City;
SELECT * FROM Sales.Currency;
SELECT * FROM Sales.Orders;
SELECT * FROM Factory.Product;
SELECT * FROM Factory.ProductType;




INSERT INTO Sales.CustomerInfo (ciCustomerKey, cinfoTitle, cinfoFirstName, cinfoMiddleName, cinfoLastName, cinfoBirthDate, cinfoMaritalStatus, cinfoGender, cinfoEmailAddress, cinfoYearlyIncome, cinfoTotalChildren, cinfoNumberChildrenAtHome, cinfoEducation, cinfoOccupation, cinfoPhone, cinfoHouseOwnerFlag, cinfoNumberCarsOwned)
VALUES (1, 'Mr', 'Miguel', 'C', 'Park', '1999-08-01', 'M', 'M', 'john.doe@example.com', 50000, 2, 1, 'Bachelor', 'Professional', '123-456-7890', 1, 2);
INSERT INTO Sales.Customer (ctCustomerKey, ctNameStyle, ctSalesTerritoryKey, ctDateFirstPurchase, ctCommuteDistance, ctAddressLine1, ctAddressLine2, ctCityKey, ctPostalCode)
VALUES (1, 1, 1, '2022-01-01', '5 miles', '123 Main St', 'Apt 45', 1, '12345');
INSERT INTO Sales.Promotion (proPromotionKey, proUnitPriceDiscountPct, proDiscountAmount)
VALUES (7, 0.1, 5.0);
INSERT INTO Sales.Sale (salProductKey, salCustomerKey, salPromotionKey, salCurrencyKey, salSalesTerritoryKey, salSalesOrderNumber, salRevisionNumber, salExtendedAmount, salProductStandardCost, salTotalProductCost, salSalesAmount, salTaxAmt, salFreight)
VALUES (1, 1, 1, 1, 1, 'SO1001', 1, 100.0, 80.0, 90.0, 120.0, 10.0, 5.0);
INSERT INTO Factory.Product (prodProductKey, prodStandardCost, prodFinishedGoodsFlag, prodSafetyStockLevel, prodListPrice, prodProductLine, prodDealerPrice, prodClass, prodOrderKey, prodEnglishDescription, prodStatus)
VALUES (1, 50.0, 'Yes', 100, 80.0, 'Bikes', 70.0, 'High', 1, 'Mountain Bike', 'Active');


-- Voltar ao Login sa
REVERT
EXEC sp_who



--Acesso  SalesPerson

DROP USER SalesPersonUser;

DROP ROLE SalesPersonRole;

DROP LOGIN SalesPersonLogin;


-- 1. Criar Login
CREATE LOGIN SalesPersonLogin WITH PASSWORD = 'SalesPersonPassword';

-- 2. Criar Role
CREATE ROLE SalesPersonRole;

-- 3. Criar User associado ao Login
CREATE USER SalesPersonUser FOR LOGIN SalesPersonLogin;

-- 4. Conceder Permissões ao Role (SalesPersonRole)
GRANT SELECT,UPDATE,INSERT,DELETE,CONTROL ON [Sales].[Sale] TO SalesPersonRole;
GRANT SELECT,UPDATE,INSERT,DELETE,CONTROL ON [Sales].[Orders] TO SalesPersonRole;
GRANT SELECT,UPDATE,INSERT,DELETE,CONTROL ON [Sales].[Promotion] TO SalesPersonRole;
GRANT SELECT ON [Factory].[Product] TO SalesPersonRole;
GRANT SELECT ON [Factory].[ProductType] TO SalesPersonRole;
GRANT SELECT ON [Sales].[City] TO SalesPersonRole;
GRANT SELECT ON [Sales].[Currency] TO SalesPersonRole;
GRANT SELECT ON [Sales].[Customer] TO SalesPersonRole;
GRANT SELECT ON [Sales].[CustomerInfo] TO SalesPersonRole;
GRANT SELECT ON [Sales].[SaleCustomer] TO SalesPersonRole;
GRANT SELECT ON [Sales].[Territory] TO SalesPersonRole;

-- 5. Adicionar Usuário ao Role
ALTER ROLE SalesPersonRole ADD MEMBER SalesPersonUser;


EXECUTE AS USER = 'SalesPersonUser'
GO
EXEC sp_who


--Todas são executas com sucesso
SELECT * FROM Sales.Territory;
SELECT * FROM Sales.SaleCustomer;
SELECT * FROM Sales.Sale;
SELECT * FROM Sales.Promotion;
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.CustomerInfo;
SELECT * FROM Sales.City;
SELECT * FROM Sales.Currency;
SELECT * FROM Sales.Orders;
SELECT * FROM Factory.Product;
SELECT * FROM Factory.ProductType;
 
--Insucesso
INSERT INTO Sales.CustomerInfo (ciCustomerKey, cinfoTitle, cinfoFirstName, cinfoMiddleName, cinfoLastName, cinfoBirthDate, cinfoMaritalStatus, cinfoGender, cinfoEmailAddress, cinfoYearlyIncome, cinfoTotalChildren, cinfoNumberChildrenAtHome, cinfoEducation, cinfoOccupation, cinfoPhone, cinfoHouseOwnerFlag, cinfoNumberCarsOwned)
VALUES (1, 'Mr', 'Miguel', 'C', 'Park', '1999-08-01', 'M', 'M', 'john.doe@example.com', 50000, 2, 1, 'Bachelor', 'Professional', '123-456-7890', 1, 2);
INSERT INTO Sales.Customer (ctCustomerKey, ctNameStyle, ctSalesTerritoryKey, ctDateFirstPurchase, ctCommuteDistance, ctAddressLine1, ctAddressLine2, ctCityKey, ctPostalCode)
VALUES (1, 1, 1, '2022-01-01', '5 miles', '123 Main St', 'Apt 45', 1, '12345');
INSERT INTO Factory.Product (prodProductKey, prodStandardCost, prodFinishedGoodsFlag, prodSafetyStockLevel, prodListPrice, prodProductLine, prodDealerPrice, prodClass, prodOrderKey, prodEnglishDescription, prodStatus)
VALUES (1, 50.0, 'Yes', 100, 80.0, 'Bikes', 70.0, 'High', 1, 'Mountain Bike', 'Active');

--Sucesso
INSERT INTO Sales.Promotion (proPromotionKey, proUnitPriceDiscountPct, proDiscountAmount)
VALUES (8, 0.1, 5.0);
INSERT INTO Sales.Sale (salProductKey, salCustomerKey, salPromotionKey, salCurrencyKey, salSalesTerritoryKey, salSalesOrderNumber, salRevisionNumber, salExtendedAmount, salProductStandardCost, salTotalProductCost, salSalesAmount, salTaxAmt, salFreight)
VALUES (1, 2, 1, 1, 1, 'SOw001', 1, 100.0, 80.0, 90.0, 120.0, 10.0, 5.0);



-- Voltar ao Login sa
REVERT
EXEC sp_who




-- Acesso SalesTerritory
--  França

-- view auxiliar para os detalhes da França
DROP VIEW IF EXISTS vw_France_SalesDetails;
go

--Sales records para França
CREATE VIEW vw_France_SalesDetails
AS
SELECT salCustomerKey,salPromotionKey,salSalesOrderNumber,salExtendedAmount,salProductStandardCost,salSalesAmount,salTaxAmt,salFreight
,odOrderDate,odUnitPrice,odDueDate,odShipDate,stSalesTerritoryRegion,stSalesTerritoryCountry,stSalesTerritoryGroup,cCity
FROM Sales.Sale 
JOIN Sales.Orders ON salSalesOrderNumber=odSalesOrderNumber
JOIN Sales.Territory ON salSalesTerritoryKey = stSalesTerritoryKey
JOIN  Sales.City ON stSalesTerritoryRegion = cCountryRegionName
WHERE stSalesTerritoryKey = 7; 
;
GO


DROP USER SalesTerritoryFranceUser;

DROP ROLE SalesTerritoryFranceRole;

DROP LOGIN SalesTerritoryFranceLogin;

-- 1. Criar Login
CREATE LOGIN SalesTerritoryFranceLogin WITH PASSWORD = 'SalesTerritoryFrance';

-- 2. Criar Role
CREATE ROLE SalesTerritoryFranceRole;

-- 3. Criar Usuário associado ao Login
CREATE USER SalesTerritoryFranceUser FOR LOGIN SalesTerritoryFranceLogin;

-- 4. Conceder Permissões ao Role (SalesTerritoryFranceRole)
GRANT SELECT ON vw_France_SalesDetails TO SalesTerritoryFranceRole;

-- 5. Adicionar Usuário ao Role
ALTER ROLE SalesTerritoryFranceRole ADD MEMBER SalesTerritoryFranceUser;

EXECUTE AS USER = 'SalesTerritoryFranceUser'
GO
EXEC sp_who
--Sucesso 
SELECT * FROM vw_France_SalesDetails;

--Insucesso
SELECT * FROM Sales.Territory;
SELECT * FROM Sales.SaleCustomer;
SELECT * FROM Sales.Sale;
SELECT * FROM Sales.Promotion;
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.CustomerInfo;
SELECT * FROM Sales.City;
SELECT * FROM Sales.Currency;
SELECT * FROM Sales.Orders;
SELECT * FROM Factory.Product;
SELECT * FROM Factory.ProductType;


-- Voltar ao Login sa
REVERT
EXEC sp_who


--Germany

-- view auxiliar para os detalhes da França

DROP VIEW IF EXISTS  vw_Germany_Sales;
go
--Sales records para Germany
CREATE VIEW vw_Germany_Sales
AS
SELECT salCustomerKey,salPromotionKey,salSalesOrderNumber,salExtendedAmount,salProductStandardCost,salSalesAmount,salTaxAmt,salFreight
,odOrderDate,odUnitPrice,odDueDate,odShipDate,stSalesTerritoryRegion,stSalesTerritoryCountry,stSalesTerritoryGroup,cCity
FROM Sales.Sale 
JOIN Sales.Orders ON salSalesOrderNumber=odSalesOrderNumber
JOIN Sales.Territory ON salSalesTerritoryKey = stSalesTerritoryKey
JOIN  Sales.City ON stSalesTerritoryRegion = cCountryRegionName
WHERE stSalesTerritoryKey = 8; 
;

GO


DROP USER SalesTerritoryGermanyUser;

DROP ROLE SalesTerritoryGermanyRole;

DROP LOGIN SalesTerritoryGermanyLogin;

-- 1. Criar Login
CREATE LOGIN SalesTerritoryGermanyLogin WITH PASSWORD = 'SalesTerritoryGermany';

-- 2. Criar Role
CREATE ROLE SalesTerritoryGermanyRole;

-- 3. Criar Usuário associado ao Login
CREATE USER SalesTerritoryGermanyUser FOR LOGIN SalesTerritoryGermanyLogin;

-- 4. Conceder Permissões ao Role (SalesTerritoryFranceRole)
GRANT SELECT ON vw_Germany_Sales TO SalesTerritoryGermanyRole;

-- 5. Adicionar Usuário ao Role
ALTER ROLE SalesTerritoryGermanyRole ADD MEMBER SalesTerritoryGermanyUser;

EXECUTE AS USER = 'SalesTerritoryGermanyUser'
GO
EXEC sp_who
--Sucesso
SELECT * FROM vw_Germany_Sales;
--Insucesso
SELECT * FROM Sales.Territory;
SELECT * FROM Sales.SaleCustomer;
SELECT * FROM Sales.Sale;
SELECT * FROM Sales.Promotion;
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.CustomerInfo;
SELECT * FROM Sales.City;
SELECT * FROM Sales.Currency;
SELECT * FROM Sales.Orders;
SELECT * FROM Factory.Product;
SELECT * FROM Factory.ProductType;

-- Voltar ao Login sa
REVERT
EXEC sp_who
