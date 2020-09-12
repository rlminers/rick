col capture_message_create_time for a30;
col enqueue_message_create_time for a27;
col available_message_create_time for a30;

SELECT capture_name
, to_char(capture_time
, 'mm-dd-yy hh24:mi') capture_time
, capture_message_number
, to_char(capture_message_create_time,'mm-dd-yy hh24:mi') capture_message_create_time
, to_char(enqueue_time,'mm-dd-yy hh24:mi') enqueue_time
, enqueue_message_number
, to_char(enqueue_message_create_time, 'mm-dd-yy hh24:mi') enqueue_message_create_time
, available_message_number
, to_char(available_message_create_time,'mm-dd-yy hh24:mi') available_message_create_time
FROM GV$GOLDENGATE_CAPTURE;

