/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Create Tables»
 *  	
 ********************************************/

USE AdventureWorks;
GO

--============================================================================= 
-- Etapa 1: «Create das tables» 
--============================================================================= 

-- 1.1) «Tabela Territory»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Territory')
BEGIN
	CREATE TABLE Sales.Territory (
		stSalesTerritoryKey INT PRIMARY KEY,
		stSalesTerritoryRegion NVARCHAR(20),
		stSalesTerritoryCountry NVARCHAR(20),
		stSalesTerritoryGroup NVARCHAR(30)
	)ON AdventureWorks_Low_Update;
END;

-- 1.2) «Tabela CustomerInfo»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CustomerInfo')
BEGIN
	CREATE TABLE Sales.CustomerInfo (
		ciCustomerKey INT PRIMARY KEY,
		cinfoTitle VARCHAR(30),
		cinfoFirstName VARCHAR(50),
		cinfoMiddleName VARCHAR(50),
		cinfoLastName VARCHAR(50),
		cinfoBirthDate VARCHAR(20),
		cinfoMaritalStatus CHAR(1),
		cinfoGender CHAR(1),
		cinfoEmailAddress VARCHAR(85),
		cinfoYearlyIncome MONEY,
		cinfoTotalChildren TINYINT,
		cinfoNumberChildrenAtHome TINYINT,
		cinfoEducation VARCHAR(40),
		cinfoOccupation VARCHAR(40),
		cinfoPhone VARCHAR(25),
		cinfoHouseOwnerFlag BIT,
		cinfoNumberCarsOwned INT,
	);
END;

-- 1.3) «Tabela City»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'City')
BEGIN
	CREATE TABLE Sales.City (
		cCityKey INT IDENTITY(1,1) PRIMARY KEY,
		cCity VARCHAR(255),
		cCountryRegionCode CHAR(3),
		cCountryRegionName VARCHAR(100),
		cStateProvinceCode CHAR(3),
		cStateProvinceName VARCHAR(100),
	)ON AdventureWorks_Low_Update;
END;

-- 1.4) «Tabela Customer»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Customer')
BEGIN
	CREATE TABLE Sales.Customer (
		ctCustomerKey INT PRIMARY KEY,
		ctNameStyle BIT,
		ctSalesTerritoryKey INT,
		ctDateFirstPurchase VARCHAR(20),
		ctCommuteDistance VARCHAR(35),
		ctAddressLine1 VARCHAR(150),
		ctAddressLine2 VARCHAR(150),
		ctCityKey INT FOREIGN KEY REFERENCES Sales.City(cCityKey),
		ctPostalCode VARCHAR(15),
		FOREIGN KEY (ctSalesTerritoryKey) REFERENCES Sales.Territory(stSalesTerritoryKey),
		FOREIGN KEY (ctCustomerKey) REFERENCES Sales.CustomerInfo(ciCustomerKey)
	);	
END;



-- 1.5) «Tabela Currency»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Currency')
BEGIN
	CREATE TABLE Sales.Currency (
		curCurrencyKey INT PRIMARY KEY,
		curCurrencyAcronymKey VARCHAR(3),
		curCurrencyName VARCHAR(50)
	)ON AdventureWorks_Low_Update;
END;

-- 1.6) «Tabela Promotion»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Promotion')
BEGIN
	CREATE TABLE Sales.Promotion (
		proPromotionKey INT PRIMARY KEY,
		proUnitPriceDiscountPct DECIMAL(5, 2),
		proDiscountAmount DECIMAL(10, 2)
	)ON AdventureWorks_Medium_Update;
END;

-- 1.7) «Tabela Sale»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sale')
BEGIN
	CREATE TABLE Sales.Sale (
		salSaleKey INT IDENTITY(1,1) PRIMARY KEY,
		salProductKey INT,
		salCustomerKey INT,
		salPromotionKey INT,
		salCurrencyKey INT,
		salSalesTerritoryKey INT,
		salSalesOrderNumber NVARCHAR(40),
		salRevisionNumber INT,
		salExtendedAmount DECIMAL(10, 2),
		salProductStandardCost DECIMAL(10, 2),
		salTotalProductCost DECIMAL(10, 2),
		salSalesAmount DECIMAL(10, 2),
		salTaxAmt DECIMAL(10, 2),
		salFreight DECIMAL(10, 2),
		FOREIGN KEY (salSalesTerritoryKey) REFERENCES Sales.Territory(stSalesTerritoryKey),
		FOREIGN KEY (salPromotionKey) REFERENCES Sales.Promotion(proPromotionKey),
		FOREIGN KEY (salCurrencyKey) REFERENCES Sales.Currency(curCurrencyKey),
	);
END;

-- 1.8) «Tabela Product»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Product')
BEGIN
	CREATE TABLE Factory.Product (
		prodProductKey INT PRIMARY KEY,
		prodStandardCost FLOAT,
		prodFinishedGoodsFlag NVARCHAR(20),
		prodSafetyStockLevel FLOAT,
		prodListPrice FLOAT,
		prodProductLine NVARCHAR(20),
		prodDealerPrice FLOAT,
		prodClass NVARCHAR(10),
		prodOrderKey INT,
		prodEnglishDescription NVARCHAR(255),
		prodStatus NVARCHAR(20)
	)ON AdventureWorks_Medium_Update;
END;

-- 1.9) «Tabela Orders»
-- 1.9) «Tabela Orders»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Orders')
BEGIN
    CREATE TABLE Sales.Orders (
        odOrderKey INT IDENTITY(1,1) PRIMARY KEY,
        odSalesOrderNumber NVARCHAR(255),
        odOrderQuantity INT,
        odCustomerKey INT,
        odProductKey INT,
        odUnitPrice DECIMAL(10, 2),
        odCarrierTrackingNumber NVARCHAR(255),
        odSalesOrderLineNumber INT,
        odOrderDate DATETIME,
        odDueDate DATETIME,
        odShipDate DATETIME,
        odSaleKey INT, -- Adiciona a coluna odSaleKey
        FOREIGN KEY (odCustomerKey) REFERENCES Sales.Customer(ctCustomerKey),
        FOREIGN KEY (odProductKey) REFERENCES Factory.Product(prodProductKey),
        FOREIGN KEY (odSaleKey) REFERENCES Sales.Sale(salSaleKey) 
    );
END;


-- 1.10) «Tabela SaleCustomer»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SaleCustomer')
BEGIN
	CREATE TABLE Sales.SaleCustomer (
		scSalesKey INT FOREIGN KEY REFERENCES Sales.Sale(salSaleKey),
		scCustomerKey INT FOREIGN KEY REFERENCES Sales.Customer(ctCustomerKey),
		PRIMARY KEY (scSalesKey, scCustomerKey)
	);
END;
GO

-- 1.11) «Tabela ProductType»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductType')
BEGIN
	CREATE TABLE Factory.ProductType (
		ptProductTypeKey INT IDENTITY(1,1) PRIMARY KEY,
		ptProductKey INT,
		ptWeightUnitMeasureCode NVARCHAR(20),
		ptSizeUnitMeasureCode NVARCHAR(20),
		ptEnglishProductName NVARCHAR(60),
		ptSpanishProductName NVARCHAR(60),
		ptColor NVARCHAR(20),
		ptSize FLOAT,
		ptSizeRange NVARCHAR(20),
		ptWeight FLOAT,
		ptDaysToManufacture FLOAT,
		ptStyle NVARCHAR(20),
		ptModelName NVARCHAR(60),
		ptProductSubcategoryKey TINYINT,
		ptEnglishProductCategoryName NVARCHAR(60),
		ptSpanishProductCategoryName NVARCHAR(60),
		ptEnglishProductSubcategoryName NVARCHAR(60),
		ptSpanishProductSubcategoryName NVARCHAR(60),
		ptFrenchProductSubcategoryName NVARCHAR(60),
		CONSTRAINT FK_Product_ProductType FOREIGN KEY (ptProductKey) REFERENCES Factory.Product(prodProductKey)
	)ON AdventureWorks_Low_Update;
END;
GO

-- 1.12) «Tabela Login»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Login')
BEGIN
	CREATE TABLE Administrator.Login (
		lLoginID INT IDENTITY(1,1),
		lUserID INT PRIMARY KEY FOREIGN KEY REFERENCES Sales.CustomerInfo(ciCustomerKey),
		lUserName NVARCHAR(85) NOT NULL,
		lPasswordHash NVARCHAR(36) NOT NULL,
		lSecurityQuestion NVARCHAR(50), 
		lSecurityAnswer NVARCHAR(50)
	);
END;

-- 1.13) «Tabela sentEmail»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'sentEmail')
BEGIN
	CREATE TABLE Administrator.sentEmail (
		emEmailID INT IDENTITY(1,1) PRIMARY KEY,
		emUserID INT FOREIGN KEY REFERENCES Administrator.Login(lUserID),
		emDestinatario NVARCHAR(85),
		emMensagem NVARCHAR(255),
		emTimeStamp NVARCHAR(50),
	);
END;

-- 1.14) «Tabela LogError»
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'LogError')
BEGIN
	CREATE TABLE Administrator.LogError (
		logErrorID INT IDENTITY(1,1),
		logErrorMessage NVARCHAR(MAX),
		logErrorTimestamp NVARCHAR(40)
	);
END;





