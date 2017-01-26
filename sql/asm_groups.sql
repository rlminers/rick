
break on group_number skip 1

col path format a65

select d.group_number
--, d.path
, dg.name
, d.failgroup
, d.mode_status
, count(*)
from v$asm_disk d, v$asm_diskgroup dg
where d.group_number = dg.group_number
group by d.group_number
--, d.path
, dg.name
, d.failgroup
, d.mode_status
order by 1,2,3
/

