#!/bin/sh

FIND=/usr/bin/find
PURGE_DAYS=1
HOSTNAME=`hostname | cut -d '.' -f 1`
ASM_NAME=`cat /etc/oratab | grep -v "^#" | grep -v '^$' | grep ASM | cut -d":" -f1`
RAC_NODE=`echo ${ASM_NAME: -1}`

if [ -z "$HOSTNAME" ]; then
  echo HOSTNAME not set. Exiting...
  exit 1
fi

echo "--------------------------------------------------------------------------------------------------------------"
echo " Purge trace, audit, trm, ..., Rotate alert logs."
echo " Host: $HOSTNAME"
echo " Date: `date`"
echo "--------------------------------------------------------------------------------------------------------------"
echo

purge_dir ()
{
  echo "Start Purge Dir Function"
  DIR=$1
  echo "DIR = $DIR"
  FILE_EXTS="log_*.xml *.trc *.trm *.aud"
  for FILE_EXT in $FILE_EXTS
  do
    if [ -d $DIR ]
    then
       echo "$FIND $DIR -name '$FILE_EXT' -mtime +${PURGE_DAYS} -exec ls -l {} \;"
       $FIND $DIR -name "$FILE_EXT" -mtime +${PURGE_DAYS} -exec ls -l {} \;
       $FIND $DIR -name "$FILE_EXT" -mtime +${PURGE_DAYS} -exec rm -f {} \;
    fi
  done
}

echo "###########################################"
echo "###########################################"

  GRID_HOME=/u01/app/12.1.0.2/grid
ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/db_1
ORACLE_ADMIN=/u01/app/oracle/admin
DIAG_DEST=/u01/app/oracle/diag

echo "#####     ASM     ##### "
purge_dir "$DIAG_DEST/asm/+asm/${ASM_NAME}/trace"

echo "#####     LISTENER     ##### "
purge_dir "$DIAG_DEST/tnslsnr/${HOSTNAME}/listener/alert"
purge_dir "$DIAG_DEST/tnslsnr/${HOSTNAME}/listener_scan1/alert"
purge_dir "$DIAG_DEST/tnslsnr/${HOSTNAME}/listener_scan2/alert"
purge_dir "$DIAG_DEST/tnslsnr/${HOSTNAME}/listener_scan3/alert"

echo "#####     DB     ##### "
purge_dir "$DIAG_DEST/rdbms/orcl/ORCL/trace"

echo "#####     AUDIT     ##### "
purge_dir "$ORACLE_HOME/rdbms/audit"
purge_dir "$GRID_HOME/rdbms/audit"

# ####################################################################
# Rotate logs
# ####################################################################
/usr/sbin/logrotate -v -s /home/oracle/dba/etc/logrotate${RAC_NODE}.status /home/oracle/dba/etc/logrotate${RAC_NODE}.conf

exit 0

