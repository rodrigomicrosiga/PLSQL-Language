select * from sys.sysprocesses where dbid = DB_ID('arquivo_do_banco')

USE master;
GO

ALTER DATABASE arquivo_do_banco
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE arquivo_do_banco;
