
set verify off

clear breaks

col username format a30
col sid format 99999
col machine format a32
col service_name format a20
col status_count format 999,999
col status format a8

break on inst_id skip 1 on username skip 1 on service_name skip 1 on machine skip 1 on status skip 1

set feedback off

select inst_id
, username
, service_name
, machine
, status
, count(status) status_count
from gv$session
where UPPER(username) like NVL( UPPER( '&&username' ), username )
and username not in ( 'SYS','SYSTEM','DBSNMP' )
--and inst_id like NVL( '&&instance_id', inst_id )
--and UPPER( service_name ) like NVL( '&&service_name' , service_name )
group by inst_id
, username
, service_name
, machine
, status
order by 1,2,3,4,5
/

clear breaks
break on inst_id skip 1 on service_name skip 1 on report
compute sum of num_conns on report

select inst_id
, service_name
, username
, count(1) num_conns
from gv$session
where UPPER(username) like NVL( UPPER( '&username' ), username )
--and inst_id like NVL( '&instance_id', inst_id )
--and UPPER( service_name ) like NVL( '&service_name' , service_name )
and username not in ( 'SYS','SYSTEM','DBSNMP' )
group by inst_id
, service_name
, username
order by inst_id
, service_name
, username
/

undef username
undef service_name
undef instance_id
set verify on
set feedback on
clear breaks
clear computes

