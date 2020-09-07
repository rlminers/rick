set linesize 132 pagesize 999
column sql_fulltext format a120 word_wrap
column sql_text format a120 word_wrap
break on sql_fulltext skip 1

SELECT
  REPLACE( TRANSLATE(sql_fulltext, '0123456789', '999999999'), '9', '') sql_fulltext
FROM v$sql
WHERE sql_id = '&&1'
GROUP BY REPLACE( TRANSLATE(sql_fulltext, '0123456789', '999999999'), '9', '')
;

SELECT sql_fulltext
FROM v$sql
WHERE sql_id = '&&1'
;

select a.sql_text from v$sqltext_with_newlines a where sql_id = '&&1' order by a.piece;

