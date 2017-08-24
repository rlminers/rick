#!/bin/sh

# ############################
# ############################
# OPC | AWS | ExaCld | X4
CLOUD=ExaCS_BMC
SERVICE=half-rack

# vanilla | dbtuning
TEST_TYPE=dbtuning

# connect string
HOST_NAME=`hostname`
DB_SERVICE=pdb1.exacsmainsn.dnsvcnaeg.oraclevcn.com
HOST1=exacsnode-jw00z1
HOST2=exacsnode-jw00z2
HOST3=exacsnode-jw00z3
HOST4=exacsnode-jw00z4
CS="//${HOST_NAME}/${DB_SERVICE}"
# ############################
# ############################

# soe
# CF=swingconfig-10mins.xml
# sh
CF=shconfig-5mins.xml

CWD=`pwd`
PREFIX="${CLOUD}_${SERVICE}_${TEST_TYPE}_Cluster"
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

# User Counts
USER_COUNTS="4 8"
# start nmon
nmon -F $LOG_DIR/${PREFIX}.nmon -T -s 60 -c 10
sleep 5

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

  COMMAND="${CWD}/charbench -g group1 -c $CF -cs //${HOST1}/${DB_SERVICE} -uc $i -r $LOG_DIR/${PREFIX}-${UC}-node1-swingbench.xml -co localhost"
  echo "#!/bin/sh" > lg1.sh
  echo $COMMAND >> lg1.sh
  chmod 755 lg1.sh
  echo "Adding load generator 1 ..."
  ${CWD}/lg1.sh &
  sleep 3

  COMMAND="${CWD}/charbench -g group1 -c $CF -cs //${HOST2}/${DB_SERVICE} -uc $i -r $LOG_DIR/${PREFIX}-${UC}-node2-swingbench.xml -co localhost"
  echo "#!/bin/sh" > lg2.sh
  echo $COMMAND >> lg2.sh
  chmod 755 lg2.sh
  echo "Adding load generator 2 ..."
  ${CWD}/lg2.sh &
  sleep 3

  COMMAND="${CWD}/charbench -g group1 -c $CF -cs //${HOST3}/${DB_SERVICE} -uc $i -r $LOG_DIR/${PREFIX}-${UC}-node3-swingbench.xml -co localhost"
  echo "#!/bin/sh" > lg3.sh
  echo $COMMAND >> lg3.sh
  chmod 755 lg3.sh
  echo "Adding load generator 3 ..."
  ${CWD}/lg3.sh &
  sleep 3

  COMMAND="${CWD}/charbench -g group1 -c $CF -cs //${HOST4}/${DB_SERVICE} -uc $i -r $LOG_DIR/${PREFIX}-${UC}-node4-swingbench.xml -co localhost"
  echo "#!/bin/sh" > lg4.sh
  echo $COMMAND >> lg4.sh
  chmod 755 lg4.sh
  echo "Adding load generator 4 ..."
  ${CWD}/lg4.sh &
  sleep 3

  echo "Starting all load generators ... "
  ${CWD}/coordinator -runall
  sleep 5
  ${CWD}/coordinator -status

  echo "Waiting 5 mins ..."
  sleep 300

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

