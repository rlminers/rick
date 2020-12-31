#!/bin/bash

echo

ONE="$[ 24 % 5 ]"
TWO="$[ 4 + 4 ]"
THREE="$[ 16 - 1 ]"
FOUR="$[ 32 / 2 ]"
FIVE="$[ ( 3 + 10 ) * 2 - 3 ]"
SIX="$[ 21 * 2 ]"

SUM=0
for NUM in "$ONE $TWO $THREE $FOUR $FIVE $SIX"
do
  echo $NUM
done

SUM=$(( ONE + TWO + THREE + FOUR + FIVE + SIX ))
echo "SUM = $SUM"
echo

MY_ARRAY=("FIRST" "SECOND" "THIRD")
echo ${MY_ARRAY}
echo ${MY_ARRAY[0]}
echo ${MY_ARRAY[1]}
echo ${MY_ARRAY[2]}
echo ${MY_ARRAY[*]}
MY_ARRAY[3]="FOUR"
echo ${MY_ARRAY[*]}

echo
MY_NUM_ARRAY=( $ONE $TWO $THREE $FOUR $FIVE $SIX )
COUNT=0

for INDEX in ${MY_NUM_ARRAY[@]}
do
  #echo "INDEX = $INDEX"
  #echo ${MY_NUM_ARRAY[$COUNT]}
  echo ${MY_NUM_ARRAY[COUNT]}
  COUNT=$(( $COUNT + 1 ))
done

