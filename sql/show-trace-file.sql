-- Identify the current trace file.
SELECT value
FROM   v$diag_info
WHERE  name = 'Default Trace File';

