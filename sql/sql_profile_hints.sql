set lines 155
col hint for a150
SELECT attr_val hint
FROM dba_sql_profiles p
  , sqlprof$attr h
WHERE p.signature = h.signature
AND name LIKE ('&profile_name')
ORDER BY attr#;

