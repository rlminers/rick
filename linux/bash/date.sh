#!/bin/bash

# create a file with a creation date of 30 minutes ago
touch -t $(date -d "30 mins ago" +%Y%m%d%H%M.%S) filename

