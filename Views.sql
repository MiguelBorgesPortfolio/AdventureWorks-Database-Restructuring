/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Views»
 *  	
 ********************************************/

USE AdventureWorks;
GO

--============================================================================= 
-- Etapa 1: «Drop views» 
--============================================================================= 

IF OBJECT_ID('vw_SalesTotalPerYear', 'V') IS NOT NULL
    DROP VIEW vw_TotalPerYear;
GO
IF OBJECT_ID('vw_NumberProductsPerTerritoyrYear', 'V') IS NOT NULL
    DROP VIEW vw_NumberProductsPerTerritoyrYear;
GO
IF OBJECT_ID('vw_SalesTotalPerCategoryPerYear', 'V') IS NOT NULL
    DROP VIEW vw_TotalPerCategoryPerYear;
GO
IF OBJECT_ID('vw_NumberProductsPerSubcategory', 'V') IS NOT NULL
    DROP VIEW vw_NumberProductsPerSubcategory;
GO
IF OBJECT_ID('vw_ClientBuy', 'V') IS NOT NULL
    DROP VIEW vw_ClientBuy;
GO

--============================================================================= 
-- Etapa 2: «Views» 
--============================================================================= 

-- 2.1) «Total de vendas por anos»
CREATE VIEW vw_SalesTotalPerYear
AS
SELECT
    YEAR(odOrderDate) AS 'Year',
    SUM(salSalesAmount) AS Total
FROM
    Sales.Sale
    JOIN Sales.Orders ON Sale.salSaleKey = Orders.odOrderKey
GROUP BY
    YEAR(odOrderDate);
GO

SELECT * FROM vw_SalesTotalPerYear ORDER BY Year ASC;

-- 2.2) «Total de vendas por Categoria e por ano»
CREATE VIEW vw_SalesTotalPerCategoryPerYear
AS
SELECT
    YEAR(o.odOrderDate) AS 'Year',
    pt.ptEnglishProductCategoryName AS Category,
    SUM(s.salSalesAmount) AS Total
FROM
    Sales.Sale s
    JOIN Sales.Orders o ON s.salSaleKey = o.odOrderKey
    JOIN Factory.Product p ON s.salProductKey = p.prodProductKey
    JOIN Factory.ProductType pt ON p.prodProductKey = pt.ptProductKey
GROUP BY
    YEAR(o.odOrderDate),
    pt.ptEnglishProductCategoryName;
GO

SELECT * FROM vw_SalesTotalPerCategoryPerYear ORDER BY Year, Category ASC;

-- 2.3) «Número de produtos por subcategoria»
CREATE VIEW vw_NumberProductsPerSubcategory
AS
SELECT
    pt.ptEnglishProductSubcategoryName AS Subcategory,
    COUNT(s.salProductKey) AS Number_Products
FROM
    Sales.Sale s
    JOIN Factory.Product p ON s.salSaleKey = p.prodProductKey
    JOIN Factory.ProductType pt ON p.prodProductKey = pt.ptProductKey
GROUP BY
    pt.ptEnglishProductSubcategoryName;
GO

SELECT * FROM vw_NumberProductsPerSubcategory ORDER BY Number_Products DESC;

-- 2.4) «Número de produtos por país e ano»
CREATE VIEW vw_NumberProductsPerTerritoyrYear
AS
SELECT
    YEAR(o.odOrderDate) AS 'Year',
    t.stSalesTerritoryCountry AS Country,
    COUNT(s.salProductKey) AS Number_Products
FROM
    Sales.Sale s
    JOIN Sales.Orders o ON s.salSaleKey = o.odOrderKey
    JOIN Sales.Territory t ON s.salSalesTerritoryKey = t.stSalesTerritoryKey
GROUP BY
    YEAR(o.odOrderDate),
    t.stSalesTerritoryCountry;
GO

SELECT * FROM vw_NumberProductsPerTerritoyrYear ORDER BY Year, Country ASC;

-- 2.5) «Sales por Cliente»
CREATE VIEW vw_ClientBuy AS
    SELECT
        ci.ciCustomerKey AS CustomerID,
        ci.cinfoFirstName + ' ' + ci.cinfoMiddleName + ' ' + ci.cinfoLastName AS Name_Customer,
        o.odOrderKey AS OrderID,
        o.odSalesOrderNumber AS NumberOrder,
        o.odOrderDate AS Date_Order,
        p.prodProductKey AS ProductID,
        pt.ptEnglishProductName AS Name_Product,
        o.odOrderQuantity AS Quantity,
        o.odUnitPrice AS Unit_Price,
        o.odSalesOrderLineNumber AS Number_Line_Number
    FROM
        Sales.Orders o
    JOIN
        Factory.Product p ON o.odProductKey = p.prodProductKey
    JOIN
        Factory.ProductType pt ON p.prodProductKey = pt.ptProductKey
    JOIN
        Sales.CustomerInfo ci ON o.odCustomerKey = ci.ciCustomerKey;
GO

SELECT * FROM vw_ClientBuy WHERE Name_Customer = 'Lisa  Cai';


