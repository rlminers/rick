SELECT
    module,
    COUNT(*) dim_cputime,
    round(COUNT(*) / SUM(COUNT(*)) OVER(), 2) * 100 pctload
FROM
    v$active_session_history
WHERE
    sample_time > sysdate - 1 / 24 / 60
    AND session_type <> 'BACKGROUND'
    AND session_state = 'ON CPU'
GROUP BY
    module
ORDER BY
    COUNT(*) DESC;

