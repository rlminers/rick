#!/bin/sh

CWD=`pwd`
CLOUD=$1
PREFIX=$2
USER_COUNTS="$3"
LOG_DIR=${CWD}/benchmark/${CLOUD}/${PREFIX}

PATH=.:$PATH
export PATH

# ############################
# main
# ############################
RFILE=$LOG_DIR/${PREFIX}-swingbench.csv
echo "number_of_users,node,TotalCompletedTransactions,AverageTransactionsPerSecond,CustomerRegistration,UpdateCustomerDetails,BrowseProducts,OrderProducts,ProcessOrders,BrowseOrders,AverageResponse" > $RFILE

for i in $USER_COUNTS
do
  echo "loop counter = $i"
  UC=$i
  TTRANS1=0
  TPS1=0
  TTRANS2=0
  TPS2=0
  SUMTTRANS=0
  SUMTPS=0
  LFS=0
  LFPW=0
  AVERAGE=0

  TTRANS1=`cat $LOG_DIR/${PREFIX}-${UC}-node1-swingbench.xml | grep TotalCompletedTransactions   | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
     TPS1=`cat $LOG_DIR/${PREFIX}-${UC}-node1-swingbench.xml | grep AverageTransactionsPerSecond | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
  NSTRING=""
  CNTR=0
  SUMR=0
  DIV=0
  grep AverageResponse $LOG_DIR/${PREFIX}-${UC}-node1-swingbench.xml | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | while read -r line ; do
    (( CNTR = CNTR + 1 ))
    SUMR=$(echo "$SUMR + $line" | bc)
    NSTRING+=", $line"
    if [ $CNTR = 6 ]; then
      DIV=$(echo "$SUMR/$CNTR" | bc -l)
      echo "$NSTRING , $DIV" > /tmp/nstring.txt
    fi
  done
  NSTRING=`cat /tmp/nstring.txt`
  echo "$UC , node1 , $TTRANS1 , $TPS1 $NSTRING" >> $RFILE

  TTRANS2=`cat $LOG_DIR/${PREFIX}-${UC}-node2-swingbench.xml | grep TotalCompletedTransactions   | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
     TPS2=`cat $LOG_DIR/${PREFIX}-${UC}-node2-swingbench.xml | grep AverageTransactionsPerSecond | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
  NSTRING=""
  CNTR=0
  SUMR=0
  DIV=0
  grep AverageResponse $LOG_DIR/${PREFIX}-${UC}-node2-swingbench.xml | awk -F">" '{print $2}' | awk -F"<" '{print $1}' | while read -r line ; do
    (( CNTR = CNTR + 1 ))
    SUMR=$(echo "$SUMR + $line" | bc)
    NSTRING+=", $line"
    if [ $CNTR = 6 ]; then
      DIV=$(echo "$SUMR/$CNTR" | bc -l)
      echo "$NSTRING , $DIV" > /tmp/nstring.txt
    fi
  done
  NSTRING=`cat /tmp/nstring.txt`
  echo "$UC , node2 , $TTRANS2 , $TPS2 $NSTRING" >> $RFILE

  SUMTTRANS=$(($TTRANS1 + $TTRANS2))
  SUMTPS=$(echo "$TPS1 + $TPS2" | bc)
  echo " , TOTALS , $SUMTTRANS , $SUMTPS" >> $RFILE

  LFS=`cat $LOG_DIR/awrrpt*$PREFIX-$i.html | grep -i 'log file sync' | grep Commit | grep -v FOREGROUND | awk -F"class" '{print $5}' | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
  echo " , log file sync , $LFS" >> $RFILE

  LFPW=`cat $LOG_DIR/awrrpt*$PREFIX-$i.html | grep -i -m 1 'log file parallel write' | awk -F"class" '{print $6}' | awk -F">" '{print $2}' | awk -F"<" '{print $1}'`
  echo " , log file parallel write , $LFPW" >> $RFILE
done

exit 0

