#!/usr/bin/env sh
. /etc/os-release
FONTSIZE="22"
pgrep -f notifyclient.sh || ~/dotfiles/notifyclient.sh &
~/dotfiles/homestatus.sh pango loop | wayout --foreground-color "#ffffff" --font "Monospace" --fontsize "$FONTSIZE" --feed-par --height 500 $1 >&2 2> /tmp/wayout.log
