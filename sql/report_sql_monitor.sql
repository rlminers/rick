set lines 175
col report for a176
set long 99999999
accept sid  prompt "Enter value for sid: "
select
DBMS_SQLTUNE.REPORT_SQL_MONITOR(
   session_id=>nvl('&&sid',sys_context('userenv','sid')),
   session_serial=>decode('&&sid',null,null,
sys_context('userenv','sid'),(select serial# from v$session where audsid = sys_context('userenv','sessionid')),
null),
   sql_id=>'&sql_id',
   sql_exec_id=>'&sql_exec_id',
   report_level=>'ALL')
as report
from dual;
set lines 155
undef SID

