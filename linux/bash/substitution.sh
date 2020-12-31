#!/bin/bash

shopt -s expand_aliases

alias TODAY="date"

TODAYS_DATE=`date`

echo
echo "TODAY = $TODAY"
echo
echo "Today's Date: $TODAYS_DATE"
echo

A=`TODAY`

echo
echo "With alias, TODAY = $A"
echo

