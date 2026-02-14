#!/bin/sh
USAGE=$(vnstat -m -i wwan0 --oneline b 2> /dev/null | cut -d ';' -f 11)
if [ -n "$USAGE" ]; then
    if [ $USAGE -gt 1835008000 ]; then
        nmcli connection down Simyo && mpv expired.oga
    fi
fi
