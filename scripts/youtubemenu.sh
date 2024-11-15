#!/bin/sh

. ~/dotfiles/scripts/colorargs.sh

if [ -n "$WAYLAND_DISPLAY" ]; then
    QUERY=$(echo "" | bemenu -p Youtube -l 10 --fn "$BEMENU_FONT" $BEMENU_COLORARGS)
    if [ -n "$QUERY" ]; then
        ytfzf --external-menu --loop "$QUERY"
    else
        echo "No query">&2
    fi
fi
