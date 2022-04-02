#!/bin/sh
# configversion: 1

# Homestatus widget, wrapper around
# homestatus.sh using wayout

check=0
while true; do
    case $1 in
        --check)
            check=1
            ;;
        *)
            break
    esac
    shift
done

if [ $check -eq 1 ]; then
    echo "Checking">&2
    pgrep -f homestatus.sh && exit 0
    export XDG_RUNTIME_DIR=~/.local/run/
    export SWAYSOCK=~/.cache/sxmo/sxmo.swaysock
    export WAYLAND_DISPLAY=wayland-1
fi
FONTSIZE="22"
if pgrep -f notifyclient.sh; then
    #already running
    #ping just after connection (triggers playing a sound and also returns status)
    (sleep 1 && ~/dotfiles/notifysend.sh "home/command/ping" "$(hostname)") &
else
    ~/dotfiles/notifyclient.sh &
fi
#kill existing wayout
pkill -f wayout
~/dotfiles/homestatus.sh pango loop wayout 2> /tmp/homestatus.log | wayout --foreground-color "#ffffff" --font "Monospace" --fontsize "$FONTSIZE" --feed-par --height 500 >&2 2> /tmp/wayout.log
