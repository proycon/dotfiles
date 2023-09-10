#!/bin/sh

# Receives notifications from MQTT

. ~/dotfiles/scripts/colorargs.sh

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
        chosen=$(cat ~/dotfiles/homecommands | sxmo_dmenu.sh -i -p "Home" -l 20 | sed "s/.*=//")
    elif [ -n "$WAYLAND_DISPLAY" ]; then
        chosen=$(cat ~/dotfiles/homecommands | bemenu -i -p "Home" -l 20 --fn "$BEMENU_FONT" $BEMENU_COLORARGS | sed "s/.*=//")
    else
        chosen=$(cat ~/dotfiles/homecommands | dmenu -i -l 20 -p "Home" $DMENU_COLORARGS | sed "s/.*=//")
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

~/dotfiles/scripts/notifysend.sh "$TOPIC" "$PAYLOAD"
ret=$?
if [ $ret -eq 0 ]; then
    mpv --no-video --quiet ~/lighthome/media/computerbeep_5.wav
else
    mpv --no-video --quiet ~/lighthome/media/computerbeep_9.wav

fi
exit $ret
