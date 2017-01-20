#!/bin/sh

# ############################
# ############################
# opc | aws | ExaCld | X4 | x86
CLOUD=bmc
# compute | dbcs | ec2 | rds | other
SERVICE=bare_metal_72cpu
# SINGLE | PDB
DB_TYPE=PDB

# vanilla | dbtuning
TEST_TYPE=vanilla

# user count
UC=200

# connect string
HOST_NAME=`hostname`
DB_SERVICE=pdb1.aeg
CS="//${HOST_NAME}/${DB_SERVICE}"
# ############################
# ############################

CF=swingconfig-90mins.xml
CWD=`pwd`
PREFIX="${CLOUD}_${SERVICE}_${DB_TYPE}_${TEST_TYPE}_${UC}"
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

./run-create-awr-snap.sh start
START_SNAP=`cat start_snap_id.txt | grep -v select | grep "SNAP=" | awk '{print $2}'`
echo "START_SNAP = $START_SNAP"
mv start_snap_id.txt $LOG_DIR

# start nmon
nmon -F $LOG_DIR/${PREFIX}.nmon -T -s 30 -c 190

# start oswbb
cd /home/oracle/rick/OSWatcherBB/oswbb
./stopOSWbb.sh
rm -rf archive/
./startOSWbb.sh 60 4
sleep 60
cd $CWD

# start charbench
nohup ${CWD}/charbench -c $CF -cs $CS -uc $UC -r $LOG_DIR/${PREFIX}-swingbench.xml -a -v users,tpm,tps,cpu > charbench.out &

# ############################
# collect reports every 15 min
# ############################

for i in {1..6}
do
  echo "loop counter = $i"
  date
  sleep 900
  iostat -x 2 5 > iostat_${i}.out
  mv iostat_${i}.out $LOG_DIR
  ./run-create-awr-snap.sh ${i}
  array1[$i]=`cat ${i}_snap_id.txt | grep -v select | grep "SNAP=" | awk '{print $2}'`
  echo "snap ${i} = ${array1[$i]}"
  mv ${i}_snap_id.txt $LOG_DIR
done

# stop oswbb
cd /home/oracle/rick/OSWatcherBB/oswbb
./stopOSWbb.sh
sleep 5
mv archive $LOG_DIR
cd $CWD

# generate AWRRPTs
getawr ${START_SNAP} ${array1[1]} $PREFIX ${INSTNUM} $LOG_DIR
getawr ${array1[1]}  ${array1[2]} $PREFIX ${INSTNUM} $LOG_DIR
getawr ${array1[2]}  ${array1[3]} $PREFIX ${INSTNUM} $LOG_DIR
getawr ${array1[3]}  ${array1[4]} $PREFIX ${INSTNUM} $LOG_DIR
getawr ${array1[4]}  ${array1[5]} $PREFIX ${INSTNUM} $LOG_DIR
getawr ${array1[5]}  ${array1[6]} $PREFIX ${INSTNUM} $LOG_DIR
getawr ${START_SNAP} ${array1[6]} $PREFIX ${INSTNUM} $LOG_DIR
getawr ${array1[1]}  ${array1[5]} $PREFIX ${INSTNUM} $LOG_DIR

mv charbench.out $LOG_DIR

exit 0

