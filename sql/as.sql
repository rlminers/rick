
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
         --hash_value,
--         a.status,
         substr(a.machine,1,20) machine,
         username,
         b.sql_id,
         child_number child,
--         plan_hash_value,
         executions execs,
         (elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_etime,
        ((elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions)/3600) avg_htime,
--     lpad( to_char( trunc(24*(sysdate-a.logon_time))) || to_char( trunc(sysdate) + (sysdate-a.logon_time) ,':MI:SS') , 10, ' ') AS run_time,
         regexp_replace(sql_text, '[[:space:]]+',' ' ) sql_text
    FROM v$session a, v$sql b
    --WHERE     status in ('ACTIVE','KILLED')
    WHERE     status = 'ACTIVE'
         AND username IS NOT NULL
         AND a.sql_id = b.sql_id
         AND a.sql_child_number = b.child_number
         AND sql_text NOT LIKE
                'SELECT sid, SUBSTR (program, 1, 19)%'
--ORDER BY sql_id, sql_child_number
ORDER BY username, program, sql_id
/

!uptime

