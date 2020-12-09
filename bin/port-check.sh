#!/bin/sh

HOST=$1
PORT=$2

TOOLS="nmap nc timeout"
TOOL_TO_RUN=""

for tool in $TOOLS
do
    which $tool
    RC=$?
    echo $RC
    if [ $RC -eq 0 ]
    then
        TOOL_TO_RUN=$tool
        echo "break on $tool"
        break
    fi
done

if [ "$TOOL_TO_RUN" = "nmap" ]
then
    CMD="nmap -Pn -p $PORT $HOST"
elif [ "$TOOL_TO_RUN" = "nc" ]
then
    CMD="nc -z -w1 $HOST $PORT"
elif [ "$TOOL_TO_RUN" = "timeout" ]
then
    CMD="timeout 1 bash -c 'cat < /dev/null > /dev/tcp/${HOST}/${PORT}'; echo $?"
fi

#> nc -z -w1 cdh-master 21050
#> timeout 1 bash -c 'cat < /dev/null > /dev/tcp/cdh-master/21050'; echo $?
#> nmap -Pn -p 21050 cdh-master

echo
echo $CMD
echo

