col SQL_TEXT format a30 truncate
col avg_etime format 999.999999
col executions_total format 999,999,999,999
col PARSING_SCHEMA_NAME format a25
break on instance_number skip 1 on PARSING_SCHEMA_NAME skip 1

set verify off

SELECT stat.instance_number
, PARSING_SCHEMA_NAME
, STAT.SQL_ID
, SQL_TEXT
, PLAN_HASH_VALUE
--, ELAPSED_TIME_DELTA
, executions_total
--, elapsed_time_total
, ROUND( (elapsed_time_total/1000000)/decode(nvl(executions_total,0),0,1,executions_total),2) avg_etime
--, STAT.SNAP_ID
--, SS.END_INTERVAL_TIME
FROM DBA_HIST_SQLSTAT STAT, DBA_HIST_SQLTEXT TXT, DBA_HIST_SNAPSHOT SS
WHERE UPPER(PARSING_SCHEMA_NAME) LIKE NVL( UPPER('&username'), UPPER(PARSING_SCHEMA_NAME) )
AND lower(SQL_TEXT) LIKE NVL( lower('&sql_text'), lower(SQL_TEXT) )
AND stat.sql_id like NVL( '&sql_id', stat.sql_id )
AND STAT.SQL_ID = TXT.SQL_ID
AND STAT.DBID = TXT.DBID
AND SS.DBID = STAT.DBID
AND SS.INSTANCE_NUMBER = STAT.INSTANCE_NUMBER
AND STAT.SNAP_ID = SS.SNAP_ID
AND (elapsed_time_total/1000000)/decode(nvl(executions_total,0),0,1,executions_total) BETWEEN &eta_min and &eta_max
--AND STAT.INSTANCE_NUMBER = inst_id
AND SS.BEGIN_INTERVAL_TIME >= sysdate-1
ORDER BY stat.instance_number, PARSING_SCHEMA_NAME, avg_etime DESC
/

undef username
undef sql_text
undef eta_min
undef eta_max

clear breaks

