#!/bin/sh
~/dotfiles/scripts/lock.sh &
sleep 5
while pidof notmuch rsync pacman git apk; do
    sleep 5
done
if command -v systemctl; then
    systemctl suspend
elif command -v zzz; then
    wlopm --off eDP-1
    doas zzz
    wlopm --on eDP-1
elif command -v rtcwake; then
    if [ "$HOST" != "toren" ]; then
        umountssh &&\
        nmcli dev down wlan0 &&\
        wlopm --off eDP-1 &&\
        doas zzz
        wlopm --on eDP-1
        nmcli dev up wlan0
    fi
fi
