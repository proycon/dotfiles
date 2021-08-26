#!/bin/sh
export MOZ_ENABLE_WAYLAND=1
export GDK_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
if [ "$(hostname)" = "mhysa" ]; then
    export MOZ_WEBRENDER=0 #may be needed for wlroots-eglstream on proprietary nvidia
    exec sway --my-next-gpu-wont-be-nvidia
else
    exec sway
fi
