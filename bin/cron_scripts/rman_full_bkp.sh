#!/bin/sh

PATH=/usr/local/bin:$PATH
export PATH

NLS_DATE_FORMAT="yy-mm-dd hh24:mi"
export NLS_DATE_FORMAT

HOME_DIR=/home/oracle/rick/bin/cron_scripts

SID="ORCL"
ORACLE_SID=$SID
ORAENV_ASK=NO
. /usr/local/bin/oraenv
export ORACLE_SID
export ORACLE_HOME

LOGFILE=$HOME/dba/log/${ORACLE_SID}_rman_full_bkp.log

$ORACLE_HOME/bin/rman target / nocatalog <<EOF
SET ENCRYPTION IDENTIFIED BY "iforgot" ONLY;
@${HOME_DIR}/rman_full_bkp.rcv
@${HOME_DIR}/rman_crosscheck2.rcv
exit
EOF

exit 0

