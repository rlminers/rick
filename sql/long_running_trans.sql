col machine format a25
col program format a25
col username format a32

  SELECT t.start_time,
         t.status, 
	 t.used_urec,
	 t.used_ublk,
         s.sid,
         s.serial#,
--         s.username,
         s.status sess_status,
--         s.schemaname,
--         s.osuser,
--         s.process,
--         s.machine,
--         s.terminal,
         s.program
--         s.module,
--         TO_CHAR (s.logon_time, 'DD/MON/YY HH24:MI:SS') logon_time
    FROM v$transaction t, v$session s
   WHERE s.saddr = t.ses_addr
   and start_time < to_char(sysdate - 1/24,'MM/DD/YY HH24:MI:SS')
--   and t.status = 'ACTIVE'
--   and s.status = 'INACTIVE'
   and s.sid = &sid
ORDER BY start_time;

undef sid

