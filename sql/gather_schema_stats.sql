
begin
  SYS.DBMS_STATS.GATHER_SCHEMA_STATS (
      ownname => UPPER('&username')
    , estimate_percent => dbms_stats.auto_sample_size
    , degree => 24
    , cascade => TRUE
  );
end;
/

