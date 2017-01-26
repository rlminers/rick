col name format a32

SELECT p.name,
  p.status,
  to_char(p.created,'MM/DD/YYYY') created,
  s.sql_id,
  s.plan_hash_value,
  s.executions execs,
  ROUND( (s.elapsed_time / 1000000) / DECODE (NVL (s.executions, 0), 0, 1, s.executions), 2)  avg_etime,
  ROUND( s.buffer_gets   / DECODE (NVL (s.executions, 0), 0, 1, s.executions), 2) avg_lio
FROM dba_sql_profiles p,
  v$sql s
WHERE p.name       = s.sql_profile
AND s.sql_profile IS NOT NULL
and s.executions > 0
ORDER BY 1,2,4,5,6;

