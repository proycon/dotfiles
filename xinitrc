#!/bin/zsh
export LANG=en_GB.UTF-8
export LANGUAGE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

cd $HOME

xrdb -merge /home/proycon/.Xresources
xsetroot -cursor_name left_ptr
amixer sset Master unmute
pulseaudio --start &
compton -cC -z -r 3 -l 2 -t 2 -f -b
fcitx
sleep 0.2
#dbus-launch /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 
dbus-launch gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg  &
#dbus-launch /usr/lib/gnome-settings-daemon/gnome-settings-daemon & 
xrdb -merge /home/proycon/.Xresources
feh --bg-scale /home/proycon/Pictures/Local/wallpapers/archplains.jpg &  #03529_marronbells_5120x2880.jpg &  #~/Pictures/Local/wallpapers/thomascolliers.png &
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
#xscreensaver -no-splash &
xss-lock --ignore-sleep -- /home/proycon/dotfiles/lock.sh &
udiskie &
volumeicon &
tint2 &
setxkbmap proylatin
/home/proycon/homeautomation/notifyclient_autoconnect.sh &
play ~/cylontune_low.ogg &

which bspwm > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    HAVE_BSPWM=1
else
    HAVE_BSPWM=0
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
    dbus-launch sxhkd &
    exec dbus-launch bspwm
elif [ $HAVE_OPENBOX -eq 1 ]; then
    exec dbus-launch openbox 
elif [ $HAVE_XFCE4 -eq 1 ]; then
    exec dbus-launch --exit-with-session startxfce4 
else
    exec xterm
fi
