#!/usr/bin/env sh
if [ "$1" = "--check" ]; then
    pidof wayout && exit 0
    export XDG_RUNTIME_DIR=~/.local/run/
    export CACHEDIR=~/.cache/
    export SWAYSOCK=$(cat $CACHEDIR/sxmo/sxmo.swaysock)
fi
FONTSIZE="22"
pgrep -f notifyclient.sh || ~/dotfiles/notifyclient.sh &
pgrep -f homestatus.sh && pkill -f homestatus.sh
pgrep -f wayout && pkill -f wayout
~/dotfiles/homestatus.sh pango loop | wayout --foreground-color "#ffffff" --font "Monospace" --fontsize "$FONTSIZE" --feed-par --height 500 $1 >&2 2> /tmp/wayout.log
