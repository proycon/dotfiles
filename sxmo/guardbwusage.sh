#!/bin/sh
USAGE=$(vnstat -i wwan0 --oneline b | cut -d ';' -f 11)
if [ -n "$USAGE" ]; then
    if [ $USAGE -gt 1835008000 ]; then
        nmcli connection down Simyo && aplay expired.oga
    fi
fi
