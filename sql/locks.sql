prompt blocking sessions with v$session
SELECT
   s.blocking_session, 
   s.sid, 
   s.serial#, 
   s.seconds_in_wait
FROM
   v$session s
WHERE
   blocking_session IS NOT NULL;

prompt blocking sessions using v$lock
SELECT 
   l1.sid || ' is blocking ' || l2.sid blocking_sessions
FROM 
   v$lock l1, v$lock l2
WHERE
   l1.block = 1 AND
   l2.request > 0 AND
   l1.id1 = l2.id1 AND
   l1.id2 = l2.id2;

prompt blocking sessions with all available information
-- The next query prints a few more information, it let's you quickly see who's blocking who
SELECT s1.username || '@' || s1.machine
    || ' ( SID=' || s1.sid || ' )  is blocking '
    || s2.username || '@' || s2.machine || ' ( SID=' || s2.sid || ' ) ' AS blocking_status
    FROM v$lock l1, v$session s1, v$lock l2, v$session s2
    WHERE s1.sid=l1.sid AND s2.sid=l2.sid
    AND l1.BLOCK=1 AND l2.request > 0
    AND l1.id1 = l2.id1
    AND l1.id2 = l2.id2;

prompt identifying blocked objects
SELECT sid, id1 FROM v$lock WHERE TYPE='TM';

