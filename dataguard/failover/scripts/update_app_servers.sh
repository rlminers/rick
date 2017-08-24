#!/bin/sh

# db1nvme : 129.146.17.108
# db2nvme : 129.146.3.211

# bmc
# psapp1 : 129.146.28.131 10.10.7.2

HN=`hostname`
CWD=/home/oracle/failover/scripts
SSH_KEY_FILE=${CWD}/BareMetal_openssh

if [ "$HN" == "dbaas36cpu" ]
then
	# switch to db1nvme
	ssh -i ${SSH_KEY_FILE} opc@129.146.17.62 "sudo cp /etc/hosts-dbaas36cpu /etc/hosts"
	ssh -i ${SSH_KEY_FILE} opc@129.146.1.106 "sudo cp /etc/hosts-dbaas36cpu /etc/hosts"
elif [ "$HN" == "dbaasstby" ]
then
	# switch to db2nvme
	ssh -i ${SSH_KEY_FILE} opc@129.146.17.62 "sudo cp /etc/hosts-dbaasstby /etc/hosts"
	ssh -i ${SSH_KEY_FILE} opc@129.146.1.106 "sudo cp /etc/hosts-dbaasstby /etc/hosts"
fi

exit 0

