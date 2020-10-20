--
--set colsep ,
--set headsep off
--set pagesize 0
set pages 1000
--set trimspool on
set lines 300
--
col name format a40
col type_desc format a15
col db_name format a12
col db_uniq_name format a12
col value format a30
--
--select inst_id, instance_name, host_name, version, edition from gv$instance;
--
/*
select i.inst_id as r_inst_id
, i.instance_name as r_inst_name
, i.host_name as r_host_name
, d.name as r_db_name
, d.db_unique_name r_db_uniq_name
, i.version
, i.edition
from gv$instance i
, gv$database d
where i.inst_id = d.inst_id
*/

--
select inst_id
, :r_db_name as db_name
--, :r_db_uniq_name as db_uniq_name
, name
, value
, type
, case type
  when 1 then 'Boolean'
  when 2 then 'String'
  when 3 then 'Integer'
  when 4 then 'Parameter file'
  when 5 then 'Reserved'
  when 6 then 'Big integer'
end as type_desc
, issys_modifiable
, isinstance_modifiable
from gv$parameter
--where rownum < 10
order by inst_id
, name;

