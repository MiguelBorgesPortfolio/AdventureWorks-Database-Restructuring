/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Migrate data»
 *  	
 ********************************************/

USE AdventureWorks;
GO

--============================================================================= 
-- Etapa 1: «Drop Procedures» 
--=============================================================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_TerritoryMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_TerritoryMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_.SaleCustomerMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_SaleCustomerMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_SaleMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_SaleMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_PromotionMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_PromotionMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_OrdersMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_OrdersMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_SaleCustomerInfoMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_CustomerInfoMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_CustomerMigrate') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE sp_CustomerMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_CurrencyMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_CurrencyMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_CityMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_CityMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_ProductMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_ProductMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_ProductTypeMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_ProductTypeMigrate;
END;
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('sp_SecurityQuestionMigrate') AND type in (N'P', N'PC'))
BEGIN
    DROP PROCEDURE sp_SecurityQuestionMigrate;
END;
GO

--============================================================================= 
-- Etapa 2: «Procedures para migrar dados da AdventureOldData para a nova» 
--=============================================================================

CREATE PROCEDURE sp_TerritoryMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Territory')
	BEGIN
		INSERT INTO Sales.Territory(stSalesTerritoryKey, stSalesTerritoryRegion, stSalesTerritoryCountry, stSalesTerritoryGroup)
		SELECT SalesTerritoryKey, SalesTerritoryRegion, SalesTerritoryCountry, SalesTerritoryGroup
		FROM [AdventureOldData].[dbo].[SalesTerritory];
	END;
END;
GO

CREATE PROCEDURE sp_SaleCustomerMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SaleCustomer')
	BEGIN
		INSERT INTO [Sales].[SaleCustomer]([scSalesKey],[scCustomerKey])
		SELECT s.salSaleKey, c.ctCustomerKey
		FROM AdventureWorks.Sales.Sale s
		LEFT JOIN Sales.Customer c ON s.salCustomerKey = c.ctCustomerKey
	END;
END;
GO

CREATE PROCEDURE sp_SaleMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sale')
    BEGIN
		INSERT INTO [Sales].[Sale]([salProductKey],[salCustomerKey],[salPromotionKey],[salCurrencyKey],[salSalesTerritoryKey]
			   ,[salSalesOrderNumber],[salRevisionNumber],[salExtendedAmount],[salProductStandardCost],[salTotalProductCost],[salSalesAmount]
			   ,[salTaxAmt], [salFreight])
		SELECT s.ProductKey,s.CustomerKey,s.PromotionKey,c.curCurrencyKey,s.SalesTerritoryKey,
			   s.SalesOrderNumber,s.RevisionNumber,s.ExtendedAmount,s.ProductStandardCost,s.TotalProductCost,s.SalesAmount,
			   s.TaxAmt, s.Freight
		FROM [AdventureOldData].[dbo].[sales7$] s
		INNER JOIN Sales.Currency c ON s.CurrencyKey = c.curCurrencyKey;
    END;
END;
GO

CREATE PROCEDURE sp_PromotionMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Promotion')
    BEGIN
        INSERT INTO [Sales].[Promotion]([proPromotionKey],[proUnitPriceDiscountPct],[proDiscountAmount])
		SELECT DISTINCT [PromotionKey], [UnitPriceDiscountPct], [DiscountAmount]
		FROM [AdventureOldData].[dbo].[sales7$]
    END;
END;
GO

CREATE PROCEDURE sp_OrdersMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Orders')
    BEGIN
        INSERT INTO [Sales].[Orders]([odSalesOrderNumber],[odOrderQuantity],[odCustomerKey],[odProductKey],[odUnitPrice]
           ,[odCarrierTrackingNumber],[odSalesOrderLineNumber],[odOrderDate],[odDueDate],[odShipDate])
		SELECT[SalesOrderNumber],[OrderQuantity],[CustomerKey],[ProductKey],[UnitPrice],[CarrierTrackingNumber]
			,[SalesOrderLineNumber],[OrderDate],[DueDate],[ShipDate]
        FROM [AdventureOldData].[dbo].[sales7$]
    END;
END;
GO

CREATE PROCEDURE sp_CustomerInfoMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CustomerInfo')
    BEGIN
        INSERT INTO Sales.CustomerInfo([ciCustomerKey],[cinfoTitle],[cinfoFirstName],[cinfoMiddleName],[cinfoLastName],[cinfoBirthDate]
			,[cinfoMaritalStatus],[cinfoGender],[cinfoEmailAddress],[cinfoYearlyIncome],[cinfoTotalChildren],[cinfoNumberChildrenAtHome],[cinfoEducation]
			,[cinfoOccupation],[cinfoPhone],[cinfoHouseOwnerFlag],[cinfoNumberCarsOwned])
		SELECT [CustomerKey] ,[Title],[FirstName],[MiddleName],[LastName],[BirthDate],[MaritalStatus],[Gender],[EmailAddress],[YearlyIncome]
			,[TotalChildren],[NumberChildrenAtHome],[Education],[Occupation],[Phone],[HouseOwnerFlag],[NumberCarsOwned]
		FROM [AdventureOldData].[dbo].[Customer];
    END;
END;
GO






CREATE PROCEDURE sp_CustomerMigrate
AS
BEGIN
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Customer')
    BEGIN
        INSERT INTO Sales.Customer (
            ctCustomerKey, ctNameStyle, ctSalesTerritoryKey, ctDateFirstPurchase, ctCommuteDistance,
            ctAddressLine1, ctAddressLine2,ctCityKey, ctPostalCode)
        SELECT 
            c.[CustomerKey], c.[NameStyle], c.[SalesTerritoryKey], c.[DateFirstPurchase], c.[CommuteDistance], 
            c.[AddressLine1], c.[AddressLine2],(select top 1 cCityKey from  AdventureWorks.sales.City
 where city = cCity and stateProvinceCode = cStateProvinceCode) as cKey, c.[PostalCode]
        FROM 
            [AdventureOldData].[dbo].[Customer] c
			-- INNER join [Sales].[City] p ON c.City = p.cCity
    END;
END;
GO


CREATE PROCEDURE sp_CurrencyMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Currency')
    BEGIN
        INSERT INTO Sales.Currency(curCurrencyKey, curCurrencyAcronymKey, curCurrencyName)
		SELECT CurrencyKey, CurrencyAlternateKey, CurrencyName
		FROM [AdventureOldData].[dbo].[Currency];
    END;
END;
GO

CREATE PROCEDURE sp_CityMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'City')
    BEGIN
        INSERT INTO [Sales].[City]([cCity],[cCountryRegionCode],[cCountryRegionName],[cStateProvinceCode],[cStateProvinceName])
		SELECT DISTINCT [City],[CountryRegionCode],[CountryRegionName],[StateProvinceCode],[StateProvinceName]
		FROM [AdventureOldData].[dbo].[Customer];
    END;
END;
GO

CREATE PROCEDURE sp_ProductMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Product')
	BEGIN
		INSERT INTO [Factory].[Product]([prodProductKey], [prodStandardCost], [prodFinishedGoodsFlag],
			[prodSafetyStockLevel], [prodListPrice], [prodProductLine], [prodDealerPrice], [prodClass], 
			[prodEnglishDescription], [prodStatus])
		SELECT
			[ProductKey],
			[StandardCost], [FinishedGoodsFlag], [SafetyStockLevel],
			[ListPrice], [ProductLine], [DealerPrice], [Class], [EnglishDescription], [Status]
		FROM [AdventureOldData].[dbo].[Products$]
	END;
END;
GO

CREATE PROCEDURE sp_ProductTypeMigrate
AS
BEGIN
	IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductType')
	BEGIN
		INSERT INTO [Factory].[ProductType](ptProductKey, [ptWeightUnitMeasureCode], [ptSizeUnitMeasureCode], 
			[ptEnglishProductName], [ptSpanishProductName],[ptColor], [ptSize], [ptSizeRange], [ptWeight], 
			[ptDaysToManufacture], [ptStyle], [ptModelName], [ptProductSubcategoryKey], [ptEnglishProductCategoryName],
			[ptSpanishProductCategoryName], [ptEnglishProductSubcategoryName], [ptSpanishProductSubcategoryName], [ptFrenchProductSubcategoryName])
		SELECT ProductKey, p.[WeightUnitMeasureCode] ,p.[SizeUnitMeasureCode], p.[EnglishProductName], p.[SpanishProductName], 
			p.[Color], p.[Size], p.[SizeRange], p.[Weight], p.[DaysToManufacture], p.[Style], p.[ModelName], p.[ProductSubcategoryKey],p.[EnglishProductCategoryName], 
			p.[SpanishProductCategoryName], s.[EnglishProductSubcategoryName], s.[SpanishProductSubcategoryName], s.[FrenchProductSubcategoryName]
		FROM [AdventureOldData].[dbo].[Products$] p
		LEFT JOIN AdventureOldData.dbo.ProductSubCategory s ON s.ProductSubcategoryKey = p.ProductSubcategoryKey;
	END;
END;
GO

--============================================================================= 
-- Etapa 3: «Executa as Procedures» 
--=============================================================================

EXEC sp_TerritoryMigrate;
EXEC sp_PromotionMigrate;
EXEC sp_CustomerInfoMigrate;
EXEC sp_CityMigrate;
EXEC sp_CustomerMigrate;
EXEC sp_CurrencyMigrate;
EXEC sp_SaleMigrate;
EXEC sp_SaleCustomerMigrate;
EXEC sp_ProductMigrate;
EXEC sp_ProductTypeMigrate;
EXEC sp_OrdersMigrate;
GO