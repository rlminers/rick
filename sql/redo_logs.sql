
-- RAC

col member format a50

break on group# skip 1

select a.inst_id , a.group#
, b.status
, a.member
, b.bytes/1024/1024 "SIZE_MB"
from gv$logfile a, gv$log b
where a.group# = b.group#
and a.inst_id = b.inst_id
order by 1,2;

