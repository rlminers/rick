set lines 100
col name format a60
select  name
,       floor(space_limit / 1024 / 1024 / 1024 ) "Size GB"
,       ceil(space_used  / 1024 / 1024 / 1024 ) "Used GB"
from    v$recovery_file_dest
order by name
/

col name format a12
col space_limit_gb format 999,999,999.9
col space_used_gb format 999,999,999.9
select name
, space_limit/1024/1024/1024 space_limit_gb
, space_used/1024/1024/1024 space_used_gb
, space_reclaimable
, number_of_files
 from V$RECOVERY_FILE_DEST
/

select *
from v$flash_recovery_area_usage
/

