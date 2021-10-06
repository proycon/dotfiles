#!/bin/zsh
export LANG=en_GB.UTF-8
export LANGUAGE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
#export GTK_IM_MODULE=ibus
#export XMODIFIERS=@im=ibus
#export QT_IM_MODULE=ibus
#export GLFW_IM_MODULE=ibus #for kitty
export QT_AUTO_SCREEN_SCALE_FACTOR=1

export PATH=~/bin:$PATH
export BROWSER=firefox

cd $HOME

#exec dbus-launch i3 -d all 2> ~/.xsession-errors$DISPLAY
#exit 0

xset r rate 300 50
xrdb -all -merge /home/proycon/.Xresources
xsetroot -cursor_name left_ptr
amixer sset Master unmute
pulseaudio --start &
HOSTNAME=$(hostname)
#fcitx
sleep 0.2
#dbus-launch /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1
dbus-launch gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg  &
#dbus-launch /usr/lib/gnome-settings-daemon/gnome-settings-daemon &
xrdb -all -merge /home/proycon/.Xresources
if [[ "$HOSTNAME" == "mhysa" ]]; then
    mountssh &
fi
pidof nm-applet
if [[ "$?" == "1" ]]; then
    nm-applet &
fi
killall xss-lock
xss-lock --ignore-sleep -- /home/proycon/dotfiles/lock.sh &
udiskie &
slstatus &
dunst &
setxkbmap proylatin
if [[ "$HOSTNAME" == "rocinante" ]]; then
    setxkbmap -option "altwin:swap_lalt_lwin"
fi
/home/proycon/dotfiles/notifyclient.sh &
play ~/dotfiles/media/cylontune_low.ogg &
which picom > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    picom -f -e 1.0 &
else
    compton -cC -z -r 3 -l 2 -t 2 -f -e 1.0 &
fi

#if [ $MULTI -eq 1 ]; then
#    DISPLAY=$DISPLAY1 i3 -d all 2> ~/.xsession-errors$DISPLAY1 &
#    # DISPLAY=:0.1 polybar -c ~/dotfiles/polybar/config_i3 simple &
#    DISPLAY=$DISPLAY1 feh --bg-scale ~/dotfiles/media/ArchDarkFloral.png  &
#    DISPLAY=$DISPLAY0
#fi
#
if [[ "$HOSTNAME" == "mhysa" ]]; then
    #multi screen
    echo "Multi screen enabled">&2
    sleep 1
    xrandr --setprovideroutputsource 1 0 && xrandr --output DP-1-1 --auto --left-of DisplayPort-1 --rotate left
    #feh --bg-tile --no-xinerama ~/dotfiles/media/hummingbird_twin.jpg
    #feh --bg-center ~/dotfiles/media/centerpiece.png --image-bg '#191919'
fi
feh --bg-fill ~/dotfiles/media/green-leafed-closeup.jpg --image-bg '#2e3440'

dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY

which dwm > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    HAVE_DWM=1
else
    HAVE_DWM=0
fi
which i3 > /dev/null 2>/dev/null
if [ $? -eq 0 ]; then
    HAVE_I3=1
else
    HAVE_I3=0
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

if [ $HAVE_DWM -eq 1 ]; then
    while true; do
        dwm 2> ~/.xsession-errors$DISPLAY
    done
elif [ $HAVE_I3 -eq 1 ]; then
    exec dbus-launch i3 -d all 2> ~/.xsession-errors$DISPLAY
elif [ $HAVE_BSPWM -eq 1 ]; then
    dbus-launch sxhkd &
    exec dbus-launch bspwm
elif [ $HAVE_OPENBOX -eq 1 ]; then
    exec dbus-launch openbox
elif [ $HAVE_XFCE4 -eq 1 ]; then
    exec dbus-launch --exit-with-session startxfce4
else
    exec xterm
fi
