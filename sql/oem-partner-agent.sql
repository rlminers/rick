set lines 120
set pages 100
col agent format a50
col buddy format a50

select b.target_name agent
, c.target_name buddy
from sysman.em_agent_buddy_map a
, sysman.em_targets b
, sysman.em_targets c
where a.agent_target_guid = b.target_guid
and a.buddy_target_guid = c.target_guid
order by 1,2
;

select b.target_name agent
, c.target_name buddy
from sysman.em_agent_buddy_map a
, sysman.em_targets b
, sysman.em_targets c
where a.agent_target_guid = b.target_guid
and a.buddy_target_guid = c.target_guid
and lower(c.target_name) like 'xp10%'
order by 1,2
;

select b.target_name agent
, c.target_name buddy
from sysman.em_agent_buddy_map a
, sysman.em_targets b
, sysman.em_targets c
where a.agent_target_guid = b.target_guid
and a.buddy_target_guid = c.target_guid
and lower(c.target_name) not like 'xp10%'
order by 1,2
;

-- xp10dbda1node02.veritracks.com
-- xp10dbda1node05.veritracks.com
-- xd10db01.veritracks.com
-- xd10db01.veritracks.com

-- EM 12c: Agent Unreachable Alert 'Host Down - Detected by Partner Agent' 'Agent has stopped monitoring. Read timed out' (Doc ID 1950494.1)
-- EM 12c,EM 13c: How to Disable the Partner Agent to Avoid Alerts in Enterprise Manager Cloud Control (Doc ID 1927827.1)
-- EM12c, EM13c : Troubleshooting Agent Unreachable Alert 'Host Down - Detected by Partner Agent' 'Agent has stopped monitoring. Read timed out' (Doc ID 2101383.1)
-- EM12c, EM13c : Troubleshooting Agent Unreachable Alert 'Host Down - Detected by Partner Agent' 'Agent has stopped monitoring. Read timed out' (Doc ID 2101383.1)

/*

[oracle@xp10dbda1node01 bin]$ cd /u01/app/oracle/agent/agent_13.4.0.0.0/bin

[oracle@xp10dbda1node01 bin]$ ./emctl stop agent
Oracle Enterprise Manager Cloud Control 13c Release 4
Copyright (c) 1996, 2020 Oracle Corporation.  All rights reserved.
Stopping agent ... stopped.

[oracle@xp10dbda1node01 bin]$ ./emctl setproperty agent  -allow_new -name AgentPersistenceTimeout -value 240
Oracle Enterprise Manager Cloud Control 13c Release 4
Copyright (c) 1996, 2020 Oracle Corporation.  All rights reserved.
EMD setproperty succeeded

[oracle@xp10dbda1node01 bin]$ ./emctl start agent
Oracle Enterprise Manager Cloud Control 13c Release 4
Copyright (c) 1996, 2020 Oracle Corporation.  All rights reserved.
Starting agent ....................... started.

[oracle@xp10dbda1node01 bin]$ ./emctl getproperty agent -name AgentPersistenceTimeout
Oracle Enterprise Manager Cloud Control 13c Release 4
Copyright (c) 1996, 2020 Oracle Corporation.  All rights reserved.
AgentPersistenceTimeout=240

[oracle@xp10dbda1node01 bin]$ ./emctl status agent

*/

