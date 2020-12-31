#!/bin/bash

# math equality
#NUM=3
echo "${NUM:=3}"
if [ $NUM -eq 3 ]
then
  echo "match"
fi

# does file exist
#FILE=if.sh
echo "${FILE:=if.sh}"
if [ -f $FILE ]
then
  echo "file exists"
fi

# does file exist and is readable
echo "${FILE:=if.sh}"
if [ -f $FILE ] && [ -r $FILE ]
then
  echo "file exists and is readable"
fi

# redirect errors if do not enter a number
echo "Enter a number between 1 and 3:"
read VALUE

if [ "$VALUE" -eq "1" ] 2>/dev/null
then
  echo "You entered 1"
elif [ "$VALUE" -eq "2" ] 2>/dev/null
then
  echo "You entered 2"
elif [ "$VALUE" -eq "3" ] 2>/dev/null
then
  echo "You entered 3"
else
  echo "You didn't follow directions!"
fi

