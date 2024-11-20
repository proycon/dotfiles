#!/bin/sh
~/dotfiles/scripts/lock.sh &
sleep 5
while pidof notmuch rsync pacman git apk; do
    sleep 5
done
if command -v systemctl; then
    systemctl suspend
elif command -v rtcwake; then
    if [ "$HOST" != "toren" ]; then
        doas rtcwake -m mem -s 99999999
    fi
fi
