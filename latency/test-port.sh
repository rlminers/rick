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
  CMD="nc -z -w1 $SERVER_IP $PORT"
  echo "$CMD"
  $CMD
elif [ $RC_TO = 0 ]
then
  echo "Using timeout ..."
  CMD="timeout 1 bash -c 'cat < /dev/null > /dev/tcp/${SERVER_IP}/${PORT}'"
  echo "$CMD"
  timeout 1 bash -c "cat < /dev/null > /dev/tcp/${SERVER_IP}/${PORT}"
  echo $?
else
  echo "Did not find utility to test report port"
fi

exit 0

