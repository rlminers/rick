
set lines 150
set verify off

select *
from table(dbms_xplan.display_cursor(
  '&sql_id'
 ,'&child_no'
 ,'adaptive +report')
)
/

undef sql_id
undef child_no

