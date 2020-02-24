SET NOCOUNT ON;

DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

SELECT object_id AS objectid
	,index_id AS indexid
	,partition_number AS partitionnum
	,avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.Dm_db_index_physical_stats(Db_id(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0
	AND index_id > 0;

DECLARE partitions CURSOR
FOR
SELECT *
FROM #work_to_do;

OPEN partitions;

WHILE (1 = 1)
BEGIN
		;

	FETCH NEXT
	FROM partitions
	INTO @objectid
		,@indexid
		,@partitionnum
		,@frag;

	IF @@FETCH_STATUS < 0
		BREAK;

	SELECT @objectname = Quotename(o.NAME)
		,@schemaname = Quotename(s.NAME)
	FROM sys.objects AS o
	JOIN sys.schemas AS s ON s.schema_id = o.schema_id
	WHERE o.object_id = @objectid;

	SELECT @indexname = Quotename(NAME)
	FROM sys.indexes
	WHERE object_id = @objectid
		AND index_id = @indexid;

	SELECT @partitioncount = Count(*)
	FROM sys.partitions
	WHERE object_id = @objectid
		AND index_id = @indexid;

	IF @frag < 10
		SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REORGANIZE ';

	IF @frag >= 10
		SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + @schemaname + N'.' + @objectname + N' REBUILD ';

	IF @partitioncount > 1
		SET @command = @command + N' PARTITION=' + Cast(@partitionnum AS NVARCHAR(10));

	EXEC (@command);
END;

CLOSE partitions;

DEALLOCATE partitions;

DROP TABLE #work_to_do;
GO