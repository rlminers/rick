
@@dr_hours_behind

break on inst_id skip 1

SELECT inst_id, process, thread#, status, count(thread#)
FROM   GV$MANAGED_STANDBY
group by inst_id, process, thread#, status
order by inst_id, process, thread#, status
/

SELECT process, thread#, status, count(thread#)
FROM   GV$MANAGED_STANDBY
group by process, thread#, status
order by process, thread#, status
/

