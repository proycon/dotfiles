#!/usr/bin/env sh
pgrep -f notifyclient.sh || ~/dotfiles/notifyclient.sh &
~/dotfiles/homestatus.sh pango loop | wayout -v -v -v --font "Monospace 20" --feed-par --height 500 $1 >&2 2> /tmp/wayout.log
