/*
COMANDOS SQL UTEIS: ARQUIVOS DE DATA E LOG, HORA INICIO E FIM, INTEGRIDADE, COLLATION, ETC
*/
-- RESTORE FILELISTONLY
RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/data/arquivo_de_backup.bak'

-- RESTORE LABELONLY
RESTORE LABELONLY FROM DISK = '/var/opt/mssql/data/arquivo_de_backup.bak'

-- RESTORE HEADERONLY
RESTORE HEADERONLY FROM DISK = '/var/opt/mssql/data/arquivo_de_backup.bak'

-- RESTORE VERIFYONLY
RESTORE VERIFYONLY FROM DISK = '/var/opt/mssql/data/arquivo_de_backup.bak'