#!/bin/sh
evtest /dev/input/event0 2>/dev/null |
while read -r line; do
    case "$line" in
        *SW_LID*"value 1"*)
            sxmo_wm.sh display off
            ;;
        *SW_LID*"value 0"*)
            sxmo_wm.sh display on
            ;;
    esac
done
