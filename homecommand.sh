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

if [ ! -z "$1" ]; then
    chosen=$(cut -d ';' -f1 ~/dotfiles/homecommands | dmenu -fn "Sans 16" | sed "s/ .*//")

    # Exit if none chosen.
    [ -z "$chosen" ] && exit

    TOPIC="$chosen"
else
    TOPIC="/home/command/$1"
fi

~/dotfiles/notifysend.sh $TOPIC

