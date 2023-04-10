#!/usr/bin/env sh
if [ ! -f /tmp/locked ]; then
    task=$(todo.sh timetrack current -t)
    todo.sh timetrack stop
    touch /tmp/locked
    play ~/dotfiles/media/lock.wav >/dev/null 2>/dev/null &!
    if [ -n "$WAYLAND_DISPLAY" ]; then
        swaymsg input type:keyboard xkb_layout proylatin
        swaylock -c 220000
        hyprctl dispatch dpms on #ensure dpms is on after lock finishes
        pidof waybar || waybar &!
    else
        setxkbmap proylatin
        i3lock -n -c '220000'
        pidof picom || picom -f -e 1.0 &
    fi
    play ~/dotfiles/media/unlock.wav >/dev/null 2>/dev/null &!
    rm /tmp/locked
    todo.sh timetrack start "$task"
fi
