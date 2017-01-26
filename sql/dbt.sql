
set lines 155
col dbtime for 999,999.99
col begin_timestamp for a40
col min_snap new_value min_snap
set verify off
set feedback off

col begin_interval_time format a28
SELECT begin_interval_time, min_snap
  FROM (SELECT MIN (snap_id) min_snap
          FROM dba_hist_snapshot
         WHERE     instance_number = 1
               --AND begin_interval_time >= TRUNC (SYSDATE) - 1) a
               AND begin_interval_time >= TRUNC (SYSDATE,'HH24') - 1) a
      ,dba_hist_snapshot b
 WHERE a.min_snap = b.snap_id AND b.instance_number = 1;
--select &min_snap from dual;

col max_snap new_value max_snap
SELECT begin_interval_time, max_snap
  FROM (SELECT MAX (snap_id) max_snap
          FROM dba_hist_snapshot
         WHERE     instance_number = 1
               --AND begin_interval_time >= TRUNC (SYSDATE) - 1) a
               AND begin_interval_time >= TRUNC (SYSDATE,'HH24') - 1) a
      ,dba_hist_snapshot b
 WHERE a.max_snap = b.snap_id AND b.instance_number = 1;
--select &max_snap from dual;

set feedback on

select /*+ RESULT_CACHE */ * from (
select begin_snap, end_snap, timestamp begin_timestamp, inst, a/1000000/60 DBtime from
(
select
 e.snap_id end_snap,
 lag(e.snap_id) over (order by e.snap_id) begin_snap,
 lag(s.end_interval_time) over (order by e.snap_id) timestamp,
 s.instance_number inst,
 e.value,
 nvl(value-lag(value) over (order by e.snap_id),0) a
from dba_hist_sys_time_model e, DBA_HIST_SNAPSHOT s
where s.snap_id = e.snap_id
 and e.instance_number = s.instance_number
 --and e.instance_number = 1
 and e.instance_number = NVL('&instance_number',e.instance_number)
 and stat_name             = 'DB time'
)
where  begin_snap between &min_snap and &max_snap
and begin_snap=end_snap-1
order by dbtime desc
)
where rownum <= 24
/

