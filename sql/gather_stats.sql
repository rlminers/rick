set serveroutput on

declare
  cursor c_users is
  select username
  from dba_users
  where username not in ( 'ANONYMOUS',
'APEX_040200','APEX_PUBLIC_USER','APPQOSSYS','AUDSYS','CTXSYS','DBSNMP','DIP','DVF','DVSYS',
'ENKITEC','FLOWS_FILES','GSMADMIN_INTERNAL','GSMCATUSER','GSMUSER','LBACSYS','MDDATA','MDSYS',
'OJVMSYS','OLAPSYS','ORACLE_OCM','ORDDATA','ORDPLUGINS','ORDSYS','OUTLN','SCOTT','SI_INFORMTN_SCHEMA',
'SPATIAL_CSW_ADMIN_USR','SPATIAL_WFS_ADMIN_USR','SYS','SYSBACKUP','SYSDG','SYSKM','SYSTEM','WMSYS',
'XDB','XS$NULL','EXADATA','IBMCDC','MIS','MIS_DM_RPT','MIS_RPT_DEV')
order by username;

begin
  for r_users in c_users loop
    dbms_output.put_line('user = ' || r_users.username );
    SYS.DBMS_STATS.GATHER_SCHEMA_STATS (
     ownname => r_users.username
   , estimate_percent => dbms_stats.auto_sample_size
   , degree => 16
   , options => 'GATHER AUTO'
--   , cascade => TRUE
  );
  end loop;
end;
/

