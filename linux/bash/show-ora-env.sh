#!/bin/bash

HOST=`hostname`

echo
echo "# Oracle SID : $ORACLE_SID"
echo "# Host       : $HOST"
echo

# PS1 = [\u@\h \W]\$
PS1="[\u@${ORACLE_SID}\/\/\h \W]\$"
export PS1

