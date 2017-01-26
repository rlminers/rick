
col total_size_mb format 999,999,999.99

set verify off

select username, account_status, lock_date
from dba_users
where username like NVL(  UPPER( '&&schema' ), username )
/

select tablespace_name, status
from dba_tablespaces
where tablespace_name in (
SELECT distinct tablespace_name
FROM dba_segments
WHERE owner like NVL(  UPPER( '&schema' ), owner )
)
order by tablespace_name
/

SELECT
  tablespace_name
, ROUND( SUM ( bytes ) / 1024 / 1024 / 1024,2) AS total_size_gb
FROM dba_segments
WHERE owner like NVL(  UPPER( '&schema' ), owner )
AND tablespace_name like NVL(  UPPER( '&tablespace_name' ), tablespace_name )
GROUP BY owner , rollup ( tablespace_name ) 
/

select username, count(1) conns
from v$session
where username like NVL(  UPPER( '&schema' ), username )
group by username
order by 1
/

undef schema
undef tablespace_name

