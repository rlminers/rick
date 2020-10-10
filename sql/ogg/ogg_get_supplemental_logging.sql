-- --------------------------------------------------------------------------------
-- https://www.dbasolved.com/2016/08/digging-into-add-schematrandata-where-goldengate-is-going/
-- https://www.dbasolved.com/2016/08/to-trandata-or-to-schematrandata-that-is-the-goldengate-questions-of-the-day/
-- --------------------------------------------------------------------------------

-- integrated

select *
from table(logmnr$always_suplog_columns('SOE','ORDERS'));

select *
from table(logmnr$always_suplog_columns('ARIESTRN_RT','TRANSACTION'));

/*
GGSCI > INFO SCHEMATRANDATA SCOTT
2015-11-04 08:02:54  INFO    OGG-01785  Schema level supplemental logging is enabled on schema SCOTT.
2015-11-04 08:02:54  INFO    OGG-01981  Schema level supplemental logging is enabled on schema SCOTT for all scheduling columns.

GGSCI > INFO TRANDATA SCOTT.EMP
2015-11-04 08:02:59  INFO    OGG-01785  Schema level supplemental logging is enabled on schema SCOTT.
2015-11-04 08:02:59  INFO    OGG-01980  Schema level supplemental logging is enabled on schema SCOTT for all scheduling columns.
Logging of supplemental redo log data is enabled for table SCOTT.EMP.
Columns supplementally logged for table SCOTT.EMP: EMPNO.
*/

-- classic

select owner
, log_group_name
, table_name
, log_group_type
, always
, generated
from dba_log_groups
where owner = 'ARIESTRN_RT'
and log_group_name like 'GGS%';

-- db log levels
select SUPPLEMENTAL_LOG_DATA_MIN
, SUPPLEMENTAL_LOG_DATA_PK
, SUPPLEMENTAL_LOG_DATA_UI
, FORCE_LOGGING
from V$DATABASE;

select LOG_GROUP_NAME, TABLE_NAME, LOG_GROUP_TYPE, ALWAYS from DBA_LOG_GROUPS where OWNER='SCOTT';
/*
LOG_GROUP_NAME                 TABLE_NAME                     LOG_GROUP_TYPE               ALWAYS
------------------------------ ------------------------------ ---------------------------- -----------
GGS_75335                      EMP                            USER LOG GROUP               ALWAYS
SYS_C0017806                   EMP                            PRIMARY KEY LOGGING          ALWAYS
SYS_C0017807                   EMP                            UNIQUE KEY LOGGING           CONDITIONAL
SYS_C0017808                   EMP                            FOREIGN KEY LOGGING          CONDITIONAL
SYS_C0017809                   EMP                            ALL COLUMN LOGGING           ALWAYS
*/

