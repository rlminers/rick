set feedback off
set echo     off
set timing   off
set heading  off
set pagesize 0
set linesize 2000
 
SELECT /***** ASM SPACE USAGE *****/
       CONCAT('+' || disk_group_name, SYS_CONNECT_BY_PATH(alias_name, '/')) ||'!~!'||
       bytes                                                                ||'!~!'||
       space                                                                ||'!~!'||
       NVL(type, '<DIRECTORY>')                                             ||'!~!'||
       creation_date                                                        ||'!~!'||
       creation_time                                                        ||'!~!'||
       modification_date                                                    ||'!~!'||
       modification_time                                                    ||'!~!'||
       disk_group_name                                                      ||'!~!'||
       system_created
  FROM (SELECT g.name                                     disk_group_name,
               a.parent_index                             pindex,
               a.name                                     alias_name,
               a.reference_index                          rindex,
               a.system_created                           system_created,
               f.bytes                                    bytes,
               f.space                                    space,
               f.type                                     type,
               TO_CHAR(f.creation_date, 'YYYY-MM-DD')     creation_date,
               TO_CHAR(f.creation_date, 'HH24:MI:SS')     creation_time,
               TO_CHAR(f.modification_date, 'YYYY-MM-DD') modification_date,
               TO_CHAR(f.modification_date, 'HH24:MI:SS') modification_time
          FROM v$asm_file  f,
               v$asm_alias a,
               v$asm_diskgroup g
         WHERE (f.group_number(+) = a.group_number and f.file_number(+) = a.file_number)
           AND g.group_number(+)  = f.group_number
       )
WHERE type IS NOT NULL
START WITH (MOD(pindex, POWER(2, 24))) = 0 CONNECT BY PRIOR rindex = pindex;

