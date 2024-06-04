#!/bin/sh

if [ -n "$WAYLAND_DISPLAY" ]; then
    TEXT="$(wl-paste -p)"
elif [ -n "$DISPLAY" ]; then
    TEXT="$(xclip -out)"
fi
[ -z "$TEXT" ] && notify-send "No text selected"
echo "IN: $TEXT"

if echo -n "$TEXT" | ~/dotfiles/scripts/ischinese.py; then
    TRANS=$(grep -h "$TEXT" ~/projects/vocadata/zh/hsk*.tsv | cut -f 1-4)
    if [ -n "$TRANS" ]; then
        notify-send -t 10000 "HSK Lookup" "$TRANS"
        exit 0
    elif [ -e ~/Documents/languages/chinese/cedict.txt ]; then
        TRANS=$(grep -h "$TEXT" ~/Documents/languages/chinese/cedict.txt | head)
        if [ -n "$TRANS" ]; then
            notify-send -t 10000 "CEDICT Lookup" "$TRANS"
            exit 0
        fi
    fi
    notify-send "Not in HSK or CEDICT"
fi

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


if [ "$1" ]; then
    DETECTEDLANG="$1"
else
    DETECTEDLANG=$(lingua-cli -l fr,de,es,it,pt,ru,zh,uk,ro,pl "$TEXT" | cut -f 1)
fi
. ~/local/argostranslate.env/bin/activate
if [ ! -e ~/local/argostranslate.env/bin/argos-translate ]; then
    notify-send "Pip installing argostranslate, this may take quite a while!"
    if pip install argostranslate; then
        argospm update
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
