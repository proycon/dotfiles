#!/bin/bash

# Receives notifications from MQTT

if [ ! -z "$MQTT_USER" ]; then
    echo "No MQTT user defined">&2
    exit 2
fi

if [ ! -z "$MQTT_PASSWORD" ]; then
    echo "No MQTT password defined">&2
    exit 2
fi


if [ -z "$1" ]; then
    which rofi > /dev/null 2> /dev/null
    if [ $? -eq 0 ]; then
        chosen=$(cat ~/dotfiles/homecommands | rofi -dmenu -font "Sans 16" | sed "s/.*=//")
    else
        chosen=$(cat ~/dotfiles/homecommands | dmenu -l 20 -c -p "Home" -fn "Terminus-20" | sed "s/.*=//")
    fi

    # Exit if none chosen.
    [ -z "$chosen" ] && exit

    TOPIC="home/command/$chosen"
else
    TOPIC="home/command/$1"
fi


~/dotfiles/notifysend.sh $TOPIC
exit $?
