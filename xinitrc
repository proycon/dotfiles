#!/bin/zsh
export LANG=en_GB.UTF-8
export LANGUAGE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

source ~/.zshrc
~/.config/openbox/autostart.sh

xrdb -merge ~/.Xresources

which bspwm > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    HAVE_BSPWM=1
else
    HAVE_BSPWM=0
fi
which dbus-launch > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    DBUSLAUNCH="dbus-launch"
else
    DBUSLAUNCH=""
fi
which openbox > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    HAVE_OPENBOX=1
else
    HAVE_OPENBOX=0
fi
which startxfce4 > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    HAVE_XFCE4=1
else
    HAVE_XFCE4=0
fi

if [ $HAVE_BSPWM -eq 1 ]; then
    sxhkd &!
    exec $DBUSLAUNCH bspwm
elif [ $HAVE_OPENBOX -eq 1 ]; then
    exec $DBUSLAUNCH openbox 
elif [ $HAVE_XFCE4 -eq 1 ]; then
    exec $DBUSLAUNCH --exit-with-session startxfce4 
else
    exec xterm
fi
