SELECT capture_name
, 86400 * (available_message_create_time - capture_message_create_time) lag_in_seconds
FROM GV$GOLDENGATE_CAPTURE;

