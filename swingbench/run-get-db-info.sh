#!/bin/sh

sqlplus / as sysdba << EOF
set head off
set echo off
set feedback off
set heading off
spool db-info.txt
select 'DBID= ' || dbid DB_ID from v\$database ;
select 'INSTNUM= ' || instance_number INST_NUM from v\$instance;
spool off
exit
EOF

exit 0

