col name format a32
col created format a15 trunc
col last_modified format a15 trunc
col category for a15
col sql_text for a40 trunc
col status format a8

select name
--, category
, status
, created
, last_modified
, force_matching
, sql_text
from dba_sql_profiles
where sql_text like nvl('&sql_text','%')
and name like nvl('&name',name)
order by last_modified;

SELECT DISTINCT p.name
, s.sql_id sql_id
FROM dba_sql_profiles p
, dba_hist_sqlstat s
WHERE p.name=s.sql_profile (+);

