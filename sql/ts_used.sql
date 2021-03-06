REM
REM Script: ts_used.sql
REM
REM Function: Display tablespace usage with graph
REM
REM
clear columns
column tablespace format a30
column total_gb format 999,999,999,999.99
column used_gb format 999,999,999,999.99
column free_gb format 999,999,999.99
column pct_used format 999.99
column graph format a25 heading "GRAPH (X=5%)"
column status format a10
compute sum of total_gb on report
compute sum of used_gb on report
compute sum of free_gb on report
break on report 
set verify off
select  total.ts tablespace,
        DECODE(total.gb,null,'OFFLINE',dbat.status) status,
                total.gb total_gb,
                NVL(total.gb - free.gb,total.gb) used_gb,
                NVL(free.gb,0) free_gb,
        DECODE(total.gb,NULL,0,NVL(ROUND((total.gb - free.gb)/(total.gb)*100,2),100)) pct_used,
                CASE WHEN (total.gb IS NULL) THEN '['||RPAD(LPAD('OFFLINE',13,'-'),20,'-')||']'
                ELSE '['|| DECODE(free.gb,
                             null,'XXXXXXXXXXXXXXXXXXXX',
                             NVL(RPAD(LPAD('X',trunc((100-ROUND( (free.gb)/(total.gb) * 100, 2))/5),'X'),20,'-'),
                                '--------------------'))||']' 
         END as GRAPH
from
                (select tablespace_name ts, sum(bytes)/1024/1024/1024 gb
                 from dba_data_files
                 WHERE tablespace_name LIKE NVL( UPPER( '&&tbsp_name' ), tablespace_name )
                 group by tablespace_name) total,
                (select tablespace_name ts, sum(bytes)/1024/1024/1024 gb
                 from dba_free_space
                 WHERE tablespace_name LIKE NVL( UPPER( '&tbsp_name' ), tablespace_name )
                 group by tablespace_name) free,
        dba_tablespaces dbat
where total.ts=free.ts(+)
and total.ts=dbat.tablespace_name
and dbat.status LIKE NVL( UPPER( '&&status' ), dbat.status )
UNION ALL
select  sh.tablespace_name, 
        'TEMP',
                SUM(sh.bytes_used+sh.bytes_free)/1024/1024/1024 total_gb,
                SUM(sh.bytes_used)/1024/1024/1024 used_gb,
                SUM(sh.bytes_free)/1024/1024/1024 free_gb,
        ROUND(SUM(sh.bytes_used)/SUM(sh.bytes_used+sh.bytes_free)*100,2) pct_used,
        '['||DECODE(SUM(sh.bytes_free),0,'XXXXXXXXXXXXXXXXXXXX',
              NVL(RPAD(LPAD('X',(TRUNC(ROUND((SUM(sh.bytes_used)/SUM(sh.bytes_used+sh.bytes_free))*100,2)/5)),'X'),20,'-'),
                '--------------------'))||']'
FROM v$temp_space_header sh
WHERE sh.tablespace_name LIKE NVL( UPPER( '&tbsp_name' ), sh.tablespace_name )
GROUP BY tablespace_name
order by 1
/

ttitle off

select distinct owner
from dba_segments
where tablespace_name LIKE NVL( UPPER( '&tbsp_name' ), 'DUMMY' )
order by owner
/

undefine tbsp_name
undef status

