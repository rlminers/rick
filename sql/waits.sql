
col wait_class format a30
break on inst_id skip 1

col minutes new_value minutes
accept minutes prompt 'Enter minutes : '
set verify off
set feedback off
SET termout OFF
SELECT '&minutes' AS minutes FROM dual;
SET termout ON

select
  inst_id
, nvl(wait_class,'ON CPU') wait_class
, wait_class_id
, count(*) cnt
from GV$ACTIVE_SESSION_HISTORY
where sample_time > sysdate - &minutes/1440
group by
  inst_id
, wait_class_id
, wait_class
order by
  inst_id
, count(*) desc;



prompt
col wait_class new_value wait_class
accept wait_class prompt 'Enter wait_class : '
set verify off
set feedback off
SET termout OFF
SELECT '&wait_class' AS wait_class FROM dual;
SET termout ON

col wait_class format a24
prompt
select
  inst_id
, nvl(wait_class,'ON CPU') wait_class
, wait_class_id
, count(*) cnt
from gV$ACTIVE_SESSION_HISTORY
where wait_class = '&wait_class'
and sample_time > sysdate - &minutes/1440
group by inst_id, wait_class_id, wait_class
order by 1, 3 desc;

prompt
col wait_class_id new_value wait_class_id
set verify off
set feedback off
SET termout OFF
SELECT distinct wait_class_id AS wait_class_id
from gV$ACTIVE_SESSION_HISTORY
where wait_class = '&wait_class'
and sample_time > sysdate - &minutes/1440;
SET termout ON

col inst_id new_value inst_id
accept inst_id prompt 'Enter inst_id : '
set verify off
set feedback off
SET termout OFF
SELECT '&inst_id' AS inst_id FROM dual;
SET termout ON

select
  event_id
, event
, count(*) cnt
from gV$ACTIVE_SESSION_HISTORY
where sample_time > sysdate - &minutes/1440
and wait_class_id = &wait_class_id
and inst_id = &inst_id
group by event_id, event
order by 3 desc;

prompt
col event_id new_value event_id
accept event_id prompt 'Enter event_id : '
set verify off
set feedback off
SET termout OFF
SELECT '&event_id' AS event_id FROM dual;
SET termout ON

select sql_id, count(*) cnt
from gV$ACTIVE_SESSION_HISTORY
where sample_time > sysdate - &minutes/1440
and event_id = &event_id
group by sql_id
having count(*)>1
order by 2 desc;

prompt
col sql_id new_value sql_id
accept sql_id prompt 'Enter sql_id : '
break on sql_id
set verify off
set feedback off
SET termout OFF
SELECT '&sql_id' AS sql_id FROM dual;
SET termout ON

select sql_id, sql_text
from gV$SQLTEXT
where sql_id = '&sql_id'
and inst_id = &inst_id
order by sql_id, piece;

select current_obj#, count(*) cnt
from gV$ACTIVE_SESSION_HISTORY
where sample_time > sysdate - &minutes/1440
and event_id = &event_id
and sql_id = '&sql_id'
group by current_obj#
order by 2 desc;

prompt
col obj_id new_value obj_id
accept obj_id prompt 'Enter obj_id : '
set verify off
set feedback off
SET termout OFF
SELECT '&obj_id' AS obj_id FROM dual;
SET termout ON

prompt
col object_name format a32
select object_id, owner, object_name, object_type
from dba_objects
where object_id = '&obj_id';

undef minutes
undef wait_class
undef wait_class_id
undef event_id
undef sql_id
undef obj_id

