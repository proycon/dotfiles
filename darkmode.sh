#!/bin/sh

ln -sf ~/.config/foot/foot.dark.ini ~/.config/foot/foot.ini
ln -sf ~/.config/alacritty/alacritty.dark.yml ~/.config/alacritty/alacritty.yml
ln -sf ~/.config/rofi/rofi.dark.rasi ~/.config/rofi/config.rasi
rm ~/.light 2>/dev/null
feh --bg-fill ~/dotfiles/media/mountains.jpg --image-bg '#2e3440'
notify-send "dark mode"
