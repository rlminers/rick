SELECT
    'execute SYS.DBMS_ADVANCED_REWRITE.ALTER_REWRITE_EQUIVALENCE('''
    || hybrid_owner
    || '.'
    || hybrid_view
    || ''' , REWRITE_MODE=>''DISABLED'')'
FROM
    gluent_adm.offload_objects oo
WHERE
    hybrid_view_type = 'GLUENT_OFFLOAD_AGGREGATE_HYBRID_VIEW'
-- and hybrid_view like '%CNT%'
    AND EXISTS (
        SELECT
            1
        FROM
            dba_rewrite_equivalences dre
        WHERE
            rewrite_mode = 'GENERAL'
            AND oo.hybrid_owner = dre.owner
            AND oo.hybrid_view = dre.name
    )
    AND hybrid_owner LIKE upper('&hybrid_user')
    AND hybrid_view LIKE upper('&hybrid_view')
;

