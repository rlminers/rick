ALTER SESSION SET NLS_DATE_FORMAT='DD-Mon-RR HH12:MI AM';
ALTER SESSION SET NLS_DATE_LANGUAGE=AMERICAN;

SELECT FACILITY
, ERROR_CODE
, TIMESTAMP
, MESSAGE FROM V$DATAGUARD_STATUS
WHERE TRUNC(TIMESTAMP)= TRUNC(SYSTIMESTAMP)
ORDER BY TIMESTAMP;

