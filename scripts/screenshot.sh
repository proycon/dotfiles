#!/bin/sh
rm /tmp/screenshot-latest.jpg 2> /dev/null
if [ "$1" = "region" ]; then
    NAME="screenshot$(date +%Y%m%d%H%M%S)-$(pwgen -1 -0 -A).png"
    wl-copy "https://download.anaproy.nl/$NAME"
    if grim -g "$(slurp)" "/nettmp/$NAME"; then
        ln -s "/nettmp/$NAME" "/tmp/$NAME"
        notify-send "Screenshot ready" "Published at https://download.anaproy.nl/$NAME and URL copied to clipboard"
        magick convert "/tmp/$NAME" /tmp/screenshot-latest.jpg
    else
        notify-send "Screenshot failed!"
    fi
elif [ "$1" = "annotate" ]; then
    NAME="screenshot$(date +%Y%m%d%H%M%S)-$(pwgen -1 -0 -A).png"
    wl-copy "https://download.anaproy.nl/$NAME"
    if grim -g "$(slurp -o -r -c '#ff0000ff')" - | satty --filename - --fullscreen --output-filename "/nettmp/$NAME"; then
        ln -s "/nettmp/$NAME" "/tmp/$NAME"
        notify-send "Screenshot ready" "Published at https://download.anaproy.nl/$NAME and URL copied to clipboard"
        magick convert "/tmp/$NAME" /tmp/screenshot-latest.jpg
    else
        notify-send "Screenshot failed!"
    fi
else
    NAME="$(date +%Y-%m-%d-%H%M%S)_screenshot-$(pwgen -1 -0 -A).png"
    wl-copy "/home/proycon/$NAME"
    grim "/home/proycon/$NAME" && notify-send "Full screenshot ready" "In /home/proycon/$NAME (copied to clipboard)"
    magick convert "/tmp/$NAME" /tmp/screenshot-latest.jpg
fi

