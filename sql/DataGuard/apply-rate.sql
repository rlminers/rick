SELECT START_TIME 
, ITEM
, SOFAR || ' ' || UNITS Sofar
FROM V$RECOVERY_PROGRESS
WHERE ITEM IN ('Active Apply Rate', 'Average Apply Rate', 'Redo Applied');
 
