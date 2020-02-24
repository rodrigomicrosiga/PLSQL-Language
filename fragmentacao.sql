-- verificar fragmentação das tabelas de todo banco de dados

SELECT dbschemas.[name] AS 'Schema'
	,dbtables.[name] AS 'Table'
	,dbindexes.[name] AS 'Index'
	,indexstats.avg_fragmentation_in_percent
	,indexstats.page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
	AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID()
--WHERE indexstats.database_id = DB_ID() AND dbtables.[ name ] like '%CT2%' 
ORDER BY indexstats.avg_fragmentation_in_percent DESC
	-- adicionar clausula para buscar uma tabela em específico
    -- WHERE indexstats.database_id = DB_ID() AND dbtables.[ name ] like '%CT2%' 

SELECT * FROM sys.tables

--reorganizar um índice específico
ALTER INDEX IX_NAME
  ON dbo.P12117MNT  
REORGANIZE ;   
GO  

-- reorganizar todos os índices de uma tabela
ALTER INDEX ALL ON dbo.P12117MNT  
REORGANIZE ;   
GO  

-- rebuild de um índice específico
ALTER INDEX PK_Employee_BusinessEntityID ON dbo.P12117MNT
REBUILD;

-- rebuild de todos índice de uma tabela
ALTER INDEX ALL ON dbo.P12117MNT
REBUILD;
