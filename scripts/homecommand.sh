#!/bin/sh

# Receives notifications from MQTT

. ~/dotfiles/scripts/colorargs.sh

if [ -z "$1" ]; then
    if [ "$SXMO_WM" = "sway" ]; then
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

if [ ! -e ~/lighthome ]; then
    if [ -e ~/projects/lighthome ]; then
        ln -s ~/projects/lighthome ~/lighthome
    else
        echo "lighthome not installed" >&2
        exit 2
    fi
fi

~/lighthome/send.sh --notify "$TOPIC" "$PAYLOAD"
