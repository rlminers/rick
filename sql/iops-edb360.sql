PRO
PRO *************************** Sizing ***************************
PRO

WITH 
sysstat_io AS (
SELECT 
       snap_id,
       dbid,
       instance_number,
       stat_id,
       stat_name,
       value
  FROM dba_hist_sysstat
 WHERE stat_name IN (''redo writes'', ''redo size'', ''physical read total IO requests'', ''physical read total bytes'', ''physical write total IO requests'', ''physical write total bytes'', ''user I/O wait time'')
),
snaps AS (
SELECT 
       snap_id,
       dbid,
       instance_number,
       begin_interval_time,
       end_interval_time,
       startup_time
  FROM dba_hist_snapshot
),
sysstat_denorm1 AS (
SELECT 
       t1.snap_id,
       t1.dbid,
       t1.instance_number,
       s1.begin_interval_time,
       s1.end_interval_time,
       CASE WHEN t1.stat_name = ''redo writes'' THEN t1.value - t0.value END redo_writes,
       CASE WHEN t1.stat_name = ''redo size'' THEN t1.value - t0.value END redo_size,
       CASE WHEN t1.stat_name = ''physical read total IO requests'' THEN t1.value - t0.value END IO_read_reqs,
       CASE WHEN t1.stat_name = ''physical read total bytes'' THEN t1.value - t0.value END IO_read_bytes,
       CASE WHEN t1.stat_name = ''physical write total IO requests'' THEN t1.value - t0.value END IO_write_reqs,
       CASE WHEN t1.stat_name = ''physical write total bytes'' THEN t1.value - t0.value END IO_write_bytes,
       CASE WHEN t1.stat_name = ''user I/O wait time'' THEN t1.value - t0.value END userio_cs
  FROM sysstat_io t0,
       sysstat_io t1,
       snaps s0,
       snaps s1
 WHERE t1.snap_id = t0.snap_id + 1
   AND t1.dbid = t0.dbid
   AND t1.instance_number = t0.instance_number
   AND t1.stat_id = t0.stat_id
   AND t1.stat_name = t0.stat_name
   AND s0.snap_id = t0.snap_id
   AND s0.dbid = t0.dbid
   AND s0.instance_number = t0.instance_number
   AND s1.snap_id = t1.snap_id
   AND s1.dbid = t1.dbid
   AND s1.instance_number = t1.instance_number
   AND s1.snap_id = s0.snap_id + 1
   AND s1.startup_time = s0.startup_time
),
sysstat_denorm2 AS (
SELECT 
       snap_id,
       dbid,
       instance_number,
       begin_interval_time,
       end_interval_time,
       SUM(redo_writes) redo_writes,
       SUM(redo_size) redo_size,
       SUM(IO_read_reqs) IO_read_reqs,
       SUM(IO_read_bytes) IO_read_bytes,
       SUM(IO_write_reqs) IO_write_reqs,
       SUM(IO_write_bytes) IO_write_bytes,
       SUM(userio_cs) userio_cs,
       SUM(NVL(redo_writes, 0) + NVL(IO_read_reqs, 0) + NVL(IO_write_reqs, 0)) rw_reqs,
       SUM(IO_read_reqs) r_reqs,
       SUM(NVL(redo_writes, 0) + NVL(IO_write_reqs, 0)) w_reqs,
       SUM(NVL(redo_size, 0) + NVL(IO_read_bytes, 0) + NVL(IO_write_bytes, 0)) rw_bytes,
       SUM(IO_read_bytes) r_bytes,
       SUM(NVL(redo_size, 0) + NVL(IO_write_bytes, 0)) w_bytes,
       ROUND(((CAST(end_interval_time AS DATE) - CAST(begin_interval_time AS DATE)) * 24 * 60 * 60)) elapsed_sec,
       ROUND(SUM(userio_cs) / ((CAST(end_interval_time AS DATE) - CAST(begin_interval_time AS DATE)) * 24 * 60 * 60 * 100), 3) aas_userio
  FROM sysstat_denorm1
 GROUP BY
       snap_id,
       dbid,
       instance_number,
       begin_interval_time,
       end_interval_time
),
sysstat_denorm2_combined AS (
SELECT 
       snap_id,
       dbid,
       MIN(begin_interval_time) begin_interval_time,
       MIN(end_interval_time) end_interval_time,
       SUM(redo_writes) redo_writes,
       SUM(redo_size) redo_size,
       SUM(IO_read_reqs) IO_read_reqs,
       SUM(IO_read_bytes) IO_read_bytes,
       SUM(IO_write_reqs) IO_write_reqs,
       SUM(IO_write_bytes) IO_write_bytes,
       SUM(userio_cs) userio_cs,
       SUM(NVL(redo_writes, 0) + NVL(IO_read_reqs, 0) + NVL(IO_write_reqs, 0)) rw_reqs,
       SUM(IO_read_reqs) r_reqs,
       SUM(NVL(redo_writes, 0) + NVL(IO_write_reqs, 0)) w_reqs,
       SUM(NVL(redo_size, 0) + NVL(IO_read_bytes, 0) + NVL(IO_write_bytes, 0)) rw_bytes,
       SUM(IO_read_bytes) r_bytes,
       SUM(NVL(redo_size, 0) + NVL(IO_write_bytes, 0)) w_bytes,
       ROUND(((MIN(CAST(end_interval_time AS DATE)) - MIN(CAST(begin_interval_time AS DATE))) * 24 * 60 * 60)) elapsed_sec,
       ROUND(SUM(userio_cs) / ((MIN(CAST(end_interval_time AS DATE)) - MIN(CAST(begin_interval_time AS DATE))) * 24 * 60 * 60 * 100), 3) aas_userio
  FROM sysstat_denorm1
 GROUP BY
       snap_id,
       dbid
),
sysstat_denorm3 AS (
SELECT 
       (SELECT LOWER(i.host_name) FROM gv$instance i WHERE i.instance_number = s.instance_number) hostname,
       (SELECT LOWER(i.instance_name) FROM gv$instance i WHERE i.instance_number = s.instance_number) instance,
       ROUND(MAX(rw_reqs / elapsed_sec)) peak_rw_iops,
       ROUND(MAX(r_reqs / elapsed_sec)) peak_r_iops,
       ROUND(MAX(w_reqs / elapsed_sec)) peak_w_iops,
       ROUND(MAX(rw_bytes / 1024 / 1024 / elapsed_sec)) peak_rw_mbps,
       ROUND(MAX(r_bytes / 1024 / 1024 / elapsed_sec)) peak_r_mbps,
       ROUND(MAX(w_bytes / 1024 / 1024 / elapsed_sec)) peak_w_mbps,
       MAX(aas_userio) peak_aas_userio,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (rw_reqs / elapsed_sec))) perc_999_rw_iops,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (r_reqs / elapsed_sec))) perc_999_r_iops,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (w_reqs / elapsed_sec))) perc_999_w_iops,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (rw_bytes / 1024 / 1024 / elapsed_sec))) perc_999_rw_mbps,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (r_bytes / 1024 / 1024 / elapsed_sec))) perc_999_r_mbps,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (w_bytes / 1024 / 1024 / elapsed_sec))) perc_999_w_mbps,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY aas_userio), 3) perc_999_aas_userio,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (rw_reqs / elapsed_sec))) perc_99_rw_iops,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (r_reqs / elapsed_sec))) perc_99_r_iops,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (w_reqs / elapsed_sec))) perc_99_w_iops,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (rw_bytes / 1024 / 1024 / elapsed_sec))) perc_99_rw_mbps,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (r_bytes / 1024 / 1024 / elapsed_sec))) perc_99_r_mbps,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (w_bytes / 1024 / 1024 / elapsed_sec))) perc_99_w_mbps,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY aas_userio), 3) perc_99_aas_userio,
       ROUND(SUM(rw_reqs) / SUM(elapsed_sec)) avg_rw_iops,
       ROUND(SUM(r_reqs) / SUM(elapsed_sec)) avg_r_iops,
       ROUND(SUM(w_reqs) / SUM(elapsed_sec)) avg_w_iops,
       ROUND(SUM(rw_bytes) / 1024 / 1024 / SUM(elapsed_sec)) avg_rw_mbps,
       ROUND(SUM(r_bytes) / 1024 / 1024 / SUM(elapsed_sec)) avg_r_mbps,
       ROUND(SUM(w_bytes) / 1024 / 1024 / SUM(elapsed_sec)) avg_w_mbps,
       ROUND(AVG(aas_userio), 3) avg_aas_userio
  FROM sysstat_denorm2 s
 WHERE elapsed_sec > 60 -- ignore snaps too close
 GROUP BY
       dbid,
       instance_number
 ORDER BY
       hostname,
       instance
),
sysstat_combined AS (
SELECT 
       NULL hostname,
       ''Combined'' instance,
       ROUND(MAX(rw_reqs / elapsed_sec)) peak_rw_iops,
       ROUND(MAX(r_reqs / elapsed_sec)) peak_r_iops,
       ROUND(MAX(w_reqs / elapsed_sec)) peak_w_iops,
       ROUND(MAX(rw_bytes / 1024 / 1024 / elapsed_sec)) peak_rw_mbps,
       ROUND(MAX(r_bytes / 1024 / 1024 / elapsed_sec)) peak_r_mbps,
       ROUND(MAX(w_bytes / 1024 / 1024 / elapsed_sec)) peak_w_mbps,
       MAX(aas_userio) peak_aas_userio,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (rw_reqs / elapsed_sec))) perc_999_rw_iops,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (r_reqs / elapsed_sec))) perc_999_r_iops,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (w_reqs / elapsed_sec))) perc_999_w_iops,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (rw_bytes / 1024 / 1024 / elapsed_sec))) perc_999_rw_mbps,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (r_bytes / 1024 / 1024 / elapsed_sec))) perc_999_r_mbps,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (w_bytes / 1024 / 1024 / elapsed_sec))) perc_999_w_mbps,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY aas_userio), 3) perc_999_aas_userio,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (rw_reqs / elapsed_sec))) perc_99_rw_iops,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (r_reqs / elapsed_sec))) perc_99_r_iops,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (w_reqs / elapsed_sec))) perc_99_w_iops,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (rw_bytes / 1024 / 1024 / elapsed_sec))) perc_99_rw_mbps,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (r_bytes / 1024 / 1024 / elapsed_sec))) perc_99_r_mbps,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (w_bytes / 1024 / 1024 / elapsed_sec))) perc_99_w_mbps,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY aas_userio), 3) perc_99_aas_userio,
       ROUND(SUM(rw_reqs) / SUM(elapsed_sec)) avg_rw_iops,
       ROUND(SUM(r_reqs) / SUM(elapsed_sec)) avg_r_iops,
       ROUND(SUM(w_reqs) / SUM(elapsed_sec)) avg_w_iops,
       ROUND(SUM(rw_bytes) / 1024 / 1024 / SUM(elapsed_sec)) avg_rw_mbps,
       ROUND(SUM(r_bytes) / 1024 / 1024 / SUM(elapsed_sec)) avg_r_mbps,
       ROUND(SUM(w_bytes) / 1024 / 1024 / SUM(elapsed_sec)) avg_w_mbps,
       ROUND(AVG(aas_userio), 3) avg_aas_userio
  FROM sysstat_denorm2_combined s
 WHERE elapsed_sec > 60 -- ignore snaps too close
),
sysstat_total AS (
SELECT 
       NULL hostname,
       ''Sum'' instance,
       SUM(peak_rw_iops) peak_rw_iops,
       SUM(peak_r_iops) peak_r_iops,
       SUM(peak_w_iops) peak_w_iops,
       SUM(peak_rw_mbps) peak_rw_mbps,
       SUM(peak_r_mbps) peak_r_mbps,
       SUM(peak_w_mbps) peak_w_mbps,
       SUM(peak_aas_userio) peak_aas_userio,
       SUM(perc_999_rw_iops) perc_999_rw_iops,
       SUM(perc_999_r_iops) perc_999_r_iops,
       SUM(perc_999_w_iops) perc_999_w_iops,
       SUM(perc_999_rw_mbps) perc_999_rw_mbps,
       SUM(perc_999_r_mbps) perc_999_r_mbps,
       SUM(perc_999_w_mbps) perc_999_w_mbps,
       SUM(perc_999_aas_userio) perc_999_aas_userio,
       SUM(perc_99_rw_iops) perc_99_rw_iops,
       SUM(perc_99_r_iops) perc_99_r_iops,
       SUM(perc_99_w_iops) perc_99_w_iops,
       SUM(perc_99_rw_mbps) perc_99_rw_mbps,
       SUM(perc_99_r_mbps) perc_99_r_mbps,
       SUM(perc_99_w_mbps) perc_99_w_mbps,
       SUM(perc_99_aas_userio) perc_99_aas_userio,
       SUM(avg_rw_iops) avg_rw_iops,
       SUM(avg_r_iops) avg_r_iops,
       SUM(avg_w_iops) avg_w_iops,
       SUM(avg_rw_mbps) avg_rw_mbps,
       SUM(avg_r_mbps) avg_r_mbps,
       SUM(avg_w_mbps) avg_w_mbps,
       SUM(avg_aas_userio) avg_aas_userio
  FROM sysstat_denorm3
)
SELECT * 
  FROM sysstat_denorm3
 UNION ALL
SELECT * 
  FROM sysstat_combined
 UNION ALL
SELECT * 
  FROM sysstat_total
;

