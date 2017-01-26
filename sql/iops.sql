REM LOCATION:   System Monitoring\Reports
REM FUNCTION:   Reports on the file io status of all of the datafiles
REM             in the database
REM TESTED ON:  10.2.0.3 and 11.1.0.6 (9i should be supported too)
REM PLATFORM:   non-specific
REM REQUIRES:   v$filestat, v$dbfile
REM
REM  This is a part of the Knowledge Xpert for Oracle Administration library.
REM  Copyright (C) 2008 Quest Software
REM  All rights reserved.
REM
REM******************** Knowledge Xpert for Oracle Administration ********************

COLUMN Percent   format 999.99    heading 'Percent|Of IO'
COLUMN ratio     format 999.999   heading 'Block|Read|Ratio'
COLUMN phyrds                     heading 'Physical | Reads'
COLUMN phywrts                    heading 'Physical | Writes'
COLUMN phyblkrd                   heading 'Physical|Block|Reads'
COLUMN name      format a50       heading 'File|Name'
SET feedback off verify off lines 132 pages 60
TTITLE left _date center 'File IO Statistics Report' skip 2

WITH total_io AS
     (SELECT SUM (phyrds + phywrts) sum_io
        FROM v$filestat)
SELECT   NAME, phyrds, phywrts, ((phyrds + phywrts) / c.sum_io) * 100 PERCENT,
         phyblkrd, (phyblkrd / GREATEST (phyrds, 1)) ratio
    FROM SYS.v_$filestat a, SYS.v_$dbfile b, total_io c
   WHERE a.file# = b.file#
ORDER BY a.file#
/
SET feedback on verify on lines 80 pages 22
CLEAR columns
TTITLE off

