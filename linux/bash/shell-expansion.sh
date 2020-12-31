#!/bin/bash

echo sh{ot,ort,oot}

echo st{il,al}l

for word in `echo sh{ot,ort,oot}`
do
  echo $word
done

echo "${FIRST_NAME:=Rick}"

my_old_l_name="Meiners"
echo "${LAST_NAME:=$my_old_l_name}"

echo $FIRST_NAME $LAST_NAME

