select process, thread#, count(1)
from v$managed_standby
group by process, thread#
order by process, thread#
/
