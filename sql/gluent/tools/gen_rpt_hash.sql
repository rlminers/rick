set heading off
set verify off
set feedback off

undefine gluent_tab_owner
undefine gluent_tab_name

col gluent_tab_owner new_value gluent_tab_owner
col gluent_tab_name  new_value gluent_tab_name

set termout off
select UPPER('&1') as gluent_tab_owner from dual;
select UPPER('&2') as gluent_tab_name  from dual;
set termout on

variable gluent_tab_owner VARCHAR2(120);
variable gluent_tab_name  VARCHAR2(120);

--BEGIN
exec  :gluent_tab_owner := '&gluent_tab_owner';
exec  :gluent_tab_name  := '&gluent_tab_name';
--END;
--/


spool rpt_hash_out/temp_rpt_hash.sql

select 'spool rpt_hash_out/rpt_hash_' || :gluent_tab_owner || '_' || :gluent_tab_name || '.out' from dual;
select 'set heading on' from dual;
select 'set lines 120' from dual;
select 'set pages 1000' from dual;

select * from (
  select '@rpt_hash ' || tcs.column_name || ' ' || tcs.owner || ' ' || tcs.table_name 
  from   
         dba_tab_col_statistics tcs
  ,      dba_tab_columns dtc
  where
         tcs.owner = Upper(:gluent_tab_owner)
         and tcs.table_name like Upper(:gluent_tab_name)
         and tcs.owner = dtc.owner
         and tcs.table_name = dtc.table_name
         and tcs.column_name = dtc.column_name
         --and dtc.nullable='N'
         and tcs.num_nulls = 0
  order by
           tcs.num_distinct desc
)
where rownum < 21
;

select 'spool off'
from dual;

spool off
@rpt_hash_out/temp_rpt_hash.sql

