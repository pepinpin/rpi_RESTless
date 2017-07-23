#!/bin/bash

# Utility to control the GPIO pins of the Raspberry Pi
# Can be called as a script or sourced so that the gpio
# function can be called directly
#
# from https://github.com/lasandell/RaspberryPi/
#

###
#
# The CONFIG_FILE
#
###

# set the CONFIG_FILE variable with 
# the path to the CONFIG_FILE file
CONFIG_FILE="$( dirname $( dirname $( realpath $0 ) ) )/CONFIG_FILE"

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

###
#
# The GPIO pins to use
# ( check the CONFIG_FILE for a 
# complete pin layout map)
#
###

# available pins for the raspi 2 & 3
GPIO_PINS='0 1 4 7 8 9 10 11 14 15 17 18 21 22 23 24 25'

# if the raspberry pi is of version 1
if [ $RASPI_VERSION -eq 1  ]
then
	# override the GPIO_PINS variable withe the proper map
	GPIO_PINS='2 3 4 7 8 9 10 11 14 15 17 18 22 23 24 25 27'
fi

###
#
# The function
#
###
#
# takes up to 3 arguments :
#
# * a verb ( can be 'read', 'write', 'mode' or 'state')
# * a pin number (which one to you want to interact with)
# * and a "value" for the requested action (can be omitted for 'read' and 'state')
# *** for 'write' it can be : 1 or 0
# *** for 'mode' it can be : in OR out
# *** for 'read' it can be omitted 
# *** for 'state' it can be ommitted

function gpio()
{
    local verb=$1
    local pin=$2
    local value=$3

    local pins=($GPIO_PINS)
    if [[ "$pin" -lt ${#pins[@]} ]]; then
        local pin=${pins[$pin]}
    fi

    local gpio_path=/sys/class/gpio
    local pin_path=$gpio_path/gpio$pin

    case $verb in
        read)
            cat $pin_path/value
        ;;

        write)
            echo $value > $pin_path/value
        ;;

        mode)
            if [ ! -e $pin_path ]; then
                echo $pin > $gpio_path/export
            fi
            echo $value > $pin_path/direction
        ;;

        state)
            if [ -e $pin_path ]; then
                local dir=$(cat $pin_path/direction)
                local val=$(cat $pin_path/value)
                echo "$dir $val"
            fi
        ;;

        *)
            echo "Control the GPIO pins of the Raspberry Pi"
            echo "Usage: $0 mode [pin] [in|out]"
            echo "       $0 read [pin]"
            echo "       $0 write [pin] [0|1]"
            echo "       $0 state [pin]"
            echo "If GPIO_PINS is an environment variable containing"
            echo "a space-delimited list of integers, then up to 17"
            echo "logical pins (0-16) will map to the physical pins"
            echo "specified in the list."
        ;;
    esac
}

# Just invoke our function if the script is called directly
if [ "$BASH_SOURCE" == "$0" ]; then
    gpio $@
fi
