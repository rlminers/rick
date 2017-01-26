col inst_id format 9999
col SQL_FULLTEXT format a30 truncate
col PARSING_SCHEMA_NAME format a25 truncate
col executions format 999,999,999,999

break on inst_id skip 1 on parsing_schema_name skip 1

set verify off

SELECT inst_id
, PARSING_SCHEMA_NAME
, SQL_ID
, SQL_FULLTEXT
, PLAN_HASH_VALUE
--, ELAPSED_TIME/1000000 total_seconds
, executions
, (elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) avg_etime
FROM GV$SQL
WHERE UPPER(PARSING_SCHEMA_NAME) LIKE NVL( UPPER('&username'), UPPER(PARSING_SCHEMA_NAME) )
and lower(SQL_FULLTEXT) LIKE NVL( lower('&sql_text'), lower(SQL_FULLTEXT) )
and sql_id like NVL( '&sql_id', sql_id )
AND (elapsed_time/1000000)/decode(nvl(executions,0),0,1,executions) BETWEEN &eta_min and &eta_max
AND executions > 5
ORDER BY inst_id, parsing_schema_name, avg_etime desc
/

undef username
undef sql_text
undef eta_min
undef eta_max


