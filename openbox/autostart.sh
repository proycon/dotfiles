#!/bin/bash
#xcompmgr -cC -t-3 -l-5 -r5 &
#xcompmgr -fF &
~/bin/setinput.sh
xrdb -merge ~/.Xresources
xsetroot -cursor_name left_ptr
amixer sset Master unmute
pulseaudio --start &
compton -cC -z -r 3 -l 2 -t 2 -f -b
dbus-launch /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 
dbus-launch gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg 
dbus-launch /usr/lib/gnome-settings-daemon/gnome-settings-daemon 
feh --bg-scale ~/Pictures/Local/wallpapers/thomascolliers.png &
#setlayout 0 3 3 0
if [[ $HOST == "mhysa" ]]; then
    mountssh &
fi
LINES=`ps aux | grep tilda | wc -l`
if [[ $LINES -lt 2 ]]; then
    tilda &
fi
#thunar-volman &
pidof nm-applet
if [[ "$?" == "1" ]]; then
    nm-applet &
fi
udiskie &
volumeicon &
tint2 &
#ibus-daemon -d -x
setxkbmap proylatin
play ~/cylontune_low.ogg &

