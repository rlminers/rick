SELECT /*+ MATERIALIZE NO_MERGE(o) */
    o.owner,
    o.object_name,
    o.subobject_name,
    o.object_type,
    o.object_id,
    SUM(ss.logical_reads_delta) AS logical_reads,
    SUM(ss.db_block_changes_delta) AS db_block_changes
FROM
    dba_objects         o
    INNER JOIN dba_hist_seg_stat   ss ON ( ss.obj# = o.object_id
                                         AND ss.dataobj# = o.data_object_id )
    INNER JOIN dba_hist_snapshot   sn ON ( sn.dbid = ss.dbid
                                         AND sn.instance_number = ss.instance_number
                                         AND sn.snap_id = ss.snap_id )
    --INNER JOIN dba_tab_partitions tp ON ( o.subobject_name = tp.partition_name )
WHERE
    o.owner = 'CDRMART'
    AND o.object_name = 'MAIN_CDR_EVENT'
    --AND o.object_name = 'NONUMB_CDR_EVENT'
    AND o.object_type LIKE 'TABLE%'
    AND sn.end_interval_time > systimestamp - numtodsinterval(30, 'DAY')
    AND sn.dbid = 1058941516
GROUP BY
    o.owner,
    o.object_name,
    o.subobject_name,
    o.object_type,
    o.object_id
HAVING
    SUM(ss.db_block_changes_delta) > 0
/

--
--

SELECT /*+ MATERIALIZE NO_MERGE(o) */
    o.owner,
    o.object_name,
    o.subobject_name,
    o.object_type,
    o.object_id,
    SUM(ss.logical_reads_delta) AS logical_reads,
    SUM(ss.db_block_changes_delta) AS db_block_changes
FROM
    dba_objects         o
    INNER JOIN dba_hist_seg_stat   ss ON ( ss.obj# = o.object_id
                                         AND ss.dataobj# = o.data_object_id )
    INNER JOIN dba_hist_snapshot   sn ON ( sn.dbid = ss.dbid
                                         AND sn.instance_number = ss.instance_number
                                         AND sn.snap_id = ss.snap_id )
    --INNER JOIN dba_tab_partitions tp ON ( o.subobject_name = tp.partition_name )
WHERE
    o.owner = 'NEXOSS'
    --AND o.object_name = 'ARCHIVEDREPORTABLECDR'
    AND o.object_name = 'REPORTABLECDR'
    AND o.object_type LIKE 'TABLE%'
    AND sn.end_interval_time > systimestamp - numtodsinterval(180, 'DAY')
    AND sn.dbid = 1058941516
GROUP BY
    o.owner,
    o.object_name,
    o.subobject_name,
    o.object_type,
    o.object_id
--HAVING SUM(ss.db_block_changes_delta) > 0
/
