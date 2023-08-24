#!/bin/sh
if [ -e /sys/class/net/wwan0 ]; then
    USAGE=$(vnstat -m -i wwan0 --oneline b | cut -d ';' -f 11)
elif [ -e /sys/class/net/wlan0 ]; then
    USAGE=$(vnstat -m -i wlan0 --oneline b | cut -d ';' -f 11)
fi
if [ -n "$USAGE" ]; then
    if [ $USAGE -gt 1835008000 ]; then
        nmcli connection down Simyo && mpv expired.oga
    fi
fi
