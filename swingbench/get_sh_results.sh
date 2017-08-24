#!/bin/sh

FILE=$1

cat $FILE | egrep "Result id|AverageResponse|TransactionCount" | grep -v FailedTransactionCount 

#cat $FILE | egrep "Result id|AverageResponse|TransactionCount" | grep -v FailedTransactionCount | awk -F">" '{print $2}' | awk -F"<" '{print $1}'

