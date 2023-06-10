#!/bin/sh
#workspaces might end up on wrong monitor if it powers up first
for i in $(seq 1 9); do 
    hyprctl dispatch moveworkspacetomonitor $i DP-2
done
hyprctl focusmonitor DP-3
hyprctl workspace 10
hyprctl focusmonitor DP-2
hyprctl workspace 1
pidof waybar || waybar &
