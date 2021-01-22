set lines 120

select 'EXEC SYS.DBMS_ADVANCED_REWRITE.DROP_REWRITE_EQUIVALENCE (name => ''' || owner || '.' || name || ''');'
from DBA_REWRITE_EQUIVALENCES
where owner = upper( '&owner' )
;

/*
Drop query rewrite rules
Fri Jan 22 08:51:57 2021
Oracle sql: BEGIN SYS.DBMS_ADVANCED_REWRITE.DROP_REWRITE_EQUIVALENCE(:1); END;
Bind values:
:1 = SCN_AUDIT_H.CALL_PARTY_EXTDATA_LOG_AGG
Step time: 0:00:00
Done

Create query rewrite rules
Fri Jan 22 08:51:57 2021
Oracle sql: BEGIN
  sys.DBMS_ADVANCED_REWRITE.DECLARE_REWRITE_EQUIVALENCE(
    :1,
    :2,
    :3,
    validate=>false,
    rewrite_mode=>'general');
END;

*/

