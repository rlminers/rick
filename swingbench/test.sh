#!/bin/sh

# connect string
HOST_NAME=`hostname`
DB_SERVICE=pdb1.aeg
CS="//${HOST_NAME}/${DB_SERVICE}"
# ############################
# ############################

CF=swingconfig-5mins.xml

# start charbench
rm erase-swingbench.xml
./charbench -c $CF -cs $CS -uc 5 -r erase-swingbench.xml -a -v users,tpm,tps,cpu

exit 0

