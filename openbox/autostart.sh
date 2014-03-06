#!/bin/bash
#xcompmgr -cC -t-3 -l-5 -r5 &
xcompmgr -fF &
setinput.sh
pulseaudio --start &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
gnome-settings-daemon &
gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg &
#feh --bg-scale ~/Pictures/Local/wallpapers/shirahige2.jpg &
#feh --bg-scale ~/Pictures/Local/wallpapers/Perfection_Cold_by_yaromanzarek.jpg &
feh --bg-scale ~/Pictures/Local/wallpapers/buddhavoid1920.png &
setlayout 0 3 3 0
pidof synapse
if [[ "$?" == "1" ]]; then
    synapse -s &
fi
if [[ $HOST == "mhysa" ]]; then
    mountssh &
fi
LINES=`ps aux | grep guake | wc -l`
if [[ $LINES -lt 2 ]]; then
    guake &
fi
tint2 &
thunar-volman &
conky &
nm-applet &
udiskie &
volumeicon &
ibus-daemon -d -x
#sleep 3 && feh --bg-scale ~/Pictures/Local/wallpapers/shirahige2.jpg &
#sleep 2 && feh --bg-scale ~/Pictures/Local/wallpapers/Perfection_Cold_by_yaromanzarek.jpg &
sleep 2 && feh --bg-scale ~/Pictures/Local/wallpapers/buddhavoid1920.png &
play ~/cylontune_low.ogg &

