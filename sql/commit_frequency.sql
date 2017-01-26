
PROMPT The MOS note, Troubleshooting: “log file sync” Waits [ID 1376916.1],
PROMPT gives a formula to calculating the frequency of commits: 
PROMPT
PROMPT In the AWR or Statspack report, if  the  average user calls per commit/rollback 
PROMPT calculated as "user calls/(user commits+user rollbacks)"   
PROMPT is less than 30, then  commits are happening too frequently: 

col METRIC_NAME format a30
col METRIC_UNIT format a30
col value format 999,999,999,999

select to_char(begin_time,'MM/DD/YYYY:HH24:MI:SS') begin_time
, to_char(end_time,'MM/DD/YYYY:HH24:MI:SS') end_time
, metric_name
, metric_unit
, value
from v$metric
where metric_name in ( 'User Calls Per Sec','User Commits Per Sec','User Rollbacks Per Sec' )
and group_id = 2;
--
with ucalls as (
select inst_id, to_char(begin_time,'MM/DD/YYYY:HH24:MI:SS') begin_time
, to_char(end_time,'MM/DD/YYYY:HH24:MI:SS') end_time
, metric_name
, metric_unit
, value
from gv$metric
where metric_name = 'User Calls Per Sec'
and group_id = 2
)
, ucommits as (
select inst_id, to_char(begin_time,'MM/DD/YYYY:HH24:MI:SS') begin_time
, to_char(end_time,'MM/DD/YYYY:HH24:MI:SS') end_time
, metric_name
, metric_unit
, value
from gv$metric
where metric_name = 'User Commits Per Sec'
and group_id = 2
)
, urollbacks as (
select inst_id, to_char(begin_time,'MM/DD/YYYY:HH24:MI:SS') begin_time
, to_char(end_time,'MM/DD/YYYY:HH24:MI:SS') end_time
, metric_name
, metric_unit
, value
from gv$metric
where metric_name = 'User Rollbacks Per Sec'
and group_id = 2
)
select ucalls.inst_id
, ROUND( ucalls.value, 2 ) user_calls_per_sec
, ROUND( ucommits.value, 2 ) user_commits_per_sec
, ROUND( urollbacks.value, 2 ) user_rollbacks_per_sec
, ROUND( ( ucalls.value / ( ucommits.value + urollbacks.value ) ), 2 ) freq_of_commits
from ucalls, ucommits, urollbacks
where ucalls.inst_id = ucommits.inst_id
and ucommits.inst_id = urollbacks.inst_id
order by inst_id;

