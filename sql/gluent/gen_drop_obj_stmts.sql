select
  case
    when hybrid_view_type = 'GLUENT_OFFLOAD_HYBRID_VIEW' then
      'drop view ' || hybrid_owner || '.' || hybrid_view || ';'
      || chr(10)
      || 'drop table ' || hybrid_owner || '.' || hybrid_external_table || ';'
    when hybrid_view_type = 'GLUENT_OFFLOAD_AGGREGATE_HYBRID_VIEW' then
      'drop view ' || hybrid_owner || '.' || hybrid_view || ';'
      || chr(10)
      || 'drop table ' || hybrid_owner || '.' || hybrid_external_table || ';'
      || chr(10)
      || 'execute dbms_advanced_rewrite.drop_rewrite_equivalence( name => '''
      || hybrid_owner || '.' || hybrid_view || ''');'
    else '-- unhandled hybrid_view_type: ' || hybrid_view_type
  end "STMT"
FROM    gluent_adm.offload_objects
WHERE   offloaded_owner = UPPER(&OFFLOAD_OWNER)
AND     offloaded_table = UPPER(&OFFLOAD_TABLE)
;

