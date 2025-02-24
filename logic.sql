/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Logic of database»
 *  	
 ********************************************/

USE AdventureWorks;
GO

--============================================================================= 
-- Etapa 1: «Master Key» 
--============================================================================= 

IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'MySymmetricKey')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AdventureWorks';
END;
GO

IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'MyCertificate')
BEGIN
    CREATE CERTIFICATE MyCertificate
    WITH SUBJECT = 'My Certificate Subject';
END;
GO

CREATE SYMMETRIC KEY MySymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE MyCertificate;
GO

--============================================================================= 
-- Etapa 2: «Create das Procedures» 
--============================================================================= 

-- 2.1) «Procedure para editar informações do cliente e login»
CREATE PROCEDURE sp_EditCustomerInfoAndLogin
    @CustomerID INT,
    @NewUserName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @OldUserName NVARCHAR(100);

        -- Retrieve the old username
        SELECT @OldUserName = lUserName
        FROM Administrator.Login
        WHERE lUserID = @CustomerID;

        IF @@ROWCOUNT > 0
        BEGIN
            -- Update only the username
            UPDATE Administrator.Login
            SET lUserName = @NewUserName
            WHERE lUserID = @CustomerID;

            UPDATE Sales.CustomerInfo
            SET cinfoEmailAddress = @NewUserName
            WHERE ciCustomerKey = @CustomerID;

            -- Adicionar mensagem à tabela sentEmail
            INSERT INTO Administrator.sentEmail (emDestinatario, emMensagem, emTimeStamp)
            VALUES (@NewUserName, 'As suas informações foram atualizadas com sucesso.', GETDATE());

            PRINT 'Customer information updated successfully.';
        END
        ELSE
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(255);
            SET @ErrorMessage = CONCAT('Customer ', CAST(@CustomerID AS NVARCHAR(10)), ' not found in Login table.');

            THROW 50000, @ErrorMessage, 1;
        END
    END TRY
    BEGIN CATCH
        INSERT INTO Administrator.LogError (logErrorMessage, logErrorTimestamp)
        VALUES (ERROR_MESSAGE(), CONVERT(NVARCHAR(255), GETDATE()));

        THROW;
    END CATCH
END;
GO

-- 2.2) «Procedure para adicionar um cliente ao Login»
CREATE PROCEDURE sp_AddCustomerToLogin
    @CustomerID INT,
    @SecurityAnswer NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(255);

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Sales.Customer WHERE ctCustomerKey = @CustomerID)
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM Administrator.Login WHERE lUserID = @CustomerID)
            BEGIN
                DECLARE @DefaultUserName NVARCHAR(100);
                SET @DefaultUserName = (
                    SELECT TOP 1 ci.cinfoEmailAddress
                    FROM Sales.CustomerInfo ci
                    WHERE ci.ciCustomerKey = @CustomerID
                );

                DECLARE @DefaultPasswordHash NVARCHAR(50);
                SET @DefaultPasswordHash = CONVERT(NVARCHAR(36), NEWID());

                INSERT INTO Administrator.Login (lUserID, lUserName, lPasswordHash, lSecurityQuestion, lSecurityAnswer)
                VALUES (@CustomerID, @DefaultUserName, @DefaultPasswordHash, 'How many cars do you have?', @SecurityAnswer);

                -- Enviar email de boas-vindas
                INSERT INTO Administrator.sentEmail (emDestinatario, emMensagem, emTimeStamp)
                VALUES (@DefaultUserName, 'Bem-vindo ao sistema! Seu nome de Utilizador é: ' + @DefaultUserName, GETDATE());

                PRINT 'Customer added to Login table successfully.';
            END
            ELSE
            BEGIN
                SET @ErrorMessage = CONCAT('Customer ', CAST(@CustomerID AS NVARCHAR(10)), ' already exists in Login table.');
                THROW 50000, @ErrorMessage, 1;
            END
        END
        ELSE
        BEGIN
            SET @ErrorMessage = CONCAT('Customer ', CAST(@CustomerID AS NVARCHAR(10)), ' does not exist in Customer table.');
            THROW 50000, @ErrorMessage, 1;
        END
    END TRY
    BEGIN CATCH
        INSERT INTO Administrator.LogError (logErrorMessage, logErrorTimestamp)
        VALUES (ERROR_MESSAGE(), CONVERT(NVARCHAR(255), GETDATE()));

        THROW;
    END CATCH
END;
GO

-- 2.3) «Procedure para remover um cliente já existente na tabela Login»
CREATE PROCEDURE sp_RemoveCustomerFromLogin
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Administrator.Login WHERE lUserID = @CustomerID)
        BEGIN
            DELETE FROM Administrator.Login WHERE lUserID = @CustomerID;

            DECLARE @UserName NVARCHAR(100);
            SET @UserName = (
                SELECT TOP 1 ci.cinfoEmailAddress
                FROM Sales.CustomerInfo ci
                WHERE ci.ciCustomerKey = @CustomerID
            );

            INSERT INTO Administrator.sentEmail (emDestinatario, emMensagem, emTimeStamp)
            VALUES (@UserName, 'Seu utilizador foi removido.', GETDATE());

            PRINT 'Customer removed from Login table successfully.';
        END
        ELSE
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(255);
            SET @ErrorMessage = CONCAT('Customer ', CAST(@CustomerID AS NVARCHAR(10)), ' not found in Login table.');

            THROW 50000, @ErrorMessage, 1;
        END
    END TRY
    BEGIN CATCH
        INSERT INTO Administrator.LogError (logErrorMessage, logErrorTimestamp)
        VALUES (ERROR_MESSAGE(), CONVERT(NVARCHAR(255), GETDATE()));

        THROW;
    END CATCH
END;
GO

-- 2.4) «Procedure para mudar a password do Cliente e mandar um email»
CREATE PROCEDURE sp_ChangePassword
    @UserName NVARCHAR(100),
    @RespostaSeguranca NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Senha NVARCHAR(36), @ErrorMessage NVARCHAR(255)

    IF EXISTS (
        SELECT 1
        FROM Administrator.Login
        WHERE lUserName = @UserName
    )
    BEGIN
        -- Descriptografar lSecurityAnswer para comparar com a resposta fornecida
        DECLARE @DecryptedAnswer INT;
        OPEN SYMMETRIC KEY MySymmetricKey DECRYPTION BY CERTIFICATE MyCertificate;

        SELECT @DecryptedAnswer = CONVERT(INT, DECRYPTBYKEY(lSecurityAnswer))
        FROM Administrator.Login
        WHERE lUserName = @UserName;

        CLOSE SYMMETRIC KEY MySymmetricKey;

        -- Comparar a resposta de segurança
        IF @DecryptedAnswer = @RespostaSeguranca
        BEGIN
            -- Gerar nova senha
            SET @Senha = CONVERT(NVARCHAR(36), NEWID());

            -- Atualizar a senha na tabela Login
            UPDATE Administrator.Login
            SET lPasswordHash = @Senha
            WHERE lUserName = @UserName;

            -- Enviar email com a nova senha
            INSERT INTO Administrator.sentEmail (emDestinatario, emMensagem, emTimeStamp)
            VALUES (@UserName, 'Sua nova senha é: ' + @Senha, GETDATE());

            PRINT 'Senha recuperada com sucesso. Verifique seu e-mail para a nova senha.';
        END
        ELSE
        BEGIN
            SET @ErrorMessage = 'Resposta de segurança incorreta. A recuperação de senha falhou.';

            -- Adicionar log de erro
            INSERT INTO Administrator.LogError (logErrorMessage, logErrorTimestamp)
            VALUES (@ErrorMessage, CONVERT(NVARCHAR(255), GETDATE()));

            THROW 50000, @ErrorMessage, 1;
        END
    END
    ELSE
    BEGIN
        SET @ErrorMessage = 'Utilizador não encontrado.';

        -- Adicionar log de erro
        INSERT INTO Administrator.LogError (logErrorMessage, logErrorTimestamp)
        VALUES (@ErrorMessage, CONVERT(NVARCHAR(255), GETDATE()));

        THROW 50000, @ErrorMessage, 1;
    END
END;
GO

--============================================================================= 
-- Etapa 3: «Create dos Triggers» 
--============================================================================= 

-- 3.1) «Trigger para inserir cada Cliente na tabela Login»
CREATE TRIGGER trg_AfterInsertCustomer
ON Sales.Customer
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorMessage NVARCHAR(255);

    BEGIN TRY
        OPEN SYMMETRIC KEY MySymmetricKey
        DECRYPTION BY CERTIFICATE MyCertificate;

        INSERT INTO Administrator.Login (lUserID, lUserName, lPasswordHash, lSecurityQuestion, lSecurityAnswer)
        SELECT
            cinfo.ciCustomerKey,
            cinfo.cinfoEmailAddress,
            CONVERT(NVARCHAR(36), NEWID()),
            'How many cars do you have?',
            ENCRYPTBYKEY(KEY_GUID('MySymmetricKey'), CONVERT(VARBINARY(MAX), cinfo.cinfoNumberCarsOwned))
        FROM inserted AS ci
        JOIN Sales.CustomerInfo cinfo ON ci.ctCustomerKey = cinfo.ciCustomerKey;

        CLOSE SYMMETRIC KEY MySymmetricKey;

        -- Enviar e-mail de boas-vindas
        INSERT INTO Administrator.sentEmail (emDestinatario, emMensagem, emTimeStamp)
        SELECT
            cinfo.cinfoEmailAddress,
            'Bem-vindo ao sistema! Seu nome é: ' + cinfo.cinfoEmailAddress,
            GETDATE()
        FROM inserted AS ci
        JOIN Sales.CustomerInfo cinfo ON ci.ctCustomerKey = cinfo.ciCustomerKey;

    END TRY
    BEGIN CATCH
        INSERT INTO Administrator.LogError (logErrorMessage, logErrorTimestamp)
        VALUES (ERROR_MESSAGE(), CONVERT(NVARCHAR(255), GETDATE()));

        THROW;
    END CATCH
END;
GO