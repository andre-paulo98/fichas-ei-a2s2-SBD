-------------------------
--     QUESTÃO 1 a)
-------------------------

CONN SYSTEM/ORaCLe2020

SET TIMING ON

/*
CREATE TABLESPACE TBS_Ficha03
DATAFILE 'C:\ORACLE11G\oradata\orcl\TBS_Ficha03.dbf'
SIZE 1700M AUTOEXTEND ON NEXT 100M;

CREATE TABLESPACE TBS_IDX_Ficha03
DATAFILE 'C:\ORACLE11G\oradata\orcl\TBS_IDX_Ficha03.dbf'
SIZE 1500M AUTOEXTEND ON NEXT 100M;

CREATE TEMPORARY TABLESPACE TEMP_Ficha03
TEMPFILE 'C:\ORACLE11G\oradata\orcl\TEMP_Ficha03.dbf'
SIZE 800M AUTOEXTEND ON NEXT 100M;



-------------------------
--     QUESTÃO 1 b)
-------------------------


CONN SYSTEM/ORaCLe2020
DESC dba_tablespaces;

SELECT tablespace_name, contents, status FROM dba_tablespaces;

DESC dba_data_files;

SELECT file_name, tablespace_name, bytes/1024/1024 || 'MB' AS SIZE_MB  FROM dba_data_files
UNION 
SELECT file_name, tablespace_name, bytes/1024/1024 || 'MB' AS SIZE_MB  FROM dba_temp_files
ORDER BY 2;


-------------------------
--     QUESTÃO 1 c)
-------------------------

SELECT username FROM dba_users WHERE username = 'USEROPTIM';
-- não existe logo criar


CREATE USER USEROPTIM IDENTIFIED BY USEROPTIM
DEFAULT TABLESPACE TBS_Ficha03
TEMPORARY TABLESPACE TEMP_Ficha03;


GRANT CONNECT, RESOURCE TO USEROPTIM;
GRANT CREATE DATABASE LINK TO USEROPTIM;


-------------------------
--     QUESTÃO 1 d)
-------------------------
-- verificar o user criado, incluindo o default tablespace e o temporary tablespace na vista: dba_users
-- depois o dba_sys_privs

CONN USEROPTIM/USEROPTIM
SELECT * FROM session_privs;
SELECT * FROM session_roles;


-------------------------
--     QUESTÃO 2 a)
-------------------------

CONN USEROPTIM/USEROPTIM

-- CRIAR O DATABASE LINK
CREATE DATABASE LINK L_WAREHOUSE 
connect TO warehouse_readonly
IDENTIFIED BY sbd
USING 'BDADOS';

-- verificar se ficou criado
SELECT * FROM USER_DB_LINKS;

-------------------------
--     QUESTÃO 2 C)
-------------------------

CONN USEROPTIM/USEROPTIM
SET TIMING ON

-------------------------
--     QUESTÃO 2 d)
-------------------------

SELECT object_name, object_type FROM user_objects@L_WAREHOUSE;

-------------------------
--     QUESTÃO 2 d)
-------------------------

CONN USEROPTIM/USEROPTIM
SET TIMING ON

CREATE TABLE t_metadados NOLOGGING AS SELECT * FROM t_metadados@L_WAREHOUSE;

CREATE TABLE t_resultados NOLOGGING AS SELECT * FROM t_resultados@L_WAREHOUSE;


-------------------------
--     QUESTÃO 3 a)
-------------------------
CONN USEROPTIM/USEROPTIM

SELECT table_name, num_rows FROM user_tab_statistics;
*/
-------------------------
--     QUESTÃO 3 b)
-------------------------
CONN USEROPTIM/USEROPTIM

EXECUTE dbms_stats.DELETE_TABLE_STATS('USEROPTIM', 't_metadados');
EXECUTE dbms_stats.DELETE_TABLE_STATS('USEROPTIM', 't_resultados');


EXECUTE dbms_stats.LOCK_TABLE_STATS(user, 't_metadados');
EXECUTE dbms_stats.LOCK_TABLE_STATS(user, 't_resultados');

