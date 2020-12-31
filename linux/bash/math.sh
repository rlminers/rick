#!/bin/bash

# must put spaces between operands
echo

# modulus
expr 24 % 5

# addition
expr 4 + 4

# subtraction
expr 16 - 1

# division
expr 32 / 2

# order of precedence
expr 3 + 10 \* 2

# multiplication
expr 21 \* 2


echo
# grouping
#expr \( 3 + 10 \)  \* 2

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

SUM="$[ $ONE + $TWO + $THREE + $FOUR + $FIVE + $SIX ]"
echo "The total is ${TOTAL:=$SUM}"
echo

SUM2=$(( ONE + TWO + THREE + FOUR + FIVE + SIX ))
echo "SUM2 = $SUM2"
echo

