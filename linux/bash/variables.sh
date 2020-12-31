#!/bin/bash

# defining variables explicitly

# integer
declare -i NUM1=10
declare -p NUM1

# readonly
declare -r READ_ONLY="Cannot overwrite"
declare -p READ_ONLY

# optional readonly
readonly RO="Do NOT overwrite"
echo $RO

