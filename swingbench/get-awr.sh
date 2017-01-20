#!/bin/sh

BID=$1
EID=$2
PREFIX=$3

sqlplus / as sysdba << EOF
@run-awrrpt.sql $BID $EID ${PREFIX}
exit
EOF

exit 0

