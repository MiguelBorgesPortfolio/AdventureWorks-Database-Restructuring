
DECLARE @DataBase NVARCHAR(255) = 'AdventureWorks'
DECLARE @FileGroup NVARCHAR(255) = 'AdventureWorks_Low_Update' 
DECLARE @path NVARCHAR(255) = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Backups\AdventureWorks_Low_Update\' 

DECLARE @DateTimeBackup NVARCHAR(20) = REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 120), ':', '_')


DECLARE @WeekDay INT = DATEPART(WEEKDAY, GETDATE())

DECLARE @MesAtual INT = MONTH(GETDATE())


DECLARE @firstSundayOfMonth BIT = CASE WHEN DATEPART(DAY, GETDATE()) <= 7 AND @WeekDay = 1 THEN 1 ELSE 0 END


IF @MesAtual IN (3, 9) AND @firstSundayOfMonth = 1
BEGIN
    DECLARE @ArquiveFullBackup NVARCHAR(255) = @path + @DataBase + '_FullBackup_' + @DateTimeBackup + '.bak'

    BACKUP DATABASE @DataBase
    FILEGROUP = @FileGroup  
    TO DISK = @ArquiveFullBackup
    WITH
        INIT,
        NAME = @DataBase + ' Backup Completo',
        STATS = 10;

    PRINT 'Backup completo do filegroup ' + @FileGroup + ' da base de dados ' + @DataBase + ' realizado com sucesso. Caminho do backup: ' + @ArquiveFullBackup;
END

IF @firstSundayOfMonth = 1 AND @MesAtual NOT IN (3, 9)
BEGIN
    DECLARE @ArquiveDiffBackup NVARCHAR(255) = @path + @DataBase + '_Differencial_Backup_' + @DateTimeBackup + '.bak'

    BACKUP DATABASE @DataBase
    FILEGROUP = @FileGroup  
    TO DISK = @ArquiveDiffBackup
    WITH
        DIFFERENTIAL,
        INIT,
        NAME = @DataBase + ' Differencial Backup ',
        STATS = 10;

    PRINT 'Backup diferencial do filegroup ' + @FileGroup + ' do banco de dados ' + @DataBase + ' realizado com sucesso. Caminho do backup: ' + @ArquiveDiffBackup;
END


IF @WeekDay = 1 AND @firstSundayOfMonth = 0
BEGIN
    DECLARE @ArquiveTLog NVARCHAR(255) = @path + @DataBase + '_Transaction_Log_' + @DateTimeBackup + '.trn'

    BACKUP LOG @DataBase
    TO DISK = @ArquiveTLog
    WITH
        INIT,
        NAME = @DataBase + ' Transaction Log',
        STATS = 10;

    PRINT 'Backup do log de transações do filegroup ' + @FileGroup + ' da Base de Dados ' + @DataBase + ' realizado com sucesso. Caminho do backup: ' + @ArquiveTLog;
END


