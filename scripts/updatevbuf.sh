#!/bin/sh
if [ -n "$DISPLAY" ]; then
    xsel -i -b < ~/.vbuf
fi
