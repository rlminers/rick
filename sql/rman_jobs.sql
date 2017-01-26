select start_time, end_time, output_device_type, status, input_type
from V$RMAN_BACKUP_JOB_DETAILS
where start_time >= trunc(sysdate-3)
order by start_time desc
/

