
undef username
undef sid
undef session_id
undef serial_num
undef module

col os_pid for a7
col username for a15

SELECT s.username
, s.sid
, s.serial#
, p.spid os_pid
, s.module
FROM V$SESSION S, v$process p
where p.addr = s.paddr
and s.username LIKE UPPER( NVL( '&username', s.username ) )
and s.sid = NVL( '&sid', s.sid ) 
and s.module LIKE NVL( '%&module%', s.module ) 
order by 1, 2
/

exec dbms_monitor.session_trace_enable( &&session_id, &&serial_num, TRUE, TRUE );

SELECT p.tracefile
FROM v$session s,v$process p
WHERE s.paddr = p.addr
AND s.sid = &session_id
AND s.serial# = &serial_num ;

/*
DBMS_MONITOR.SESSION_TRACE_ENABLE(
    session_id   IN  BINARY_INTEGER DEFAULT NULL,
    serial_num   IN  BINARY_INTEGER DEFAULT NULL,
    waits        IN  BOOLEAN DEFAULT TRUE,
    binds        IN  BOOLEAN DEFAULT FALSE,
    plan_stat    IN  VARCHAR2 DEFAULT NULL);
*/

undef username
undef sid
undef session_id
undef serial_num
undef module

