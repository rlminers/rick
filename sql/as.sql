set lines 150
set pages 1000
 
col username format a15
col prog format a8 trunc
col sql_text format a50 trunc
col sid format 9999
col child for 999
col avg_etime heading "SECONDS"for 99,999.999
col avg_htime heading "HOURS"for 999.9
col machine format a12 trunc
col run_time format a10 justify right
 
SELECT sid, SUBSTR (program, 1, 19) prog,
         substr(a.machine,1,20) machine,
         username,
         b.sql_id,
         child_number child,
--         plan_hash_value,
         executions execs,
         (elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_etime,
        ((elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions)/3600) avg_htime,
         regexp_replace(sql_text, '[[:space:]]+',' ' ) sql_text
    FROM v$session a, v$sql b
    WHERE     status = 'ACTIVE'
         AND username IS NOT NULL
         AND a.sql_id = b.sql_id
         AND a.sql_child_number = b.child_number
--         AND sid != ( select sid from v$mystat where rownum=1 )
ORDER BY status, username, program, sql_id
/
 
col username format a30
compute sum of sql_id_cnt on report
break on report
 
SELECT status, username, count(b.sql_id) sql_id_cnt
    FROM v$session a, v$sql b
    WHERE username IS NOT NULL
         AND a.sql_id = b.sql_id
GROUP BY status, username
ORDER BY status, username
/
 
clear breaks

