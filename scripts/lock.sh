#!/usr/bin/env sh
if [ ! -f /tmp/locked ]; then
    if pidof mpv steam X-Plane-x86_64 && [ "$1" != "force" ]; then
        #no lock
        exit 0
    fi
    task=$(todo.sh timetrack current -t)
    todo.sh timetrack stop
    touch /tmp/locked
    #killall gpg-agent
    paplay ~/dotfiles/media/lock.wav >/dev/null 2>/dev/null &
    if [ -n "$WAYLAND_DISPLAY" ]; then
        waylock -init-color 0x110000 -input-color 0x112200 -fail-color 0x990000
    else
        setxkbmap proylatin
        i3lock -n -c '220000'
        pidof picom || picom -f -e 1.0 &
    fi
    paplay ~/dotfiles/media/unlock.wav >/dev/null 2>/dev/null &
    rm /tmp/locked
    todo.sh timetrack start "$task"
    if [ "$HOSTNAME" = "pollux" ]; then
        if ! pgrep -f streamdeck.py; then
            nohup setsid python /home/proycon/dotfiles/scripts/streamdeck.py &
        fi
    fi
fi
