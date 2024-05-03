#!/bin/sh
killall client.sh
rm /tmp/locked
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_SCALE_FACTOR=1.8
export ELM_SCALE=1.8
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export SDL_VIDEODRIVER=wayland
export GLFW_IM_MODULE=fcitx
#export GTK_IM_MODULE=fcitx
export INPUT_METHOD=fcitx
export XMODIFIERS=@im=fcitx
export IMSETTINGS_MODULE=fcitx
export QT_IM_MODULE=fcitx
#export GDK_DPI_SCALE=2    # only needed for firefox, messes up others
export BEMENU_BACKEND=wayland
exec Hyprland
