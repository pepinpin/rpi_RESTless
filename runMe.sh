#!/bin/bash
#
# The MAIN script
#
#
###
#
# The argument
#
###
# if the argument "force" is passed to this script
# the test will check if the API is online and reset
# the alert if it is (to avoid having an email/chat message
# saying the API is down after a reboot)
#
force_check_on_reboot=false
if [ "${1}" = "force" ]
then
    force_check_on_reboot=true
    sleep 120 # sleep 2 mn after reboot to ensure the wifi is up
fi

####
#
# The config file
#
###

CONFIG_FILE=$(dirname $(realpath $0 ))/CONFIG_FILE

###
#
# The Scripts
#
###

TEST_API=$(dirname $(realpath $0 ) )/scripts/testAPI.sh
GPIO=$(dirname $(realpath $0 ))/scripts/useGPIO.sh
CHAT=$(dirname $(realpath $0 ))/scripts/useRocketChat.sh
EMAIL=$(dirname $(realpath $0 ))/scripts/sendEmail.sh
HEARTBEAT=$(dirname $(realpath $0 ))/scripts/heartBeat.sh

###
#
# Test to make sure the files
# are where they supposed to be
#
###

if [[ -f $CONFIG_FILE  && -f $TEST_API && -f $GPIO && -f $EMAIL && -f $HEARTBEAT ]]
# if they do
then
    # source the needed files
    source $CONFIG_FILE
    source $GPIO
    source $CHAT
    source $EMAIL
    source $HEARTBEAT

# if one of them doesn't exist
else
    # exit with an error
    exit 1
fi


##########
#
# The following section is to insure that there is only 
# 1 instance of this script running at any point in time
#
##########

# The location to store the PID file
# by default it's stored on a tmpfs partiton (/dev/shm)
# that only exist in memory to avoid unecessary access to the SDCard
PID_FILE=/dev/shm/runMe_rpi_restless.pid

#debug
if [ "$DEBUG" = "true" ] 
then
    echo "the PID for this process is :: $$"
fi


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
        #debug
        #echo "Process already running"
        if [ $DEBUG = true  ]
        then
            echo "Process already running"
        fi

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
            #debug
            if [ $DEBUG = true  ]
            then
                echo "Cannot create PID file"
            fi

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
        #debug
        if [ $DEBUG = true  ]
        then
                echo "Cannot create PID file"
        fi

        # exit with an error
        exit 1 # cannot create the pid file
    fi
fi


#####
#
# This section actually runs the test
#
#####

# variable to hold the test result
test_failed=true

# has the alerting system already been triggered ?
alert_triggered=false

# the failure counter (to avoid sending an alert if the API
# is not really down, for instance, if ti tool some time to reply...)
failure_counter=0

# the amount of failed tests before sending an alert
failure_counter_trigger_limit=3


# set the GPIO_PIN mode
if [ "$GPIO_ALERT" = "true" ]
then
    if [ "$DEBUG" = "true" ]
    then
        echo "gpio state for pin $GPIO_PIN :: $( gpio state $GPIO_PIN )"
        echo "GPIO_PINS available :: $GPIO_PINS"
    fi


    gpio mode $GPIO_PIN out
fi


# while the test_failed variable is true
while [ "$test_failed" = "true" ]
do
    # run the script that tests the API
    $TEST_API
    test_result=$?

    # if its exit code is 0 (target is online)
    if [ $test_result -eq 0 ]
    then

        # reset the failure counter
        failure_counter=0;

        if [ $DEBUG = true ]
        then
            echo "..:: ONLINE ::.."
        fi

        ###
        #
        # STOP & RESET THE ALERTS
        #
        ###
        # if the alert has been triggered
        if [[ "$alert_triggered" = "true" || "$force_check_on_reboot" = "true" ]]
        then

            # stop the alert
            # >>> do something here
            if [ "$GPIO_ALERT" = "true" ]
            then
                if [ "$DEBUG" = "true" ]
                then
                    echo "set the pin $GPIO_PIN >> DOWN"
                fi

                # set the GPIO_PIN low
                gpio write $GPIO_PIN 0
            fi

            if [ "$CHAT_ALERT" = "true" ]
            then
                if [ "$force_check_on_reboot" = "true" ]
                then
                    postMessage "after $HOSTNAME reboot : $ROCKETCHAT_MSG_SUCCESS"
                else
                    # send a message on rocket chat
                    postMessage $ROCKETCHAT_MSG_SUCCESS
                fi
            fi

            if [ "$EMAIL_ALERT = true" ]
            then
                if [ "$force_check_on_reboot" = "true" ]
                then
                    sendEmail "after $HOSTNAME reboot : $SENDMAIL_SUBJECT_SUCCESS"
                else
                    # send a message on rocket chat
                    sendEmail $SENDMAIL_SUBJECT_SUCCESS
                fi
            fi

            # reset the alert_triggered variable
            alert_triggered=false
        fi


        # trigger the heartbeat
        if [ "$GPIO_ALERT" = "true" ]
        then
            heartBeat
        fi

        # reset the test_failed variable
        # to false to stop the loop
        if [ "$RUN_FOREVER" = "false" ]
        then
            test_failed=false
        else
                # sleep for few seconds
            sleep $SLEEPING_TIME
        fi


    # if exit code is 1 (CONFIG_FILE not found)
    elif [ $test_result -eq 1 ]
    then
            if [ "$DEBUG" = "true" ]
            then
                echo "The CONFIG_FILE for the script $( basename $TEST_API )"
                echo "located here : $TEST_API"
                echo "could NOT BE FOUND !"
            fi

            # exit with an error
            exit 1

    # if exit code is 2 (target API is unreachable)
    elif [ $test_result -eq 2 ]
    then

        # test to avoid setting off an alert on 1st failure,
        # to avoid false positive (if the API takes some time to reply or something)
        if [ ${failure_counter} -eq ${failure_counter_trigger_limit} ]
        then

            # reset the failure counter
            failure_counter=0;

            if [ "$DEBUG" = "true" ]
            then
                echo "!!!!.. OFFLINE ..!!!!"
            fi

            ###
            #
            # TRIGGER THE ALERTS
            #
            ###
            if [ "$alert_triggered" = "false"  ]
            then

                # trigger an  the alert
                if [ "$GPIO_ALERT" = "true" ]
                then
                        if [ "$DEBUG" = "true" ]
                        then
                                echo "set the pin $GPIO_PIN >> UP"
                        fi

                        # set the GPIO_PIN high
                        gpio write $GPIO_PIN 1
                fi

                if [ "$CHAT_ALERT" = "true" ]
                then
                        # send a message on rocket chat
                        postMessage $ROCKETCHAT_MSG_FAILURE
                fi

                if [ "$EMAIL_ALERT" = "true" ]
                then
                        # send a message on rocket chat
                        sendEmail $SENDMAIL_SUBJECT_FAILURE
                fi

                # set the alert_triggered variable
                alert_triggered=true
            fi
        else
            # increment the failure counter
            ((failure_counter++))
        fi

        # sleep for few seconds
        sleep $SLEEPING_TIME


    # if the exit code is not 0, 1 or 2 then
    # it's an unknown error
    else
            if [ "$DEBUG" = "true" ]
            then
                    echo "an unknown error has occured !!!"
            fi

            # exit with an error
            exit 1
    fi
done

# exit gracefully
exit 0