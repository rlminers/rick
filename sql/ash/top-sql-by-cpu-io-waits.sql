SELECT
    a.sql_id,
    substr(q.sql_text, 1, 40) sql_text,
    SUM(decode(a.session_state, 'ON CPU', 1, 0)) cpu_time,
    SUM(decode(a.session_state, 'WAITING', decode(en.wait_class, 'User 
I/O', 1, 0), 0)) io_wait,
    SUM(decode(a.session_state, 'ON CPU', 1, 1)) wait_total
FROM
    v$active_session_history   a,
    v$event_name               en,
    v$sqlarea                  q
WHERE
    a.sql_id IS NOT NULL
    AND en.event# (+) = a.event#
    AND a.sql_id = q.sql_id (+)
GROUP BY
    a.sql_id,
    substr(q.sql_text, 1, 20)
ORDER BY
    cpu_time DESC;

