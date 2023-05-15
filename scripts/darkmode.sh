#!/bin/sh

ln -sf ~/.config/foot/foot.dark.$(hostname).ini ~/.config/foot/foot.ini
ln -sf ~/.config/rofi/rofi.dark.rasi ~/.config/rofi/config.rasi
rm ~/.light 2>/dev/null
swaybg -m fill -i ~/dotfiles/media/forest.jpg &
notify-send "dark mode"
