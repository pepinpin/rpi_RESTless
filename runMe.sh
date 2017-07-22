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
PID_FILE=/dev/shm/rpi_RESTless/runMe.pid

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
#
















:w

