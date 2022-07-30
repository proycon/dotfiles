#!/bin/sh

ln -sf ~/.config/foot/foot.light.ini ~/.config/foot/foot.ini
ln -sf ~/.config/alacritty/alacritty.light.yml ~/.config/alacritty.yml
touch ~/.light
notify-send "light mode"
