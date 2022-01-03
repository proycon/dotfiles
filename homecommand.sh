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
    if [ -x "$(which sxmo_dmenu.sh 2> /dev/null)" ]; then
        alias bemenu="$(which sxmo_dmenu.sh 2> /dev/null)"
    else
        alias dmenu="$(which sxmo_dmenu.sh 2> /dev/null)"

    fi
    if [ -n "$WAYLAND_DISPLAY" ]; then
        chosen=$(cat ~/dotfiles/homecommands | bemenu -p "Home Command" -l 20 -p "Home" | sed "s/.*=//")
    else
        chosen=$(cat ~/dotfiles/homecommands | dmenu -l 20 -p "Home" | sed "s/.*=//")
    fi

    # Exit if none chosen.
    [ -z "$chosen" ] && exit

    TOPIC="home/command/$chosen"
else
    TOPIC="home/command/$1"
fi


if [ -n "$2" ]; then
    PAYLOAD=$2
else
    PAYLOAD=ON
fi

~/dotfiles/notifysend.sh $TOPIC $PAYLOAD
exit $?
