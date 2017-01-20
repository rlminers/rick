#!/bin/sh

# ############################
# ############################
# OPC | AWS | ExaCld | X4
CLOUD=opc
SERVICE=BareMetal

# vanilla | dbtuning
TEST_TYPE=dbtuning-vl_72cpu

# connect string
HOST_NAME=`hostname`
DB_SERVICE=pdb1
CS="//${HOST_NAME}/${DB_SERVICE}"
# ############################
# ############################

CF=swingconfig-10mins.xml
CWD=`pwd`
PREFIX="${CLOUD}_${SERVICE}_${TEST_TYPE}_VariableLoad"
LOG_DIR=${CWD}/benchmark/${CLOUD}/${PREFIX}
if [ ! -d $LOG_DIR ]
then
  mkdir -p $LOG_DIR
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

# start nmon
nmon -F $LOG_DIR/${PREFIX}.nmon -T -s 60 -c 92

# start oswbb
cd /home/oracle/rick/OSWatcherBB/oswbb
./stopOSWbb.sh
rm -rf archive/
./startOSWbb.sh 60 4
sleep 60
cd $CWD

# ############################
# main
# ############################

for i in 100 200 300 400 500 600 700
do
  echo "loop counter = $i"
  date
  UC=$i

  # create awr snap
  ./run-create-awr-snap.sh 1
  snap1=`cat 1_snap_id.txt | grep -v select | grep "SNAP=" | awk '{print $2}'`
  echo "snap 1 = $snap1"

  # run charbench
  ${CWD}/charbench -c $CF -cs $CS -uc $UC -r $LOG_DIR/${PREFIX}-${UC}-swingbench.xml -a -v users,tpm,tps,cpu

  # create awr snap
  ./run-create-awr-snap.sh 2
  snap2=`cat 2_snap_id.txt | grep -v select | grep "SNAP=" | awk '{print $2}'`
  echo "snap 2 = $snap2"

  # generate AWRRPT
  echo "getawr $snap1 $snap2 $PREFIX-$i ${INSTNUM} $LOG_DIR"
  getawr $snap1 $snap2 $PREFIX-$i ${INSTNUM} $LOG_DIR
  sleep 5
done

# stop oswbb
cd /home/oracle/rick/OSWatcherBB/oswbb
./stopOSWbb.sh
sleep 20
mv /home/oracle/rick/OSWatcherBB/oswbb/archive .
cd $CWD

exit 0

