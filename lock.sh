#!/usr/bin/env sh
if [ ! -f /tmp/locked ]; then
    lasttask=$(tail -n 1 ~/.timetracker.log | cut --delimiter=" " -f 4 | tr -d '\n')
    ~/dotfiles/timetracker.sh 0 afk
    touch /tmp/locked
    play ~/dotfiles/media/lock.wav >/dev/null 2>/dev/null &!
    if [ -n "$WAYLAND_DISPLAY" ]; then
        swaymsg input type:keyboard xkb_layout proylatin
        swaylock -f -c 220000
    else
        setxkbmap proylatin
        i3lock -n -c '#220000'
    fi
    play ~/dotfiles/media/unlock.wav >/dev/null 2>/dev/null &!
    rm /tmp/locked
    ~/dotfiles/timetracker.sh 0 "$lasttask"
fi
