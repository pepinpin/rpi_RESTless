#!/bin/bash
#
#
#####
#
#	SEND A MESSAGE / FILE TO ROCKETCHAT
#
#####

function postMessage(){
# set the CONFIG_FILE variable with
# the path to the CONFIG_FILE file
#CONFIG_FILE="$( dirname $( dirname $( realpath $0 ) ) )/CONFIG_FILE"
readonly CONFIG_FILE="$( dirname $( realpath $0 ) )/CONFIG_FILE"

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

# test the rocket chat channel to use
if [[ -z $ROCKETCHAT_ROOM_ID && -z $ROCKETCHAT_CHANNEL_NAME ]]
then
	echo "You need to provider either a channel name or a room id"
	exit 10
fi

usage(){

	echo ""
	echo ""
	echo ""
}

# store the given params as the message to send
message_to_send="$1"

if [ -n $message_to_send ]
then
	echo "No message to send"
	exit 2
fi

#####
#
#	AUTHENTICATE
#
####


# authenticate to get the user id & the authentication token
# use the -k option to avoid checking self sign certifs
# send request as form-data
auth_result="$(curl -k -s $ROCKETCHAT_API_URL/login -d "user=$ROCKETCHAT_USER_EMAIL&password=$ROCKETCHAT_USER_PASSWORD")"

# test the result of calling the API
if [ "$(echo $auth_result | jq -r ."status")" = "success"  ]
then
	auth_token="$(echo $auth_result | jq -r ."data.authToken")"
	user_id="$(echo $auth_result | jq -r ."data.userId")"

else
	echo "Couldn't authenticate with the given username/password" 
	echo "on :: $ROCKETCHAT_API_URL"
	exit 3 # couldn't loggin
fi

#####
#
#	SEND THE MESSAGE
#
#####

# send request as form-data
send_result="$(curl -k -s $ROCKETCHAT_API_URL/chat.postMessage -H "X-Auth-Token: $auth_token" -H "X-User-Id: $user_id" -d "channel=$ROCKETCHAT_CHANNEL_NAME&text=$message_to_send")"

# test the result of calling the API
if [[ "$send_result" = "Bad Request" || $(echo $send_result | jq -r ."success") != "true" ]]
then
	echo "Couldn't post the message"
	echo "This channel may not exist :: $ROCKETCHAT_CHANNEL_NAME"
	echo "Or your message isn't formated properly :: $message_to_send"
	exit 4 # couldn't post the message
fi


#####
#
#	LOGOUT
#
#####

# logout to invalidate the auth token
logout_result="$(curl -k -s $ROCKETCHAT_API_URL/logout -H "X-Auth-Token: $auth_token" -H "X-User-Id: $user_id")"

exit 0
}

if [ "$BASH_SOURCE" == "$0" ]
then
	postMessage $@
fi
