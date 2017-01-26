
alter session set nls_date_format='dd/mm/yy hh24:mi:ss'
/

col totalwork format 999,999,999,999
col sofar format 999,999,999,999
col "Minutes" format 999,999.99
col "Hours" format 999,999.99

select inst_id
, SID
, START_TIME
, TOTALWORK
, sofar
, ROUND( (sofar/totalwork) * 100,2) "% done"
, sysdate + TIME_REMAINING/3600/24 end_at
from gv$session_longops
where totalwork > sofar
AND opname NOT LIKE '%aggregate%'
AND opname like 'RMAN%'
order by inst_id, start_time
/

select SESSION_KEY
, INPUT_TYPE
, STATUS
, to_char(START_TIME,'mm/dd/yy hh24:mi') start_time
, to_char(END_TIME,'mm/dd/yy hh24:mi') end_time
, round((end_time-start_time)*1440,2) "Minutes"
, round((end_time-start_time)*1440/60,2) "Hours"
from V$RMAN_BACKUP_JOB_DETAILS
where start_time >= trunc(sysdate-2)
order by start_time asc
/

