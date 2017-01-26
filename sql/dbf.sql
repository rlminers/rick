
col tablespace_name format a25
col file_name format a50
col mb format 999,999.99
col gb format 999,999.99
col incr_mb format 999,999.99
 
SELECT tablespace_name
, file_name
, AUTOEXTENSIBLE
, ROUND(INCREMENT_BY/1024/1024) incr_mb
, ROUND(bytes/1024/1024) MB
, ROUND(bytes/1024/1024/1024) GB
FROM dba_data_files
WHERE tablespace_name LIKE NVL( UPPER( '&&tbsp_name' ), tablespace_name )
and AUTOEXTENSIBLE like NVL( '&&auto_ext', AUTOEXTENSIBLE )
union all
SELECT tablespace_name
, file_name
, AUTOEXTENSIBLE
, ROUND(INCREMENT_BY/1024/1024) incr_mb
, ROUND(bytes/1024/1024) MB
, ROUND(bytes/1024/1024/1024) GB
FROM dba_temp_files
WHERE tablespace_name LIKE NVL( UPPER( '&tbsp_name' ), tablespace_name )
and AUTOEXTENSIBLE like NVL( '&auto_ext', AUTOEXTENSIBLE )
ORDER BY tablespace_name, file_name
/

undefine tbsp_name

