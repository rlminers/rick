
set long 5000
set pages 1000
set verify off

undef object_type
undef object_name
undef owner

select dbms_metadata.get_ddl(
  '&object_type'
, '&object_name'
, '&owner' )
from dual
/

undef object_type
undef object_name
undef owner
