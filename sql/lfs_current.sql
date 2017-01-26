col event format a40

SELECT --wait_class, 
event
, SUM(total_waits) total_waits
, ROUND( ( SUM(time_waited_micro)/1000 ) / SUM(total_waits) , 2 )
  avg_wait_ms
FROM gv$session_event
WHERE event IN ('enq: CF - contention','log file sync','gcs log flush sync', 'log file parallel write'
  ,'wait for scn ack', 'gc cr grant 2-way',
  'gc buffer busy','gc current block 2-way')
OR event LIKE '%LGWR%'
OR event LIKE '%LNS%'
GROUP BY wait_class
, event
ORDER BY wait_class
, event
/

