#!/bin/sh

ln -sf ~/.config/foot/foot.dark.ini ~/.config/foot/foot.ini
ln -sf ~/.config/alacritty/alacritty.dark.yml ~/.config/alacritty/alacritty.yml
rm ~/.light 2>/dev/null
notify-send "dark mode"
