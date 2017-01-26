col sql_text for a9 truncate
set verify off
set pagesize 999
set lines 155
col username format a13
col prog format a22
col sid format 9999999
col child_number format 99999 heading CHILD
col ocategory format a10
col avg_etime format 9,999,999.9999
col avg_pio format 9,999,999.99
col avg_lio format 999,999,999,999
col etime format 9,999,999.99

select     
 substr(sql_text,9) sql_text,
 parsing_schema_name as parsed,
 elapsed_time_delta/1000/1000 as elapsed_sec,
 stat.snap_id,
 to_char(snap.end_interval_time,'dd.mm hh24:mi:ss') as snaptime,
 txt.sql_id
from     
 dba_hist_sqlstat stat,
 dba_hist_sqltext txt,
 dba_hist_snapshot snap
where stat.sql_id=txt.sql_id
and stat.snap_id=snap.snap_id
and snap.begin_interval_time>=sysdate-8
--and upper(sql_text) like upper(nvl('&sql_text',sql_text))
and sql_text not like '%where upper(sql_text) like upper(nvl(%'
and stat.sql_id like nvl('&sql_id',stat.sql_id)
and parsing_schema_name not in ('SYS','SYSMAN','MDSYS','WKSYS')
order by elapsed_time_delta asc;

