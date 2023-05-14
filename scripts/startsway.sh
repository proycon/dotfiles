#!/bin/sh
export MOZ_ENABLE_WAYLAND=1
export GDK_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
if [ "$(hostname)" = "mhysa" ]; then
    exec sway --unsupported-gpu
else
    exec sway
fi
