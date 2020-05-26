SELECT /*+
                    MATERIALIZE
                    NO_MERGE(o)
                */
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
HAVING SUM(ss.db_block_changes_delta) > 0
/

select partition_name, high_value
from dba_tab_partitions where partition_name in (
'SYS_P61599',
'SYS_P59879',
'SYS_P60159',
'SYS_P63223',
'SYS_P60939',
'SYS_P60499',
'SYS_P62904',
'SYS_P61803',
'SYS_P62203',
'SYS_P62723',
'SYS_P61399',
'SYS_P61983',
'SYS_P62543',
'SYS_P63063',
'SYS_P62363',
'SYS_P60739',
'SYS_P61159'
)
;
