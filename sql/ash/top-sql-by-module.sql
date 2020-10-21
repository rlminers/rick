SELECT
    module,
    COUNT(*) dim_dbtime,
    round(COUNT(*) / SUM(COUNT(*)) OVER(), 2) * 100 pctload
FROM
    v$active_session_history
WHERE
    sample_time >= current_timestamp - INTERVAL '5' MINUTE
    AND session_type <> 'BACKGROUND'
GROUP BY
    module
ORDER BY
    COUNT(*) DESC;

