SELECT r.apply_name
, 86400 * (r.dequeue_time - c.lwm_message_create_time) latency_in_seconds
FROM GV$GG_APPLY_READER r
, GV$GG_APPLY_COORDINATOR c
WHERE r.apply# = c.apply#
AND r.apply_name = c.apply_name;

