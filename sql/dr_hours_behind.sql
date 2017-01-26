
SELECT a.thread#
, a.applied
, ROUND( 24*(sysdate-max (a.first_time)),1) hours
, MAX (a.sequence#)
FROM v$archived_log a, v$database d
WHERE a.activation# = d.activation#
AND a.applied = 'YES'
GROUP BY a.thread#, a.applied
ORDER BY a.thread#
/

