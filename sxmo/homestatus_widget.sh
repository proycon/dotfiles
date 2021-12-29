#!/bin/sh

# Homestatus widget, wrapper around
# homestatus.sh using wayout

if [ "$1" = "--check" ]; then
    pgrep -f homestatus.sh && exit 0
    export XDG_RUNTIME_DIR=~/.local/run/
    export SWAYSOCK=~/.cache/sxmo/sxmo.swaysock
    export WAYLAND_DISPLAY=wayland-1
    shift
fi
FONTSIZE="22"
if pgrep -f notifyclient.sh; then
    #already running
    #ping just after connection (triggers playing a sound and also returns status)
    (sleep 1 && ~/dotfiles/notifysend.sh "home/command/ping" "$(hostname)") &
else
    ~/dotfiles/notifyclient.sh &
fi
~/dotfiles/homestatus.sh pango loop | wayout --foreground-color "#ffffff" --font "Monospace" --fontsize "$FONTSIZE" --feed-par --height 500 $1 >&2 2> /tmp/wayout.log
