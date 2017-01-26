col sql_handle for a35 
col plan_name for a35 
col enabled for a7
col accepted for a10

SELECT sql_handle, plan_name, enabled, accepted 
FROM   dba_sql_plan_baselines
WHERE sql_text NOT LIKE '%dba_sql_plan_baselines%';

