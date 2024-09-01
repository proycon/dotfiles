#!/bin/sh

export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_SCALE_FACTOR=1.8
#export TDESKTOP_DISABLE_GTK_INTEGRATION=1
export CLUTTER_BACKEND=wayland
export ELM_SCALE=1.8
export XDG_CURRENT_DESKTOP=river
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=river
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

HOSTNAME=$(hostname)
if [ "$HOSTNAME" = "trantor" ]; then
    KB_OPTS="-options lv3:ralt_switch,caps:ctrl_modifier,altwin:swap_alt_win,grp:alt_shift_toggle"
else
    KB_OPTS=
fi
export KB_OPTS
