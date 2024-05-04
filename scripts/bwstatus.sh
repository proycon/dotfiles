#!/bin/sh

if [ -e /sys/class/net/qmapmux0.0 ]; then
    vnstat qmapmux0.0 --oneline | cut -d ';' -f 11
else
    vnstat wwan0 --oneline | cut -d ';' -f 11
fi
