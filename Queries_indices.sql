
/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Indices»
 *  	
 ********************************************/
--============================================================================= 
-- Etapa 1: « Pesquisa de vendas por cidade » 
--============================================================================= 

USE AdventureWorks

-- 1.1) «Criação da View»

CREATE VIEW  vw_SalesSearchByCity AS 
SELECT
    cCity,
    cStateProvinceCode,
    SUM(salSalesAmount) AS TotalSales
FROM
    Sales.City 
JOIN Sales.Customer ON cCityKey = ctCityKey
JOIN Sales.SaleCustomer ON ctCustomerKey = scCustomerKey
JOIN Sales.Sale ON scCustomerKey = salCustomerKey

GROUP BY
    cCity, cStateProvinceCode;

-- 1.2) «Antes dos Indices»


SELECT * FROM vw_SalesSearchByCity;

-- 1.3) «Drop dos Indices»

DROP INDEX IF EXISTS Sales.City.idx_cCity;
DROP INDEX IF EXISTS Sales.SaleCustomer.idx_scCustomerKey;
DROP INDEX IF EXISTS Sales.Sale.idx_salCustomerKey;

-- 1.4) «Indices»

Create NonClustered index idx_cCity ON Sales.City(cCity);
Create NonClustered index idx_scCustomerKey ON Sales.SaleCustomer(scCustomerKey);
Create NonClustered index idx_salCustomerKey ON Sales.Sale(salCustomerKey);


-- 1.5) «Depois dos Indices»

SELECT * FROM vw_SalesSearchByCity;

-- 1.6) «Demostração da escolha dos Indices através da seletividade»

-- 1.6.1) «Seletividade Tabela Sales.Sale»


Declare cur CURSOR FOR
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'Sale' AND TABLE_CATALOG = 'AdventureWorks';

DECLARE @column_name varchar(100)
DECLARE @sql varchar(MAX)

DROP TABLE IF EXISTS Result
CREATE TABLE Result (column_name varchar(100),seletividade decimal(5,2))
OPEN cur
FETCH NEXT FROM cur INTO @column_name 
WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @sql = ' INSERT INTO Result
			SELECT ''' + @column_name + ''', CAST(COUNT(DISTINCT '+@column_name +') as decimal)/(COUNT(*))
			FROM [Sales].[Sale] '
	EXEC (@sql)

	FETCH NEXT FROM cur INTO @column_name
END
CLOSE cur
DEALLOCATE cur


select * FROM Result order by seletividade desc

-- salCustomerKey tem 0.76 de seletividade logo é um bom candidato a indice

-- 1.6.2) «Seletividade Tabela Sales.City»

Declare cur CURSOR FOR
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'City' AND TABLE_CATALOG = 'AdventureWorks';

DECLARE @column_name varchar(100)
DECLARE @sql varchar(MAX)

DROP TABLE IF EXISTS Result
CREATE TABLE Result (column_name varchar(100),seletividade decimal(5,2))
OPEN cur
FETCH NEXT FROM cur INTO @column_name 
WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @sql = ' INSERT INTO Result
			SELECT ''' + @column_name + ''', CAST(COUNT(DISTINCT '+@column_name +') as decimal)/(COUNT(*))
			FROM [Sales].[City] '
	EXEC (@sql)

	FETCH NEXT FROM cur INTO @column_name
END
CLOSE cur
DEALLOCATE cur


select * FROM Result order by seletividade desc

-- cCity tem 0.94 de seletividade logo é um bom candidato a indice


-- 1.6.3) «Seletividade Tabela Sales.Customer»

Declare cur CURSOR FOR
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'SaleCustomer' AND TABLE_CATALOG = 'AdventureWorks';

DECLARE @column_name varchar(100)
DECLARE @sql varchar(MAX)

DROP TABLE IF EXISTS Result
CREATE TABLE Result (column_name varchar(100),seletividade decimal(5,2))
OPEN cur
FETCH NEXT FROM cur INTO @column_name 
WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @sql = ' INSERT INTO Result
			SELECT ''' + @column_name + ''', CAST(COUNT(DISTINCT '+@column_name +') as decimal)/(COUNT(*))
			FROM [Sales].[SaleCustomer] '
	EXEC (@sql)

	FETCH NEXT FROM cur INTO @column_name
END
CLOSE cur
DEALLOCATE cur


select * FROM Result order by seletividade desc

-- scCustomerKey tem 0.76 de seletividade logo é um bom candidato a indice




--============================================================================= 
-- Etapa 2: « Taxa de crescimento » 
--============================================================================= 

-- 2.1) «Criação da View»

CREATE VIEW vw_VendasTaxaCrescimento AS
SELECT
    V.Ano,
    V.Categoria,
    V.Vendas,
    VendasAnoAnterior.Vendas AS VendasAnoAnterior,
    (V.Vendas - VendasAnoAnterior.Vendas) / VendasAnoAnterior.Vendas AS TaxaCrescimento
FROM (
    SELECT
        YEAR(o.odDueDate) AS Ano,
        pt.ptEnglishProductCategoryName AS Categoria,
        SUM(s.salSalesAmount) AS Vendas
    FROM
        Sales.Sale AS s
    JOIN
        Sales.Orders AS o ON s.salSalesOrderNumber = o.odSalesOrderNumber
    JOIN
        Factory.Product AS p ON s.salProductKey = p.prodProductKey
    JOIN
        Factory.ProductType AS pt ON p.prodProductKey = pt.ptProductKey
    GROUP BY
        YEAR(o.odDueDate),
        pt.ptEnglishProductCategoryName
) AS V
JOIN (
    SELECT
        YEAR(o.odDueDate) AS AnoAnterior,
        pt.ptEnglishProductCategoryName AS Categoria,
        SUM(s.salSalesAmount) AS Vendas
    FROM
        Sales.Sale AS s
    JOIN
        Sales.Orders AS o ON s.salSalesOrderNumber = o.odSalesOrderNumber
    JOIN
        Factory.Product AS p ON s.salProductKey = p.prodProductKey
    JOIN
        Factory.ProductType AS pt ON p.prodProductKey = pt.ptProductKey
    GROUP BY
        YEAR(o.odDueDate),
        pt.ptEnglishProductCategoryName
) AS VendasAnoAnterior ON V.Ano = VendasAnoAnterior.AnoAnterior + 1 AND V.Categoria = VendasAnoAnterior.Categoria;

-- 2.2) «Antes dos Indices»

SELECT * FROM vw_VendasTaxaCrescimento;


-- 2.3) «Drop dos Indices»

DROP INDEX IF EXISTS Sales.Orders.idx_odSalesOrderNumber;
DROP INDEX IF EXISTS Factory.ProductType.idx_ptEnglishProductName;
DROP INDEX IF EXISTS Sales.Sale.idx_salSaleOrderNumber;
DROP INDEX IF EXISTS Factory.ProductType.idx_ptProductKey;

-- 2.4) «Indices»

Create NonClustered index idx_odSalesOrderNumber ON Sales.Orders(odSalesOrderNumber);
Create NonCLUSTERED index idx_ptEnglishProductName ON Factory.ProductType(ptEnglishProductCategoryName);
Create NonClustered index idx_salSaleOrderNumber ON Sales.Sale(salSalesOrderNumber);
Create NonClustered index idx_ptProductKey ON Factory.ProductType(ptProductKey);

-- 2.5) «Depois dos Indices»

SELECT * FROM vw_VendasTaxaCrescimento;

-- 2.6) «Demostração da escolha dos Indices através da seletividade»

-- 2.6.1) «Seletividade Tabela Factory.ProductType»


Declare cur CURSOR FOR
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'ProductType' AND TABLE_CATALOG = 'AdventureWorks';

DECLARE @column_name varchar(100)
DECLARE @sql varchar(MAX)

DROP TABLE IF EXISTS Result
CREATE TABLE Result (column_name varchar(100),seletividade decimal(5,2))
OPEN cur
FETCH NEXT FROM cur INTO @column_name 
WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @sql = ' INSERT INTO Result
			SELECT ''' + @column_name + ''', CAST(COUNT(DISTINCT '+@column_name +') as decimal)/(COUNT(*))
			FROM [Factory].[ProductType] '
	EXEC (@sql)

	FETCH NEXT FROM cur INTO @column_name
END
CLOSE cur
DEALLOCATE cur


select * FROM Result order by seletividade desc

-- ptProductType tem 1.00 de seletivade logo é um bom candidato a indice
-- ptEnglishProduct tem 0.74 de seletividade logo tambem é um bom candidato


-- 2.6.2) «Seletividade Tabela Sales.Orders»

Declare cur CURSOR FOR
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'Orders' AND TABLE_CATALOG = 'AdventureWorks';

DECLARE @column_name varchar(100)
DECLARE @sql varchar(MAX)

DROP TABLE IF EXISTS Result
CREATE TABLE Result (column_name varchar(100),seletividade decimal(5,2))
OPEN cur
FETCH NEXT FROM cur INTO @column_name 
WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @sql = ' INSERT INTO Result
			SELECT ''' + @column_name + ''', CAST(COUNT(DISTINCT '+@column_name +') as decimal)/(COUNT(*))
			FROM [Sales].[Orders] '
	EXEC (@sql)

	FETCH NEXT FROM cur INTO @column_name
END
CLOSE cur
DEALLOCATE cur


select * FROM Result order by seletividade desc

-- odSalesOrderNumber tem 0.87 de seletividade logo faz dele um bom candidato a indice


-- 2.6.3) «Seletividade Tabela Sales.Sale»


Declare cur CURSOR FOR
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'Sale' AND TABLE_CATALOG = 'AdventureWorks';

DECLARE @column_name varchar(100)
DECLARE @sql varchar(MAX)

DROP TABLE IF EXISTS Result
CREATE TABLE Result (column_name varchar(100),seletividade decimal(5,2))
OPEN cur
FETCH NEXT FROM cur INTO @column_name 
WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @sql = ' INSERT INTO Result
			SELECT ''' + @column_name + ''', CAST(COUNT(DISTINCT '+@column_name +') as decimal)/(COUNT(*))
			FROM [Sales].[Sale] '
	EXEC (@sql)

	FETCH NEXT FROM cur INTO @column_name
END
CLOSE cur
DEALLOCATE cur


select * FROM Result order by seletividade desc

-- salSalesOrderNumber tem 0.87 de seletividade logo é um bom candidato a indice



--============================================================================= 
-- Etapa 3: « Numero de vendas por cores » 
--============================================================================= 

-- 3.1) «Criação da View»

CREATE VIEW vw_VendasPorCor AS
SELECT
    pt.ptColor AS Color,
    COUNT(DISTINCT s.salProductKey) AS NumeroProdutos
FROM
    Sales.Sale AS s
JOIN
    Factory.Product AS p ON s.salProductKey = p.prodProductKey
JOIN
    Factory.ProductType AS pt ON p.prodProductKey = pt.ptProductKey
GROUP BY
    pt.ptColor;

-- 3.2) «Antes dos Indices»

SELECT * FROM vw_VendasPorCor order by NumeroProdutos;

-- 3.3) «Drop dos Indices»

DROP INDEX IF EXISTS Factory.ProductType.idx_ptProductKey;

-- 3.4) «Indices»

Create NonClustered index idx_ptProductKey  ON Factory.ProductType(ptProductKey);

-- 3.5) «Depois dos Indices»

SELECT * FROM vw_VendasPorCor order by NumeroProdutos;

-- 3.6) «Demostração da escolha dos Indices através da seletividade»

-- 3.6.1) «Seletividade Tabela Factory.ProductType»

Declare cur CURSOR FOR
		SELECT COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = 'ProductType' AND TABLE_CATALOG = 'AdventureWorks';

DECLARE @column_name varchar(100)
DECLARE @sql varchar(MAX)

DROP TABLE IF EXISTS Result
CREATE TABLE Result (column_name varchar(100),seletividade decimal(5,2))
OPEN cur
FETCH NEXT FROM cur INTO @column_name 
WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @sql = ' INSERT INTO Result
			SELECT ''' + @column_name + ''', CAST(COUNT(DISTINCT '+@column_name +') as decimal)/(COUNT(*))
			FROM [Factory].[ProductType] '
	EXEC (@sql)

	FETCH NEXT FROM cur INTO @column_name
END
CLOSE cur
DEALLOCATE cur


SELECT * FROM Result order by seletividade desc

-- ptProductType tem 1.00 de seletividade logo é um bom candidato a Indice