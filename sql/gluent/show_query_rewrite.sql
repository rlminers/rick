select
    SOURCE_STMT
    , DESTINATION_STMT
  from
    dba_rewrite_equivalences
  where
    owner = Upper( '&hybrid_owner')
    and name = Upper( '&hybrid_view')
  order by
    owner
    , name
;

