#!/bin/sh

TABLE="/apps/securus/pre-prod/offload/sec_scn_audit.db/call_party_extdata_log"

BUCKETS=`hdfs dfs -ls $TABLE | grep "bucket_id=0" | awk '{print $8}'`
for BUCKET in $BUCKETS
do
  echo $BUCKET
  BUCKET_CMD="hdfs dfs -ls $BUCKET"
  PARTITIONS=`$BUCKET_CMD | awk '{print $8}'`
  for PARTITION in $PARTITIONS
  do
    echo $PARTITION
    FILE_CMD="hdfs dfs -ls -h $PARTITION"
    FILES=`$FILE_CMD | awk '{printf "%s", $5} {printf "%s", $6} END {print ""}'`
    for FILE in $FILES
    do
      echo $FILE
    done
  done
done

exit 0

