set lines 150
select * from table(dbms_xplan.display_cursor('&sql_id','&child_no','TYPICAL +PEEKED_BINDS'))
/

undef sql_id
undef child_no

