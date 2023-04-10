#!/bin/sh

. ~/dotfiles/colorargs.sh 

CHOICE="$(
    printf %b "
        Cancel
        $(ps -eo pid,tt,user,cmd | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | grep "$USER" | tail -n +2)
    " |
    awk '{$1=$1};1' | grep '\w' | bemenu -p 'Kill' -l 20 --fn "$BEMENU_FONT" $BEMENU_COLORARGS
)"

PID="$(echo "$CHOICE" | cut -d " " -f 1)"
if [ -n "$PID" ] && [ "$PID" != "cancel" ]; then
    kill "$PID"
fi
