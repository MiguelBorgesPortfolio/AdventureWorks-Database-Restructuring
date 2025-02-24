
DECLARE @Database NVARCHAR(255) = 'AdventureWorks'
DECLARE @FileGroup NVARCHAR(255) = 'AdventureWorks_Medium_Update' 
DECLARE @path NVARCHAR(255) = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Backups\AdventureWorks_Medium_Update\'
DECLARE @DateTimeBackup NVARCHAR(20) = REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 120), ':', '_')


DECLARE @weekDay INT = DATEPART(WEEKDAY, GETDATE())

DECLARE @firstSundayOfMonth BIT = CASE WHEN DATEPART(DAY, GETDATE()) <= 7 AND @weekDay = 1 THEN 1 ELSE 0 END


IF @firstSundayOfMonth = 1
BEGIN
    DECLARE @ArquiveFullBackup NVARCHAR(255) = @path + @Database + '_FullBackup_' + @DateTimeBackup + '.bak'

    BACKUP DATABASE @Database
    FILEGROUP = @FileGroup  
    TO DISK = @ArquiveFullBackup
    WITH
        INIT,
        NAME = @Database + ' Backup Completo',
        STATS = 10;

    PRINT 'Backup completo do filegroup ' + @FileGroup + ' do banco de dados ' + @Database + ' realizado com sucesso. Caminho do backup: ' + @ArquiveFullBackup;
END

IF @weekDay = 1 AND @firstSundayOfMonth = 0
BEGIN
    DECLARE @ArquiveDiffBackup NVARCHAR(255) = @path + @Database + '_Differencial_Backup_' + @DateTimeBackup + '.bak'

    BACKUP DATABASE @Database
    FILEGROUP = @FileGroup  
    TO DISK = @ArquiveDiffBackup
    WITH
        DIFFERENTIAL,
        INIT,
        NAME = @Database + ' Backup Diferencial',
        STATS = 10;

    PRINT 'Backup diferencial do filegroup ' + @FileGroup + ' da Base de Dados ' + @Database + ' realizado com sucesso. Caminho do backup: ' + @ArquiveDiffBackup;
END


IF @weekDay IN (3, 5, 7)
BEGIN
    DECLARE @ArquiveTLog NVARCHAR(255) = @path + @Database + '_Transaction_Log_' + @DateTimeBackup + '.trn'

    BACKUP LOG @Database
    TO DISK = @ArquiveTLog
    WITH
        INIT,
        NAME = @Database + ' Transaction Log',
        STATS = 10;

    PRINT 'Backup do log de transações do filegroup ' + @FileGroup + ' da Base de dados ' + @Database + ' realizado com sucesso. Caminho do backup: ' + @ArquiveTLog;
END

