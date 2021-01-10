ALTER SESSION SET NLS_DATE_FORMAT='DD-Mon-RR HH12:MI AM';
ALTER SESSION SET NLS_DATE_LANGUAGE=AMERICAN;

SELECT NAME
, VALUE
, UNIT
, TIME_COMPUTED
FROM V$DATAGUARD_STATS
WHERE NAME IN ('transport lag','apply lag','apply finish time');

