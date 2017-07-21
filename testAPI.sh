#!/bin/bash
#
#
# .: THE SCRIPT : .
#
#
# Source the settings file
source ./CONFIG_FILE 
#
#
# The result of calling the API
# with the requested paramters,
# here it should be the string 'PONG'
result="$(curl -s -X $queryMethod -H "Accept: application/json" $url | jq -r '.'$jsonKey)"

# Check the result of calling the API
if [ "$result" = 'PONG' ]
then
	echo "TRUE"
	exit 0
else
	echo "FALSE"
	exit 1
fi
