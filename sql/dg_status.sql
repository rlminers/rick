/*
-------------
-- From Note 1577406.1
-- Copied on 12/9/13 dac
-- Modified 12/31/13 dac
-- Set for CNA 10/26/15 dac
----------------------------------------------------------------
*/
set echo off 
set feedback off 

column timecol new_value timestamp 
column spool_extension new_value suffix 
select to_char(sysdate,'Mondd_hhmi') timecol, '.html' spool_extension from sys.dual; 
column output new_value dbname 
select value || '_' output 
from v$parameter where name = 'db_unique_name'; 

set linesize 2000
set pagesize 50000
set numformat 999999999999999
set trim on 
set trims on 
ALTER SESSION SET nls_date_format = 'DD-MON-YYYY HH24:MI:SS'; 
SELECT TO_CHAR(sysdate) time FROM dual; 

spool ${SPOOL_FILE}

SELECT 'The following select will give us the generic information about how this standby is setup.<br>The DATABASE_ROLE should be STANDBY as that is what this script is intended to be run on.<br>PLATFORM_ID should match the PLATFORM_ID of the primary or conform to the supported options in<br>Note: 413484.1 Data Guard Support for Heterogeneous Primary and Physical Standbys in Same Data Guard Configuration.<br>FLASHBACK can be YES (recommended) or NO.<br>If PROTECTION_LEVEL is different from PROTECTION_MODE then for some reason the mode listed in PROTECTION_MODE experienced a need to downgrade.<br>Once the error condition has been corrected the PROTECTION_LEVEL should match the PROTECTION_MODE after the next log switch.' "Database 1" FROM dual; 

SELECT database_role role, name, db_unique_name, platform_id, open_mode, log_mode, flashback_on, protection_mode, protection_level FROM v$database;

SELECT 'FORCE_LOGGING is not mandatory but is recommended.<br>REMOTE_ARCHIVE should be ENABLE.<br>SUPPLEMENTAL_LOG_DATA_PK and SUPPLEMENTAL_LOG_DATA_UI must be enabled if this standby is associated with a primary that has a logical standby.<br>During normal operations it is acceptable for SWITCHOVER_STATUS to be NOT ALLOWED.<br>DATAGUARD_BROKER can be ENABLED (recommended) or DISABLED.' "Database 2" FROM dual; 
 
column force_logging format a13 tru 
column supplemental_log_data_pk format a24 tru
column supplemental_log_data_ui format a24 tru

SELECT force_logging, remote_archive, supplemental_log_data_pk, supplemental_log_data_ui, switchover_status, dataguard_broker  FROM v$database;  

SELECT 'Check how many threads are enabled and started for this database. If the number of instances below does not match then not all instances are up.' "Threads" FROM dual;

SELECT thread#, instance, status FROM v$thread;

SELECT 'The number of instances returned below is the number currently running.  If it does not match the number returned in Threads above then not all instances are up.<br>VERSION should match the version from the primary database.<br>ARCHIVER can be (STOPPED | STARTED | FAILED). FAILED means that the archiver failed to archive a log last time, but will try again within 5 minutes.<br>LOG_SWITCH_WAIT the ARCHIVE LOG/CLEAR LOG/CHECKPOINT event log switching is waiting for.<br>Note that if ALTER SYSTEM SWITCH LOGFILE is hung, but there is room in the current online redo log, then the value is NULL.' "Instances" FROM dual;

column host_name format a32 wrap

SELECT thread#, instance_name, host_name, version, archiver, log_switch_wait FROM gv$instance ORDER BY thread#;
 
SELECT 'Check the number and size of online redo logs on each thread.' "Online Redo Logs" FROM dual;

set feedback on

SELECT thread#, group#, sequence#, bytes, archived ,status FROM v$log ORDER BY thread#, group#; 

set feedback off

SELECT 'The following query is run to see if standby redo logs have been created.<br>The standby redo logs should be the same size as the online redo logs.<br>There should be (( # of online logs per thread + 1) * # of threads) standby redo logs.<br>A value of 0 for the thread# means the log has never been allocated.' "Standby Redo Logs" FROM dual;

set feedback on

SELECT thread#, group#, sequence#, bytes, archived, status FROM v$standby_log order by thread#, group#; 

set feedback off

SELECT 'This query produces a list of defined archive destinations. It shows if they are enabled, what process is servicing that destination, if the destination is local or remote, and if remote what the current mount ID is.<br>For a physical standby we should have at least one remote destination that points the primary set.' "Archive Destinations" FROM dual;
 
column destination format a35 wrap 
column process format a7 
column ID format 99
column mid format 99 
 
SELECT thread#, dest_id, destination, gvad.status, target, schedule, process, mountid mid FROM gv$archive_dest gvad, gv$instance gvi WHERE gvad.inst_id = gvi.inst_id AND destination is NOT NULL ORDER BY thread#, dest_id; 
 
SELECT 'If the protection mode of the standby is set to anything higher than max performance then we need to make sure the remote destination that points to the primary is set with the correct options else we will have issues during switchover.' "Archive Destination Options" FROM dual;
 
set numwidth 8
column archiver format a8 
column ID format 99 
column error format a55 wrap

SELECT thread#, dest_id, gvad.archiver, transmit_mode, affirm, async_blocks, net_timeout, delay_mins, reopen_secs reopen, register, binding FROM gv$archive_dest gvad, gv$instance gvi WHERE gvad.inst_id = gvi.inst_id AND destination is NOT NULL ORDER BY thread#, dest_id; 
 
SELECT 'The following select will show any errors that occured the last time an attempt to archive to the destination was attempted.<br>If ERROR is blank and status is VALID then the archive completed correctly.' "Archive Destination Errors" FROM dual; 

SELECT thread#, dest_id, gvad.status, error FROM gv$archive_dest gvad, gv$instance gvi WHERE gvad.inst_id = gvi.inst_id AND destination is NOT NULL ORDER BY thread#, dest_id; 
 
SELECT 'The query below will determine if any error conditions have been reached by querying the v$dataguard_status view (view only available in 9.2.0 and above).' "Data Guard Status" FROM dual;
 
column message format a80 

set feedback on

SELECT timestamp, gvi.thread#, message FROM gv$dataguard_status gvds, gv$instance gvi WHERE gvds.inst_id = gvi.inst_id AND severity in ('Error','Fatal') ORDER BY timestamp, thread#;
 
set feedback off

SELECT 'Query v$managed_standby to see the status of processes involved in the shipping redo on this system.<br>Does not include processes needed to apply redo.' "Managed Standby Status" FROM dual;
 
SELECT inst_id, thread#, process, pid, status, client_process, client_pid, sequence#, block#, active_agents, known_agents FROM gv$managed_standby ORDER BY thread#, pid;

SELECT 'Verify the last sequence# received and the last sequence# applied to standby database.' "Last Sequence Received/Applied" FROM dual;

SELECT al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied" FROM (select thread# thrd, MAX(sequence#) almax FROM v$archived_log WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) al, (SELECT thread# thrd, MAX(sequence#) lhmax FROM v$log_history WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) lh WHERE al.thrd = lh.thrd;

SELECT 'Check the transport lag and apply lag from the V$DATAGUARD_STATS view.  This is only relevant when LGWR log transport and real time apply are in use.' "Standby Lag" FROM dual;

SELECT * FROM v$dataguard_stats WHERE name LIKE '%lag%';

SELECT 'The V$ARCHIVE_GAP fixed view on a physical standby database only returns the next gap that is currently blocking redo apply from continuing.<br>After resolving the identified gap and starting redo apply, query the V$ARCHIVE_GAP fixed view again on the physical standby database to determine the next gap sequence, if there is one.' "Archive Gap" FROM dual;

SELECT * FROM v$archive_gap; 

SELECT 'Non-default init parameters.<br>For a RAC DB Thread# = * means the value is the same for all threads (SID=*)<br>Threads with different values are shown with their individual thread# and values.' "Non Default init Parameters" FROM dual;

column num noprint

SELECT num, '*' "THREAD#", name, value FROM v$PARAMETER WHERE NUM IN (SELECT num FROM v$parameter WHERE isdefault = 'FALSE'
MINUS
SELECT num FROM gv$parameter gvp, gv$instance gvi WHERE num IN (SELECT DISTINCT gvpa.num FROM gv$parameter gvpa, gv$parameter gvpb WHERE gvpa.num = gvpb.num AND  gvpa.value <> gvpb.value AND gvpa.isdefault = 'FALSE') AND gvi.inst_id = gvp.inst_id  AND gvp.isdefault = 'FALSE')
UNION
SELECT num, TO_CHAR(thread#) "THREAD#", name, value FROM gv$parameter gvp, gv$instance gvi WHERE num IN (SELECT DISTINCT gvpa.num FROM gv$parameter gvpa, gv$parameter gvpb WHERE gvpa.num = gvpb.num AND  gvpa.value <> gvpb.value AND gvpa.isdefault = 'FALSE') AND gvi.inst_id = gvp.inst_id  AND gvp.isdefault = 'FALSE' ORDER BY 1, 2;

-- this will fail on standby
whenever sqlerror continue

select 'Verify there is enough space in the recovery file destination and that backups are clearing this out regularly' "DB Recovery Destination Sizes" from dual;

column name format a20

SELECT name,
       ROUND(
             space_limit / (1024 * 1024 * 1024),
             3
            )
           gb_space_limit,
       ROUND(
             space_used / (1024 * 1024 * 1024),
             3
            )
           gb_space_used,
       ROUND(
             space_reclaimable / (1024 * 1024 * 1024),
             3
            )
           gb_space_reclaimable,
       ROUND(
             100 * (space_used / space_limit),
             2
            )
           pct_used
FROM   v$recovery_file_dest;

spool off
set markup html off entmap on
set feedback on
set echo on



