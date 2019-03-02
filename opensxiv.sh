#!/bin/bash
dir=$(ls -d ~/Pictures/*/  | sed "s|$HOME/Pictures/||g" | dmenu -fn Sans -l 20 -i -p "Open Folder?")
sxiv -rt "$HOME/Pictures/$dir"
