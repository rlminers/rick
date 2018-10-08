col name format a30
col value format 999,999,999,999

select
  a.*
, sysdate - b.startup_time days_old
from
  v$sysstat a
, v$instance b
where
  a.name like 'parse%'
/

