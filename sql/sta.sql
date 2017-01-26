
----------------------------------------------------------
-- Set the environment
----------------------------------------------------------
col sql_id new_value sql_id
accept sql_id prompt 'Enter sql_id : '
set verify off
set feedback off
SET termout OFF
SELECT '&sql_id' AS sql_id FROM dual;
SET termout ON

----------------------------------------------------------
-- Create a task
----------------------------------------------------------
DECLARE
 my_task_name VARCHAR2(30);
BEGIN
 my_task_name := DBMS_SQLTUNE.CREATE_TUNING_TASK
 (
   sql_id      => '&sql_id'
 , scope       => 'COMPREHENSIVE'
 , time_limit  => 7200
 , task_name   => 'STA_TASK_'||'&sql_id'
 , description => 'STA_TASK_'||'&sql_id'
 );
END;
/

SELECT task_name, status
FROM DBA_ADVISOR_LOG
where task_name = 'STA_TASK_'||'&sql_id';

----------------------------------------------------------
-- Perform the analyses 
----------------------------------------------------------
BEGIN
  DBMS_SQLTUNE.EXECUTE_TUNING_TASK( task_name => 'STA_TASK_'||'&sql_id' );
END;
/

----------------------------------------------------------
-- Review the recommendations
----------------------------------------------------------
set pages 1000
SET LONG 999999
SET LONGCHUNKSIZE 1000
SET LINESIZE 140
spool sta_task_&sql_id.txt
SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK( 'STA_TASK_'||'&sql_id' )
  FROM DUAL;
spool off;

----------------------------------------------------------
-- output the command to drop the STA task
----------------------------------------------------------
set serveroutput on
exec dbms_output.put_line( '--------------------------------------------------------' );
exec dbms_output.put_line( '--   Run the following command to drop the STA Task   --' );
exec dbms_output.put_line( '--------------------------------------------------------' );
exec dbms_output.put_line( 'exec dbms_sqltune.drop_tuning_task( ''' || 'STA_TASK_'||'&sql_id'||''');' );

