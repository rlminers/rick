SET ECHO OFF

REM This script queries the dictionary tables for all interesting info
REM for a table object. This is primarily for investigations involving
REM logminer/streams/logical standby/goldengate etc
REM


SET feedback on linesize 80 pagesize 1000
ACCEPT spool prompt "Enter the scripts output file name: "
SPOOL &spool REPLACE

PROMPT Support Note 1364340.1 Output
ACCEPT owner prompt "Enter the table OWNER name, case sensitive: "
ACCEPT table prompt "Enter the TABLE name, case sensitive: "

COLUMN tabobj new_value tabobj
select obj# tabobj
from obj$ o
where owner#=(select user# from user$ where name='&owner')
and name='&table'
and namespace=1
and type#=2;

alter session set nls_date_format = 'YYYYMMDD HH24:MI:SS';

SET echo on

PROMPT OBJ$ for table object
select * from obj$ where obj#=&tabobj;

PROMPT TAB$ for table object
select * from tab$ where obj#=&tabobj;

PROMPT COL$ for table object
select * from col$ where obj#=&tabobj;

PROMPT CCOL$ for constraint columns on table object
select * from ccol$ where obj#=&tabobj;

PROMPT CON$ for constraints on the table object
select * from con$
where con# in (select con# from cdef$ where obj#=&tabobj);

PROMPT CDEF$ for constraints on the table object
select * from cdef$ where obj#=&tabobj;

PROMPT IND$ for indexes on table object
select * from ind$ where bo#=&tabobj;

PROMPT OBJ$ for index objects against the table
select * from obj$ where obj# in
(select obj# from ind$ where bo#=&tabobj);

PROMPT ICOL$ for columns used by indexes against the table
select * from icol$ where bo#=&tabobj;

PROMPT ICOLDEP$ for columns used by indexes against the table
select * from icoldep$ where bo#=&tabobj;

PROMPT Sanity checks
PROMPT OBJ# for index objects referenced from ICOL$ but not IND$
select obj# from icol$ where bo#=&tabobj
minus
select obj# from ind$ where bo#=&tabobj;

PROMPT OBJ$ for index objects referenced from ICOL$ but not IND$
select * from obj$ where obj# in
(select obj# from icol$ where bo#=&tabobj
minus
select obj# from ind$ where bo#=&tabobj
);

PROMPT OBJ# for index objects referenced from ICOLDEP$ but not IND$
select obj# from icoldep$ where bo#=&tabobj
minus
select obj# from ind$ where bo#=&tabobj;

PROMPT OBJ$ for index objects referenced from ICOLDEP$ but not IND$
select * from obj$ where obj# in
(select obj# from icoldep$ where bo#=&tabobj
minus
select obj# from ind$ where bo#=&tabobj
);

SPOOL OFF

PROMPT Please check the output file &spool

