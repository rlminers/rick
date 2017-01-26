set pagesize 999
set lines 150

col inst_id heading "INST" format 9
col username format a24
col prog format a8 trunc
col sql_text format a20 trunc
col sid format 9999
col child for 99999
col avg_etime for 99,999.999
col machine format a12 trunc
col run_time format a10 justify right
col status format a1
col inst_id format 9999

break on inst_id skip 1

SELECT
  a.inst_id
, sid
, SUBSTR (program, 1, 19) prog
, DECODE ( a.status, 'ACTIVE','A','KILLED','K', a.status) status
, substr(a.machine,1,15) machine
, username
, b.sql_id
, child_number child
--, hash_value
--, plan_hash_value
, DECODE(IO_CELL_OFFLOAD_ELIGIBLE_BYTES,0,'No','Yes') Offload
, executions execs
, ROUND( (elapsed_time / DECODE (NVL (executions, 0), 0, 1, executions)) / 1000000 ,1 ) avg_etime
--, lpad( to_char( trunc(24*(sysdate-a.logon_time))) || to_char( trunc(sysdate) + (sysdate-a.logon_time) ,':MI:SS') , 10, ' ') AS run_time
, regexp_replace(sql_text, '[[:space:]]+',' ') sql_text
FROM gv$session a, gv$sql b
WHERE status in ('ACTIVE','KILLED')
AND a.inst_id = b.inst_id
AND username IS NOT NULL
AND a.sql_id = b.sql_id
AND a.sql_child_number = b.child_number
AND sql_text NOT LIKE '%substr(a.machine,1,20) machine%'
ORDER BY
  inst_id
, username
, program
, sql_id
/


