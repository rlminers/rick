-- estimate_percent => dbms_stats.auto_sample_size
exec DBMS_STATS.GATHER_TABLE_STATS(ownname=>'&table_owner',tabname=>'&table_name',estimate_percent=>dbms_stats.auto_sample_size,degree=>8,cascade=>TRUE,force=>TRUE);

