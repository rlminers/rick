#!/bin/sh

# ############################
# ############################
# OPC | AWS | ExaCld | X4
CLOUD=bmc
SERVICE=oda-rac-72cpu-count

# vanilla | dbtuning
TEST_TYPE=dbtuning

# connect string
HOST_NAME=`hostname`
DB_SERVICE=odapdb1.aeg
CS="//${HOST_NAME}/${DB_SERVICE}"
# ############################
# ############################

CF=swingconfig-10mins.xml
CWD=`pwd`
PREFIX="${CLOUD}_${SERVICE}_${TEST_TYPE}_Cluster"
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

# User Counts
USER_COUNTS="100 200 300 400 500 600"
# start nmon
nmon -F $LOG_DIR/${PREFIX}.nmon -T -s 60 -c 64

# ############################
# main
# ############################

for i in $USER_COUNTS
do
  echo "loop counter = $i"
  date
  UC=$i

  # create awr snap
  ./run-create-awr-snap.sh 1
  snap1=`cat 1_snap_id.txt | grep -v select | grep "SNAP=" | awk '{print $2}'`
  echo "snap 1 = $snap1"

  # run charbench
echo "Starting Coordinator ..."
  ${CWD}/coordinator -c &
sleep 5

  COMMAND="${CWD}/charbench -g group1 -c $CF -cs //odanode1/odapdb1.aeg -uc $i -r $LOG_DIR/${PREFIX}-${UC}-node1-swingbench.xml -co localhost"
  echo "#!/bin/sh" > lg1.sh
  echo $COMMAND >> lg1.sh
  chmod 755 lg1.sh
  echo "Adding load generator 1 ..."
  ${CWD}/lg1.sh &
  sleep 3

  COMMAND="${CWD}/charbench -g group1 -c $CF -cs //odanode2/odapdb1.aeg -uc $i -r $LOG_DIR/${PREFIX}-${UC}-node2-swingbench.xml -co localhost"
  echo "#!/bin/sh" > lg2.sh
  echo $COMMAND >> lg2.sh
  chmod 755 lg2.sh
  echo "Adding load generator 2 ..."
  ${CWD}/lg2.sh &
  sleep 3

echo "Starting all load generators ... "
  ${CWD}/coordinator -runall
  sleep 5
  ${CWD}/coordinator -status

echo "Waiting 10 mins ..."
  sleep 600

echo "Stopping all load generators ... "

  ${CWD}/coordinator -stopall
  ${CWD}/coordinator -kill

  # create awr snap
  ./run-create-awr-snap.sh 2
  snap2=`cat 2_snap_id.txt | grep -v select | grep "SNAP=" | awk '{print $2}'`
  echo "snap 2 = $snap2"

  # generate AWRRPT
  echo "getawr $snap1 $snap2 $PREFIX-$i ${INSTNUM} $LOG_DIR"
  getawr $snap1 $snap2 $PREFIX-$i ${INSTNUM} $LOG_DIR
  sleep 5
done

./get_cluster_results.sh "$CLOUD" "$PREFIX" "$USER_COUNTS"

exit 0

