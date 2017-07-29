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


SENDMAIL_SUBJECT="test again"
SENDMAIL_RECIPIENT="toto@to.to"

	# send the email
	/usr/lib/sendmail -s "Subject : $SENDMAIL_SUBJECT" -v $SENDMAIL_RECIPIENT
}

if [ "$BASH_SOURCE" == "$0" ]
then
        postMessage $@
fi

