alter session set nls_date_format = 'YYYY-MM-DD';

with xmlform as
(
select dbms_xmlgen.getxmltype(
    'select table_name,partition_name,num_rows,high_value,partition_position from dba_tab_partitions where table_owner = ''SCN_AUDIT'' and table_name=''CALL_PARTY_EXTDATA_LOG'''
    ) as x
  from dual
)
select table_name
    , partition
    , num_rows
    , high_value
    --, substr(high_value,1,instr(high_value, ',') ) high_value
    , to_date( substr(high_value, instr(high_value,''' ',1,1)+2, 19 ),'YYYY-MM-DD HH24:MI:SS') high_date
    , partition_position
    from xmlform
      ,xmltable('/ROWSET/ROW'
          passing xmlform.x
          columns table_name varchar2(32) path 'TABLE_NAME'
                 ,partition  varchar2(11)  path 'PARTITION_NAME'
                 ,high_value varchar2(85) path 'HIGH_VALUE'
                 ,partition_position number path 'PARTITION_POSITION'
                 ,num_rows number path 'NUM_ROWS'
      ) xmltab
    order by high_date;

--
--

alter session set nls_date_format = 'YYYY-MM-DD';

with xmlform as
(
select dbms_xmlgen.getxmltype(
    'select table_name,partition_name,num_rows,high_value,partition_position from dba_tab_partitions where table_owner = ''SCN_AUDIT'' and table_name=''CALL_PARTY_LOOKUP_LOG'''
    ) as x
  from dual
)
select table_name
    , partition
    , num_rows
    , high_value
    --, substr(high_value,1,instr(high_value, ',') ) high_value
    , to_date( substr(high_value, instr(high_value,''' ',1,1)+2, 19 ),'YYYY-MM-DD HH24:MI:SS') high_date
    , partition_position
    from xmlform
      ,xmltable('/ROWSET/ROW'
          passing xmlform.x
          columns table_name varchar2(32) path 'TABLE_NAME'
                 ,partition  varchar2(11)  path 'PARTITION_NAME'
                 ,high_value varchar2(85) path 'HIGH_VALUE'
                 ,partition_position number path 'PARTITION_POSITION'
                 ,num_rows number path 'NUM_ROWS'
      ) xmltab
    order by high_date;

--
--

alter session set nls_date_format = 'YYYY-MM-DD';

with xmlform as
(
select dbms_xmlgen.getxmltype(
    'select table_name,partition_name,num_rows,high_value,partition_position from dba_tab_partitions where table_owner = ''SCN_AUDIT'' and table_name=''USER_ACTIVITY_LOG'''
    ) as x
  from dual
)
select table_name
    , partition
    , num_rows
    , high_value
    --, substr(high_value,1,instr(high_value, ',') ) high_value
    , to_date( substr(high_value, instr(high_value,''' ',1,1)+2, 19 ),'YYYY-MM-DD HH24:MI:SS') high_date
    , partition_position
    from xmlform
      ,xmltable('/ROWSET/ROW'
          passing xmlform.x
          columns table_name varchar2(32) path 'TABLE_NAME'
                 ,partition  varchar2(11)  path 'PARTITION_NAME'
                 ,high_value varchar2(85) path 'HIGH_VALUE'
                 ,partition_position number path 'PARTITION_POSITION'
                 ,num_rows number path 'NUM_ROWS'
      ) xmltab
    order by high_date;

--
--

alter session set nls_date_format = 'YYYY-MM-DD';

with xmlform as
(
select dbms_xmlgen.getxmltype(
    'select table_name,partition_name,num_rows,high_value,partition_position from dba_tab_partitions where table_owner = ''SCN_AUDIT'' and table_name=''RULESET_DETAIL_LOG'''
    ) as x
  from dual
)
select table_name
    , partition
    , num_rows
    , high_value
    --, substr(high_value,1,instr(high_value, ',') ) high_value
    , to_date( substr(high_value, instr(high_value,''' ',1,1)+2, 19 ),'YYYY-MM-DD HH24:MI:SS') high_date
    , partition_position
    from xmlform
      ,xmltable('/ROWSET/ROW'
          passing xmlform.x
          columns table_name varchar2(32) path 'TABLE_NAME'
                 ,partition  varchar2(11)  path 'PARTITION_NAME'
                 ,high_value varchar2(85) path 'HIGH_VALUE'
                 ,partition_position number path 'PARTITION_POSITION'
                 ,num_rows number path 'NUM_ROWS'
      ) xmltab
    order by high_date;

--
--

alter session set nls_date_format = 'YYYY-MM-DD';

with xmlform as
(
select dbms_xmlgen.getxmltype(
    'select table_name,partition_name,num_rows,high_value,partition_position from dba_tab_partitions where table_owner = ''SCN_AUDIT'' and table_name=''EVENT_LOG'''
    ) as x
  from dual
)
select table_name
    , partition
    , num_rows
    , high_value
    --, substr(high_value,1,instr(high_value, ',') ) high_value
    , to_date( substr(high_value, instr(high_value,''' ',1,1)+2, 19 ),'YYYY-MM-DD HH24:MI:SS') high_date
    , partition_position
    from xmlform
      ,xmltable('/ROWSET/ROW'
          passing xmlform.x
          columns table_name varchar2(32) path 'TABLE_NAME'
                 ,partition  varchar2(11)  path 'PARTITION_NAME'
                 ,high_value varchar2(85) path 'HIGH_VALUE'
                 ,partition_position number path 'PARTITION_POSITION'
                 ,num_rows number path 'NUM_ROWS'
      ) xmltab
    order by high_date;

--
--

alter session set nls_date_format = 'YYYY-MM-DD';

with xmlform as
(
select dbms_xmlgen.getxmltype(
    'select table_name,partition_name,num_rows,high_value,partition_position from dba_tab_partitions where table_owner = ''SCN_OPDB'' and table_name=''CALL_PARTY_EXTENDED_DATA_HIST'''
    ) as x
  from dual
)
select table_name
    , partition
    , num_rows
    , high_value
    --, substr(high_value,1,instr(high_value, ',') ) high_value
    , to_date( substr(high_value, instr(high_value,''' ',1,1)+2, 19 ),'YYYY-MM-DD HH24:MI:SS') high_date
    , partition_position
    from xmlform
      ,xmltable('/ROWSET/ROW'
          passing xmlform.x
          columns table_name varchar2(32) path 'TABLE_NAME'
                 ,partition  varchar2(11)  path 'PARTITION_NAME'
                 ,high_value varchar2(85) path 'HIGH_VALUE'
                 ,partition_position number path 'PARTITION_POSITION'
                 ,num_rows number path 'NUM_ROWS'
      ) xmltab
    order by high_date;

--
--

alter session set nls_date_format = 'YYYY-MM-DD';

with xmlform as
(
select dbms_xmlgen.getxmltype(
    'select table_name,partition_name,num_rows,high_value,partition_position from dba_tab_partitions where table_owner = ''SCN_USAGE'' and table_name=''USAGE_DETAIL'''
    ) as x
  from dual
)
select table_name
    , partition
    , num_rows
    , high_value
    --, substr(high_value,1,instr(high_value, ',') ) high_value
    --, to_date( substr(high_value, instr(high_value,''' ',1,1)+2, 19 ),'YYYY-MM-DD HH24:MI:SS') high_date
    , partition_position
    from xmlform
      ,xmltable('/ROWSET/ROW'
          passing xmlform.x
          columns table_name varchar2(32) path 'TABLE_NAME'
                 ,partition  varchar2(32)  path 'PARTITION_NAME'
                 ,high_value varchar2(85) path 'HIGH_VALUE'
                 ,partition_position number path 'PARTITION_POSITION'
                 ,num_rows number path 'NUM_ROWS'
      ) xmltab
    order by partition_position
    ;
