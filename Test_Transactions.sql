
/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Testes das Transações»
 *  	
 ********************************************/

 --============================================================================= 
-- Teste 1: «Teste AddProductToOrder» 
--=============================================================================


Select * from Sales.Orders where odProductKey=211


 --============================================================================= 
-- Teste 2: «Teste UpdatePrice» 
--=============================================================================

Select * from Factory.Product

EXEC UpdateProductPrice @prodProductKey = 210, @newListPrice = 43.99;

 --============================================================================= 
-- Teste 3: «Teste UpdatePrice» 
--=============================================================================

EXEC AddProductToOrder
    @odSalesOrderNumber = 'SO123',
    @odOrderQuantity = 3,
    @odProductKey = 210,
    @odUnitPrice = 19.99,
    @odCarrierTrackingNumber = 'ABC123',
    @odSalesOrderLineNumber = 1,
    @odOrderDate = '2024-01-20 10:00:00',
    @odDueDate = '2024-01-25 10:00:00',
    @odShipDate = '2024-01-27 10:00:00';
Go

 --============================================================================= 
-- Teste 4: «Teste update CustomerInfo» 
--=============================================================================


SELECT *FROM Sales.CustomerInfo where ciCustomerKey = 11000;


 --============================================================================= 
-- Teste 5: «Teste update stock» 
--=============================================================================
-
SELECT prodProductKey, prodSafetyStockLevel FROM Factory.Product WHERE prodProductKey = 210;
