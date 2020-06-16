#!/bin/sh

if [ -z "$2" ]; then
    chosen=$(cut -d ';' -f1 ~/dotfiles/timetracker.tasks | rofi -dmenu -font "Monospace 28" | sed "s/ .*//")
else
    chosen=$(echo "$2" | tr -d "\n")
fi

# Exit if none chosen.
[ -z "$chosen" ] && exit

if [ -z "$1" ]; then
    D=$(date "+%Y-%m-%d %a %H:%M")
else
    T=$(date "+%s")
    let "T=$T - ($1 *  60)"
    D=$(date "+%Y-%m-%d %a %H:%M" --date "@$T")
fi
echo "$D $chosen" >> ~/.timetracker.$(hostname).log
