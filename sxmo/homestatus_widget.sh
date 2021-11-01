#!/usr/bin/env sh
pgrep -f notifyclient.sh || ~/dotfiles/notifyclient.sh &
~/dotfiles/homestatus.sh pango loop | wayout --font "Monospace 20" --feed-par --height 500 $1
