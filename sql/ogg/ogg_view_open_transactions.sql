SELECT component_name capture_name
, count(*) open_transactions
, sum(cumulative_message_count) LCRs
FROM GV$GOLDENGATE_TRANSACTION
WHERE component_type='CAPTURE'
group by component_name;

