#!/bin/sh

. ~/dotfiles/colorargs.sh

if [ -z "$2" ]; then
    if [ -n "$WAYLAND_DISPLAY" ]; then
        chosen=$(cut -d ';' -f1 ~/dotfiles/timetracker.tasks | bemenu -n -p "Task" -l 10 $BEMENU_COLORARGS | sed "s/ .*//")
    else
        chosen=$(cut -d ';' -f1 ~/dotfiles/timetracker.tasks | rofi -dmenu -font "Monospace 28" | sed "s/ .*//")
    fi
else
    chosen=$(echo "$2" | tr -d "\n")
fi

# Exit if none chosen.
[ -z "$chosen" ] && exit

if [ -z "$1" ] || [ "$1" = "0" ]; then
    D=$(date "+%Y-%m-%d %a %H:%M")
else
    T=$(date "+%s")
    let "T=$T - ($1 *  60)"
    D=$(date "+%Y-%m-%d %a %H:%M" --date "@$T")
fi
echo "$D $chosen" >> ~/.timetracker.$(hostname).log
echo "$(date +%H:%M) $chosen" > ~/.timetracker.current
