#!/bin/bash
# #############################################################################
#
# This script sets up all of the required tunnels for the labs.
# It takes input the IP addresses of the DBCS server, JCS WLS Admin server
# and Load Balancer and creates a custome SSH configuration file
# "myssh" which is used to create the tunnels.
#
# DBCS
#   DBaas Monitor
#   Apex console
#   Glassfish console
#   EM Express - DB
#
# JCS
#   WLS Admin console
#   VNC Server support to the WLS Admin server
#   (VNC has to be started on the server)
#
# LB
#   Oracle Traffic Director console
#
# Created by:
# -----------
# Maqsood Alam, Oracle Corp.
#
# #############################################################################
#
# example Usage
# ./setssh.sh 129.144.30.211 ~/.ssh/iaas_key DBONLY
# ps -ef | grep DBCS
# cat myssh
#
# #############################################################################

canI_SSH()
{
	IP=$1
	KEY=$2

	echo -n "** Checking SSH to $IP.. "

	ssh -o "StrictHostKeyChecking no" -o ConnectTimeout=45 -i ${KEY} opc@${IP} echo "SUCCESS!!"

	RETVAL=$?

	if [ $RETVAL != 0 ]
	then
		echo "** ERROR: Unable to SSH to $IP"
		echo "** ERROR: Please check IP/connectivty and run again."
		return 1
	else
		return 0
	fi
}

create_myssh_DBCS()
{
	IP=$1
	KEY=$2
	MYSSHFILE=$3
	echo "** Creating DBCS tunnel config entries for SSH"

cat >> $MYSSHFILE << EOF
Host AlphaDBCS
  hostname ${IP}

  user oracle
  IdentityFile ${KEY}

  # Database Access
  LocalForward 1526 ${IP}:1521

  # Apex and DB Monitor
  # https://localhost:443/apex/apex/pdb1/ .... workspace=internal, username=admin
  # https://localhost:443/dbaas_monitor ..... username=dbaas_monitor
  LocalForward 443 ${IP}:443

  # Glass Fish
  # https://localhost:4848  .... username=admin
  LocalForward 4848 ${IP}:4848

  # Enterprise Manager
  # https://localhost:5501/em  ..... username=sys
  LocalForward 5501 ${IP}:5501

  ServerAliveInterval 60
  StrictHostKeyChecking no

EOF
}

create_myssh_JCS()
{
	IP=$1
	KEY=$2
	MYSSHFILE=$3
	echo "** Creating JCS tunnel config entries for SSH"

cat >> $MYSSHFILE << EOF
Host AlphaJCS
  hostname ${IP}

  user opc
  IdentityFile ${KEY}

  # WLS Admin Server
  #http://localhost:9001/console
  LocalForward 9001 ${IP}:9001

  # VNC
  LocalForward 5901 ${IP}:5901
  RemoteForward 4000 ${IP}:7101

  ServerAliveInterval 60
  StrictHostKeyChecking no

EOF
}

create_myssh_LB()
{
	IP=$1
	KEY=$2
	MYSSHFILE=$3
	echo "** Creating LB tunnel config entries for SSH"

cat >> $MYSSHFILE << EOF
Host AlphaLB
  hostname ${IP}

  user opc
  IdentityFile ${KEY}

  # Oracle Traffic Director Console
  #https://localhost:8989
  LocalForward 8989 ${IP}:8989

  # VNC
  #LocalForward 5902 ${IP}:5901

  ServerAliveInterval 60
  StrictHostKeyChecking no
EOF
}

# #############################################################################
# Main routine
# #############################################################################

echo "**"
echo "** `basename ${0}` `date`"
echo "**"
if (( $# != 3 ))
then
	echo "** ERROR: Usage: `basename ${0}` Public_IP_Addr Key_File [DBONLY | ALL]"
	exit 1
fi

IPADDR=$1
KEYFILE=$2
RUN_MODE=$3
MYSSHOUT="myssh"
SSHOUT="ssh.out"
SSHERR="ssh.err"

# Cleanup previous run
rm -rf $MYSSHOUT $SSHOUT $SSHERR

# Check RUN_MODE
if [ $RUN_MODE != "DBONLY" ] && [ $RUN_MODE != "ALL" ]
then
	echo "** ERROR: Invalid run mode $RUN_MODE provided"
	echo "** ERROR: Please check and run again."
	exit 1;
fi

# Check if Key File exists
if [ ! -f $KEYFILE ]
then
	echo "** ERROR: Key file $KEYFILE does not exist"
	echo "** ERROR: Please provide a valid key file."
	exit 1
fi

# Check IPAddress and Keyfile via SSH
canI_SSH $IPADDR $KEYFILE

if [ $? != 0 ]
then
	exit 1
fi

# Check sudo
if (sudo -n true 2>/dev/null)
then
	echo "** Checking sudo.. SUCCESS!"
else
	echo "** Checking sudo.. please enter password for sudo.."
	sudo ls > /dev/null 2>&1

	# Check if sudo works now
	if (! sudo -n true 2>/dev/null)
	then
		echo "** ERROR: sudo failed, cannot proceed without sudo"
		exit 1
	fi
fi

if [ $RUN_MODE == "DBONLY" ]
then
	# Create SSH configs
	create_myssh_DBCS $IPADDR $KEYFILE $MYSSHOUT

	# Create DBONLY Tunnels
	sudo ssh -t -t -F $MYSSHOUT AlphaDBCS > $SSHOUT 2>$SSHERR &

	if [ $? != 0 ]
	then
		echo "** ERROR: Unable to create DBONLY Tunnels"
		exit 1
	fi
elif [ $RUN_MODE == "ALL" ]
then
	# Create SSH configs
	create_myssh_DBCS $IPADDR $KEYFILE $MYSSHOUT
	create_myssh_JCS $IPADDR $KEYFILE $MYSSHOUT
	create_myssh_LB $IPADDR $KEYFILE $MYSSHOUT

	# Create DBONLY Tunnels
	sudo ssh -t -t -F $MYSSHOUT AlphaDBCS > $SSHOUT 2>$SSHERR &

	if [ $? != 0 ]
	then
		echo "** ERROR: Unable to create DBCS Tunnels"
		exit 1
	fi

	sudo ssh -t -t -F $MYSSHOUT AlphaJCS > $SSHOUT 2>$SSHERR &
	if [ $? != 0 ]
	then
		echo "** ERROR: Unable to create JCS Tunnels"
		exit 1
	fi

	sudo ssh -t -t -F $MYSSHOUT AlphaLB > $SSHOUT 2>$SSHERR &
	if [ $? != 0 ]
	then
		echo "** ERROR: Unable to create LB Tunnels"
		exit 1
	fi
fi

echo "**"
echo "** Tunnels have been successfully created for $IPADDR"
echo "** !!! DO NOT CLOSE THIS TERMINAL WINDOW !!!"
echo "** `basename ${0}` `date`"
echo "**"
exit 0
