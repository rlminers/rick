#!/bin/sh

DBID=$1
INST_NUM=$2
BID=$3
EID=$4
RPT_NAME=$5

sqlplus / as sysdba << EOF
spool awrrpt_${RPT_NAME}.html
select output
from table(dbms_workload_repository.awr_report_html(
$DBID ,
$INST_NUM ,
$BID ,
$EID ,
1
));
spool off
exit
EOF

exit 0

