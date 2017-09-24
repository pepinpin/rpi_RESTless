#!/bin/bash
#
# .: THE SCRIPT THAT TESTS THE API :.
#
#

# set the CONFIG_FILE variable with 
# the path to the CONFIG_FILE file
CONFIG_FILE=$( dirname $( dirname $( realpath $0 ) ) )/CONFIG_FILE

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


# The result of calling the API
# with the requested parameters,
# here it should be the string 'PONG'
result="$(curl -s -X $QUERY_METHOD -H "Accept: application/json" $URL | jq -r '.'$JSON_KEY 2> /dev/null)"

# test the result of calling the API
if [ "$result" = "$JSON_VALUE" ]
then
	exit 0 # the target has been reached
else
	if [ "${DEBUG}" = "true" ]
	then
		echo "The API didn't reply with the expected response or the API cannot be reached"
	fi

	exit 2 # the target can't be reached
fi
