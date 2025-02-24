/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Transações»
 *  	
 ********************************************/



Use AdventureWorks

--============================================================================= 
-- Etapa 1: «Procedures para adicionar produto á order» 
--=============================================================================

-- 1.1) «Criação da Procedure»

Drop  procedure if exists AddProductToOrder;
GO

CREATE PROCEDURE AddProductToOrder
    @odSalesOrderNumber NVARCHAR(255),
    @odOrderQuantity INT,
    @odProductKey INT,
    @odUnitPrice DECIMAL(10, 2),
    @odCarrierTrackingNumber NVARCHAR(255),
    @odSalesOrderLineNumber INT,
    @odOrderDate DATETIME,
    @odDueDate DATETIME,
    @odShipDate DATETIME
AS
BEGIN
   
    DECLARE @generatedSaleID INT;

    BEGIN TRANSACTION;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

    IF EXISTS (
        SELECT 1
        FROM Sales.Sale
        WHERE salSalesOrderNumber = @odSalesOrderNumber
          AND salProductKey = @odProductKey
    )
    BEGIN
     
        UPDATE Sales.Sale
        SET
            salSalesAmount = salSalesAmount + (@odOrderQuantity * @odUnitPrice)
        WHERE
            salSalesOrderNumber = @odSalesOrderNumber
            AND salProductKey = @odProductKey;

        SET @generatedSaleID = (SELECT salSaleKey FROM Sales.Sale WHERE salSalesOrderNumber = @odSalesOrderNumber AND salProductKey = @odProductKey);
    END
    ELSE
    BEGIN

        INSERT INTO Sales.Sale (
            salProductKey,
            salSalesOrderNumber,
            salSalesAmount,
            salTaxAmt,
            salFreight
            
        )
        VALUES (
            @odProductKey,
            @odSalesOrderNumber,
            @odOrderQuantity * @odUnitPrice,
            0,
            0
        );
        SET @generatedSaleID = SCOPE_IDENTITY();
    END;

    IF EXISTS (
        SELECT 1
        FROM Sales.Orders
        WHERE odSalesOrderNumber = @odSalesOrderNumber
          AND odProductKey = @odProductKey
          AND odSaleKey = @generatedSaleID
    )
    BEGIN
        UPDATE Sales.Orders
        SET
            odOrderQuantity = odOrderQuantity + @odOrderQuantity
        WHERE
            odSalesOrderNumber = @odSalesOrderNumber
            AND odProductKey = @odProductKey
            AND odSaleKey = @generatedSaleID;
    END
    ELSE
    BEGIN

        INSERT INTO Sales.Orders (
            odSalesOrderNumber,
            odOrderQuantity,
            odProductKey,
            odUnitPrice,
            odCarrierTrackingNumber,
            odSalesOrderLineNumber,
            odOrderDate,
            odDueDate,
            odShipDate,
            odSaleKey
        )
        VALUES (
            @odSalesOrderNumber,
            @odOrderQuantity,
            @odProductKey,
            @odUnitPrice,
            @odCarrierTrackingNumber,
            @odSalesOrderLineNumber,
            @odOrderDate,
            @odDueDate,
            @odShipDate,
            @generatedSaleID 
        );
    END;
	WAITFOR DELAY '00:00:10';
    COMMIT TRANSACTION;
END;


-- 1.2) «Execução da Procedure» / Executar juntamente com Teste 1

EXEC AddProductToOrder
    @odSalesOrderNumber = 'SO123',
    @odOrderQuantity = 3,
    @odProductKey = 211,
    @odUnitPrice = 19.99,
    @odCarrierTrackingNumber = 'ABC123',
    @odSalesOrderLineNumber = 1,
    @odOrderDate = '2024-01-20 10:00:00',
    @odDueDate = '2024-01-25 10:00:00',
    @odShipDate = '2024-01-27 10:00:00';

	Go

-- 1.3) «Verificar alteração»

Select * from Sales.orders where odProductKey=210




--============================================================================= 
-- Etapa 2: «Procedures UpdateProductPrice» 
--=============================================================================


Drop  procedure if exists UpdateProductPrice;
GO
-- 2.1) «Criação da Procedure»

CREATE PROCEDURE UpdateProductPrice
    @prodProductKey INT,
    @newListPrice FLOAT
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION;

    IF NOT EXISTS (
        SELECT 1
        FROM Sales.Sale s
        INNER JOIN Sales.Orders o ON s.salSaleKey = o.odSaleKey
        WHERE o.odProductKey = @prodProductKey
    )
    BEGIN
        UPDATE Factory.Product
        SET
            prodListPrice = @newListPrice
        WHERE
            prodProductKey = @prodProductKey;
			WAITFOR DELAY '00:00:10';
        COMMIT TRANSACTION;

        PRINT 'Preço do produto atualizado com sucesso.';
    END
    ELSE
    BEGIN

        ROLLBACK TRANSACTION;

        PRINT 'Não é possível atualizar o preço. Existem vendas pendentes para o produto.';
    END; 
END;

-- 2.2) «Execução da procedure/ Teste para verificar se a venda esta por finalizar » / Executar juntamente com Teste 2

EXEC UpdateProductPrice @prodProductKey = 211, @newListPrice = 12.99;

-- Adicionar produto á order
EXEC AddProductToOrder
    @odSalesOrderNumber = 'SO123',
    @odOrderQuantity = 3,
    @odProductKey = 211,
    @odUnitPrice = 19.99,
    @odCarrierTrackingNumber = 'ABC123',
    @odSalesOrderLineNumber = 1,
    @odOrderDate = '2024-01-20 10:00:00',
    @odDueDate = '2024-01-25 10:00:00',
    @odShipDate = '2024-01-27 10:00:00';

	Go




--============================================================================= 
-- Etapa 3: «Procedures para calcular o total de vendas» 
--=============================================================================

-- 3.1) «Criação da Procedure»

Drop procedure if exists CalculateTotalSales

CREATE PROCEDURE CalculateTotalSales
    @processStartDate DATETIME
AS
BEGIN
    
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION;


    DECLARE @totalSales DECIMAL(10, 2);

    SELECT
        @totalSales = ISNULL(SUM(salSalesAmount), 0)
    FROM
        Sales.Sale s
    INNER JOIN
        Sales.Orders o ON s.salSalesOrderNumber = o.odSalesOrderNumber
    WHERE
        YEAR(o.odDueDate) = YEAR(GETDATE());

    PRINT 'Total de Vendas no Ano Corrente até ' + CONVERT(NVARCHAR, @processStartDate, 120) + ': ' + CONVERT(NVARCHAR, @totalSales);
	WAITFOR DELAY '00:00:10';
    COMMIT TRANSACTION;

    SELECT @totalSales AS TotalSales;
END;




DECLARE @processStartDate DATETIME = '2024-01-01';

-- 3.2) «Execução da procedure/ Teste para verificar se a venda esta por finalizar » / Executar juntamente com Teste 2
EXEC CalculateTotalSales @processStartDate;

-- addProductToOrder
EXEC AddProductToOrder
    @odSalesOrderNumber = 'SO123',
    @odOrderQuantity = 3,
    @odProductKey = 211,
    @odUnitPrice = 19.99,
    @odCarrierTrackingNumber = 'ABC123',
    @odSalesOrderLineNumber = 1,
    @odOrderDate = '2024-01-20 10:00:00',
    @odDueDate = '2024-01-25 10:00:00',
    @odShipDate = '2024-01-27 10:00:00';
	Go

	--============================================================================= 
-- Etapa 4: «Procedures para UpdateCustomerInfo» 
--=============================================================================
-- 4.1) «Criação da Procedure»
	DROP  PROCEDURE IF EXISTS  UpdateCustomerInfo;

CREATE PROCEDURE UpdateCustomerInfo
    @customerKey INT,
    @newEmailAddress NVARCHAR(85)
AS
BEGIN
    
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION;
    IF EXISTS (SELECT 1 FROM Sales.Customer WHERE ctCustomerKey = @customerKey)
    BEGIN
      
        UPDATE Sales.CustomerInfo
        SET cinfoEmailAddress = @newEmailAddress
        WHERE ciCustomerKey = @customerKey;

        
        COMMIT TRANSACTION;

        PRINT 'Dados do cliente atualizados com sucesso.';
    END
    ELSE
    BEGIN
        
        ROLLBACK TRANSACTION;
        PRINT 'Cliente não encontrado.';
    END;
END;


--4.2) «Execução da procedure/ Teste para verificar se a venda esta por finalizar » / Executar juntamente com Teste 4

BEGIN TRANSACTION;
EXEC UpdateCustomerInfo @customerKey = 11000, @newEmailAddress = 'CBD@ips.com';
WAITFOR DELAY '00:00:10';
COMMIT TRANSACTION;


--============================================================================= 
-- Etapa 5: «Procedures para atualizar o stock» 
--=============================================================================

-- 5.1) «Criação da Procedure»

DROP PROCEDURE IF EXISTS UpdateProductStockLevel;

CREATE PROCEDURE UpdateProductStockLevel
    @productKey INT,
    @newStockLevel FLOAT
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    BEGIN TRANSACTION;

    UPDATE Factory.Product
    SET prodSafetyStockLevel = @newStockLevel
    WHERE prodProductKey = @productKey;

    COMMIT TRANSACTION;

    PRINT 'Nível de estoque do produto atualizado com sucesso.';
END;

--5.2) «Execução da procedure/ Teste para verificar se a venda esta por finalizar » / Executar juntamente com Teste 5

BEGIN TRAN
EXEC UpdateProductStockLevel @productKey = 210, @newStockLevel = 50;
WAITFOR DELAY '00:00:10'; 
COMMIT TRAN;


SELECT * FROM  Factory.Product































