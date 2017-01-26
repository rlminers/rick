-- Disable a profile
begin
  DBMS_SQLTUNE.ALTER_SQL_PROFILE ( name => '&sql_prof_name', attribute_name => 'STATUS', value => 'DISABLED');
end;
/

