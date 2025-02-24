
DECLARE @Database NVARCHAR(255) = 'AdventureWorks'
DECLARE @FileGroup NVARCHAR(255) = 'Primary' 
DECLARE @path NVARCHAR(255) = 'C:\Users\migue\OneDrive\Ambiente de Trabalho\Faculdade\2 ano 1 semestre\CBD\ProjCBD\ProjetoCBD Versão final\Backups\Primary\'
DECLARE @DateTimeBackup NVARCHAR(20) = REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 120), ':', '_')

DECLARE @DiaSemana INT = DATEPART(WEEKDAY, GETDATE())


IF @DiaSemana = 1
BEGIN
    DECLARE  @ArquiveFullBackup NVARCHAR(255) = @path + @Database + '_FullBackup_' + @DateTimeBackup + '.bak'

    BACKUP DATABASE @Database
    FILEGROUP = @FileGroup  
    TO DISK = @ArquiveFullBackup
    WITH
        INIT,
        NAME = @Database + ' Full Backup',
        STATS = 10;

    PRINT 'Backup completo do filegroup ' + @FileGroup + ' do banco de dados ' + @Database + ' realizado com sucesso. Caminho do backup: ' +  @ArquiveFullBackup;
END



IF @DiaSemana IN (3, 5, 7)
BEGIN
    DECLARE @ArquiveDiffBackup NVARCHAR(255) = @path + @Database + '_Backup_Diferencial_' + @DateTimeBackup + '.bak'

    BACKUP DATABASE @Database
    FILEGROUP = @FileGroup  
    TO DISK = @ArquiveDiffBackup
    WITH
        DIFFERENTIAL,
        INIT,
        NAME = @Database + ' Diferencial Backup',
        STATS = 10;

    PRINT 'Backup diferencial do filegroup ' + @FileGroup + ' da base de dados' + @Database + ' realizado com sucesso. Caminho do backup: ' + @ArquiveDiffBackup;
END



DECLARE @ArquiveTLog NVARCHAR(255) = @path + @Database + '_Transaction_Log_' + @DateTimeBackup + '.trn'

BACKUP LOG @Database
TO DISK = @ArquiveTLog
WITH
    INIT,
    NAME = @Database + ' Transaction Log',
    STATS = 10;

PRINT 'Backup do log de transações do banco de dados ' + @Database + ' realizado com sucesso. Caminho do backup: ' + @ArquiveTLog;


