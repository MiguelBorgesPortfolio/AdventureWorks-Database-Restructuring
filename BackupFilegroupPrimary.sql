/********************************************
 *	UC: Complementos de Bases de Dados 2023/2024
 *
 *	Turma: 2ºL_EI-SW-03
 *		Miguel Borges (202200252)
 *		Miguel Pinto (202200964)
 *	
 *  «Backup filegroup Primary»
 *  	
 ********************************************/


DECLARE @DataBase NVARCHAR(255) = 'AdventureWorks'
DECLARE @FileGroup NVARCHAR(255) = 'Primary' 
DECLARE @path NVARCHAR(255) = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Backups\Primary\' 

-- Construa os nomes dos arquivos de backup
DECLARE @FullBackupArquive NVARCHAR(255) = @path + @DataBase + '_Backup_Completo_' + @FileGroup + '.bak'
DECLARE @DifferencialBackupArquive NVARCHAR(255) = @path + @DataBase + '_Backup_Diferencial_' + @FileGroup + '.bak'
DECLARE @TLogsArquive NVARCHAR(255) = @path + @DataBase + '_Backup_Log_' + @FileGroup + '.trn'

-- Comando de Backup Completo
BACKUP DATABASE @DataBase
FILEGROUP = @FileGroup
TO DISK = @FullBackupArquive
WITH INIT;

PRINT 'Backup completo do filegroup ' + @FileGroup + ' da Base de dados ' + @DataBase + ' realizado com sucesso. Caminho do backup: ' + @FullBackupArquive;

-- Comando de Backup Diferencial
BACKUP DATABASE @DataBase
FILEGROUP = @FileGroup
TO DISK = @DifferencialBackupArquive
WITH DIFFERENTIAL, INIT;

PRINT 'Backup diferencial do filegroup ' + @FileGroup + ' de base dados ' + @DataBase + ' realizado com sucesso. Caminho do backup: ' + @DifferencialBackupArquive;

-- Comando de Backup de Log
BACKUP LOG @DataBase
TO DISK = @TLogsArquive
WITH INIT;

PRINT 'Backup de log do filegroup ' + @FileGroup + ' de base dados ' + @DataBase + ' realizado com sucesso. Caminho do backup: ' + @TLogsArquive;






--Restore
use master
DECLARE @Database NVARCHAR(255) = 'AdventureWorks'
DECLARE @pathTail NVARCHAR(255) = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Backups\Primary\tailLog\' 
DECLARE @LastFullBackup NVARCHAR(255) 
DECLARE @LastDifferencial NVARCHAR(255) 
DECLARE @LastTransactionLog NVARCHAR(255) 
DECLARE @TailLogPath NVARCHAR(255)

SET @TailLogPath = @pathTail + @Database + '_Tail_Log.bak'
BACKUP LOG @Database TO DISK = @TailLogPath WITH INIT;

SET @LastFullBackup = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Backups\Primary\AdventureWorks_Backup_Completo_Primary.bak'
SET @LastDifferencial = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Backups\Primary\AdventureWorks_Backup_Diferencial_Primary.bak'
SET @LastTransactionLog = '"C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Backups\Primary\AdventureWorks_Backup_Log_Primary.trn"'


RESTORE DATABASE @Database
FROM DISK = @LastFullBackup
WITH
    NORECOVERY, 
    REPLACE,    
    STATS = 10;

-- Restauração do Último Backup Diferencial
RESTORE DATABASE @Database
FROM DISK = @LastDifferencial
WITH
    NORECOVERY, 
    STATS = 10;

-- Restauração dos Backups de Log
RESTORE LOG @Database
FROM DISK = @LastTransactionLog
WITH
    NORECOVERY, 
    STATS = 10;



RESTORE LOG @Database
FROM DISK = @TailLogPath
WITH
    FILE = 1,  -- Número do arquivo de backup de log
    NORECOVERY;


RESTORE DATABASE @Database
WITH RECOVERY;

PRINT 'Recuperação da Base de Dados ' + @Database + ' concluída com sucesso.';
