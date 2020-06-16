#!/bin/sh

if [ -z "$2" ]; then
    chosen=$(cut -d ';' -f1 ~/dotfiles/timetracker.tasks | rofi -dmenu -font "Monospace 28" | sed "s/ .*//")
else
    chosen="$2"
fi

# Exit if none chosen.
[ -z "$chosen" ] && exit

if [ -z "$1" ]; then
    D=$(date "+%Y-%m-%d %a %H:%M:%S")
else
    T=$(date "+%s")
    let "T=$T - ($1 *  60)"
    D=$(date "+%Y-%m-%d %a %H:%M:%S" --date "@$T")
fi
echo "$D $chosen" >> ~/.timetracker.$(hostname).log
