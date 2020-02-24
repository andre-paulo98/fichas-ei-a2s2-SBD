-------------------------
--     QUESTÃO 1 a)
-------------------------
/*
conn sys/sys as sysdba


CREATE OR REPLACE FUNCTION f_check_pw_alunos (
	p_username VARCHAR2,
	p_new_password VARCHAR2,
	p_old_password VARCHAR2) RETURN BOOLEAN AS
		BEGIN
			IF(
				LENGTH(p_new_password) < 6 OR 
				p_new_password = p_old_password OR
				upper(p_new_password) IN ('123456', 'PASSWORD') )THEN
				RETURN FALSE;
			ELSE 
				RETURN TRUE;
			END IF;
		END f_check_pw_alunos;
	/

SET SERVEROUTPUT ON 
BEGIN 
	IF(f_check_pw_alunos('a', 'X', 'a') = TRUE) THEN
		DBMS_OUTPUT.PUT_LINE('VALID PASSWORD');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('INVALID PASSWORD');
	END IF;
END;
/

CREATE PROFILE PERFIL_ALUNO LIMIT PASSWORD_VERIFY_FUNCTION f_check_pw_alunos;

SELECT RESOURCE_NAME, LIMIT, RESOURCE_TYPE FROM DBA_PROFILES WHERE PROFILE = 'PERFIL_ALUNO';

ALTER USER SUSANA10800008 PROFILE PERFIL_ALUNO;
ALTER USER FILIPE10900009 PROFILE PERFIL_ALUNO;

conn SUSANA10800008/SUSANA10800008

ALTER USER SUSANA10800008 IDENTIFIED BY 123456 REPLACE SUSANA10800008;





-------------------------
--     QUESTÃO 1 b)
-------------------------

conn sys/sys as sysdba

ALTER PROFILE PERFIL_ALUNO LIMIT FAILED_LOGIN_ATTEMPTS 3,
PASSWORD_LOCK_TIME 2, PASSWORD_LIFE_TIME 15, PASSWORD_GRACE_TIME 10;



-------------------------
--     QUESTÃO 2)
-------------------------

conn sys/sys as sysdba

CREATE PROFILE PERFIL_FUNC LIMIT 
	SESSIONS_PER_USER 2
	CPU_PER_SESSION unlimited
	CPU_PER_CALL 100
	CONNECT_TIME 2
	LOGICAL_READS_PER_CALL 1000
	PRIVATE_SGA 15K;

SELECT RESOURCE_NAME, LIMIT, RESOURCE_TYPE
FROM DBA_PROFILES
WHERE PROFILE = 'PERFIL_FUNC'
ORDER BY 3, 1;

ALTER SYSTEM SET RESOURCE_LIMIT=true SCOPE=both;*/


-------------------------
--     QUESTÃO 3)
-------------------------

conn sys/sys as sysdba

show parameter audit_trail

select * from dba_obj_audit_opts WHERE owner = 'REP_FICHA1';
--select * from dba_priv_audit_opts WHERE owner = 'rep_ficha1';

--audit update on rep_ficha1.aluno BY ACCESS whenever successful;
--audit update on rep_ficha1.aluno BY SESSION whenever NOT successful;

select * from dba_obj_audit_opts WHERE owner = 'REP_FICHA1';

-- testar 
-- entrar com jalmeida
-- alterar varias vezes o numero bi de um aluno

conn jalmeida/JALMEIDA

/*UPDATE rep_ficha1.aluno
set bi = 14540544
WHERE nome = 'Andre Paulo';

UPDATE rep_ficha1.aluno
set bi = 14540544
WHERE nome = 'Andre Paulo';

UPDATE rep_ficha1.aluno
set bi = 14540544
WHERE nome = 'Andre Paulo';

UPDATE rep_ficha1.aluno
set bi = 14540544
WHERE nome = 'Andre Paulo';

UPDATE rep_ficha1.aluno
set nome = 'Andre Paulo', morada = 'Leiria'
WHERE bi = 14540543;*/

conn sys/sys as sysdba

select timestamp, action_name, username, ses_actions 
FROM dba_audit_trail 
WHERE obj_name = 'ALUNO' and owner = 'REP_FICHA1';


-------------------------
--     QUESTÃO 3 e)
-------------------------

noaudit update on rep_ficha1.aluno;

select * from dba_obj_audit_opts WHERE owner = 'REP_FICHA1';


-------------------------
--     QUESTÃO 3 d)
-------------------------
-- guardar registos da auditoria
SPOOL Z:\ficha01-seguranca-parte02\DUMP_DATA.TXT CREATE
select timestamp, action_name, username, ses_actions 
FROM dba_audit_trail 
WHERE obj_name = 'ALUNO' and owner = 'REP_FICHA1';
SPOOL OFF;

-- apagar registos da auditoria
DELETE FROM AUD$ WHERE action_name = 'UPDATE' AND USERNAME = 'JALMEIDA';