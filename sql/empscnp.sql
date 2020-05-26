-- tables
SELECT
    owner,
    table_name,
    num_rows,
    last_analyzed,
    partitioned
FROM
    dba_tables
WHERE
    owner = 'SCN_AUDIT'
    AND table_name IN (
        'CALL_PARTY_EXTDATA_LOG',
        'CALL_PARTY_LOOKUP_LOG',
        'USER_ACTIVITY_LOG',
        'RULESET_DETAIL_LOG',
        'EVENT_LOG'
    )
UNION
SELECT
    owner,
    table_name,
    num_rows,
    last_analyzed,
    partitioned
FROM
    dba_tables
WHERE
    owner = 'SCN_OPDB'
    AND table_name = 'CALL_PARTY_EXTENDED_DATA_HIST'
UNION
SELECT
    owner,
    table_name,
    num_rows,
    last_analyzed,
    partitioned
FROM
    dba_tables
WHERE
    owner = 'SCN_USAGE'
    AND table_name = 'USAGE_DETAIL'
ORDER BY
    owner,
    table_name;

--
--
/*
•	EMPSCNP.SCN_OPDB.CALL_PARTY_EXTENDED_DATA_HIST
•	EMPSCNP.SCN_USAGE.USAGE_DETAIL

•	EMPSCNP.SCN_AUDIT.CALL_PARTY_EXTDATA_LOG
•	EMPSCNP.SCN_AUDIT.CALL_PARTY_LOOKUP_LOG
•	EMPSCNP.SCN_AUDIT.USER_ACTIVITY_LOG
•	EMPSCNP.SCN_AUDIT.RULESET_DETAIL_LOG
•	EMPSCNP.SCN_AUDIT.EVENT_LOG
*/

--
-- modifications
--
select * from dba_tab_modifications where table_owner = 'SCN_AUDIT' and table_name = 'CALL_PARTY_EXTDATA_LOG' and partition_name is null;

SELECT
    table_owner, table_name, partition_name, subpartition_name, inserts, updates, deletes, timestamp, truncated, drop_segments
FROM
    dba_tab_modifications
WHERE
    table_owner = 'SCN_AUDIT'
    AND table_name IN (
        'CALL_PARTY_EXTDATA_LOG',
        'CALL_PARTY_LOOKUP_LOG',
        'USER_ACTIVITY_LOG',
        'RULESET_DETAIL_LOG',
        'EVENT_LOG'
    )
UNION
SELECT
    table_owner, table_name, partition_name, subpartition_name, inserts, updates, deletes, timestamp, truncated, drop_segments
FROM
    dba_tab_modifications
WHERE
    table_owner = 'SCN_OPDB'
    AND table_name = 'CALL_PARTY_EXTENDED_DATA_HIST'
UNION
SELECT
    table_owner, table_name, partition_name, subpartition_name, inserts, updates, deletes, timestamp, truncated, drop_segments
FROM
    dba_tab_modifications
WHERE
    table_owner = 'SCN_USAGE'
    AND table_name = 'USAGE_DETAIL'
ORDER BY
table_owner, table_name, partition_name, timestamp desc;


-- partitions

SELECT
    table_owner, table_name, partition_name, partition_position, subpartition_count, high_value, num_rows, last_analyzed
FROM
    dba_tab_partitions
WHERE
    table_owner = 'SCN_USAGE'
    AND table_name IN ('USAGE_DETAIL')
    and partition_name = 'SCN_USAGE_OLD'
;

with xmlform as
(
select dbms_xmlgen.getxmltype(
    'select table_owner,table_name,partition_name,partition_position,subpartition_count,num_rows,high_value from dba_tab_partitions where table_owner = ''SCN_AUDIT'' and table_name=''DEVICE_TRACK'''
    ) as x
  from dual
)
select table_name
    , partition
    , num_rows
    , substr(high_value,1,instr(high_value, ',') ) high_value
    , to_date( substr(high_value, instr(high_value,''' ',1,1)+2, 19 ),'YYYY-MM-DD HH24:MI:SS') high_date
    , partition_position
    from xmlform
      ,xmltable('/ROWSET/ROW'
          passing xmlform.x
          columns table_name varchar2(20) path 'TABLE_NAME'
                 ,partition  varchar2(11)  path 'PARTITION_NAME'
                 ,high_value varchar2(85) path 'HIGH_VALUE'
                 ,partition_position number path 'PARTITION_POSITION'
                 ,num_rows number path 'NUM_ROWS'
      ) xmltab
    order by high_date;
    