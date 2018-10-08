#!/bin/sh

PORTS="7809 7810 7811 7812 7813 7814 7815 7816 7817 7818 7819 7820"

for PORT in $PORTS
do
  java -cp . SocketTest $PORT &
  sleep 1
done

ps -ef | grep Socket

exit 0

