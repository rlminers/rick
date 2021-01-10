col column_name for a30
col hash_bucket for 99
col bucket_count for 999,999,999
select Upper('&1') column_name, ora_hash( &1, 16) hash_bucket, count(*) bucket_count
  from &2..&3
where
  rownum <= 1000000
group by Upper('&1'), ora_hash( &1, 16)
order by 3 asc
/

