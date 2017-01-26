  SELECT sid
        ,program
        ,address
        ,hash_value
        ,b.sql_id
        ,child_number child
        ,plan_hash_value
        ,executions execs
        ,(elapsed_time / DECODE (NVL (executions, 0), 0, 1, executions)) / 1000000 avg_etime
        ,sql_text
    FROM v$session a, v$sql b
   WHERE     status = 'ACTIVE'
         AND username IS NOT NULL
         AND osuser NOT IN ('aleonard', 'sys')
         AND username NOT IN ('SYS', 'CF', 'SYSTEM', 'NTAYO', 'DAEVANS', 'RMINERS')
         AND a.sql_id = b.sql_id
         AND (elapsed_time / DECODE (NVL (executions, 0), 0, 1, executions)) / 1000000 > 3600
         AND a.sql_child_number = b.child_number
         AND sql_text NOT LIKE 'select sid, program, address, hash_value, b.sql_id, child_number child,%'
         AND sql_text NOT LIKE 'select min(minbkt),maxbkt%'
ORDER BY sql_id, sql_child_number;

