#!/bin/sh

SERVER_TYPE=$1
SERVER_IP=$2
PORT=$3

# find utility
which nc
RC_NC=$?

if [ $RC_NC = 0 ]
then
  USE_NC=0
  echo "USE_NC = $USE_NC"
  CMD="nc -z -w1 $SERVER_IP $PORT"
  echo "CMD = $CMD"
  $CMD
  if [ $SERVER_TYPE = "SERVER" ]
  then
    SERVER_START="java -jar oratcptest.jar -server $SERVER_IP -port=$PORT"
    echo $SERVER_START
  else
    LATENCY_TEST="java -jar oratcptest.jar $SERVER_IP -mode=sync -length=0 -duration=1s -interval=1s -port=$PORT"
    echo $LATENCY_TEST
    THROUGHPUT_TEST="java -jar oratcptest.jar $SERVER_IP -mode=async -duration=10s -interval=2s -port=$PORT"
    echo $THROUGHPUT_TEST
  fi
fi


exit 0

# connectivity tests
# timeout 1 bash -c 'cat < /dev/null > /dev/tcp/129.152.166.162/22'
# nc -z -w1 192.168.10.3 3306

# latency
# java -jar oratcptest.jar -server 10.10.2.3 -port=1521
# java -jar oratcptest.jar 10.10.2.3 -mode=sync -length=0 -duration=1s -interval=1s -port=1521

# throughput
# java -jar oratcptest.jar -server 10.0.0.2 -port=1521
# java -jar oratcptest.jar 10.0.0.2 -mode=async -duration=10s -interval=2s -port=1521


