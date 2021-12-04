#!/usr/bin/env sh
. /etc/os-release
pgrep -f notifyclient.sh || ~/dotfiles/notifyclient.sh &
if [ "$DISTRIB_ID" = "postmarketos" ]; then
    FONTSIZE="12"
else
    FONTSIZE="20"
fi
~/dotfiles/homestatus.sh pango loop | wayout --fgcolor "#ffffff" --font "Monospace" --fontsize "$FONTSIZE" --feed-par --height 500 $1 >&2 2> /tmp/wayout.log
