#!/bin/sh
if [ -n "$1" ]; then
    echo "$1" > /tmp/linkhandler.target
    notify-send "link target is $1"
else
    rm -f /tmp/linkhandler.target
    notify-send "link target is local system"
fi
