use AdventureWorks
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


--Select * from sys.indexes where object_id = object_id('Sales.Orders');