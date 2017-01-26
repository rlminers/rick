col dest_name format a20
col db_unique_name format a14
col destination format a16
col error format a20

select dest_id, db_unique_name, dest_name, archiver, status, error, destination, log_sequence, transmit_mode
from v$archive_dest
where dest_name in ('LOG_ARCHIVE_DEST_1','LOG_ARCHIVE_DEST_2');

col name format a25
col value format a100

select name, value
from v$parameter
where name in ('log_archive_dest_1','log_archive_dest_2',
'log_archive_dest_state_1','log_archive_dest_state_2',
'log_archive_max_processes','log_archive_config','log_archive_format');

