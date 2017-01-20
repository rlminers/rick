#!/bin/sh

# connect string
HOST_NAME=`hostname`
DB_SERVICE=pdb1.aeg
CS="//${HOST_NAME}/${DB_SERVICE}"
# ############################
# ############################

CF=oewizard.xml

./oewizard -c $CF -cl -cs $CS -u soe -p soe -ts soe -create -hashpart -tc 12 -scale 1 -dbap "Enk1tec#_Aeg1"

exit 0

