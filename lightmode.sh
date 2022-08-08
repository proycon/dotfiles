#!/bin/sh

ln -sf ~/.config/foot/foot.light.ini ~/.config/foot/foot.ini
ln -sf ~/.config/alacritty/alacritty.light.yml ~/.config/alacritty/alacritty.yml
ln -sf ~/.config/rofi/rofi.light.rasi ~/.config/rofi/config.rasi
touch ~/.light
feh --bg-fill ~/dotfiles/media/blossom-branch.jpg --image-bg '#2e3440'
notify-send "light mode"
