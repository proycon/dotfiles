#!/bin/sh
if [ -n "$1" ]; then
    grim "/home/proycon/$(date +%Y-%m-%d-%H%M%S)_screenshot.png" && notify-send "Screenshot ready"
else
    grim "/home/proycon/$(date +%Y-%m-%d-%H%M%S)_screenshot.png" && notify-send "Screenshot ready"
fi

