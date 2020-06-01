#!/bin/sh

NODES="localhost"

active_node=''
for node in $NODES
do
  echo "Checking ${node} ..."
  if hadoop fs -test -e hdfs://${node}/
  then
    active_node=${node}
  fi
done

echo
echo "Active namenode : $active_node"

