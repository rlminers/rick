SET VERIFY OFF;
set echo off;
set linesize 999;
set pagesize 30000;
set head on ;
CLEAR COLUMNS;
set markup html on 
set markup html entmap off

spool &1

COLUMN SESSION_KEY          FORMAT 999999999        HEADING 'KEY'
COLUMN INPUT_TYPE	    FORMAT A10	
COLUMN STATUS		    FORMAT A10
COLUMN GB_PER_HR            FORMAT 999,999.9        HEADING 'GB/HR'
COLUMN START_TIME           FORMAT DATE             HEADING 'STARTED'
COLUMN END_TIME             FORMAT DATE             HEADING 'ENDED'
COLUMN OUTPUT_GB            FORMAT 999,999,999.999  HEADING 'OUTPUT GB'
COLUMN COMPRESSION_RATIO    FORMAT 99.99            HEADING 'COMP. RATIO'
COLUMN TIME_TAKEN_DISPLAY   FORMAT A10

SELECT session_key "SESSION_KEY",
       input_type "INPUT_TYPE",
       status "STATUS",
       ROUND (a.input_bytes / POWER (1024, 3) / (greatest(.001,elapsed_seconds) / 3600), 3)
           "GB_PER_HR",
       TO_CHAR (START_time, 'mm/dd/yy hh24:mi') "start_TIME",
       TO_CHAR (end_time, 'mm/dd/yy hh24:mi') "END_TIME",
       ROUND (a.output_bytes / POWER (1024, 3), 3) "OUTPUT_GB",
       ROUND (a.compression_ratio, 2) "COMPRESSION_RATIO",
       to_char(a.time_taken_display) "TIME_TAKEN_DISPLAY" 
  FROM v$rman_backup_job_details a
	where start_time > trunc(sysdate) -8
ORDER BY start_time DESC;
