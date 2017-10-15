#!/bin/bash
#
#
#####
#
#       EMULATE A HEARTBEAT
#
#####
	
# set the CONFIG_FILE variable with
# the path to the CONFIG_FILE file
CONFIG_FILE=$(dirname $( dirname $( realpath $0 ) ) )/CONFIG_FILE
SCRIPTS=$(dirname $( dirname $( realpath $0 ) ) )/scripts

# test if the files exist
if [[ -f $CONFIG_FILE ]]
# if they do
then
    # source them
    source $CONFIG_FILE

# if they don't
else
        # exit with an error
        exit 1 # the files don't exist
fi


# Emulate the heartBeat
${SCRIPTS}/useGPIO.sh write ${GPIO_PIN} 1
sleep 0.5
${SCRIPTS}/useGPIO.sh write ${GPIO_PIN} 0
sleep 0.2
${SCRIPTS}/useGPIO.sh write ${GPIO_PIN} 1
sleep 0.2
${SCRIPTS}/useGPIO.sh write ${GPIO_PIN} 0
sleep 0.2
${SCRIPTS}/useGPIO.sh write ${GPIO_PIN} 1
sleep 0.2
${SCRIPTS}/useGPIO.sh write ${GPIO_PIN} 0

exit 0
