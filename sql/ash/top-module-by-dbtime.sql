SELECT *
FROM (
  SELECT
      module,
      COUNT(*) dim_dbtime,
      round(COUNT(*) / SUM(COUNT(*)) OVER(), 2) * 100 pctload
  FROM
      v$active_session_history
  WHERE
      sample_time > sysdate - 1 / 24 / 60
      AND session_type <> 'BACKGROUND'
  GROUP BY
      module
  ORDER BY
      COUNT(*) DESC
)
WHERE rownum <= 10;

-- -----------------------------------------------
-- define the variable
-- -----------------------------------------------
undefine r_max_snap
col r_max_snap new_value r_max_snap

-- -----------------------------------------------
-- turn off output and set value of the variable
-- -----------------------------------------------
set termout off

select max(snap_id) as r_max_snap
from dba_hist_snapshot;

variable r_max_snap number;
exec :r_max_snap :='&r_max_snap';
set termout on

SELECT *
FROM (
  SELECT
      module,
      COUNT(*) * 10 dim_dbtime,
      round(COUNT(*) / SUM(COUNT(*)) OVER(), 2) * 100 pctload
  FROM
      dba_hist_active_sess_history
  WHERE
      snap_id >= :r_max_snap - 1
      AND snap_id < :r_max_snap
      AND session_type <> 'BACKGROUND'
  GROUP BY
      module
  ORDER BY
      COUNT(*) DESC
)
WHERE rownum <= 10;

