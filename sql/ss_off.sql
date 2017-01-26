set echo on

-- disable virtual column offloading
alter session set "_cell_offload_virtual_columns"=false;

-- disable bloom filter offloading
alter session set "_bloom_predicate_pushdown_to_storage"=false;

-- disable storage indexes
alter session set "_kcfis_storageidx_disabled"=true;

-- no direct reads
alter session set "_serial_direct_read"=false;

-- disable cell offloading
alter session set cell_offload_processing=false;

set echo off

