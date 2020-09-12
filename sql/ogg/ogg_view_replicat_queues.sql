select REPLICAT_NAME,SERVER_NAME from DBA_GOLDENGATE_INBOUND;
select APPLY_NAME,QUEUE_NAME,status from dba_apply;
select apply_ame,state from V$GG_APPLY_COORDINATOR ;
select server_id,TOTAL_MESSAGES_APPLIED from V$GG_APPLY_SERVER where apply_ name='OGG$RFDLD001';

