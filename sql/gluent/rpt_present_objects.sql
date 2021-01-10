set lines 132 pages 10000 feedback on verify off trimspool on
col hybrid_owner for a12
col hybrid_view for a30
col v_typ for a5
col hybrid_external_table for a30
col hadoop_owner for a18
col hadoop_table for a30
SELECT  hybrid_owner
,       hybrid_view
,       case
          when hybrid_view_type='GLUENT_OFFLOAD_AGGREGATE_HYBRID_VIEW' then 'AGG-V'
          when hybrid_view_type='GLUENT_OFFLOAD_HYBRID_VIEW' then 'OFF-V'
        end v_typ
,       hybrid_external_table
, hadoop_owner
, hadoop_table
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
WHERE   offloaded_owner is null
order by hybrid_owner, hybrid_view
/
