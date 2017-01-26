
col block# format 999,999,999
col blocks format 999,999,999

SELECT process, status, delay_mins
     , pid
     , thread#
     , sequence#
     , blocks
     , block#
FROM   V$MANAGED_STANDBY
order by process, thread#, sequence#
/


