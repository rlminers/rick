
-- alter database add supplemental log data;
-- alter database add supplemental log data (primary key) columns;
-- alter database add supplemental log data (unique) columns;
-- alter database add supplemental log data (foreign key) columns;
-- alter database add supplemental log data (all) columns;

-- alter database drop supplemental log data;
-- alter database drop supplemental log data (primary key) columns;
-- alter database drop supplemental log data (unique) columns;
-- alter database drop supplemental log data (foreign key) columns;
-- alter database drop supplemental log data (all) columns;

-- alter database force logging;
-- alter database no force logging;

col supplemental_log_data_min heading "Min|SupLog" format a6
col force_logging heading "Force|Logging" format a7

select name
, log_mode
, supplemental_log_data_min
, supplemental_log_data_pk "PK"
, supplemental_log_data_ui "UI"
, force_logging
, supplemental_log_data_fk "FK"
, supplemental_log_data_all "All"
, to_char(created, 'MM-DD-YYYY HH24:MI:SS') "Created"
from v$database
/

alter system switch logfile;

