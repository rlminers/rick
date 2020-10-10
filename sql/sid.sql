
SET LINES 140 LONG 65536

CLEAR column

COLUMN username FORMAT A12 WRAP
COLUMN prog_event FORMAT A35 WRAP
COLUMN run_time FORMAT A10 JUSTIFY RIGHT
COLUMN sid FORMAT A4 NEW_VALUE sid
COLUMN status FORMAT A11
col "LOGON_TIME/MACHINE" format a21
col "SID/SERIAL" format a10

ACCEPT search_string PROMPT "Search for: "

set verify off

SELECT
s.sid||','||s.serial# || chr(10) || 'PID:' || p.spid as "SID/SERIAL"
,      s.username || chr(10) || s.osuser AS username
,      s.status || chr(10) || 'call:' || s.last_call_et AS status
,      s.logon_time || chr(10) || 'Machine:' || s.machine "LOGON_TIME/MACHINE"
,      lpad(
                to_char(
                        trunc(24*(sysdate-s.logon_time))
                ) ||
                to_char(
                        trunc(sysdate) + (sysdate-s.logon_time)
                ,      ':MI:SS'
                )
        , 10, ' ') AS run_time
,      s.program ||  chr(10) || s.event AS prog_event
FROM    v$session s
JOIN    v$process p ON (p.addr = s.paddr)
WHERE  s.username <> 'DBSNMP'
AND    audsid != sys_context('USERENV','SESSIONID')
and s.sid = &search_string
ORDER BY
        sid
/

select 'alter system kill session ''' || s.sid||','||s.serial# || ''' immediate;' kill_stmt
FROM    v$session s
JOIN    v$process p ON (p.addr = s.paddr)
WHERE  audsid != sys_context('USERENV','SESSIONID')
and s.sid = &search_string
/

/*
select sid, serial#, inst_id
from gv$session ...

alter system kill session 'sid,serial#,@inst_id'
*/

