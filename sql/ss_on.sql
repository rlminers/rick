set echo on

-- enable virtual column offloading
alter session set "_cell_offload_virtual_columns"=true;

-- enable bloom filter offloading
alter session set "_bloom_predicate_pushdown_to_storage"=true;

-- enable storage indexes
alter session set "_kcfis_storageidx_disabled"=false;

-- force direct reads
alter session set "_serial_direct_read"=always;

-- enable cell offloading
alter session set cell_offload_processing=true;

set echo off

