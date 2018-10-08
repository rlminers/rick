select sid
, serial#
, status
, sql_id
, final_blocking_session
from gv$session
where final_block_session is not null
;

