set lines 150
select * from table(dbms_xplan.display_cursor('&sql_id','&child_no','typical'))
/

undef sql_id
undef child_no

