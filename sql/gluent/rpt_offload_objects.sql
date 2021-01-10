set lines 132 pages 10000 feedback on verify off trimspool on
col hybrid_owner for a15
col hybrid_view for a30
col view_type for a12
col hybrid_external_table for a30
col iKEY for a20
col high_value for a12
col bkt for 99
SELECT  hybrid_owner
,       hybrid_view
,       case
          when hybrid_view_type='GLUENT_OFFLOAD_AGGREGATE_HYBRID_VIEW' then 'OFF-AGG-VIEW'
          when hybrid_view_type='GLUENT_OFFLOAD_HYBRID_VIEW' then 'OFF-VIEW'
        end view_type
,       hybrid_external_table
, INCREMENTAL_KEY IKEY
, case
    when incremental_high_value like 'TO_DATE%' then substr( INCREMENTAL_HIGH_VALUE , 11, 10)
    else INCREMENTAL_HIGH_VALUE 
  end HIGH_VALUE
, offload_bucket_count bkt
/*
,       hadoop_owner
,       hadoop_table
 HYBRID_OWNER
 HYBRID_VIEW
 HYBRID_VIEW_TYPE
 HYBRID_EXTERNAL_TABLE
 HADOOP_OWNER
 HADOOP_TABLE
 OFFLOAD_TYPE
 OFFLOADED_OWNER
 OFFLOADED_TABLE
 INCREMENTAL_KEY
 INCREMENTAL_HIGH_VALUE 
 TRANSFORMATIONS
 OFFLOAD_METADATA_JSON
*/
FROM    gluent_adm.offload_objects
WHERE   offloaded_owner like UPPER('&1')
AND     offloaded_table like UPPER('&2')
order by hybrid_owner, hybrid_view
/
