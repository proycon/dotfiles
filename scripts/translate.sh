#!/bin/sh

#you may pass a two letter language code for source and target and a text,  order doesn't matter except source language must come before target language

while [ $# -gt 0 ]; do
    CHARS=$(echo -n "$1" | wc -c)
    if [ "$CHARS" -eq 2 ]; then
        if [ -z "$FROMLANG" ]; then
            FROMLANG=$1
        elif [ -z "$TOLANG" ]; then
            TOLANG=$1
        else
            TEXT=$1
        fi
    else
        if [ -n "$TEXT" ]; then
            TEXT="$TEXT $1"
        else
            TEXT=$1
        fi
    fi
    shift
done

[ -z "$TOLANG" ] && TOLANG=en

if [ -z "$TEXT" ]; then
    if [ -n "$WAYLAND_DISPLAY" ]; then
        TEXT="$(wl-paste -p)"
    elif [ -n "$DISPLAY" ]; then
        TEXT="$(xclip -out)"
    fi
fi
[ -z "$TEXT" ] && notify-send "No text provided or selected"

if echo -n "$TEXT" | ~/dotfiles/scripts/ischinese.py; then
    TRANS=$(grep -h "$TEXT" ~/projects/vocadata/zh/hsk*.tsv | cut -f 1-4)
    if [ -n "$TRANS" ]; then
        notify-send -t 10000 "HSK Lookup" "$TRANS"
        echo "$TRANS"
        exit 0
    elif [ -e ~/Documents/languages/chinese/cedict.txt ]; then
        TRANS=$(grep -h "$TEXT" ~/Documents/languages/chinese/cedict.txt | head)
        if [ -n "$TRANS" ]; then
            echo "$TRANS"
            notify-send -t 10000 "CEDICT Lookup" "$TRANS"
            exit 0
        fi
    fi
    notify-send "Not in HSK or CEDICT"
fi

if [ ! -d ~/local ]; then
    mkdir ~/local
fi

if ! command -v argos-translate > /dev/null && [ ! -d ~/local/argostranslate.env ]; then
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


if [ -z "$FROMLANG" ] || [ "$FROMLANG" = "xx" ]; then
    FROMLANG=$(lingua-cli -l fr,de,es,it,pt,ru,zh,uk,ro,pl "$TEXT" | cut -f 1)
fi
#check if not already installed (e.g. from AUR)
if ! command -v argos-translate > /dev/null; then
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
fi
if [ -n "$FROMLANG" ]; then
    TRANS=$(argos-translate -f "$FROMLANG" -t "$TOLANG" "$TEXT")
    notify-send -t 10000 "Translation ($FROMLANG->$TOLANG)" "$TRANS"
    echo "(Translation $FROMLANG->$TOLANG)" >&2
    echo "$TRANS"
else 
    notify-send "No language detected, lingua-cli not in $PATH (~/.cargo/bin)?"
fi
