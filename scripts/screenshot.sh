#!/bin/sh
if [ "$1" = "region" ]; then
    NAME="screenshot$(date +%Y%m%d%H%M%S).png"
    wl-copy "https://download.anaproy.nl/$NAME"
    if grim -g "$(slurp)" "/nettmp/$NAME"; then
        notify-send "Screenshot ready" "Published at https://download.anaproy.nl/$NAME and URL copied to clipboard"
    else
        notify-send "Screenshot failed!"
    fi
elif [ "$1" = "annotate" ]; then
    NAME="screenshot$(date +%Y%m%d%H%M%S).png"
    wl-copy "https://download.anaproy.nl/$NAME"
    if grim -g "$(slurp -o -r -c '#ff0000ff')" - | satty --filename - --fullscreen --output-filename "/nettmp/$NAME"; then
        notify-send "Screenshot ready" "Published at https://download.anaproy.nl/$NAME and URL copied to clipboard"
    else
        notify-send "Screenshot failed!"
    fi
else
    NAME="$(date +%Y-%m-%d-%H%M%S)_screenshot.png"
    wl-copy "/home/proycon/$NAME"
    grim "/home/proycon/$NAME" && notify-send "Full screenshot ready" "In /home/proycon/$NAME (copied to clipboard)"
fi

