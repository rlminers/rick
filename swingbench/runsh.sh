#!/bin/sh

# ############################
# ############################
# opc | aws | ExaCld | X4 | x86
CLOUD=bmc_dbaas_denseio
# compute | dbcs | ec2 | rds | other
SERVICE=compute
# SINGLE | PDB
DB_TYPE=pdb_noarchivelog

# vanilla | dbtuning
TEST_TYPE=dbtuning

# user count
UC=1

# connect string
HOST_NAME=`hostname`
DB_SERVICE=pdbps.bmcdenseiosubne.dnsvcnaeg.oraclevcn.com
CS="//${HOST_NAME}/${DB_SERVICE}"
# ############################
# ############################

CF=shconfig-30mins.xml
CWD=`pwd`
PREFIX="${CLOUD}_${SERVICE}_${DB_TYPE}_${TEST_TYPE}_${UC}"
LOG_DIR=${CWD}/benchmark/${CLOUD}/${PREFIX}
if [ ! -d $LOG_DIR ]
then
  mkdir -p $LOG_DIR
else
  echo "Directory already exists.  Please update variables to choose another directory."
  exit 1
fi

PATH=.:$PATH
export PATH

getawr () {
./get-awr.sh ${1} ${2} ${3}
mv awrrpt_${4}_${1}_${2}_${3}.html $5

}

./run-get-db-info.sh
DBID=`cat db-info.txt | grep -v select | grep "DBID=" | awk '{print $2}'`
echo "DBID = $DBID"
INSTNUM=`cat db-info.txt | grep -v select | grep "INSTNUM=" | awk '{print $2}'`
echo "INSTNUM = $INSTNUM"
mv db-info.txt $LOG_DIR

./run-create-awr-snap.sh start
START_SNAP=`cat start_snap_id.txt | grep -v select | grep "SNAP=" | awk '{print $2}'`
echo "START_SNAP = $START_SNAP"
mv start_snap_id.txt $LOG_DIR

# start nmon
nmon -F $LOG_DIR/${PREFIX}.nmon -T -s 60 -c 31
sleep 20

# start charbench
rm -f nohup.out
nohup ${CWD}/charbench -c $CF -cs $CS -uc $UC -r $LOG_DIR/${PREFIX}-sh-swingbench.xml -a -v users,tpm,tps,cpu > charbench.out &

sleep 1800

# ############################
./run-create-awr-snap.sh end
END_SNAP=`cat end_snap_id.txt | grep -v select | grep "SNAP=" | awk '{print $2}'`
echo "END_SNAP = $END_SNAP"
mv end_snap_id.txt $LOG_DIR

# generate AWRRPT
getawr ${START_SNAP} ${END_SNAP} $PREFIX ${INSTNUM} $LOG_DIR

mv charbench.out $LOG_DIR

exit 0

