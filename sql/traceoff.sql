
undef username
undef sid
undef session_id
undef serial_num

col os_pid for a7
col username for a15

SELECT s.username
, s.sid
, s.serial#
, p.spid os_pid
FROM V$SESSION S, v$process p
where p.addr = s.paddr
and s.username LIKE UPPER( NVL( '&username', s.username ) )
and s.sid = NVL( '&sid', s.sid ) 
order by 1, 2
/


exec dbms_monitor.session_trace_disable( &session_id, &serial_num );

/*
DBMS_MONITOR.SESSION_TRACE_DISABLE(
   session_id      IN     BINARY_INTEGER DEFAULT NULL,
   serial_num      IN     BINARY_INTEGER DEFAULT NULL);
*/

undef username
undef sid
undef session_id
undef serial_num

