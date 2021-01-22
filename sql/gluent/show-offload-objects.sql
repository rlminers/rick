SELECT
    hybrid_owner,
    offloaded_owner,
    offloaded_table,
    --hybrid_view,
    --hadoop_owner,
    --hadoop_table,
    offload_type,
    incremental_key,
    incremental_high_value,
    offload_bucket_column,
    offload_bucket_count as bucket_cnt
FROM
    gluent_repo.offload_metadata
WHERE
    hybrid_view_type = 'GLUENT_OFFLOAD_HYBRID_VIEW'
ORDER BY
    1,
    2,
    3
;

