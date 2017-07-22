#!/bin/bash
#
# The main script
#
#
#####
#
# The following section is to insure that there is only 
# 1 instance of this script running at any point in time
#
#####
#
# The location to store the PID file
# by default it's stored on a tmpfs partiton (/dev/shm)
# that only exist in memory to avoid unecessary access to the SDCard
PID_FILE=/dev/shm/runMe_rpi_restless.pid
#
# check if the file exists
if [ -f PID_FILE  ]

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
#
#
#
#####
#
# This section actually runs the test
#
#####
#
# where are the other scripts located
SCRIPTS_FOLDER=./scripts
#
# the sleeping time between 2 tests if the 1st one fails
SLEEPING_TIME=3 # default 3 seconds
#
# variable to hold the test result
test_fails=true
#
# while the test_fails variable is true
while [ $test_fails = true ]
do
	# run the script that tests the API
	$SCRIPTS_FOLDER/testAPI.sh
	# if its exit code is not 0
	if [ $? -ne 0 ]
	then
		# trigger an alert
		echo "CA MARCHE PAS !!!"
		
		# sleep for few seconds
		sleep $SLEEPING_TIME
	else
		# reset the test_fails variable
		# to false to stop the loop
		test_fails=false
		# stop the alert
		echo "CA MARCHE !!!"

	fi
done

# exit gracefully
exit 0
