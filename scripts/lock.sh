#!/usr/bin/env sh
if [ ! -f /tmp/locked ]; then
    task=$(todo.sh timetrack current -t)
    todo.sh timetrack stop
    touch /tmp/locked
    killall gpg-agent
    paplay ~/dotfiles/media/lock.wav >/dev/null 2>/dev/null &!
    if [ -n "$WAYLAND_DISPLAY" ]; then
        swaylock -k -c 220000
        if [ "$XDG_SESSION_DESKTOP" = "Hyprland" ]; then
            hyprctl dispatch dpms on #ensure dpms is on after lock finishes
        fi
        pidof waybar || waybar &!
    else
        setxkbmap proylatin
        i3lock -n -c '220000'
        pidof picom || picom -f -e 1.0 &
    fi
    paplay ~/dotfiles/media/unlock.wav >/dev/null 2>/dev/null &!
    rm /tmp/locked
    todo.sh timetrack start "$task"
    if [ "$(hostname)" = "pollux" ]; then
        ~/dotfiles/scripts/fixworkspaces.sh
    fi
fi
