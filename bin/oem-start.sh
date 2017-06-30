#!/bin/bash
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2/dbhome_1
export OMS_HOME=/u02/app/oracle/product/13.2.0.0/middleware
export AGENT_HOME=/u02/app/oracle/product/13.2.0.0/em_agent/agent_inst

# Start everything
$ORACLE_HOME/bin/dbstart $ORACLE_HOME

$OMS_HOME/bin/emctl start oms

$AGENT_HOME/bin/emctl start agent

