#!/bin/bash
#
# .: THE SCRIPT : .
#
#
# set the CONFIG_FILE variable with 
# the path to the CONFIG_FILE file
CONFIG_FILE="$( dirname $( dirname $( realpath $0 ) ) )/CONFIG_FILE"
# test if the file exist
if [ -f $CONFIG_FILE  ]
# if it does
then
	# source it
	source $CONFIG_FILE
 
# if it doesn't exist
else
	# exit with an error
	exit 1 # the file doesn't exist
fi

#
# The result of calling the API
# with the requested paramters,
# here it should be the string 'PONG'
result="$(curl -s -X $queryMethod -H "Accept: application/json" $url | jq -r '.'$jsonKey)"
#
# Check if the CONFIG_FILE exists (to avoid side effects) and
# test the result of calling the API
if [[ -f $CONFIG_FILE && "$result" = "$jsonValue" ]]
then
	echo "target is ..:: ONLINE ::.."
#	isOnline='true'
else
	echo 'target is /!\/!\ :OFFLINE: /!\/!\'
#	isOnline='false'
fi
#
# write the value of the isOnline variable to the IS_ONLINE file
#echo $isOnline > ./IS_ONLINE
#
# And exit gracefully
exit 0
