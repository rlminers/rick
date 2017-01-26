set lines 140
set pages 1000

-- ---------------------------------------------------------
REM v$asm_diskgroup
-- ---------------------------------------------------------

col name format a12
col percent_used format 99,99.9
col percent_free format 99,99.9
column free_gb   format 999,999,999.9
column usable_gb format 999,999,999.9
column reqd_gb   format 999,999,999.9
column total_gb  format 999,999,999.9
column used_gb   format 999,999,999.9

clear breaks
break on group_number skip 1 on report
compute sum of total_gb on report
compute sum of  free_gb on report
compute sum of  used_gb on report

select    group_number
        , name
        , type
        , ( ROUND( ( total_mb/1024 ) / DECODE(type, 'NORMAL', 2, 'HIGH', 3, 1 ), 1 ) ) total_gb
        , ( ROUND( (  free_mb/1024 ) / DECODE(type, 'NORMAL', 2, 'HIGH', 3, 1 ), 1 ) )  free_gb
        , ROUND( (free_mb/total_mb*100), 1 ) percent_free
        , ROUND(
          ( ROUND( ( total_mb/1024 ) / DECODE(type, 'NORMAL', 2, 'HIGH', 3, 1 ), 1 ) )
        - ( ROUND( (  free_mb/1024 ) / DECODE(type, 'NORMAL', 2, 'HIGH', 3, 1 ), 1 ) )
          , 1 ) used_gb
        , ROUND( 100 - (free_mb/total_mb*100), 1 ) percent_used
from v$asm_diskgroup
order by 1
/

clear breaks

col grp format 999
col name format a12
col compatibility format a13
col database_compatibility format a13
col percent_free format 99,99
col percent_full format 99,99

select group_number
  , name
  , state
  , type
  , compatibility
  , database_compatibility
  , ROUND( ( total_mb/1024 ) / DECODE(type, 'NORMAL', 2, 'HIGH', 3, 1 ), 1 ) total_gb
  , ROUND( (  free_mb/1024 ) / DECODE(type, 'NORMAL', 2, 'HIGH', 3, 1 ), 1 )  free_gb
  , ROUND( ( REQUIRED_MIRROR_FREE_MB/1024 ) / DECODE(type, 'NORMAL', 2, 'HIGH', 3, 1 ), 1 ) Req_mir_free_GB
  , ROUND( ( usable_file_mb/1024 ), 1 ) usable_gb
from v$asm_diskgroup
order by 1
/

