#!/bin/sh

PATH=/usr/local/bin:$PATH
export PATH

NLS_DATE_FORMAT="yy-mm-dd hh24:mi"
export NLS_DATE_FORMAT

HOME_DIR=/home/oracle/rick/bin/cron_scripts

SIDS="ORCL"

for SID in $SIDS
do

  ORACLE_SID=$SID
  ORAENV_ASK=NO

  . /usr/local/bin/oraenv

  export ORACLE_SID
  export ORACLE_HOME

#  PATH=$ORACLE_HOME/bin:$PATH
#  export PATH

  LOGFILE=$HOME/dba/log/${ORACLE_SID}_rman.log

$ORACLE_HOME/bin/rman target / nocatalog <<EOF
@${HOME_DIR}/rman_del_arc_logs.rcv
exit
EOF

done

exit 0

