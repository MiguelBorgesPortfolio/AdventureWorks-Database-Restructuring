/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Selects»
 *  	
 ********************************************/

USE AdventureWorks;
GO

--============================================================================= 
-- Etapa 1: «Selects» 
--============================================================================= 

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
SELECT * FROM Administrator.Login ORDER BY lUserID;
SELECT * FROM Administrator.sentEmail ORDER BY emUserID ASC;
SELECT * FROM Administrator.LogError;

--============================================================================= 
-- Etapa 2: «Testes» 
--============================================================================= 

-- 2.1) «Descriptografia»
OPEN SYMMETRIC KEY MySymmetricKey DECRYPTION BY CERTIFICATE MyCertificate;
SELECT
    *,
    CONVERT(INT, DECRYPTBYKEY(lSecurityAnswer)) AS CampoDescriptografado
FROM 
    Administrator.Login;
CLOSE SYMMETRIC KEY MySymmetricKey;

-- 2.2) «Recuperar password»
DECLARE @Usuario NVARCHAR(100)
DECLARE @RespostaSeguranca NVARCHAR(255)
SET @Usuario = 'eugene10@adventure-works.com'
SET @RespostaSeguranca = '1'
EXEC sp_ChangePassword @UserName = @Usuario, @RespostaSeguranca = @RespostaSeguranca;

-- Verificação
SELECT emEmailID, emDestinatario, emMensagem, emTimeStamp FROM Administrator.sentEmail ORDER BY emEmailID DESC;


-- Antes da execução
SELECT * FROM Administrator.Login WHERE lUserID = 11005;

-- 2.3) «Editar acessos»
EXEC sp_EditCustomerInfoAndLogin
    @CustomerID = 11005,
    @NewUserName = 'miguel02@adventure-works.com';
GO

-- Verificação
SELECT * FROM Administrator.Login WHERE lUserID = 11005;
SELECT emEmailID, emDestinatario, emMensagem, emTimeStamp FROM Administrator.sentEmail ORDER BY emEmailID DESC;


-- 2.4) «Remover acessos»
EXEC sp_RemoveCustomerFromLogin @CustomerID = 11004;
GO

-- Verificação
SELECT * FROM Administrator.Login;
SELECT emEmailID, emDestinatario, emMensagem, emTimeStamp FROM Administrator.sentEmail ORDER BY emEmailID DESC;


-- 2.5) «Adicionar acessos»
EXEC sp_AddCustomerToLogin @CustomerID = 11004, @SecurityAnswer = '4';
GO

-- Verificação
SELECT * FROM Administrator.Login;
SELECT emEmailID, emDestinatario, emMensagem, emTimeStamp FROM Administrator.sentEmail ORDER BY emEmailID DESC;

--============================================================================= 
-- Etapa 3: «Tratamento de erros» 
--============================================================================= 

-- 3.1) «Tentando editar informações para um CustomerID que não existe»
EXEC sp_EditCustomerInfoAndLogin @CustomerID = 9999, @NewUserName = 'NovoUtilizador@gmail.com';

-- 3.2) «Tentando adicionar um CustomerID que já existe na tabela Login»
EXEC sp_AddCustomerToLogin @CustomerID = 11001, @SecurityAnswer = 'RespostaSegura';

-- 3.3) «Tentando remover um CustomerID que não existe na tabela Login»
EXEC sp_RemoveCustomerFromLogin @CustomerID = 9999;

-- 3.4) «Tentando mudar a senha para um UserName que não existe»
EXEC sp_ChangePassword @UserName = 'UsuarioInexistente', @RespostaSeguranca = '99';

SELECT * FROM Administrator.LogError;