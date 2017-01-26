BEGIN
  DBMS_SQLTUNE.drop_sql_profile (
    name   => '&sql_profile_name',
    ignore => TRUE);
END;
/
