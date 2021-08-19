#!/bin/bash
if [ -n "$WAYLAND_DISPLAY" ] || which bemenu; then
    dir=$(ls -d ~/Pictures/*/  | sed "s|$HOME/Pictures/||g" | bemenu -l 20 --fn "Monospace 20" -p "Open Folder?")
else
    dir=$(ls -d ~/Pictures/*/  | sed "s|$HOME/Pictures/||g" | rofi -dmenu -p "Open Folder?")
fi
# Exit if none chosen.
[ -z "$dir" ] && exit
echo "$dir" | tr -d '\n' | xclip -selection clipboard
export PATH=$HOME/bin:$PATH
sxiv -rt "$HOME/Pictures/$dir" 2> /tmp/err
