set feedback off
clear breaks
col host_name format a30
col name format a30
col "Ratio" format 999.99
SELECT host_name, instance_name, startup_time
FROM V$Instance;

PROMPT
PROMPT ############################# SGA Components ###########################
SELECT DECODE(pool,NULL,name,pool) "COMPONENT", sum(bytes)/1024/1024/1024 "Size(GB)"
FROM V$SgaStat
GROUP BY ROLLUP(DECODE(pool,NULL,name,pool));

break on "COMPONENT" skip 1
SELECT 'large pool' "COMPONENT", name, bytes/1024/1024/1024 "GB"
FROM V$SgaStat
WHERE pool = 'large pool'
UNION ALL
SELECT 'java pool' "COMPONENT", name, bytes/1024/1024/1024 "GB"
FROM V$SgaStat
WHERE pool = 'java pool';

-- hit ratios
SELECT 'Buffer Cache' "COMPONENT",
	'Default' "NAME",
	ROUND((1-(physical_reads/(db_block_gets+consistent_gets)))*100,2) "Ratio"
FROM V$Buffer_Pool_Statistics
UNION ALL
SELECT 'Buffer Cache' "COMPONENT",
	name || ' latch' "NAME",
	ROUND(sum(gets)/(sum(gets)+sum(misses))*100,2)
from V$Latch
where name like 'cache buffers%'
group by name
UNION ALL
SELECT 'Buffer Cache' "COMPONENT",
	'Undo Header' "NAME",
	ROUND(avg(DECODE(s.waits,0,1,1-(s.waits/s.gets)))*100,2) "Ratio"
FROM V$ROLLSTAT s, V$ROLLNAME n
WHERE s.usn = n.usn
AND n.name LIKE '%SYS%'
UNION ALL
SELECT 'Log Buffer' "COMPONENT",
	'Redo NoWait' "NAME",
	ROUND((1-(retries.value/entries.value))*100,2) "Ratio"
FROM V$SysStat retries, V$SysStat entries
WHERE retries.name = 'redo buffer allocation retries'
AND entries.name = 'redo entries'
UNION ALL
select 'Log Buffer' "COMPONENT",
	a.type "NAME",
	ROUND((1-(a.ratio/b.value))*100,2) "Ratio"
from (
	SELECT 'Ext Header' type, sum(count) ratio
	FROM V$WaitStat 
	WHERE class IN ( 'undo header', 'system undo header' )
	) a,
	(
	select 'Ext Header' type, value
	from V$SysStat
	where name = 'consistent gets'
	) b
where a.type = b.type
UNION ALL
select 'Log Buffer' "COMPONENT",
	a.type "NAME",
	ROUND((1-(a.ratio/b.value))*100,2) "Ratio"
from (
	SELECT 'Ext Block' type, sum(count) ratio
	FROM V$WaitStat 
	WHERE class IN ( 'undo block', 'system undo block' )
	) a,
	(
	select 'Ext Block' type, value
	from V$SysStat
	where name = 'consistent gets'
	) b
where a.type = b.type
UNION ALL
SELECT 'Log Buffer' "COMPONENT",
	name || ' latch' "NAME",
	ROUND(sum(gets)/(sum(gets)+sum(misses))*100,2)
from V$Latch
where name in ( 'redo copy', 'redo allocation' )
group by name
UNION ALL
SELECT 'Shared Pool' "COMPONENT",
	'Library' "NAME",
	ROUND(SUM(getHitRatio)/SUM(pinHitRatio)*100,2) "Ratio"
FROM V$LibraryCache
WHERE nameSpace in ( 'SQL AREA', 'TABLE/PROCEDURE', 'BODY', 'TRIGGER' )
UNION ALL
SELECT 'Shared Pool' "COMPONENT",
	'Dictionary' "NAME",
	ROUND((1-(SUM(getMisses)/SUM(gets)))*100,2) "Ratio"
FROM V$RowCache
UNION ALL
SELECT 'Shared Pool' "COMPONENT",
	name || ' latch' "NAME",
	ROUND(sum(gets)/(sum(gets)+sum(misses))*100,2)
from V$Latch
where name in ( 'shared pool', 'library cache' )
group by name
UNION ALL
SELECT 'UGA' "COMPONENT",
	'In-Memory Sort' "NAME",
	ROUND(mem.value/(disk.value+mem.value)*100,2) "Ratio"
FROM V$SYSSTAT mem, V$SYSSTAT disk
WHERE mem.name = 'sorts (memory)'
AND disk.name = 'sorts (disk)'
ORDER BY component, name;

----- eof -----
set feedback on


