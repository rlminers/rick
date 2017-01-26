
select * from table(dbms_xplan.display_cursor('&sql_id','&child_no','+projection'))
/

undef sql_id
undef child_no

