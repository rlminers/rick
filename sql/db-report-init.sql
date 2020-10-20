-- --------------------------------------------------
-- --------------------------------------------------
undefine r_db_name
undefine r_db_uniq_name

-- --------------------------------------------------
-- --------------------------------------------------
col r_db_name      new_value r_db_name
col r_db_uniq_name new_value r_db_uniq_name

-- --------------------------------------------------
-- --------------------------------------------------
col name format a12
col db_unique_name format a14
col host_name format a24

set termout off
select name as r_db_name
, db_unique_name as r_db_uniq_name
from gv$database;

-- select i.inst_id as r_inst_id
-- , i.instance_name as r_inst_name
-- , i.host_name as r_host_name
-- , d.name as r_db_name
-- , d.db_unique_name r_db_uniq_name
-- , i.version
-- , i.edition
-- from gv$instance i
-- , gv$database d
-- where i.inst_id = d.inst_id
-- /

-- --------------------------------------------------
-- --------------------------------------------------
variable r_db_name      varchar2(128);
variable r_db_uniq_name varchar2(128);

exec :r_db_name      :='&r_db_name';
exec :r_db_uniq_name :='&r_db_uniq_name';

-- --------------------------------------------------
-- --------------------------------------------------
select :r_db_name as r_db_name
, :r_db_uniq_name as r_db_uniq_name
from dual;

set termout on

