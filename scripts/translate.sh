#!/bin/sh

if [ -n "$WAYLAND_DISPLAY" ]; then
    TEXT=$(wl-paste -p)
elif [ -n "$DISPLAY" ]; then
    TEXT=$(xclip -out)
fi

if [ ! -d ~/local ]; then
    mkdir ~/local
fi

if [ ! -d ~/local/argostranslate.env ]; then
    cd ~/local/
    python -m venv argostranslate.env
    notify-send "Installing, creating virtualenv..."
fi


if [ ! -e ~/.cargo/bin/lingua-cli ]; then
    notify-send "Installing lingua"
    if cargo install lingua; then
        notify-send "Installation of lingua complete"
    else
        notify-send "Installation of lingua failed"
    fi
fi
LANG=$(~/.cargo/bin/lingua-cli "$TEXT" | cut -d " " -f 1)
. ~/local/argostranslate.env/bin/activate
if [ ! -e ~/local/argostranslate.env/bin/argos-translate ]; then
    notify-send "Pip installing argostranslate, this may take quite a while!"
    if pip install argostranslate; then
        notify-send "Installation of argostranslate complete"
    else
        notify-send "Installation of argostranslate failed"
    fi
fi
if [ -n "$LANG" ]; then
    TRANS=$(argos-translate -f $LANG -t en "$TEXT")
    notify-send -t 10000 "Translation ($LANG)" "$TRANS"
    echo $TRANS
fi
