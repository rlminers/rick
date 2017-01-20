#!/bin/sh

sqlplus / as sysdba << EOF
show con_name
exec dbms_workload_repository.create_snapshot; 
set head off
spool $1_snap_id.txt
select 'SNAP= ' || max(snap_id) from dba_hist_snapshot;
spool off
exit
EOF

exit 0

