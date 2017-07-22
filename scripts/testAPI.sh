#!/bin/bash
#
# .: THE SCRIPT : .
#
#
# Source the settings file
source ./CONFIG_FILE 
read isOnline < ./IS_ONLINE
#
# The result of calling the API
# with the requested paramters,
# here it should be the string 'PONG'
result="$(curl -s -X $queryMethod -H "Accept: application/json" $url | jq -r '.'$jsonKey)"
#
# Check the result of calling the API
if [ "$result" = "$jsonValue" ]
then
	echo "target is ..:: ONLINE ::.."
	isOnline='true'
else
	echo 'target is /!\/!\ :OFFLINE: /!\/!\'
	isOnline='false'
fi
#
# write the value of the isOnline variable to the IS_ONLINE file
echo $isOnline > ./IS_ONLINE
#
# And exit gracefully
exit 0
