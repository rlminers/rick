col sql_text format a50 trunc

select sid
, sql_id
, sql_exec_id
, sql_exec_start
, sql_text
from v$sql_monitor
where upper(sql_text) like upper(nvl('&sql_text',sql_text))
and sql_text not like '%where upper(sql_text) like upper(nvl(%'
and sql_id like nvl('&sql_id',sql_id)
order by 1, 2, 3;

