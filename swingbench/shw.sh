#!/bin/sh

SBH=/home/oracle/swingbench

# connect string
HOST_NAME=`hostname`
DB_SERVICE=pdb1.aeg
CS="//${HOST_NAME}/${DB_SERVICE}"
# ############################
# ############################

CF=shwizard-1tb.xml

${SBH}/bin/shwizard -c $CF -cl -create -cs $CS -u sh -p sh -ts sh -dbap "Enk1tec#_Aeg1" -scale 99

exit 0

