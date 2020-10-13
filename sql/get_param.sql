set serveroutput on
set feedback off

exec dbms_output.put_line('Parameter value in memory:');
col name format a25
col value format a10
SELECT INST_ID, NAME,VALUE,TYPE,ISSYS_MODIFIABLE, ISINSTANCE_MODIFIABLE
FROM GV$PARAMETER WHERE name ='ddl_lock_timeout' ;

exec dbms_output.put_line('Parameter value in SPFILE:');
col sid format a10
SELECT SID,NAME,VALUE,TYPE, ISSPECIFIED
FROM V$SPPARAMETER WHERE NAME ='ddl_lock_timeout';

set feedback on

