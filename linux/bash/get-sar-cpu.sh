#!/bin/bash

FILE=sar.out
TMP_FILE=sar.tmp

rm -f $FILE
rm -f $TMP_FILE
rm -f $SAR_CSV

SFILE="/var/log/sa/sa05"
sar -f $SFILE > $FILE

egrep -v "RESTART|CPU|Average|^$|Linux" $FILE >> $TMP_FILE

MYDATE=`cat $FILE | grep Linux | head | awk '{print $4}'`
#echo "MYDATE = $MYDATE"
#SAR_CSV=sar_${MYDATE}.csv
SAR_CSV=sar.csv
echo "Time, %user, %system" > $SAR_CSV

while IFS= read -r line
do
  #echo "$line"
  #awk '$4 ~ /^[0-9]{2}:[0-9]{2}:[0-9]{2}/ {print $1, $2",", $4",", $6}' $line
  awk '{print $1, $2",", $4",", $6}' >> $SAR_CSV
done < "$TMP_FILE"

