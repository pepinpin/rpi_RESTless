#!/bin/bash
#
#
#####
#
#       SEND AN EMAIL
#
#####

function sendEmail(){
	
	# set the CONFIG_FILE variable with
	# the path to the CONFIG_FILE file
	CONFIG_FILE=$( dirname $( realpath $0 ) )/CONFIG_FILE
	
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

# store the given params as the message to send
subject_to_send="$@"

	if [ "$subject_to_send" = "" ]
	then
        	echo "No message to send"
        	exit 2
	fi

	# send the email
	echo "Subject: $subject_to_send" | /usr/lib/sendmail -v $SENDMAIL_RECIPIENT

}

if [ "$BASH_SOURCE" == "$0" ]
then
        sendEmail $@
fi

