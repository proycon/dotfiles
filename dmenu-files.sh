#!/usr/bin/env sh
if [ -n "$WAYLAND_DISPLAY" ]; then
    MENUTOOL="bemenu"
else
    MENUTOOL="dmenu"
fi
PICKED=$(ls $2 "$1" | "$MENUTOOL" -i -l 20)
if [ -n "$PICKED" ]; then
    if [ -d "$1/$PICKED" ]; then
        ~/dotfiles/dmenu-files.sh "$1/$PICKED" $2
    else
        if file --mime-type "$1/$PICKED" | grep -E "text/html"; then
            firefox "$1/$PICKED" &
        elif file --mime-type "$1/$PICKED" | grep -E "(text/|message/|application/xml)"; then
            alacritty -e vim "$1/$PICKED" &
        elif file --mime-type "$1/$PICKED" | grep -E "application/pdf"; then
            zathura "$1/$PICKED" &
        else
            xdg-open "$1/$PICKED" &
        fi
    fi
fi

