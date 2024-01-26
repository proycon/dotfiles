#!/bin/sh

if [ -n "$WAYLAND_DISPLAY" ]; then
    TEXT="$(wl-paste -p)"
elif [ -n "$DISPLAY" ]; then
    TEXT="$(xclip -out)"
fi
[ -z "$TEXT" ] && notify-send "No text selected"
echo "IN: $TEXT"

if [ ! -d ~/local ]; then
    mkdir ~/local
fi

if [ ! -d ~/local/argostranslate.env ]; then
    cd ~/local/ || exit 2
    python -m venv argostranslate.env
    notify-send "Installing, creating virtualenv..."
fi


if [ ! -e ~/.cargo/bin/lingua-cli ]; then
    cd ~/local/ || exit 2
    git clone https://github.com/proycon/lingua-cli || notify-send "git clone failed"
    cd lingua-cli || exit 2
    notify-send "Installing lingua-cli"
    if cargo install --path .; then
        notify-send "Installation of lingua-cli complete"
    else
        notify-send "Installation of lingua-cli failed"
    fi
fi

DETECTEDLANG=$(lingua-cli "$TEXT" | cut -d " " -f 1)
. ~/local/argostranslate.env/bin/activate
if [ ! -e ~/local/argostranslate.env/bin/argos-translate ]; then
    notify-send "Pip installing argostranslate, this may take quite a while!"
    if pip install argostranslate; then
        argospm install translate || notify-send "Failed to install translation packages"
        notify-send "Installation of argostranslate complete"
    else
        notify-send "Installation of argostranslate failed"
    fi
fi
if [ -n "$DETECTEDLANG" ]; then
    echo "LANG: $DETECTEDLANG"
    TRANS=$(argos-translate -f "$DETECTEDLANG" -t en "$TEXT")
    notify-send -t 10000 "Translation ($DETECTEDLANG->en)" "$TRANS"
    echo "OUT: $TRANS"
else 
    notify-send "No language detected, lingua-cli not in $PATH (~/.cargo/bin)?"
fi
