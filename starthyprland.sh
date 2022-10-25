#!/bin/sh
killall client.sh
export MOZ_ENABLE_WAYLAND=1
#export GDK_DPI_SCALE=2    # only needed for firefox, messes up others
export BEMENU_BACKEND=wayland
exec Hyprland
