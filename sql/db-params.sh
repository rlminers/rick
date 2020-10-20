#!/bin/sh

# egrep -i "INST_ID|--------|block_size"

sqlplus / as sysdba << EOF
@db-report-init.sql
@get_params.sql
EOF

exit 0

