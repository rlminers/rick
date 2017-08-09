#!/bin/sh

SERVER_IP=$1
PORT=$2

# find utility
which nc
RC_NC=$?

which timeout
RC_TO=$?

if [ $RC_NC = 0 ]
then
  echo "Using nc ..."
  UTIL=nc
  CMD="nc -z -w1 $SERVER_IP $PORT"
elif [ $RC_TO = 0 ]
then
  echo "Using timeout ..."
  UTIL=to
  CMD="timeout 1 bash -c 'cat < /dev/null > /dev/tcp/${SERVER_IP}/${PORT}'"
  echo $?
else
  echo "Did not find utility to test report port"
fi

DBaaS_PORTS="22 80 443 1158 1521 4848 5500"
for PORTN in $DBaaS_PORTS
do
  echo "Checking port $PORTN ... "
  if [ $UTIL = "nc" ]
  then
    echo "$CMD"
    $CMD
  elif [ $UTIL = "to" ]
  then
    CMD="timeout 1 bash -c 'cat < /dev/null > /dev/tcp/${SERVER_IP}/${PORTN}'"
    echo "$CMD"
    timeout 1 bash -c "cat < /dev/null > /dev/tcp/${SERVER_IP}/${PORTN}"
    echo $?
    echo
    echo
  else
    echo "error"
  fi
done

exit 0

