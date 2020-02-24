/*
criando usuário e atribuindo uma senha
*/

CREATE LOGIN protheus WITH PASSWORD = 'protheus@1980' ;
GO

/*
cria o database de usuario para o login criado anteriormente
*/

USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'protheus')
BEGIN
    CREATE USER [protheus] FOR LOGIN [protheus]
    EXEC sp_addrolemember N'db_owner', N'protheus'
END;
GO

/*
incluir o usuario protheus ao sysadmin
*/

USE master;
GO

EXEC sp_addsrvrolemember N'protheus','sysadmin';  
GO

/*
criar base de dados com agrupamento Latin1_General_BIN
criar base de dados com agrupamento Latin1_General_BIN
*/

USE master;  
GO  
IF DB_ID (N'P12125MNTDB') IS NOT NULL  
DROP DATABASE P12125MNTDB;  
GO  
CREATE DATABASE P12125MNTDB
COLLATE Latin1_General_BIN;  
GO  
  
/*
verificando o agrupamento do database
*/

SELECT name, collation_name  
FROM sys.databases  
WHERE name = N'P12125MNTDB';  
GO

/*
criar base de dados com agrupamento Latin1_General_CI_AS - Fluig
*/

USE master;  
GO  
IF DB_ID (N'FLUIG') IS NOT NULL  
DROP DATABASE FLUIG;  
GO  
CREATE DATABASE FLUIG
COLLATE Latin1_General_CI_AS;  
GO  
  
/*
verificando o agrupamento do database - Fluig
*/

SELECT name, collation_name  
FROM sys.databases  
WHERE name = N'FLUIG';  
GO

/*
alteração do nível de isolamento - Fluig
*/

SELECT is_read_committed_snapshot_on FROM sys.databases WHERE name= 'FLUIG';

/*
se o resultado da consulta anterior for 0, execute:
*/

ALTER DATABASE FLUIG SET READ_COMMITTED_SNAPSHOT ON;