
set timing off

clear breaks

col name format a8

col TOTAL_mB format 999,999,999.99
col TOTAL_gB format 999,999,999.99
col TOTAL_tB format 999,999,999.99
col free_mB format 999,999,999.99
col free_gB format 999,999,999.99
col free_tB format 999,999,999.99
col used_mB format 999,999,999.99
col used_gB format 999,999,999.99
col used_tB format 999,999,999.99

select name
, state
, type
, total_mb
, free_mb
, total_mb - free_mb used_mb
, required_mirror_free_mb 
, usable_file_mb 
from v$asm_diskgroup
;

select name
, state
, type
, ROUND(total_mb/1024,2) total_gb
, ROUND(free_mb/1024,2) free_gb
, ROUND( (total_mb - free_mb)/1024,2) used_gb
, ROUND(required_mirror_free_mb/1024,2) required_mirror_free_gb
, ROUND(usable_file_mb/1024,2) usable_file_gb
from v$asm_diskgroup
;

select name
, state
, type
, ROUND(total_mb/1024/1024,2) total_tb
, ROUND(free_mb/1024/1024,2) free_tb
, ROUND( (total_mb - free_mb)/1024/1024,2) used_tb
, ROUND(required_mirror_free_mb/1024/1024,2) required_mirror_free_tb
, ROUND(usable_file_mb/1024/1024,2) usable_file_tb
from v$asm_diskgroup
;

set timing on

