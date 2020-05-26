-- Turn on tracing.
EXEC DBMS_MONITOR.session_trace_enable(waits=>TRUE, binds=>FALSE);

