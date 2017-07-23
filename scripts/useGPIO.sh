#!/bin/bash

# Utility to control the GPIO pins of the Raspberry Pi
# Can be called as a script or sourced so that the gpio
# function can be called directly
#
# from https://github.com/lasandell/RaspberryPi/
#

###
#
# The GPIO pins to use
#
###

# Uncomment the following line for the Raspberry Pi 2 and 3
#GPIO_PINS='0 1 4 7 8 9 10 11 14 15 17 18 21 22 23 24 25'
#
#	This map needs to be validated since I don't have a rpi2/rpi3
#	to try it out, USE WITH CAUTION ! 
#
#       GPIO_PINS       Physical_pins
#       0               3
#       1               5
#       4               7
#       7               8
#       8               10
#       9               11
#       10              12
#       11              13
#       14              15
#       15              16
#       17              18
#       18              19
#       21              21
#       22              22
#       23              23
#       24              24
#       25              26



# Uncomment the following line for Raspberry Pi 1 Revision 2
GPIO_PINS='2 3 4 7 8 9 10 11 14 15 17 18 22 23 24 25 27'
#
#	GPIO_PINS	Physical_pins
#	2		3
#	3		5
#	4		7
#	7		8
#	8		10
#	9		11
#	10		12
#	11		13
#	14		15
#	15		16
#	17		18
#	18		19
#	22		21
#	23		22
#	24		23
#	25		24
#	27		26




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
