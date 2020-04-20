set linesize 200 pages 1000
col osuser for a20 wrap
col USERNAME for a20 wrap
col terminal for a15 wrap
col program for a20 wrap
col module for a20 wrap
col last_act for a15
col sess_inf for a15 heading "INST:(SID,SER#)"
col user_inf for a25 heading "USER (OSUSER)"
col prog_inf for a15 heading "MODULE (PROGRAM)"
col os_pid for a10
col wait_event for a28
 
WITH hybrid_sql AS (
SELECT  DISTINCT s.sql_id
FROM    gv$sql_plan                 s
        INNER JOIN
        gluent_adm.offload_objects  o
        ON (    s.object_owner = o.hybrid_owner
            AND s.object_name  = o.hybrid_external_table)
)
SELECT  s.inst_id||': ('||s.sid||','||s.serial#||')'                   AS sess_inf
,       s.username||' ('||nvl(s.osuser,'Unknown')||')'                 AS user_inf
,       nvl(s.TYPE,'Unknown')                                          AS type
,       nvl(substr(S.MODULE,1,15),'Unknown')                           AS prog_inf
,       p.spid                                                         AS os_pid
,       nvl(S.STATUS,'Unknown')                                        AS status
,       to_char((sysdate - S.last_call_et / 86400),'DD-MM-RR HH24:MI') AS last_activity
,       round(S.last_call_et / 3600, 2)                                AS hrs_ago
,       nvl(s.SQL_ID,'Unknown')                                        AS sql_id
,       nvl(s.PREV_SQL_ID,'Unknown')                                   AS prev_sql_id
,       nvl(s.event,'Unknown')                                         AS wait_event
,       s.seconds_in_wait                                              AS sec_wt
,       round(p.pga_max_mem / 1024 / 1024, 2)                          AS pga_alloc_mb
FROM    gv$process p
        LEFT OUTER JOIN
        gv$session s
        ON (    p.addr    = s.paddr
            AND p.inst_id = s.inst_id)
        INNER JOIN
        hybrid_sql h
        ON (   s.sql_id      = h.sql_id
            OR s.prev_sql_id = h.sql_id)
order by hrs_ago DESC;

