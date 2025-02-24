
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


USE AdventureWorks;

IF OBJECT_ID('dbo.NonNullDataLength', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.NonNullDataLength;
END;
GO
CREATE FUNCTION dbo.NonNullDataLength(@value SQL_VARIANT) RETURNS INT
AS
BEGIN
    RETURN CASE WHEN @value IS NOT NULL THEN DATALENGTH(@value) ELSE 0 END;
END;
GO

-- Espaço ocupado por registo de cada tabela; 
-- Sales.Territory
SELECT
    'Sales.Territory' AS TableName,
    AVG(DATALENGTH(stSalesTerritoryKey) + DATALENGTH(stSalesTerritoryRegion) + DATALENGTH(stSalesTerritoryCountry) + DATALENGTH(stSalesTerritoryGroup)) AS AvgSpacePerRecord
FROM Sales.Territory;

-- Sales.CustomerInfo
SELECT
    'Sales.CustomerInfo' AS TableName,
    AVG(DATALENGTH(ciCustomerKey) + DATALENGTH(cinfoTitle) + DATALENGTH(cinfoFirstName) + DATALENGTH(cinfoMiddleName) + DATALENGTH(cinfoLastName) + DATALENGTH(cinfoBirthDate) + DATALENGTH(cinfoMaritalStatus) + DATALENGTH(cinfoGender) + DATALENGTH(cinfoEmailAddress) + DATALENGTH(cinfoYearlyIncome) + DATALENGTH(cinfoTotalChildren) + DATALENGTH(cinfoNumberChildrenAtHome) + DATALENGTH(cinfoEducation) + DATALENGTH(cinfoOccupation) + DATALENGTH(cinfoPhone) + DATALENGTH(cinfoHouseOwnerFlag) + DATALENGTH(cinfoNumberCarsOwned)) AS AvgSpacePerRecord
FROM Sales.CustomerInfo;

-- Sales.City
SELECT
    'Sales.City' AS TableName,
    AVG(DATALENGTH(cCity) + DATALENGTH(cCountryRegionCode) + DATALENGTH(cCountryRegionName) + DATALENGTH(cStateProvinceCode) + DATALENGTH(cStateProvinceName)) AS AvgSpacePerRecord
FROM Sales.City;


-- Sales.Currency
SELECT
    'Sales.Currency' AS TableName,
    AVG(DATALENGTH(curCurrencyKey) + DATALENGTH(curCurrencyAcronymKey) + DATALENGTH(curCurrencyName)) AS AvgSpacePerRecord
FROM Sales.Currency;

-- Sales.Promotion
SELECT
    'Sales.Promotion' AS TableName,
    AVG(DATALENGTH(proPromotionKey) + DATALENGTH(proUnitPriceDiscountPct) + DATALENGTH(proDiscountAmount)) AS AvgSpacePerRecord
FROM Sales.Promotion;

-- Sales.Sale
SELECT
    'Sales.Sale' AS TableName,
    AVG(DATALENGTH(salSaleKey) + DATALENGTH(salProductKey) + DATALENGTH(salCustomerKey) + DATALENGTH(salPromotionKey) + DATALENGTH(salCurrencyKey) + DATALENGTH(salSalesTerritoryKey) + DATALENGTH(salSalesOrderNumber) + DATALENGTH(salRevisionNumber) + DATALENGTH(salExtendedAmount) + DATALENGTH(salProductStandardCost) + DATALENGTH(salTotalProductCost) + DATALENGTH(salSalesAmount) + DATALENGTH(salTaxAmt) + DATALENGTH(salFreight)) AS AvgSpacePerRecord
FROM Sales.Sale;


-- Sales.SaleCustomer
SELECT
    'Sales.SaleCustomer' AS TableName,
    AVG(DATALENGTH(scSalesKey) + DATALENGTH(scCustomerKey)) AS AvgSpacePerRecord
FROM Sales.SaleCustomer;

-- Factory.ProductType
SELECT
    'Factory.ProductType' AS TableName,
    AVG(DATALENGTH(ptProductTypeKey) + DATALENGTH(ptProductKey) + DATALENGTH(ptWeightUnitMeasureCode) + DATALENGTH(ptSizeUnitMeasureCode) + DATALENGTH(ptEnglishProductName) + DATALENGTH(ptSpanishProductName) + DATALENGTH(ptColor) + DATALENGTH(ptSize) + DATALENGTH(ptSizeRange) + DATALENGTH(ptWeight) + DATALENGTH(ptDaysToManufacture) + DATALENGTH(ptStyle) + DATALENGTH(ptModelName) + DATALENGTH(ptProductSubcategoryKey) + DATALENGTH(ptEnglishProductCategoryName) + DATALENGTH(ptSpanishProductCategoryName) + DATALENGTH(ptEnglishProductSubcategoryName) + DATALENGTH(ptSpanishProductSubcategoryName) + DATALENGTH(ptFrenchProductSubcategoryName)) AS AvgSpacePerRecord
FROM Factory.ProductType;
;
-- Sales.Customer
SELECT
    'Sales.Customer' AS TableName,
    AVG(dbo.NonNullDataLength(ctCustomerKey) + dbo.NonNullDataLength(ctNameStyle) + dbo.NonNullDataLength(ctSalesTerritoryKey) + dbo.NonNullDataLength(ctDateFirstPurchase) + dbo.NonNullDataLength(ctCommuteDistance) + dbo.NonNullDataLength(ctAddressLine1) + dbo.NonNullDataLength(ctAddressLine2) + dbo.NonNullDataLength(ctCityKey) + dbo.NonNullDataLength(ctPostalCode)) AS AvgSpacePerRecord
FROM Sales.Customer;

-- Sales.Orders
SELECT
    'Sales.Orders' AS TableName,
    AVG(dbo.NonNullDataLength(odOrderKey) + dbo.NonNullDataLength(odSalesOrderNumber) + dbo.NonNullDataLength(odOrderQuantity) + dbo.NonNullDataLength(odCustomerKey) + dbo.NonNullDataLength(odProductKey) + dbo.NonNullDataLength(odUnitPrice) + dbo.NonNullDataLength(odCarrierTrackingNumber) + dbo.NonNullDataLength(odSalesOrderLineNumber) + dbo.NonNullDataLength(odOrderDate) + dbo.NonNullDataLength(odDueDate) + dbo.NonNullDataLength(odShipDate)) AS AvgSpacePerRecord
FROM Sales.Orders;

-- Factory.Product
SELECT
    'Factory.Product' AS TableName,
    AVG(dbo.NonNullDataLength(prodProductKey) + dbo.NonNullDataLength(prodStandardCost) + dbo.NonNullDataLength(prodFinishedGoodsFlag) + dbo.NonNullDataLength(prodSafetyStockLevel) + dbo.NonNullDataLength(prodListPrice) + dbo.NonNullDataLength(prodProductLine) + dbo.NonNullDataLength(prodDealerPrice) + dbo.NonNullDataLength(prodClass) + dbo.NonNullDataLength(prodOrderKey) + dbo.NonNullDataLength(prodEnglishDescription) + dbo.NonNullDataLength(prodStatus)) AS AvgSpacePerRecord
FROM Factory.Product;

