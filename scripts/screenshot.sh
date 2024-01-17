#!/bin/sh
if [ -n "$1" ]; then
    NAME="screenshot$(date +%Y%m%d%H%M%S).png"
    wl-copy "https://download.anaproy.nl/$NAME"
    if grim -g "$(slurp)" "/nettmp/$NAME"; then
        notify-send "Screenshot ready" "Published at https://download.anaproy.nl/$NAME and URL copied to clipboard"
    else
        notify-send "Screenshot failed!"
    fi
else
    grim "/home/proycon/$(date +%Y-%m-%d-%H%M%S)_screenshot.png" && notify-send "Screenshot ready"
fi

