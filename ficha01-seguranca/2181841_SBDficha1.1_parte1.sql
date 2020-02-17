-------------------------
--      QUESTÃO 1 a)
-------------------------

conn sys/sys as sysdba
--start X:\ficha01-seguranca\scripts\Ficha01_users.sql

DESC dba_users;


SELECT username, account_status
FROM dba_users
WHERE to_char(created, 'yyyymmdd') = to_char(SYSDATE, 'yyyymmdd');


-------------------------
--     QUESTÃO 1 b)
-------------------------

-- conectar com sys
conn sys/sys as sysdba 

-- dar permissão para iniciar sessão
GRANT CREATE SESSION TO rep_ficha1; 

-- dar permissão para criar tabela
GRANT CREATE TABLE TO rep_ficha1;

-- mostrar descrição da tabela
DESC dba_sys_privs; 

-- mostrar que o utilizador tem permissão
SELECT grantee, privilege 
FROM dba_sys_privs
WHERE UPPER(grantee) = 'REP_FICHA1';

-- realizar conexão
conn rep_ficha1/rep 

SELECT privilege 
FROM user_sys_privs;

-- start X:\ficha01-seguranca\scripts\Ficha01_tabelas.sql

desc user_tables;

select table_name
from user_tables;

-------------------------
--     QUESTÃO 1 c)
-------------------------


conn rep_ficha1/rep

-- inserir os dados
--start X:\ficha01-seguranca\scripts\Ficha01_dados.sql

desc aluno;
select * from aluno;

desc inscricao;
select * from inscricao;

desc exame;
select * from exame;






-------------------------
--     QUESTÃO 3 a)
-------------------------

conn rep_ficha1/rep

--ALTER TABLE aluno ADD (username VARCHAR2(30));

-- mostrar a tabela alunos
DESC aluno;

DESC USER_TAB_COLUMNS;

-- mostrar a tabela aluno com mais dados (tipo e quantidade)
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH
FROM USER_TAB_COLUMNS
WHERE UPPER(TABLE_NAME) = 'ALUNO';


-------------------------
--     QUESTÃO 3 b)
-------------------------

conn sys/sys as sysdba

SELECT a.nome, a.bi, d.username
FROM dba_users d JOIN rep_ficha1.aluno a
ON to_char(a.bi) = SUBSTR(d.username, -8);

select * from rep_ficha1.aluno;

UPDATE rep_ficha1.aluno a
set a.username = UPPER(SUBSTR(a.nome, 1, INSTR(a.nome, ' ') - 1)) || a.bi
WHERE a.bi IN (SELECT a1.bi FROM dba_users d JOIN rep_ficha1.aluno a1 ON to_char(a1.bi) = SUBSTR(d.username, -8));

COMMIT;

conn rep_ficha1/rep

SELECT nome, username FROM aluno;


-------------------------
--     QUESTÃO 3 c)
-------------------------

conn sys/sys as sysdba

-- criar o utilizador
CREATE USER CARLOS10700007 IDENTIFIED BY CARLOS10700007;

-- atualizar username na tabela de alunos
UPDATE rep_ficha1.aluno a
set a.username = UPPER(SUBSTR(a.nome, 1, INSTR(a.nome, ' ') - 1)) || a.bi
WHERE a.bi IN (SELECT a1.bi FROM dba_users d JOIN rep_ficha1.aluno a1 ON to_char(a1.bi) = SUBSTR(d.username, -8));


conn rep_ficha1/rep

SELECT nome, username FROM aluno;


-------------------------
--     QUESTÃO 4
-------------------------

conn sys/sys as sysdba

-- privilegios de sistema
SELECT privilege FROM dba_sys_privs WHERE grantee IN ('CARLOS10700007', 'SUSANA10800008', 'FILIPE10900009');

-- privilegios de objeto
SELECT privilege FROM dba_tab_privs WHERE grantee IN ('CARLOS10700007', 'SUSANA10800008', 'FILIPE10900009');

-- pesquisa por roles
SELECT granted_role
FROM dba_role_privs
WHERE grantee IN ('CARLOS10700007', 'SUSANA10800008', 'FILIPE10900009');


-------------------------
--     QUESTÃO 5
-------------------------

conn sys/sys as sysdba

-- verificar se as roles existem
SELECT role
from dba_roles
WHERE role IN ('ROLE_ALUNO', 'CONNECT');

--CREATE ROLE ROLE_ALUNO;

--GRANT ROLE_ALUNO TO CARLOS10700007;
--GRANT ROLE_ALUNO TO SUSANA10800008;
--GRANT ROLE_ALUNO TO FILIPE10900009;

--GRANT CONNECT TO ROLE_ALUNO;

SELECT granted_role, grantee
FROM dba_role_privs
WHERE granted_role IN ('ROLE_ALUNO', 'CONNECT');

--GRANT CREATE VIEW TO role_aluno;

SELECT role, privilege FROM role_sys_privs WHERE ROLE IN ('ROLE_ALUNO', 'CONNECT');


-------------------------
--     QUESTÃO 6
-------------------------

CREATE USER jalmeida IDENTIFIED BY JALMEIDA;

SELECT username, account_status
FROM dba_users
WHERE to_char(created, 'yyyymmdd') = to_char(SYSDATE, 'yyyymmdd');


SELECT role 
FROM dba_roles WHERE role in ('ROLE_FUNC');

--CREATE ROLE ROLE_FUNC;

--GRANT CONNECT TO ROLE_FUNC;

SELECT granted_role, grantee
FROM dba_role_privs
WHERE grantee = 'ROLE_FUNC';


conn rep_ficha1/rep

--GRANT INSERT, SELECT ON ALUNO TO ROLE_FUNC;

--GRANT UPDATE(nome, morada) ON ALUNO TO ROLE_FUNC;

SELECT TABLE_NAME, PRIVILEGE
FROM user_tab_privs_made
WHERE grantee = 'ROLE_FUNC';

SELECT TABLE_NAME, COLUMN_NAME, PRIVILEGE
FROM user_col_privs_made
WHERE grantee = 'ROLE_FUNC';