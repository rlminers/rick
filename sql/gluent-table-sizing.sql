/*
SCN_AUDIT.CALL_PARTY_EXTDATA_LOG
SCN_AUDIT.CALL_PARTY_LOOKUP_LOG
SCN_AUDIT.EVENT_LOG
SCN_AUDIT.RULESET_DETAIL_LOG
SCN_AUDIT.USER_ACTIVITY_LOG

SCN_OPDB.CALL_PARTY_EXTENDED_DATA_HIST

SCN_USAGE.USAGE_DETAIL
*/

WITH
  tables AS (
    SELECT
        /*+
          materialize
          no_merge(dt)
          user_hash(dtp dts)
        */
        dt.owner                                       table_owner
        , dt.table_name                                table_name
        , dt.num_rows                                  table_num_rows
        , dt.compression                               table_compression
        , dt.compress_for                              table_compress_for
        , dtp.partition_position                       partition_position
        , dtp.partition_name                           partition_name
        , dtp.high_value                               partition_high_value
        , dtp.num_rows                                 partition_num_rows
        , dtp.compression                              partition_compression
        , dtp.compress_for                             partition_compress_for
        , dts.subpartition_position                    subpartition_position
        , dts.subpartition_name                        subpartition_name
        , dts.high_value                               subpartition_high_value
        , dts.num_rows                                 subpartition_num_rows
        , dts.compression                              subpartition_compression
        , dts.compress_for                             subpartition_compress_for
      FROM
        dba_tables dt
      LEFT OUTER JOIN
          dba_tab_partitions dtp
        ON (
          dtp.table_owner = dt.owner
          AND dtp.table_name = dt.table_name
        )
      LEFT OUTER JOIN
          dba_tab_subpartitions dts
        ON (
          dts.table_owner = dtp.table_owner
          AND dts.table_name = dtp.table_name
          AND dts.partition_name = dtp.partition_name
        )
      WHERE
        dt.owner = UPPER( '&OWN.')
        AND dt.table_name = UPPER( '&TAB.')
  )
,
  segments AS (
    SELECT
        /*+
          materialize
          no_merge(ds)
        */
        ds.owner
        , ds.segment_name
        , ds.partition_name
        , ds.bytes
      FROM
        dba_segments ds
      WHERE
        ds.owner = UPPER( '&OWN.')
  )
SELECT
    LPAD( TO_CHAR( NVL( t.partition_position, 0)), 7, '0')
      || '.' || LPAD( TO_CHAR( NVL( t.subpartition_position, 0)), 7, '0')                          position
    , t.table_owner                                                                                table_owner
    , t.table_name                                                                                 table_name
    , t.partition_name                                                                             partition_name
    , t.subpartition_name                                                                          subpartition_name
    , COALESCE( t.subpartition_high_value, t.partition_high_value)                                 high_value
    , COALESCE( t.subpartition_num_rows, t.partition_num_rows, t.table_num_rows)                   num_rows
    , COALESCE( t.subpartition_compression, t.partition_compression, t.table_compression)          compression
    , COALESCE( t.subpartition_compress_for, t.partition_compress_for, t.table_compress_for)       compress_for
    , s.bytes/1024                                                                                 kilobytes
  FROM
    tables t
  INNER JOIN
      segments s
    ON (
      s.owner = t.table_owner
      AND s.segment_name = t.table_name
      AND COALESCE( s.partition_name, s.segment_name) = COALESCE( t.subpartition_name, t.partition_name, t.table_name)
    )
  ORDER BY
    position;
