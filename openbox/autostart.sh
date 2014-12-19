#!/bin/bash
#xcompmgr -cC -t-3 -l-5 -r5 &
#xcompmgr -fF &
~/bin/setinput.sh
xrdb -merge ~/.Xresources
xsetroot -cursor_name left_ptr
amixer sset Master unmute
pulseaudio --start &
compton -cC -z -r 3 -l 2 -t 2 -f -b
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
gnome-settings-daemon &
gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg &
if [[ $HOST == "caprica" ]]; then
    cbatticon &
fi
#feh --bg-scale ~/Pictures/Local/wallpapers/shirahige2.jpg &
#feh --bg-scale ~/Pictures/Local/wallpapers/Perfection_Cold_by_yaromanzarek.jpg &
#feh --bg-scale ~/Pictures/Local/wallpapers/buddhavoid1920.png &
feh --bg-scale ~/Pictures/Local/wallpapers/thomascolliers.png &
setlayout 0 3 3 0
if [[ $HOST == "mhysa" ]]; then
    mountssh &
fi
LINES=`ps aux | grep tilda | wc -l`
if [[ $LINES -lt 2 ]]; then
    tilda &
fi
tint2 &
thunar-volman &
pidof nm-applet
if [[ "$?" == "1" ]]; then
    nm-applet &
fi
udiskie &
volumeicon &
#ibus-daemon -d -x
setxkbmap proylatin
#sleep 3 && feh --bg-scale ~/Pictures/Local/wallpapers/shirahige2.jpg &
#sleep 2 && feh --bg-scale ~/Pictures/Local/wallpapers/Perfection_Cold_by_yaromanzarek.jpg &
#sleep 2 && feh --bg-scale ~/Pictures/Local/wallpapers/buddhavoid1920.png &
play ~/cylontune_low.ogg &

