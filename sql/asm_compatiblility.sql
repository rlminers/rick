col dg_name format a10
col compatibility heading compat format a10
col database_compatibility heading db_compat format a10
col ab_name format a25
col value format a12

break on group_number skip 1

SELECT dg.group_number
, dg.name DG_NAME
, dg.compatibility
, dg.database_compatibility
, ab.name ab_name
, ab.value
FROM v$asm_diskgroup dg, v$asm_attribute ab
where dg.group_number = ab.group_number
and ( ab.name like 'compatible%'
   or ab.name = 'content.type' 
   or ab.name = 'au_size' 
   or ab.name = 'disk_repair_time' 
   or ab.name like 'cell.smart_scan_%' )
order by dg.group_number, dg.name;

