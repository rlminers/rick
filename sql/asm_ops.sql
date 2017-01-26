
set lines 140

col error_code format a10

break on inst_id skip 1

select *
from gv$asm_operation
order by inst_id, group_number
/

clear breaks

