#!/bin/bash
#
#
#####
#
#       EMULATE A HEARTBEAT
#
#####

function heartBeat(){
	
	# set the CONFIG_FILE variable with
	# the path to the CONFIG_FILE file
	CONFIG_FILE=$( dirname $( realpath $0 ) )/CONFIG_FILE
	GPIO=$( dirname $( realpath $0 ) )/scripts/useGPIO.sh

	# test if the files exist
	if [[ -f $CONFIG_FILE && -f $GPIO ]]
	# if they do
	then
	        # source them
	        source $CONFIG_FILE
		source $GPIO
	
	# if they don't
	else
	        # exit with an error
	        exit 1 # the files don't exist
	fi


	# Emulate the heartBeat
	gpio write $GPIO_PIN 1
	sleep 0.5
	gpio write $GPIO_PIN 0
	sleep 0.2
	gpio write $GPIO_PIN 1
	sleep 0.2
	gpio write $GPIO_PIN 0
        sleep 0.2
        gpio write $GPIO_PIN 1
        sleep 0.2
        gpio write $GPIO_PIN 0
}


if [ "$BASH_SOURCE" == "$0" ]
then
        heartBeat $@
fi

