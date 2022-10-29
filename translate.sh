#!/bin/sh

if [ -n "$WAYLAND_DISPLAY" ]; then
    TEXT=$(wl-paste -p)
elif [ -n "$DISPLAY" ]; then
    TEXT=$(xclip -out)
fi

LANG=$(~/.cargo/bin/lingua-cli "$TEXT" | cut -d " " -f 1)
. ~/local/argostranslate.env/bin/activate
if [ -n "$LANG" ]; then
    TRANS=$(argos-translate -f $LANG -t en "$TEXT")
    notify-send -t 10000 "Translation ($LANG)" "$TRANS"
    echo $TRANS
fi
