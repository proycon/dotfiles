#!/bin/sh
if [ -e ~/.light ]; then
    rofi -font "Source Code Pro for Powerline 20" -combi-modi window,drun,run -show combi -modi combi ~/dotfiles/rofi.light 2> /tmp/err
else
    rofi -font "Source Code Pro for Powerline 20" -combi-modi window,drun,run -show combi -modi combi 2> /tmp/err
fi

