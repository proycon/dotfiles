#!/bin/sh

HOSTNAME="$(hostname)"

handle() {
    EVENT=$(echo "$1" | cut -d">" -f 1)
    ARG=$(echo "$1" | cut -d">" -f 3)
    case $EVENT in
        "closewindow")
            #always focus master after closing a window
            hyprctl dispatch layoutmsg focusmaster
            ;;
        "monitoradded")
            if [ "$ARG" = "DP-2" ] && [ "$HOSTNAME" = "pollux" ]; then
                #workspaces might end up on wrong monitor if it powers up first
                for i in $(seq 1 9); do 
                    hyprctl dispatch moveworkspacetomonitor $i DP-2
                done
                hyprctl focusmonitor DP-3
                hyprctl workspace 10
                hyprctl focusmonitor DP-2
                hyprctl workspace 1
                pidof waybar || waybar &
            fi
            ;;
    esac
}

socat - UNIX-CONNECT:/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock | while read line; do handle $line; done
