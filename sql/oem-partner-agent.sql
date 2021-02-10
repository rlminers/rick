set lines 120
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

-- xp10dbda1node02.veritracks.com
-- xp10dbda1node05.veritracks.com
-- xd10db01.veritracks.com
-- xd10db01.veritracks.com

