#!/bin/bash
#
#
##################################
#
#       EMULATE A ALERT SIGNAL
#
##################################

cmd_arg=${1}

# set the CONFIG_FILE variable with
# the path to the CONFIG_FILE file
CONFIG_FILE=$( dirname $( dirname $( realpath $0 ) ) )/CONFIG_FILE
SCRIPTS=$(dirname $( dirname $( realpath $0 ) ) )/scripts


PID=$$
PID_FILE=/dev/shm/flashAlert_rpi_restless.pid


####################################################
#
# Test for the config file and the GPIO script
#
####################################################
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


#########################
#
# The interesting part
#
#########################
#
# test the argument passed to this script
case ${cmd_arg} in
    start)

        ###########################################################
        #
        # The following section is to insure that there is only
        # 1 instance of this script running at any point in time
        #
        ###########################################################
        # The location to store the PID file
        # by default it's stored on a tmpfs partiton (/dev/shm)
        # that only exist in memory to avoid unecessary access to the SDCard

        # check if the file exists
        if [ -f $PID_FILE  ]

        # if it does exist
        then
            # set the PID variable the value stored in the PID_FILE
            PID=$(cat $PID_FILE)

            # check to see if a process is already running with this PID
            ps -p $PID > /dev/null 2>&1

            # if there is one
            if [ $? -eq 0 ]
            then
                # exit with an error
                exit 2 # process already running
            else
            # no process is running with the tested PID,
            # we can assume that this script isn't running
                # copy the PID of the process running
                # this script into the PID_FILE
                echo $$ > $PID_FILE

                # if it can't write to the file (for whatever reason)
                if [ $? -ne 0 ]
                then
                    # exit with an error
                    exit 1 # cannot create the pid file
                fi
            fi

        # if it doesn't exist
        else
            # copy the PID of the process running
            # this script into the PID_FILE
            echo $$ > $PID_FILE

            # if it can't create the file (for whatever reason)
            if [ $? -ne 0 ]
            then
                # exit with an error
                exit 1 # cannot create the pid file
            fi
        fi

        if [ "${DEBUG}" = "true" ]
        then
            echo ""
            echo "The Alert is flashing !!!"
            echo ""
        fi

        #################################
        #
        #   FLASH THE LIGHT / GPIO pin
        #
        #################################
        while :
        do
            # Emulate the Alert signal
            ${SCRIPTS}/useGPIO.sh write ${GPIO_PIN} 1
            sleep 1
            ${SCRIPTS}/useGPIO.sh write ${GPIO_PIN} 0
            sleep 0.5
        done
    ;;
    stop)

        if [ -f ${PID_FILE} ]
        then
            ${SCRIPTS}/useGPIO.sh write ${GPIO_PIN} 0
            PID=$(cat ${PID_FILE})
            kill ${PID}
            rm ${PID_FILE}

            if [ "${DEBUG}" = "true" ]
            then
                echo ""
                echo "The Alert has STOP flashing !!!"
                echo ""
            fi
        else
            if [ "${DEBUG}" = "true" ]
            then
                echo "The Alert is NOT flashing !!!"
            fi
        fi

    ;;
    *)
        echo ""
        echo "To use this script, call it with the 'start' or 'stop' argument"
        echo 'example ::'
        echo "          ${0} start"
        echo "or"
        echo "          ${0} stop"
        echo ""
        exit 0
esac

exit 0