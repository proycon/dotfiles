#!/usr/bin/env sh
PICKED=$(ls $2 "$1" | dmenu -l 20)
if [ -n "$PICKED" ]; then
    if [ -d "$1/PICKED" ]; then
        ~/dotfiles/dmenu-files.sh "$1/$PICKED"
    else
        xdg-open "$1/$PICKED" &
    fi
fi

