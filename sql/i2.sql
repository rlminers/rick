
set sqlprompt "_user':'_connect_identifier> "

-- SET MARKUP HTML ON SPOOL ON
-- SPOOL
-- SPOOL OFF

col supplemental_log_data_min heading SUPP_LOG format a8
col platform_name format a23
col current_scn format 999999999999999
--col archiver format a8
--col host_name format a18
col name_info heading "HOST_NAME|INSTANCE_NAME" format a18
col db_info heading "STARTUP_TIME|VERSION" format a18
col db_status heading "STATUS|ARCHIVER" format a8
col inst_info heading "INSTANCE_ROLE|INSTANCE_MODE" format a17

SELECT host_name || chr(10) || instance_name name_info
, startup_time || chr(10) || version db_info
, status || chr(10) || archiver db_status
, INSTANCE_ROLE || chr(10) || INSTANCE_MODE inst_info
FROM v$instance;

col dbnames heading "DB NAME|DB UNIQUE NAME" format a14
col sup_log heading "SUPL_LOGGING|FORCE_LOGGING" format a13
col log_flash heading "LOG_MODE|FLASHBACK_ON" format a13
col plat_cdb heading "PLATFORM_NAME|CDB" format a23
SELECT name || chr(10) || db_unique_name dbnames
, log_mode || chr(10) || flashback_on log_flash
, supplemental_log_data_min || chr(10) || force_logging sup_log
, platform_name || chr(10) || cdb plat_cdb
FROM v$database;

col name format a20
col parameter format a30
col value format a20
SELECT *
FROM NLS_DATABASE_PARAMETERS
where parameter in ( 'NLS_LANGUAGE','NLS_TERRITORY','NLS_CHARACTERSET' )
/

-- show current session and process information
/*
SELECT s.username
, s.sid
, s.serial#
, p.spid
FROM v$session s
,v$process p
WHERE p.addr = s.paddr
AND s.sid    =
  (
    SELECT DISTINCT sid
    FROM v$mystat
  ) ;
*/

