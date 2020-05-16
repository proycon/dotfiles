#!/bin/bash
dir=$(ls -d ~/Pictures/*/  | sed "s|$HOME/Pictures/||g" | rofi -dmenu -p "Open Folder?")
# Exit if none chosen.
[ -z "$dir" ] && exit
echo "$dir" | tr -d '\n' | xclip -selection clipboard
export PATH=$HOME/bin:$PATH
sxiv -rt "$HOME/Pictures/$dir" 2> /tmp/err
