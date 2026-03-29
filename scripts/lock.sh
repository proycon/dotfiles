#!/usr/bin/env sh
if [ -z "$HOSTNAME" ]; then
    HOSTNAME=$(hostname)
fi
if [ ! -f /tmp/locked ]; then
    if pidof mpv steam X-Plane-x86_64 && [ "$1" != "force" ]; then
        #no lock
        exit 0
    fi
    task=$(todo.sh timetrack current -t)
    todo.sh timetrack stop
    paplay ~/dotfiles/media/lock.wav >/dev/null 2>/dev/null &
    #if [ "$HOSTNAME" = "pollux" ]; then
    #    PID=$(pgrep -f streamdeck.py)
    #    if [ -n "$PID" ]; then
    #        echo "killing streamdeck and waiting for the kill..."
    #        kill "$PID" && pidwait --pid "$PID"
    #    fi
    #fi
    touch /tmp/locked
    #killall gpg-agent
    if [ -n "$WAYLAND_DISPLAY" ]; then
        waylock -init-color 0x110000 -input-color 0x112200 -input-alt-color 0x223300 -fail-color 0x990000
    else
        setxkbmap proylatin
        i3lock -n -c '220000'
        pidof picom || picom -f -e 1.0 &
    fi
    paplay ~/dotfiles/media/unlock.wav >/dev/null 2>/dev/null &
    rm /tmp/locked
    todo.sh timetrack start "$task"
    if [ "$HOSTNAME" = "pollux" ]; then
        mv -f "$XDG_RUNTIME_DIR/streamdeck.log" "$XDG_RUNTIME_DIR/streamdeck.1.log"
        pkill -f -9 streamdeck.py
        python /home/proycon/dotfiles/scripts/streamdeck.py > "$XDG_RUNTIME_DIR/streamdeck.log" 2>&1 &
    fi
fi
