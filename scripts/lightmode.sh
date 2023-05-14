#!/bin/sh

ln -sf ~/.config/foot/foot.light.ini ~/.config/foot/foot.ini
ln -sf ~/.config/alacritty/alacritty.light.yml ~/.config/alacritty/alacritty.yml
ln -sf ~/.config/rofi/rofi.light.rasi ~/.config/rofi/config.rasi
touch ~/.light
swaybg -i ~/dotfiles/media/blossom-branch.jpg &
notify-send "light mode"
