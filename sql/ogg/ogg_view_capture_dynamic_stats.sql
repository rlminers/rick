col state for a30;

SELECT sid
, serial#
, capture#
, CAPTURE_NAME
, STARTUP_TIME
, CAPTURE_TIME
, state
, SGA_USED
, BYTES_OF_REDO_MINED
, to_char(STATE_CHANGED_TIME
, 'mm-dd-yy hh24:mi') STATE_CHANGED_TIME
FROM V$GOLDENGATE_CAPTURE;

